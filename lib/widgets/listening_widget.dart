import 'package:flutter/material.dart';
import '../models/letter_model.dart';
import '../data/letters_data.dart';
import '../services/audio_service.dart';

/// نشاط الاستماع — الطفل كيسمع صوت الحرف فقط (الشكل مخفي فالبداية)
/// وخصو يختار الحرف الصحيح من بين 4 خيارات
class ListeningActivity extends StatefulWidget {
  final LetterModel letter;
  final VoidCallback onComplete;

  const ListeningActivity({
    super.key,
    required this.letter,
    required this.onComplete,
  });

  @override
  State<ListeningActivity> createState() => _ListeningActivityState();
}

class _ListeningActivityState extends State<ListeningActivity> {
  late List<LetterModel> _options;
  String? _selectedId;
  bool _answeredCorrectly = false;

  @override
  void initState() {
    super.initState();
    _options = [widget.letter, ...distractorsFor(widget.letter, count: 3)]
      ..shuffle();
    WidgetsBinding.instance.addPostFrameCallback((_) => _playSound());
  }

  Future<void> _playSound() =>
      AudioService().speakLetterName(widget.letter.name);

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
        const Text('اسمع الصوت واختر الحرف الصحيح',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _playSound,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.volume_up_rounded, size: 50),
          ),
        ),
        const SizedBox(height: 28),
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
