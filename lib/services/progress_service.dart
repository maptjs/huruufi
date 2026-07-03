import 'package:hive_flutter/hive_flutter.dart';
import '../data/units_data.dart';
import '../models/unit_model.dart';

/// ProgressTracker — singleton، نفس نمط أرقامي
/// يخزن: الأنشطة المكتملة، عدد النجوم لكل حرف، آخر وحدة مفتوحة
class ProgressTracker {
  ProgressTracker._internal();
  static final ProgressTracker _instance = ProgressTracker._internal();
  factory ProgressTracker() => _instance;

  static const String boxName = 'huruufi_progress';
  late Box _box;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _box = await Hive.openBox(boxName);
    _initialized = true;
  }

  // ---------- الأنشطة ----------

  Future<void> markActivityComplete(String activityId, {int stars = 3}) async {
    await _box.put('activity_$activityId', {
      'completed': true,
      'stars': stars,
      'completedAt': DateTime.now().toIso8601String(),
    });
  }

  bool isActivityComplete(String activityId) {
    final data = _box.get('activity_$activityId');
    return data != null && data['completed'] == true;
  }

  int starsForActivity(String activityId) {
    final data = _box.get('activity_$activityId');
    return data != null ? (data['stars'] as int? ?? 0) : 0;
  }

  // ---------- الحروف ----------

  /// نسبة إتقان حرف معين (0.0 - 1.0) حسب الأنشطة المكتملة فوحدته
  double letterMastery(String letterId, int unitId) {
    final unit = unitById(unitId);
    final activities = generateActivitiesForUnit(unit)
        .where((a) => a.targetLetterId == letterId)
        .toList();
    if (activities.isEmpty) return 0.0;
    final completed = activities.where((a) => isActivityComplete(a.id)).length;
    return completed / activities.length;
  }

  bool isLetterMastered(String letterId, int unitId) =>
      letterMastery(letterId, unitId) >= 1.0;

  // ---------- الوحدات ----------

  double unitProgress(int unitId) {
    final unit = unitById(unitId);
    final activities = generateActivitiesForUnit(unit);
    if (activities.isEmpty) return 0.0;
    final completed = activities.where((a) => isActivityComplete(a.id)).length;
    return completed / activities.length;
  }

  bool isUnitComplete(int unitId) => unitProgress(unitId) >= 1.0;

  int totalStarsForUnit(int unitId) {
    final unit = unitById(unitId);
    final activities = generateActivitiesForUnit(unit);
    return activities.fold(0, (sum, a) => sum + starsForActivity(a.id));
  }

  /// أول وحدة غير مكتملة — تستعمل باش الطفل يكمل من فين وقف
  int currentUnitId() {
    for (final unit in huruufiUnits) {
      if (!isUnitComplete(unit.id)) return unit.id;
    }
    return huruufiUnits.last.id;
  }

  bool isUnitUnlocked(int unitId) {
    if (unitId == 1) return true;
    return isUnitComplete(unitId - 1);
  }

  // ---------- إحصائيات عامة ----------

  int get totalStars {
    int sum = 0;
    for (final unit in huruufiUnits) {
      sum += totalStarsForUnit(unit.id);
    }
    return sum;
  }

  double get overallProgress {
    if (huruufiUnits.isEmpty) return 0.0;
    final sum = huruufiUnits.fold<double>(
        0, (acc, unit) => acc + unitProgress(unit.id));
    return sum / huruufiUnits.length;
  }

  Future<void> resetAllProgress() async {
    await _box.clear();
  }
}
