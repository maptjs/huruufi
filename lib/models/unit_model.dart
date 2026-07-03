
enum UnitType {
  lettersGroup,   // تعلم مجموعة حروف
  disambiguation, // تمييز الحروف المتشابهة
  wordBuilding,   // تركيب كلمات
  review,         // مراجعة شاملة
}

class UnitModel {
  final int id; // 1-13

  final String title; // "الوحدة 1: ا ب ت"

  final List<String> letterIds; // معرفات الحروف في هذه الوحدة

  final int typeIndex; // فهرس UnitType

  final String iconAsset;

  UnitModel({
    required this.id,
    required this.title,
    required this.letterIds,
    required this.typeIndex,
    required this.iconAsset,
  });

  UnitType get type => UnitType.values[typeIndex];
}

/// أنواع الأنشطة داخل كل وحدة — نفس بنية أرقامي
enum ActivityType {
  recognition,  // تمييز الحرف
  tracing,      // تتبع الكتابة
  matching,     // مطابقة الحرف بالكلمة/الصورة
  listening,    // استماع ونطق
  formsPractice // تمرين أشكال الحرف (بداية/وسط/نهاية)
}

class ActivityModel {
  final String id;

  final int unitId;

  final int typeIndex;

  final String targetLetterId;

  final int order;

  ActivityModel({
    required this.id,
    required this.unitId,
    required this.typeIndex,
    required this.targetLetterId,
    required this.order,
  });

  ActivityType get type => ActivityType.values[typeIndex];
}
