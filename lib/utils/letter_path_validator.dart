import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// نتيجة تحليل محاولة تتبع الحرف
class TracingResult {
  /// نسبة بكسلات شكل الحرف اللي فعلا تغطات بخط الطفل (0.0 - 1.0)
  final double coverage;

  /// نسبة خط الطفل اللي وقع فوق/قريب من شكل الحرف (0.0 - 1.0)
  /// (كيعاقب الخربشة اللي كتخرج برا الحرف)
  final double accuracy;

  final bool passed;

  const TracingResult({
    required this.coverage,
    required this.accuracy,
    required this.passed,
  });

  /// رسالة تشجيعية مناسبة لمستوى الأداء
  String get feedbackMessage {
    if (passed) return 'برافو! 🎉';
    if (coverage < 0.15) return 'حاول تتبع الحرف كامل';
    if (accuracy < 0.4) return 'حاول تبقى فوق الحرف';
    return 'قريب بزاف! جرب مرة أخرى';
  }
}

/// يرسم الحرف المستهدف فصورة فالذاكرة (offscreen) ويقارن نقط
/// تتبع الطفل مع البكسلات الفعلية ديال شكل الحرف.
///
/// هذا تحقق تقريبي (coverage/accuracy على شكل الحرف) وماشي OCR دقيق
/// 100%، لكن كافي باش يميز بين تتبع حقيقي وخربشة عشوائية — وهو المطلوب
/// فتطبيق تعليمي للأطفال الصغار.
class LetterPathValidator {
  static Future<TracingResult> validate({
    required String character,
    required List<Offset> tracedPoints,
    required Size boxSize,
    double fontSize = 220,
    double toleranceRadius = 16,
    double coverageThreshold = 0.4,
    double accuracyThreshold = 0.5,
  }) async {
    if (tracedPoints.length < 5 || boxSize.width <= 0 || boxSize.height <= 0) {
      return const TracingResult(coverage: 0, accuracy: 0, passed: false);
    }

    final glyphSamples = await _glyphSamplePoints(
      character: character,
      boxSize: boxSize,
      fontSize: fontSize,
    );

    if (glyphSamples.isEmpty) {
      return const TracingResult(coverage: 0, accuracy: 0, passed: false);
    }

    // تسريع المقارنة: نبني شبكة (grid) ديال نقط الطفل باش التقريب يبقى سريع
    final toleranceSquared = toleranceRadius * toleranceRadius;

    int coveredGlyphSamples = 0;
    for (final gp in glyphSamples) {
      final near = tracedPoints.any(
        (tp) => (tp - gp).distanceSquared <= toleranceSquared,
      );
      if (near) coveredGlyphSamples++;
    }
    final coverage = coveredGlyphSamples / glyphSamples.length;

    int onTargetTraces = 0;
    for (final tp in tracedPoints) {
      final near = glyphSamples.any(
        (gp) => (tp - gp).distanceSquared <= toleranceSquared,
      );
      if (near) onTargetTraces++;
    }
    final accuracy = onTargetTraces / tracedPoints.length;

    final passed = coverage >= coverageThreshold && accuracy >= accuracyThreshold;

    return TracingResult(coverage: coverage, accuracy: accuracy, passed: passed);
  }

  /// كيرسم الحرف بنفس الحجم والموقع اللي ظاهر بيه فالواجهة (خلفية شفافة
  /// فـ TracingActivity)، ويرجع نقط عينة (sample) من البكسلات المرسومة
  static Future<List<Offset>> _glyphSamplePoints({
    required String character,
    required Size boxSize,
    required double fontSize,
  }) async {
    final width = boxSize.width.ceil();
    final height = boxSize.height.ceil();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: character,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF000000),
        ),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    final offset = Offset(
      (width - textPainter.width) / 2,
      (height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, offset);

    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return [];

    final bytes = byteData.buffer.asUint8List();
    const step = 6; // خطوة العينة — تخفف عدد النقط وتسرع الحساب
    final samples = <Offset>[];

    for (int y = 0; y < height; y += step) {
      for (int x = 0; x < width; x += step) {
        final index = (y * width + x) * 4;
        if (index + 3 >= bytes.length) continue;
        final alpha = bytes[index + 3];
        if (alpha > 50) {
          samples.add(Offset(x.toDouble(), y.toDouble()));
        }
      }
    }

    image.dispose();
    return samples;
  }
}
