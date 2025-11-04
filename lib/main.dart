import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'views/screens/splash_screen.dart';
// --- IMPOR BARU ---
import 'utils/notification_service.dart';
// --- AKHIR IMPOR ---

void main() async {
  // Pastikan binding Flutter siap
  WidgetsFlutterBinding.ensureInitialized();

  // --- INISIALISASI NOTIFIKASI ---
  await NotificationService().init(); // Inisialisasi service
  await NotificationService().requestPermissions(); // Minta izin
  // --- AKHIR INISIALISASI ---

  // Inisialisasi format tanggal
  await initializeDateFormatting('id_ID', null);

  runApp(const NutriBalanceApp());
}

class NutriBalanceApp extends StatelessWidget {
// ... (sisa file Anda tetap sama) ...
  const NutriBalanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NutriBalance',
      theme: ThemeData(
        primaryColor: const Color(0xFF007BFF),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: const Color(0xFF007BFF)),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', 'ID'),
      ],
      locale: const Locale('id', 'ID'),
      home: const SplashScreen(),
    );
  }
}
