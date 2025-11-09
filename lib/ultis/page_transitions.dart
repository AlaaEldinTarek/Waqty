import 'package:flutter/material.dart';

/// ✅ حركة لأعلى (زي زر ابدأ)
void navigateSlideUp(BuildContext context, Widget page) {
  Navigator.of(context).push(
    _buildPageRoute(page, const Offset(0.0, 1.0), Offset.zero, fade: true),
  );
}

/// ✅ حركة لأسفل (زي زر رجوع)
void navigateSlideDown(
  BuildContext context,
  Widget page, {
  int durationMs = 1200,
}) {
  Navigator.of(context).push(
    _buildPageRoute(
      page,
      Offset.zero,
      const Offset(0.0, 1.0),
      fade: true,
      durationMs: durationMs,
    ),
  );
}

/// ✅ حركة من اليمين إلى اليسار (Slide Left)
void navigateSlideLeft(BuildContext context, Widget page) {
  Navigator.of(context).push(
    _buildPageRoute(page, const Offset(1.0, 0.0), Offset.zero, fade: true),
  );
}

/// ✅ حركة من اليسار إلى اليمين (Slide Right)
void navigateSlideRight(BuildContext context, Widget page) {
  Navigator.of(context).push(
    _buildPageRoute(page, const Offset(-1.0, 0.0), Offset.zero, fade: true),
  );
}

/// ✅ حركة تكبير (Zoom In)
void navigateZoomIn(BuildContext context, Widget page) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    ),
  );
}

/// ✅ حركة تصغير (Zoom Out)
void navigateZoomOut(BuildContext context, Widget page) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 1.2,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    ),
  );
}

/// ✅ حركة Fade فقط (تلاشي بسيط)
void navigateFade(BuildContext context, Widget page) {
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}

// 🔹 دالة مساعدة لإنشاء Route بأنيميشن Slide + Fade
PageRouteBuilder _buildPageRoute(
  Widget page,
  Offset begin,
  Offset end, {
  bool fade = false,
  int durationMs = 700,
}) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: durationMs),
    reverseTransitionDuration: Duration(milliseconds: durationMs),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final slide = Tween<Offset>(begin: begin, end: end).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeInOutQuart),
      );

      Widget transition = SlideTransition(position: slide, child: child);

      if (fade) {
        transition = FadeTransition(opacity: animation, child: transition);
      }

      return transition;
    },
  );
}
