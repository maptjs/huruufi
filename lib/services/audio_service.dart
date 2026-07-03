import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// خدمة الصوت — singleton واحد يستعمل فالتطبيق كامل
///
/// كنستعملو flutter_tts (محرك النطق ديال نظام الهاتف) باش ينطق الحروف
/// والكلمات مباشرة، بلا ما نحتاجو نسجلو ونحملو مئات ملفات mp3.
/// هذا كيخلي التطبيق خدام من البداية على أي جهاز عندو صوت عربي مثبّت.
///
/// ملاحظة: إيلا بغيتي صوت بشري احترافي مسجّل بعدين (بدل TTS)، يكفي
/// تبدّل تنفيذ speakText/speakLetter هنا باش تشغّل ملف audio بـ
/// audioplayers، والباقي ديال التطبيق ما غاديش يتبدل.
class AudioService {
  AudioService._internal() {
    _configureTts();
  }
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  final FlutterTts _tts = FlutterTts();
  bool _muted = false;
  bool _ttsReady = false;

  bool get isMuted => _muted;
  void setMuted(bool value) => _muted = value;

  Future<void> _configureTts() async {
    try {
      await _tts.setLanguage('ar-SA');
      await _tts.setSpeechRate(0.38); // بطيء شوية باش يناسب الأطفال
      await _tts.setPitch(1.05);
      await _tts.setVolume(1.0);
      _ttsReady = true;
    } catch (e) {
      // إيلا ما كانش صوت عربي مثبّت فالجهاز، غادي نفشلو بهدوء
      _ttsReady = false;
    }
  }

  /// ينطق نص عربي (حرف، اسم حرف، أو كلمة)
  Future<void> speakText(String text) async {
    if (_muted || !_ttsReady) return;
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      // fail silently — الصوت اختياري، ما خصوش يوقف التطبيق
    }
  }

  /// ينطق اسم الحرف كامل (أفضل للتعلم من الحرف المجرد وحدو)
  /// مثال: كيقول "باء" بدل "ب" فقط
  Future<void> speakLetterName(String letterName) => speakText(letterName);

  /// ينطق كلمة المثال كاملة
  Future<void> speakWord(String word) => speakText(word);

  /// تأثيرات صوتية قصيرة (نجاح، خطأ، نقرة) — نستعمل أصوات النظام
  /// والاهتزاز بدل ملفات صوت مخصصة، خفيف وشغال فورًا على كل جهاز
  Future<void> playEffect(SoundEffect effect) async {
    if (_muted) return;
    switch (effect) {
      case SoundEffect.success:
      case SoundEffect.starEarned:
      case SoundEffect.unitComplete:
        HapticFeedback.mediumImpact();
        await SystemSound.play(SystemSoundType.click);
        break;
      case SoundEffect.error:
        HapticFeedback.vibrate();
        break;
      case SoundEffect.tap:
        HapticFeedback.lightImpact();
        break;
    }
  }

  Future<void> dispose() async {
    await _tts.stop();
  }
}

enum SoundEffect { success, error, tap, starEarned, unitComplete }
