
/// شكل الحرف حسب موقعه في الكلمة
class LetterForms {
  final String isolated;   // منفرد: ب
  final String initial;    // في البداية: بـ
  final String medial;     // في الوسط: ـبـ
  final String final_;     // في النهاية: ـب

  const LetterForms({
    required this.isolated,
    required this.initial,
    required this.medial,
    required this.final_,
  });
}

class LetterModel {
  final String id; // مثال: "alif", "baa"

  final String character; // الحرف بشكله المنفرد: ا ب ت

  final int order; // ترتيبه الأبجدي 1-28

  final int unitId; // الوحدة التي ينتمي إليها

  final String name; // اسم الحرف: "ألف", "باء"

  final String initialForm;

  final String medialForm;

  final String finalForm;

  final String exampleWord; // كلمة مثال تبدأ بالحرف: "أسد"

  /// إيموجي يمثل كلمة المثال — بديل خفيف وفوري عن صور خارجية
  final String exampleEmoji;

  final List<String> similarLetters; // حروف يمكن الخلط بينها

  LetterModel({
    required this.id,
    required this.character,
    required this.order,
    required this.unitId,
    required this.name,
    required this.initialForm,
    required this.medialForm,
    required this.finalForm,
    required this.exampleWord,
    required this.exampleEmoji,
    this.similarLetters = const [],
  });

  LetterForms get forms => LetterForms(
        isolated: character,
        initial: initialForm,
        medial: medialForm,
        final_: finalForm,
      );
}
