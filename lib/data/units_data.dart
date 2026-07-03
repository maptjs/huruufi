import '../models/unit_model.dart';
import 'letters_data.dart';

/// الوحدات الـ13 الكاملة لتطبيق حروفي
/// 1-10: تعلم مجموعات الحروف (28 حرف)
/// 11: تمييز الحروف المتشابهة
/// 12: تركيب كلمات
/// 13: مراجعة شاملة
final List<UnitModel> huruufiUnits = [
  UnitModel(id: 1, title: 'الوحدة 1: ا ب ت', letterIds: ['alif', 'baa', 'taa'],
      typeIndex: UnitType.lettersGroup.index, iconAsset: 'assets/images/ui/unit1.png'),
  UnitModel(id: 2, title: 'الوحدة 2: ث ج ح', letterIds: ['thaa', 'jeem', 'haa2'],
      typeIndex: UnitType.lettersGroup.index, iconAsset: 'assets/images/ui/unit2.png'),
  UnitModel(id: 3, title: 'الوحدة 3: خ د ذ', letterIds: ['khaa', 'dal', 'thal'],
      typeIndex: UnitType.lettersGroup.index, iconAsset: 'assets/images/ui/unit3.png'),
  UnitModel(id: 4, title: 'الوحدة 4: ر ز س', letterIds: ['raa', 'zay', 'seen'],
      typeIndex: UnitType.lettersGroup.index, iconAsset: 'assets/images/ui/unit4.png'),
  UnitModel(id: 5, title: 'الوحدة 5: ش ص ض', letterIds: ['sheen', 'sad', 'dad'],
      typeIndex: UnitType.lettersGroup.index, iconAsset: 'assets/images/ui/unit5.png'),
  UnitModel(id: 6, title: 'الوحدة 6: ط ظ ع', letterIds: ['taa2', 'zaa2', 'ayn'],
      typeIndex: UnitType.lettersGroup.index, iconAsset: 'assets/images/ui/unit6.png'),
  UnitModel(id: 7, title: 'الوحدة 7: غ ف ق', letterIds: ['ghayn', 'faa', 'qaf'],
      typeIndex: UnitType.lettersGroup.index, iconAsset: 'assets/images/ui/unit7.png'),
  UnitModel(id: 8, title: 'الوحدة 8: ك ل م', letterIds: ['kaf', 'lam', 'meem'],
      typeIndex: UnitType.lettersGroup.index, iconAsset: 'assets/images/ui/unit8.png'),
  UnitModel(id: 9, title: 'الوحدة 9: ن ه', letterIds: ['noon', 'haa'],
      typeIndex: UnitType.lettersGroup.index, iconAsset: 'assets/images/ui/unit9.png'),
  UnitModel(id: 10, title: 'الوحدة 10: و ي', letterIds: ['waw', 'yaa'],
      typeIndex: UnitType.lettersGroup.index, iconAsset: 'assets/images/ui/unit10.png'),
  UnitModel(
    id: 11,
    title: 'الوحدة 11: حروف متشابهة',
    letterIds: ['baa', 'taa', 'thaa', 'noon', 'yaa', 'jeem', 'haa2', 'khaa',
      'dal', 'thal', 'raa', 'zay', 'seen', 'sheen', 'sad', 'dad', 'taa2', 'zaa2'],
    typeIndex: UnitType.disambiguation.index,
    iconAsset: 'assets/images/ui/unit11.png',
  ),
  UnitModel(
    id: 12,
    title: 'الوحدة 12: تركيب كلمات',
    letterIds: [], // تستعمل كل الحروف حسب الكلمة
    typeIndex: UnitType.wordBuilding.index,
    iconAsset: 'assets/images/ui/unit12.png',
  ),
  UnitModel(
    id: 13,
    title: 'الوحدة 13: المراجعة الشاملة',
    letterIds: arabicLetters.map((l) => l.id).toList(),
    typeIndex: UnitType.review.index,
    iconAsset: 'assets/images/ui/unit13.png',
  ),
];

UnitModel unitById(int id) => huruufiUnits.firstWhere((u) => u.id == id);

/// يولّد أنشطة الوحدة تلقائيًا حسب نوعها.
/// لوحدات "تعلم الحروف" (1-10): لكل حرف 5 أنشطة بنفس ترتيب أرقامي:
/// تمييز -> استماع -> تتبع -> أشكال الحرف -> مطابقة
List<ActivityModel> generateActivitiesForUnit(UnitModel unit) {
  final activities = <ActivityModel>[];
  int order = 0;

  if (unit.type == UnitType.lettersGroup) {
    for (final letterId in unit.letterIds) {
      final sequence = [
        ActivityType.recognition,
        ActivityType.listening,
        ActivityType.tracing,
        ActivityType.formsPractice,
        ActivityType.matching,
      ];
      for (final type in sequence) {
        activities.add(ActivityModel(
          id: '${unit.id}_${letterId}_${type.name}',
          unitId: unit.id,
          typeIndex: type.index,
          targetLetterId: letterId,
          order: order++,
        ));
      }
    }
  } else if (unit.type == UnitType.disambiguation) {
    for (final letterId in unit.letterIds) {
      activities.add(ActivityModel(
        id: '${unit.id}_${letterId}_disambig',
        unitId: unit.id,
        typeIndex: ActivityType.recognition.index,
        targetLetterId: letterId,
        order: order++,
      ));
    }
  } else {
    // wordBuilding و review: نشاط واحد شامل لكل حرف متبقٍ
    final ids = unit.letterIds.isEmpty
        ? arabicLetters.map((l) => l.id).toList()
        : unit.letterIds;
    for (final letterId in ids) {
      activities.add(ActivityModel(
        id: '${unit.id}_${letterId}_final',
        unitId: unit.id,
        typeIndex: ActivityType.matching.index,
        targetLetterId: letterId,
        order: order++,
      ));
    }
  }

  return activities;
}
