import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'language_screen.dart';
import '../ultis/page_transitions.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LanguageSelectionPage()),
        );
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF378CBF), // الأزرق الغامق بالأعلى
                    Color(0xFF1D649B), // الأزرق الفاتح بالأسفل
                  ],
                ),
              ),
            ),
            Directionality(
              textDirection:
                  isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: 300, // نفس الأبعاد اللي صدّرت بيها
                      height: 300,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // الظل (Blurred grey SVG)
                          Positioned.fill(
                            child: Transform.scale(
                              scale: 1.0,
                              child: ImageFiltered(
                                imageFilter: ui.ImageFilter.blur(
                                  sigmaX: 4,
                                  sigmaY: 4,
                                ),
                                child: SvgPicture.asset(
                                  'assets/images/onboarding_1_grey_blur.svg',
                                  fit: BoxFit.contain,
                                  colorFilter: ColorFilter.mode(
                                    Colors.grey.withOpacity(0.5),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // الرسمة الملونة (SVG)
                          Positioned.fill(
                            child: SvgPicture.asset(
                              'assets/images/onboarding_1.svg',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: double.infinity,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // الخلفية المموَّهة
                          Positioned.fill(
                            top: -180,
                            child: Transform.scale(
                              scale: 1.02,
                              child: ImageFiltered(
                                imageFilter: ui.ImageFilter.blur(
                                  sigmaX: 6,
                                  sigmaY: 6,
                                ),
                                child: SvgPicture.asset(
                                  'assets/images/background_sheap_grey_blur.svg',
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  height: double.infinity,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(.3),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // الخلفية الملونة
                          Positioned.fill(
                            top: -180,
                            child: SvgPicture.asset(
                              'assets/images/background_sheap.svg',
                              fit: BoxFit.fill,
                              width: double.infinity,
                              height: double.infinity,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF0D308A), // اللون الجديد
                                BlendMode.srcIn, // يغيّر لون كل عناصر الـ SVG
                              ),
                            ),
                          ),

                          // النصوص والأزرار
                          Positioned(
                            left: 20,
                            right: 20,
                            top: -45,
                            child: Column(
                              children: [
                                const SizedBox(height: 30),
                                SizedBox(
                                  child: Stack(
                                    children: [
                                      // الظل (النسخة السوداء بخلفية مموهة)
                                      Positioned.fill(
                                        child: Transform.translate(
                                          offset: const Offset(
                                            2,
                                            2,
                                          ), // يحرّك الظل لتحت ويمين خفيف
                                          child: Transform.scale(
                                            scale:
                                                1.03, // تكبير بسيط لظهور الحواف كظل
                                            child: ImageFiltered(
                                              imageFilter: ui.ImageFilter.blur(
                                                sigmaX:
                                                    4, // درجة التمويه أفقيًا
                                                sigmaY:
                                                    4, // درجة التمويه رأسيًا
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/images/waqty_logo.svg',
                                                height: 230,
                                                colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(
                                                    0.25,
                                                  ), // ظل ناعم شفاف
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        'assets/images/waqty_logo.svg',
                                        height: 230,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'onboarding_text'.tr(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                    shadows: [
                                      Shadow(
                                        color:
                                            Colors
                                                .black26, // لون الظل (رمادي غامق شفاف)
                                        offset: Offset(
                                          0,
                                          2,
                                        ), // المسافة الرأسية للظل
                                        blurRadius: 4, // نعومة الظل
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: 220,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(
                                            0xFF99E3FE,
                                          ), // أزرق فاتح من الأعلى (لمعة)
                                          Color(
                                            0xFF007DFF,
                                          ), // أزرق غامق من الأسفل (عمق)
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          offset: const Offset(0, 4),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final prefs =
                                            await SharedPreferences.getInstance();
                                        await prefs.setBool(
                                          'seen_onboarding',
                                          true,
                                        );
                                        // إلى الشاشة الرئيسية
                                        // ملاحظة: استبدل HomeScreen لاحقًا بصفحة حقيقية
                                        navigateSlideUp(
                                          context,
                                          const LoginScreen(),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                      ),
                                      child: Text(
                                        'start'.tr(),
                                        style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors
                                                      .black26, // لون الظل (رمادي غامق شفاف)
                                              offset: Offset(
                                                0,
                                                2,
                                              ), // المسافة الرأسية للظل
                                              blurRadius: 4, // نعومة الظل
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextButton(
                                  child: Text(
                                    'change_language'
                                        .tr(), // تأكد من وجوده في ملفات الترجمة
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      letterSpacing: 0.5,
                                      shadows: [
                                        Shadow(
                                          color:
                                              Colors
                                                  .black26, // لون الظل (رمادي غامق شفاف)
                                          offset: Offset(
                                            0,
                                            2,
                                          ), // المسافة الرأسية للظل
                                          blurRadius: 4, // نعومة الظل
                                        ),
                                      ],
                                    ),
                                  ),

                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                const LanguageSelectionPage(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
