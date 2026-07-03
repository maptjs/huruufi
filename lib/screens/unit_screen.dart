import 'package:flutter/material.dart';
import '../data/units_data.dart';
import '../data/letters_data.dart';
import '../models/unit_model.dart';
import '../models/letter_model.dart';
import '../services/audio_service.dart';
import '../services/progress_service.dart';
import '../widgets/tracing_widget.dart';
import '../widgets/recognition_widget.dart';
import '../widgets/listening_widget.dart';
import '../widgets/matching_widget.dart';

class UnitScreen extends StatefulWidget {
  final int unitId;
  const UnitScreen({super.key, required this.unitId});

  @override
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen> {
  late final UnitModel unit;
  late final List<ActivityModel> activities;
  final _tracker = ProgressTracker();
  final _audio = AudioService();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    unit = unitById(widget.unitId);
    activities = generateActivitiesForUnit(unit);
    // يبدا من أول نشاط ماشي مكمل
    final firstIncomplete = activities.indexWhere(
        (a) => !_tracker.isActivityComplete(a.id));
    _currentIndex = firstIncomplete == -1 ? 0 : firstIncomplete;
  }

  ActivityModel get currentActivity => activities[_currentIndex];
  LetterModel get currentLetter => letterById(currentActivity.targetLetterId);

  Future<void> _completeAndNext() async {
    await _tracker.markActivityComplete(currentActivity.id, stars: 3);
    await _audio.playEffect(SoundEffect.success);

    if (_currentIndex < activities.length - 1) {
      setState(() => _currentIndex++);
    } else {
      await _audio.playEffect(SoundEffect.unitComplete);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(unit.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentIndex + 1) / activities.length,
            minHeight: 6,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _buildActivity(currentActivity, currentLetter),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivity(ActivityModel activity, LetterModel letter) {
    switch (activity.type) {
      case ActivityType.recognition:
        return RecognitionActivity(letter: letter, onComplete: _completeAndNext);
      case ActivityType.listening:
        return ListeningActivity(letter: letter, onComplete: _completeAndNext);
      case ActivityType.tracing:
        return TracingActivity(letter: letter, onComplete: _completeAndNext);
      case ActivityType.formsPractice:
        return _FormsCard(letter: letter, onNext: _completeAndNext);
      case ActivityType.matching:
        return MatchingActivity(letter: letter, onComplete: _completeAndNext);
    }
  }
}

class _FormsCard extends StatelessWidget {
  final LetterModel letter;
  final VoidCallback onNext;

  const _FormsCard({required this.letter, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final forms = letter.forms;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('أشكال الحرف', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _FormChip(label: 'أول الكلمة', form: forms.initial),
            _FormChip(label: 'وسط الكلمة', form: forms.medial),
            _FormChip(label: 'آخر الكلمة', form: forms.final_),
          ],
        ),
        const Spacer(),
        FilledButton(onPressed: onNext, child: const Text('التالي')),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _FormChip extends StatelessWidget {
  final String label;
  final String form;
  const _FormChip({required this.label, required this.form});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
          ),
          child: Text(form, style: const TextStyle(fontSize: 30)),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
