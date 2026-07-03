import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import '../models/letter_model.dart';
import '../services/audio_service.dart';
import '../utils/letter_path_validator.dart';

/// نشاط تتبع الحرف — الطفل يرسم فوق الحرف الشفاف بإصبعه.
/// التحقق حقيقي: كنقارنو نقط رسم الطفل مع بكسلات شكل الحرف الفعلي
/// (LetterPathValidator) — ماشي غير "واش خط شي حاجة".
class TracingActivity extends StatefulWidget {
  final LetterModel letter;
  final VoidCallback onComplete;

  const TracingActivity({
    super.key,
    required this.letter,
    required this.onComplete,
  });

  @override
  State<TracingActivity> createState() => _TracingActivityState();
}

class _TracingActivityState extends State<TracingActivity> {
  late final SignatureController _controller;
  static const double _fontSize = 200;

  bool _checking = false;
  String? _feedback;
  bool _feedbackIsError = false;
  int _attempts = 0;
  Size _canvasSize = const Size(300, 300);

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: 12,
      penColor: const Color(0xFF2E7D6B),
      exportBackgroundColor: Colors.transparent,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    setState(() => _feedback = null);
  }

  Future<void> _submit(Size canvasSize) async {
    if (_controller.points.isEmpty || _checking) return;
    setState(() {
      _checking = true;
      _feedback = null;
    });

    final tracedPoints = _controller.points.map((p) => p.offset).toList();

    final result = await LetterPathValidator.validate(
      character: widget.letter.character,
      tracedPoints: tracedPoints,
      boxSize: canvasSize,
      fontSize: _fontSize,
    );

    _attempts++;

    if (!mounted) return;

    if (result.passed) {
      await AudioService().playEffect(SoundEffect.success);
      setState(() {
        _checking = false;
        _feedback = result.feedbackMessage;
        _feedbackIsError = false;
      });
      await Future.delayed(const Duration(milliseconds: 500));
      widget.onComplete();
    } else {
      await AudioService().playEffect(SoundEffect.error);
      setState(() {
        _checking = false;
        _feedback = result.feedbackMessage;
        _feedbackIsError = true;
      });
      // بعد 3 محاولات، نخففو الشرط باش الطفل ما يبقاش عالق
      if (_attempts >= 3) {
        await Future.delayed(const Duration(milliseconds: 900));
        if (mounted) widget.onComplete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('تتبع حرف ${widget.letter.name}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (_feedback != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              _feedback!,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _feedbackIsError ? Colors.orange.shade800 : Colors.green.shade700,
              ),
            ),
          ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
              _canvasSize = canvasSize;
              return Stack(
                alignment: Alignment.center,
                children: [
                  // الحرف كخلفية شفافة يتتبعها الطفل
                  Text(
                    widget.letter.character,
                    style: TextStyle(
                      fontSize: _fontSize,
                      color: Colors.grey.withOpacity(0.25),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Signature(
                      controller: _controller,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  if (_checking)
                    Container(
                      color: Colors.white.withOpacity(0.4),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton.icon(
              onPressed: _checking ? null : _clear,
              icon: const Icon(Icons.refresh),
              label: const Text('امسح'),
            ),
            IconButton(
              icon: const Icon(Icons.volume_up_rounded),
              onPressed: () => AudioService().speakLetterName(widget.letter.name),
            ),
            FilledButton.icon(
              onPressed: _checking ? null : () => _submit(_canvasSize),
              icon: const Icon(Icons.check),
              label: const Text('تم'),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
