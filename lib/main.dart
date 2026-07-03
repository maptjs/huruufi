import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/progress_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await ProgressTracker().init();

  runApp(const HuruufiApp());
}

class HuruufiApp extends StatelessWidget {
  const HuruufiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'حروفي',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('fr')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.cairo().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D6B), // نفس روح ألوان أرقامي/وقتي
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFDF6EC),
      ),
      builder: (context, child) {
        // فرض اتجاه RTL فكل التطبيق
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const HomeScreen(),
    );
  }
}
