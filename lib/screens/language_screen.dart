import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui';
import '../widgets/lang_btn.dart';
import '../widgets/globeIconWithShadow.dart';
import '../screens/onboarding_screen.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  Future<void> _setLanguageAndNavigate(
    BuildContext context,
    String langCode,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_lang', langCode);

    // طبّق اللغة فورًا
    await context.setLocale(Locale(langCode));

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => OnboardingScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF378CBF), // الأزرق الغامق بالأعلى
              Color(0xFF1D649B), // الأزرق الغامق بالأعلى
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 150),
            const GlobeIconWithShadow(),

            Align(
              alignment: Alignment.centerRight,
              child: Transform.translate(
                offset: const Offset(1, 0),
                child: LangButton(
                  text: 'عــربي',
                  isArabic: true,
                  onTap: () => _setLanguageAndNavigate(context, 'ar'),
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Transform.translate(
                offset: const Offset(-1, -70),
                child: LangButton(
                  text: 'English',
                  isArabic: false,
                  onTap: () => _setLanguageAndNavigate(context, 'en'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
