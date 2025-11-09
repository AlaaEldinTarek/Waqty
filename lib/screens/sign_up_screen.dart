import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../ultis/page_transitions.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isArabic = context.locale.languageCode == 'ar';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                  colors: [Color(0xFF378CBF), Color(0xFF1D649B)],
                ),
              ),
            ),

            // 🔹 الشكل العلوي
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

            // 🔹 المحتوى
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // العنوان
                  Directionality(
                    textDirection:
                        isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: isArabic ? 0 : 20,
                        right: isArabic ? 20 : 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'hello'.tr(),
                            textAlign:
                                isArabic ? TextAlign.right : TextAlign.left,
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
                          const SizedBox(height: 5),
                          Text(
                            'sign_up'.tr(),
                            textAlign:
                                isArabic ? TextAlign.right : TextAlign.left,
                            style: TextStyle(
                              fontSize: isArabic ? 40 : 55,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),

                  // الحقول
                  Expanded(
                    child: Column(
                      children: [
                        buildTextField('full_name'.tr(), Icons.person_outline),
                        const SizedBox(height: 15),
                        buildTextField('email'.tr(), Icons.email_outlined),
                        const SizedBox(height: 15),
                        buildTextField(
                          'password'.tr(),
                          Icons.lock_outline,
                          isPassword: true,
                        ),
                        const SizedBox(height: 15),
                        buildTextField(
                          'confirm_password'.tr(),
                          Icons.lock_outline,
                          isPassword: true,
                        ),

                        const SizedBox(height: 25),

                        // زر إنشاء الحساب
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF99E3FE), Color(0xFF007DFF)],
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
                            onPressed: () {
                              print("Sign Up tapped");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              'sign_up'.tr(),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
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
                                  colors: [
                                    Color(0x2EFFFFFF),
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
                        const SizedBox(height: 20),

                        // النص أسفل الزر
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have account'.tr(),
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                navigateSlideDown(context, const LoginScreen());
                              },
                              child: Text(
                                'login_title'.tr(),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom: 20),
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         SvgPicture.asset(
            //           'assets/images/waqty_logo.svg',
            //           height: 120,
            //           colorFilter: const ColorFilter.mode(
            //             Colors.white,
            //             BlendMode.srcIn,
            //           ),
            //         ),
            //         const SizedBox(height: 10),
            //         const Text(
            //           'نظّم وقتك بسهولة',
            //           style: TextStyle(color: Colors.white70, fontSize: 16),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // 🧱 مكون الحقول الموحدة
  Widget buildTextField(String hint, IconData icon, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white70, width: 1.3),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16),
      cursorColor: Colors.white,
    );
  }
}
