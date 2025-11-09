import 'package:flutter/material.dart';

class LangButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool isArabic;

  const LangButton({
    super.key,
    required this.onTap,
    required this.text,
    this.isArabic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Shadow
        CustomPaint(
          size: const Size(322, 241),
          painter: _LangButtonShadowPainter(isArabic: isArabic),
        ),
        // Button shape with tap effect
        ClipPath(
          clipper: isArabic ? ArabicShapeClipper() : EnglishShapeClipper(),
          child: Material(
            color: const Color(0xFF99E3FE),
            child: InkWell(
              onTap: onTap,
              splashColor: Colors.white24,
              highlightColor: Colors.transparent,
              child: SizedBox(
                width: 322,
                height: 241,
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ArabicShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo(size.width, size.height);
    path.lineTo(size.width - 1.216, size.height);
    path.cubicTo(
      size.width - 1.204,
      size.height - 0.5,
      size.width - 1.195,
      size.height - 1.0,
      size.width - 1.195,
      size.height - 1.5,
    );
    path.cubicTo(
      size.width - 1.195,
      size.height - 41.0,
      size.width - 39.465,
      size.height - 73.0,
      size.width - 86.673,
      size.height - 73.0,
    );
    path.lineTo(47.0, size.height - 73.0);
    path.cubicTo(
      23.252,
      size.height - 73.0,
      4.0,
      size.height - 92.5,
      4.0,
      size.height - 116.25,
    );
    path.cubicTo(
      4.0,
      size.height - 140.0,
      23.252,
      size.height - 159.25,
      47.0,
      size.height - 159.25,
    );
    path.lineTo(size.width - 86.673, size.height - 159.25);
    path.cubicTo(
      size.width - 39.465,
      size.height - 159.25,
      size.width - 1.195,
      size.height - 191.26,
      size.width - 1.195,
      size.height - 230.75,
    );
    path.cubicTo(
      size.width - 1.195,
      size.height - 231.26,
      size.width - 1.204,
      size.height - 231.77,
      size.width - 1.216,
      size.height - 232.27,
    );
    path.lineTo(size.width, size.height - 232.27);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class EnglishShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(1.216, size.height);
    path.cubicTo(
      1.204,
      size.height - 0.5,
      1.195,
      size.height - 1.0,
      1.195,
      size.height - 1.5,
    );
    path.cubicTo(
      1.195,
      size.height - 41.0,
      39.465,
      size.height - 73.0,
      86.673,
      size.height - 73.0,
    );
    path.lineTo(size.width - 47.0, size.height - 73.0);
    path.cubicTo(
      size.width - 23.252,
      size.height - 73.0,
      size.width - 4.0,
      size.height - 92.5,
      size.width - 4.0,
      size.height - 116.25,
    );
    path.cubicTo(
      size.width - 4.0,
      size.height - 140.0,
      size.width - 23.252,
      size.height - 159.25,
      size.width - 47.0,
      size.height - 159.25,
    );
    path.lineTo(86.673, size.height - 159.25);
    path.cubicTo(
      39.465,
      size.height - 159.25,
      1.195,
      size.height - 191.26,
      1.195,
      size.height - 230.75,
    );
    path.cubicTo(
      1.195,
      size.height - 231.26,
      1.204,
      size.height - 231.77,
      1.216,
      size.height - 232.27,
    );
    path.lineTo(0, size.height - 232.27);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _LangButtonShadowPainter extends CustomPainter {
  final bool isArabic;

  _LangButtonShadowPainter({required this.isArabic});

  @override
  void paint(Canvas canvas, Size size) {
    final path =
        isArabic
            ? ArabicShapeClipper().getClip(size)
            : EnglishShapeClipper().getClip(size);

    final paint =
        Paint()
          ..color = Colors.black.withOpacity(0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawPath(path.shift(const Offset(0, 4)), paint); // shadow offset
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
