import 'dart:async';
import 'package:flutter/material.dart';
import '../models/letter_model.dart';
import '../data/letters_data.dart';
import '../services/audio_service.dart';

/// نشاط التمييز — الطفل كيسمع/كيقرا اسم الحرف وخصو يختار شكله الصحيح
/// من بين 4 خيارات (واحد صحيح + 3 مشتتة، تفضّل الحروف المتشابهة)
class RecognitionActivity extends StatefulWidget {
  final LetterModel letter;
  final VoidCallback onComplete;

  const RecognitionActivity({
    super.key,
    required this.letter,
    required this.onComplete,
  });

  @override
  State<RecognitionActivity> createState() => _RecognitionActivityState();
}

class _RecognitionActivityState extends State<RecognitionActivity> {
  late List<LetterModel> _options;
  String? _selectedId;
  bool _answeredCorrectly = false;

  @override
  void initState() {
    super.initState();
    _buildOptions();
    // ينطق اسم الحرف تلقائيًا عند فتح النشاط
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AudioService().speakLetterName(widget.letter.name);
    });
  }

  void _buildOptions() {
    final distractors = distractorsFor(widget.letter, count: 3);
    _options = [widget.letter, ...distractors]..shuffle();
  }

  Future<void> _onSelect(LetterModel option) async {
    if (_answeredCorrectly) return;
    setState(() => _selectedId = option.id);

    if (option.id == widget.letter.id) {
      setState(() => _answeredCorrectly = true);
      await AudioService().playEffect(SoundEffect.success);
      await Future.delayed(const Duration(milliseconds: 600));
      widget.onComplete();
    } else {
      await AudioService().playEffect(SoundEffect.error);
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) setState(() => _selectedId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('وين هو حرف ${widget.letter.name}؟',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        IconButton(
          icon: const Icon(Icons.volume_up_rounded, size: 36),
          onPressed: () => AudioService().speakLetterName(widget.letter.name),
        ),
        const SizedBox(height: 24),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: _options.map((option) {
            final isSelected = _selectedId == option.id;
            final isCorrect = option.id == widget.letter.id;
            Color bg = Colors.white;
            if (isSelected && _answeredCorrectly) bg = Colors.green.shade100;
            if (isSelected && !isCorrect) bg = Colors.red.shade100;

            return Material(
              color: bg,
              borderRadius: BorderRadius.circular(16),
              elevation: 2,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _onSelect(option),
                child: Center(
                  child: Text(option.character,
                      style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold)),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
