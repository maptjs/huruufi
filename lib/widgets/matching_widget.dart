import 'package:flutter/material.dart';
import '../models/letter_model.dart';
import '../data/letters_data.dart';
import '../services/audio_service.dart';

/// نشاط المطابقة — الطفل كيشوف الحرف وخصو يختار الكلمة اللي تبدا بيه
/// من بين 4 كلمات (كلمة صحيحة + 3 كلمات لحروف أخرى)
class MatchingActivity extends StatefulWidget {
  final LetterModel letter;
  final VoidCallback onComplete;

  const MatchingActivity({
    super.key,
    required this.letter,
    required this.onComplete,
  });

  @override
  State<MatchingActivity> createState() => _MatchingActivityState();
}

class _MatchingActivityState extends State<MatchingActivity> {
  late List<LetterModel> _wordOptions;
  String? _selectedId;
  bool _answeredCorrectly = false;

  @override
  void initState() {
    super.initState();
    _wordOptions = [widget.letter, ...distractorsFor(widget.letter, count: 3)]
      ..shuffle();
  }

  Future<void> _onSelect(LetterModel option) async {
    if (_answeredCorrectly) return;
    setState(() => _selectedId = option.id);
    await AudioService().speakWord(option.exampleWord);

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
        Text(widget.letter.character,
            style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('اختر الكلمة اللي تبدا بهاد الحرف',
            style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
        const SizedBox(height: 20),
        ..._wordOptions.map((option) {
          final isSelected = _selectedId == option.id;
          final isCorrect = option.id == widget.letter.id;
          Color bg = Colors.white;
          if (isSelected && _answeredCorrectly) bg = Colors.green.shade100;
          if (isSelected && !isCorrect) bg = Colors.red.shade100;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: bg,
              borderRadius: BorderRadius.circular(14),
              elevation: 1,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => _onSelect(option),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  child: Row(
                    children: [
                      Text(option.exampleEmoji, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Text(option.exampleWord, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
