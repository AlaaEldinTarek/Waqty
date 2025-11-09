import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../ultis/page_transitions.dart';
import 'dart:math' as math;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        print('✅ تم تسجيل الدخول كـ ${googleUser.displayName}');
      } else {
        print('❌ المستخدم ألغى العملية');
      }
    } catch (e) {
      print('⚠️ خطأ في تسجيل الدخول بـ Google: $e');
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        print('✅ تم تسجيل الدخول كـ ${userData['name']}');
      } else {
        print('❌ فشل تسجيل الدخول: ${result.status}');
      }
    } catch (e) {
      print('⚠️ خطأ في تسجيل الدخول بـ Facebook: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = context.locale.languageCode == 'ar';
    return WillPopScope(
      onWillPop: () async {
        // لو فيه صفحة قبلها، ارجع لها
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          return false; // ← متقفلش التطبيق
        }
        // لو مفيش صفحات قبلها، اسمح بالخروج
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // ⛔️ يقفل الكيبورد ويلغي الفوكس
        },
        child: Scaffold(
          resizeToAvoidBottomInset:
              false, // ⛔️ يمنع تحريك المحتوى عند ظهور الكيبورد
          body: Stack(
            children: [
              // 🔹 الخلفية الجريدينت
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF378CBF), // الأزرق الغامق بالأعلى
                      Color(0xFF1D649B),
                    ],
                  ),
                ),
              ),
              // 🔹 الظل (Blur shadow)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ImageFiltered(
                  imageFilter: ui.ImageFilter.blur(
                    sigmaX: 6, // درجة البلور أفقياً
                    sigmaY: 6, // درجة البلور رأسياً
                  ),
                  child: Transform.translate(
                    offset: const Offset(0, 3), // نزله شوية لتحت
                    child: SvgPicture.asset(
                      'assets/images/small_Shape.svg',
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: 350,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.35), // لون الظل
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),

              // 🔹 الشكل الأزرق الأصلي فوقه
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/images/small_Shape.svg',
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: 360,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF0D308A),
                    BlendMode.srcIn,
                  ),
                ),
              ),

              // 🔹 المحتوى الرئيسي
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 80,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ✅ العنوان
                      Directionality(
                        textDirection:
                            isArabic
                                ? ui.TextDirection.rtl
                                : ui.TextDirection.ltr,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: isArabic ? 0 : 20,
                            right: isArabic ? 20 : 0,
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            textDirection:
                                isArabic
                                    ? ui.TextDirection.rtl
                                    : ui.TextDirection.ltr,

                            children: [
                              Row(
                                children: [
                                  Text(
                                    'welcome_back'.tr(),
                                    textAlign:
                                        isArabic
                                            ? TextAlign.left
                                            : TextAlign.right,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  // 👋 إيموجي بيتحرك بنطّة
                                  TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.0, end: 0.0),
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeInOut,
                                    builder: (context, value, child) {
                                      // نطّة خفيفة لأعلى ولأسفل بشكل متكرر

                                      final offsetY =
                                          math.sin(value * 2 * math.pi) * -8;
                                      return Transform.translate(
                                        offset: Offset(0, offsetY),
                                        child: child,
                                      );
                                    },
                                    onEnd:
                                        () {}, // مهم علشان الأنيمشن يخلص طبيعي
                                    child: const Text(
                                      '👋',
                                      style: TextStyle(fontSize: 28),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 5),
                              Text(
                                'log_in'.tr(),
                                textAlign:
                                    isArabic ? TextAlign.right : TextAlign.left,
                                style: TextStyle(
                                  fontSize:
                                      isArabic
                                          ? 40
                                          : 60, // 👈 الإنجليزي أكبر من العربي
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 75),

                      // ✅ البلوك الشفاف
                      Container(
                        padding: const EdgeInsets.all(20),
                        // decoration: BoxDecoration(
                        //   color: Colors.white.withOpacity(0.1),
                        //   borderRadius: BorderRadius.circular(25),
                        //   boxShadow: [
                        //     BoxShadow(
                        //       color: Colors.black.withOpacity(0.25),
                        //       blurRadius: 10,
                        //       offset: const Offset(0, 4),
                        //     ),
                        //   ],
                        // ),
                        child: Column(
                          children: [
                            // البريد الإلكتروني
                            TextField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.person_outline,
                                  color: Colors.white,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.15),
                                hintText: 'email_or_username'.tr(),
                                hintStyle: const TextStyle(
                                  color: Colors.white70,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color:
                                        Colors
                                            .white70, // لما المستخدم يختار الحقل
                                    width: 1.3,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 16,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              cursorColor: Colors.white,
                            ),
                            const SizedBox(height: 20),

                            // كلمة المرور
                            TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Colors.white,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.15),
                                hintText: 'password'.tr(),
                                hintStyle: const TextStyle(
                                  color: Colors.white70,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color:
                                        Colors
                                            .white70, // لما المستخدم يختار الحقل
                                    width: 1.3,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 16,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              cursorColor: Colors.white,
                            ),
                            const SizedBox(height: 15),

                            // تذكرني ونسيت كلمة المرور
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: true,
                                      onChanged: (val) {},
                                      checkColor: Colors.white,
                                      activeColor: const Color(0xFF007DFF),
                                    ),
                                    Text(
                                      'remember_me'.tr(),
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'forgot_password'.tr(),
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            // زر تسجيل الدخول
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF99E3FE),
                                    Color(0xFF007DFF),
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
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                child: Text(
                                  'login_title'.tr(),
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // 🔹 الانتقال إلى صفحة إنشاء الحساب مع أنيميشن جميل
                              navigateSlideUp(context, const SignUpScreen());
                            },
                            child: Text(
                              'create_account'.tr(),
                              style: TextStyle(
                                color: Color(0xFF99E3FE),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Text(
                        'or_continue_with'.tr(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 🔵 Facebook Button
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0x2EFFFFFF), // نفس شفافية التكست بوكس
                                  Color(0x15FFFFFF),
                                ],
                              ),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.25),
                              //     blurRadius: 8,
                              //     offset: const Offset(0, 4),
                              //   ),
                              // ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                splashColor: Colors.white24,
                                highlightColor: Colors.white10,
                                onTap: () {
                                  print('Facebook tapped');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: SvgPicture.asset(
                                    'assets/icons/facebook.svg',
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                    height: 28,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 20), // مسافة بين الزرين
                          // 🔴 Google Button
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0x2EFFFFFF), Color(0x15FFFFFF)],
                              ),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.25),
                              //     blurRadius: 8,
                              //     offset: const Offset(0, 4),
                              //   ),
                              // ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                splashColor: Colors.white24,
                                highlightColor: Colors.white10,
                                onTap: () {
                                  print('Google tapped');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/google.svg',
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                    height: 28,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 0),

                      // ✅ اللوجو في الأسفل
                      // ✅ اللوجو في الأسفل (ثابت حتى مع السكروول)
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/images/waqty_logo.svg',
                        height: 120,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'نظّم وقتك بسهولة',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              // ✅ زر الرجوع الذكي مع تحريك خفيف (Transform.translate)
              // Positioned(
              //   top: 50,
              //   left: 20,
              //   child: Transform.translate(
              //     offset: const Offset(1, 0), // ← حرّكه أفقيًا (يمين أو شمال)
              //     child: IconButton(
              //       icon: Icon(
              //         isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
              //         color: Colors.white,
              //         size: 26,
              //       ),
              //       onPressed: () {
              //         navigateSlideDown(context, OnboardingScreen());
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
