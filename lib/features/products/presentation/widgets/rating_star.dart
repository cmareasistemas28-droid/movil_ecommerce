import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A yellow star with curved tips and valleys, shared by ratings and reviews.
class RatingStar extends StatelessWidget {
  const RatingStar({super.key, this.size = 22, this.fill = 1});

  final double size;
  final double fill;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: _RatingStarPainter(fill.clamp(0, 1)),
  );
}

class _RatingStarPainter extends CustomPainter {
  const _RatingStarPainter(this.fill);

  final double fill;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final vertices = [
      for (var index = 0; index < 10; index++)
        center +
            Offset(
                  math.cos(-math.pi / 2 + index * math.pi / 5),
                  math.sin(-math.pi / 2 + index * math.pi / 5),
                ) *
                (size.shortestSide * (index.isEven ? .46 : .25)),
    ];
    final path = Path();
    for (var index = 0; index < vertices.length; index++) {
      final point = vertices[index];
      final rounding = index.isEven ? .28 : .18;
      final entry = Offset.lerp(point, vertices[(index + 9) % 10], rounding)!;
      final exit = Offset.lerp(point, vertices[(index + 1) % 10], rounding)!;
      if (index == 0) {
        path.moveTo(entry.dx, entry.dy);
      } else {
        path.lineTo(entry.dx, entry.dy);
      }
      path.quadraticBezierTo(point.dx, point.dy, exit.dx, exit.dy);
    }
    path.close();
    final paint = Paint()..color = const Color(0xFFF2B826);
    canvas.drawPath(
      path,
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.shortestSide * .055,
    );
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width * fill, size.height));
    canvas.drawPath(path, paint..style = PaintingStyle.fill);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_RatingStarPainter oldDelegate) =>
      oldDelegate.fill != fill;
}
