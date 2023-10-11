import 'dart:math';
import 'package:flutter/material.dart';

class AirQualityPainter extends CustomPainter {
  final int aqi;

  AirQualityPainter(this.aqi);

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 40;
    double borderThickness = 10.0;

    final double radius = size.width / 2;

    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + borderThickness
      ..strokeCap = StrokeCap.round;

    // Draw the white border arc
    canvas.drawArc(
			Rect.fromCircle(center: Offset(radius, radius), radius: radius - 5 - borderThickness / 2),
			pi,
			pi,
			false,
			borderPaint
		);

    final Paint dialPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.green,
          Colors.yellow,
          Colors.orange,
          Colors.red,
          Colors.purple,
          Colors.brown
        ],
        stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
      ).createShader(
				Rect.fromCircle(center: Offset(radius, radius), radius: radius)
			)
			..style = PaintingStyle.stroke
			..strokeWidth = strokeWidth
			..strokeCap = StrokeCap.round;

    // Draw the colored arc
    canvas.drawArc(
			Rect.fromCircle(center: Offset(radius, radius), radius: radius - borderThickness),
			pi,
			pi,
			false,
			dialPaint
		);

    double normalizedAqi = aqi.clamp(0, 300) / 300;
    double angle = pi - normalizedAqi * pi;

    final Color needleColor = _getColorAtPosition(normalizedAqi);
    final Paint needlePaint = Paint()
      ..color = needleColor
      ..style = PaintingStyle.fill;

    double anchorRadius = 30.0;
    final Paint anchorPaint = Paint()..color = Colors.white;

    double needleLength = radius - (strokeWidth + anchorRadius + 14);
    Offset start = Offset(radius, radius);
    Offset end = Offset(radius + needleLength * cos(angle), radius - needleLength * sin(angle));
    double arrowSize = 14.0;
		final Path borderPath = Path();

		borderPath.moveTo(start.dx, start.dy);
		borderPath.lineTo(end.dx + arrowSize * 1.2 * cos(angle + pi / 4), end.dy - arrowSize * 1.2 * sin(angle + pi / 4));
		borderPath.lineTo(end.dx + 2 * arrowSize * 1.2 * cos(angle), end.dy - 2 * arrowSize * 1.2 * sin(angle));
		borderPath.lineTo(end.dx + arrowSize * 1.2 * cos(angle - pi / 4), end.dy - arrowSize * 1.2 * sin(angle - pi / 4));
		borderPath.close();

		final Paint borderPaint2 = Paint()
			..color = Colors.white
			..style = PaintingStyle.stroke
			..strokeWidth = 8.0; // Set border thickness

		canvas.drawPath(borderPath, borderPaint2);
		canvas.drawPath(borderPath, needlePaint); // Fill the arrow with color after drawing border

		// Then draw the actual arrow path
		final Path path = Path();
		path.moveTo(start.dx, start.dy);
		path.lineTo(end.dx + arrowSize * cos(angle + pi / 4), end.dy - arrowSize * sin(angle + pi / 4));
		path.lineTo(end.dx + 2 * arrowSize * cos(angle), end.dy - 2 * arrowSize * sin(angle));
		path.lineTo(end.dx + arrowSize * cos(angle - pi / 4), end.dy - arrowSize * sin(angle - pi / 4));
		path.close();

		canvas.drawPath(path, needlePaint);
		canvas.drawCircle(start, anchorRadius, anchorPaint);
  }

  Color _getColorAtPosition(double position) {
    List<Color> colors = [
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.brown
    ];
    List<double> stops = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0];
    for (int i = 0; i < stops.length - 1; i++) {
      if (position <= stops[i + 1]) {
        double t = (position - stops[i]) / (stops[i + 1] - stops[i]);
        return Color.lerp(colors[i], colors[i + 1], t)!;
      }
    }
    return colors.last;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}