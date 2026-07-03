import 'package:flutter/material.dart';
import '../data/units_data.dart';
import '../services/progress_service.dart';
import 'unit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _tracker = ProgressTracker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حروفي', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${_tracker.totalStars}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: huruufiUnits.length,
        itemBuilder: (context, index) {
          final unit = huruufiUnits[index];
          final unlocked = _tracker.isUnitUnlocked(unit.id);
          final progress = _tracker.unitProgress(unit.id);

          return _UnitCard(
            title: 'وحدة ${unit.id}',
            subtitle: unit.letterIds.isEmpty
                ? ''
                : unit.letterIds.take(3).join(' '),
            unlocked: unlocked,
            progress: progress,
            onTap: unlocked
                ? () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UnitScreen(unitId: unit.id),
                      ),
                    );
                    setState(() {}); // تحديث التقدم عند الرجوع
                  }
                : null,
          );
        },
      ),
    );
  }
}

class _UnitCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool unlocked;
  final double progress;
  final VoidCallback? onTap;

  const _UnitCard({
    required this.title,
    required this.subtitle,
    required this.unlocked,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Opacity(
      opacity: unlocked ? 1.0 : 0.45,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  unlocked ? Icons.menu_book_rounded : Icons.lock_rounded,
                  size: 32,
                  color: color,
                ),
                const SizedBox(height: 6),
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                if (subtitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(subtitle,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                  ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: Colors.grey[200],
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
