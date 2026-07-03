import '../models/letter_model.dart';

/// قائمة الحروف العربية الـ28 كاملة، مرتبة أبجديًا
/// توزيع الوحدات (unitId):
/// 1: ا ب ت   2: ث ج ح   3: خ د ذ   4: ر ز س   5: ش ص ض
/// 6: ط ظ ع   7: غ ف ق   8: ك ل م   9: ن ه     10: و ي
///
/// ملاحظة: نستعمل إيموجي (exampleEmoji) بدل صور خارجية، والنطق كيتصنّع
/// مباشرة بالجهاز عبر AudioService (flutter_tts) بدل ملفات صوت مسجلة —
/// هكذا التطبيق كيخدم من البداية بلا ما تحتاج تجيب assets يدويًا.
final List<LetterModel> arabicLetters = [
  LetterModel(
    id: 'alif', character: 'ا', order: 1, unitId: 1, name: 'ألف',
    initialForm: 'ا', medialForm: 'ـا', finalForm: 'ـا',
    exampleWord: 'أسد', exampleEmoji: '🦁',
    similarLetters: ['dal', 'lam'],
  ),
  LetterModel(
    id: 'baa', character: 'ب', order: 2, unitId: 1, name: 'باء',
    initialForm: 'بـ', medialForm: 'ـبـ', finalForm: 'ـب',
    exampleWord: 'بطة', exampleEmoji: '🦆',
    similarLetters: ['taa', 'thaa', 'noon', 'yaa'],
  ),
  LetterModel(
    id: 'taa', character: 'ت', order: 3, unitId: 1, name: 'تاء',
    initialForm: 'تـ', medialForm: 'ـتـ', finalForm: 'ـت',
    exampleWord: 'تفاحة', exampleEmoji: '🍎',
    similarLetters: ['baa', 'thaa', 'noon', 'yaa'],
  ),
  LetterModel(
    id: 'thaa', character: 'ث', order: 4, unitId: 2, name: 'ثاء',
    initialForm: 'ثـ', medialForm: 'ـثـ', finalForm: 'ـث',
    exampleWord: 'ثعلب', exampleEmoji: '🦊',
    similarLetters: ['baa', 'taa', 'noon', 'yaa'],
  ),
  LetterModel(
    id: 'jeem', character: 'ج', order: 5, unitId: 2, name: 'جيم',
    initialForm: 'جـ', medialForm: 'ـجـ', finalForm: 'ـج',
    exampleWord: 'جمل', exampleEmoji: '🐪',
    similarLetters: ['haa2', 'khaa'],
  ),
  LetterModel(
    id: 'haa2', character: 'ح', order: 6, unitId: 2, name: 'حاء',
    initialForm: 'حـ', medialForm: 'ـحـ', finalForm: 'ـح',
    exampleWord: 'حصان', exampleEmoji: '🐴',
    similarLetters: ['jeem', 'khaa'],
  ),
  LetterModel(
    id: 'khaa', character: 'خ', order: 7, unitId: 3, name: 'خاء',
    initialForm: 'خـ', medialForm: 'ـخـ', finalForm: 'ـخ',
    exampleWord: 'خروف', exampleEmoji: '🐑',
    similarLetters: ['jeem', 'haa2'],
  ),
  LetterModel(
    id: 'dal', character: 'د', order: 8, unitId: 3, name: 'دال',
    initialForm: 'د', medialForm: 'ـد', finalForm: 'ـد',
    exampleWord: 'دب', exampleEmoji: '🐻',
    similarLetters: ['thal', 'alif'],
  ),
  LetterModel(
    id: 'thal', character: 'ذ', order: 9, unitId: 3, name: 'ذال',
    initialForm: 'ذ', medialForm: 'ـذ', finalForm: 'ـذ',
    exampleWord: 'ذئب', exampleEmoji: '🐺',
    similarLetters: ['dal'],
  ),
  LetterModel(
    id: 'raa', character: 'ر', order: 10, unitId: 4, name: 'راء',
    initialForm: 'ر', medialForm: 'ـر', finalForm: 'ـر',
    exampleWord: 'ريشة', exampleEmoji: '🪶',
    similarLetters: ['zay'],
  ),
  LetterModel(
    id: 'zay', character: 'ز', order: 11, unitId: 4, name: 'زاي',
    initialForm: 'ز', medialForm: 'ـز', finalForm: 'ـز',
    exampleWord: 'زرافة', exampleEmoji: '🦒',
    similarLetters: ['raa'],
  ),
  LetterModel(
    id: 'seen', character: 'س', order: 12, unitId: 4, name: 'سين',
    initialForm: 'سـ', medialForm: 'ـسـ', finalForm: 'ـس',
    exampleWord: 'سمكة', exampleEmoji: '🐟',
    similarLetters: ['sheen'],
  ),
  LetterModel(
    id: 'sheen', character: 'ش', order: 13, unitId: 5, name: 'شين',
    initialForm: 'شـ', medialForm: 'ـشـ', finalForm: 'ـش',
    exampleWord: 'شمس', exampleEmoji: '☀️',
    similarLetters: ['seen'],
  ),
  LetterModel(
    id: 'sad', character: 'ص', order: 14, unitId: 5, name: 'صاد',
    initialForm: 'صـ', medialForm: 'ـصـ', finalForm: 'ـص',
    exampleWord: 'صقر', exampleEmoji: '🦅',
    similarLetters: ['dad'],
  ),
  LetterModel(
    id: 'dad', character: 'ض', order: 15, unitId: 5, name: 'ضاد',
    initialForm: 'ضـ', medialForm: 'ـضـ', finalForm: 'ـض',
    exampleWord: 'ضفدع', exampleEmoji: '🐸',
    similarLetters: ['sad'],
  ),
  LetterModel(
    id: 'taa2', character: 'ط', order: 16, unitId: 6, name: 'طاء',
    initialForm: 'طـ', medialForm: 'ـطـ', finalForm: 'ـط',
    exampleWord: 'طائرة', exampleEmoji: '✈️',
    similarLetters: ['zaa2'],
  ),
  LetterModel(
    id: 'zaa2', character: 'ظ', order: 17, unitId: 6, name: 'ظاء',
    initialForm: 'ظـ', medialForm: 'ـظـ', finalForm: 'ـظ',
    exampleWord: 'ظرف', exampleEmoji: '✉️',
    similarLetters: ['taa2'],
  ),
  LetterModel(
    id: 'ayn', character: 'ع', order: 18, unitId: 6, name: 'عين',
    initialForm: 'عـ', medialForm: 'ـعـ', finalForm: 'ـع',
    exampleWord: 'عصفور', exampleEmoji: '🐦',
    similarLetters: ['ghayn'],
  ),
  LetterModel(
    id: 'ghayn', character: 'غ', order: 19, unitId: 7, name: 'غين',
    initialForm: 'غـ', medialForm: 'ـغـ', finalForm: 'ـغ',
    exampleWord: 'غزال', exampleEmoji: '🦌',
    similarLetters: ['ayn'],
  ),
  LetterModel(
    id: 'faa', character: 'ف', order: 20, unitId: 7, name: 'فاء',
    initialForm: 'فـ', medialForm: 'ـفـ', finalForm: 'ـف',
    exampleWord: 'فيل', exampleEmoji: '🐘',
    similarLetters: ['qaf'],
  ),
  LetterModel(
    id: 'qaf', character: 'ق', order: 21, unitId: 7, name: 'قاف',
    initialForm: 'قـ', medialForm: 'ـقـ', finalForm: 'ـق',
    exampleWord: 'قطة', exampleEmoji: '🐱',
    similarLetters: ['faa'],
  ),
  LetterModel(
    id: 'kaf', character: 'ك', order: 22, unitId: 8, name: 'كاف',
    initialForm: 'كـ', medialForm: 'ـكـ', finalForm: 'ـك',
    exampleWord: 'كتاب', exampleEmoji: '📖',
    similarLetters: [],
  ),
  LetterModel(
    id: 'lam', character: 'ل', order: 23, unitId: 8, name: 'لام',
    initialForm: 'لـ', medialForm: 'ـلـ', finalForm: 'ـل',
    exampleWord: 'ليمون', exampleEmoji: '🍋',
    similarLetters: ['alif'],
  ),
  LetterModel(
    id: 'meem', character: 'م', order: 24, unitId: 8, name: 'ميم',
    initialForm: 'مـ', medialForm: 'ـمـ', finalForm: 'ـم',
    exampleWord: 'موز', exampleEmoji: '🍌',
    similarLetters: [],
  ),
  LetterModel(
    id: 'noon', character: 'ن', order: 25, unitId: 9, name: 'نون',
    initialForm: 'نـ', medialForm: 'ـنـ', finalForm: 'ـن',
    exampleWord: 'نحلة', exampleEmoji: '🐝',
    similarLetters: ['baa', 'taa', 'thaa', 'yaa'],
  ),
  LetterModel(
    id: 'haa', character: 'ه', order: 26, unitId: 9, name: 'هاء',
    initialForm: 'هـ', medialForm: 'ـهـ', finalForm: 'ـه',
    exampleWord: 'هلال', exampleEmoji: '🌙',
    similarLetters: [],
  ),
  LetterModel(
    id: 'waw', character: 'و', order: 27, unitId: 10, name: 'واو',
    initialForm: 'و', medialForm: 'ـو', finalForm: 'ـو',
    exampleWord: 'وردة', exampleEmoji: '🌹',
    similarLetters: [],
  ),
  LetterModel(
    id: 'yaa', character: 'ي', order: 28, unitId: 10, name: 'ياء',
    initialForm: 'يـ', medialForm: 'ـيـ', finalForm: 'ـي',
    exampleWord: 'يد', exampleEmoji: '✋',
    similarLetters: ['baa', 'taa', 'thaa', 'noon'],
  ),
];

LetterModel letterById(String id) =>
    arabicLetters.firstWhere((l) => l.id == id);

List<LetterModel> lettersByUnit(int unitId) =>
    arabicLetters.where((l) => l.unitId == unitId).toList()
      ..sort((a, b) => a.order.compareTo(b.order));

/// يختار حروف خاطئة (خيارات مشتتة) لأسئلة الاختيار المتعدد.
/// يفضّل الحروف المتشابهة شكليًا أولاً (أصعب وأكثر فائدة تعليمية)،
/// ثم يكمل بحروف عشوائية إذا احتاج.
List<LetterModel> distractorsFor(LetterModel letter, {int count = 3}) {
  final pool = <LetterModel>[];

  for (final id in letter.similarLetters) {
    if (pool.length >= count) break;
    pool.add(letterById(id));
  }

  final others = arabicLetters
      .where((l) => l.id != letter.id && !pool.contains(l))
      .toList()
    ..shuffle();

  for (final l in others) {
    if (pool.length >= count) break;
    pool.add(l);
  }

  pool.shuffle();
  return pool.take(count).toList();
}
