import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;

Future<void> createAppIcon() async {
  const int size = 1024; // High resolution for all icon sizes
  
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  
  // Background - Dark gradient with gold accents
  final bgGradient = ui.Gradient.radial(
    Offset(size * 0.5, size * 0.4),
    size * 0.6,
    [
      const Color(0xFF1a1a1a), // Dark center
      const Color(0xFF000000), // Black outer
      const Color(0xFF2d1810), // Dark brown edge
    ],
    [0.0, 0.7, 1.0],
  );
  
  final bgPaint = Paint()..shader = bgGradient;
  canvas.drawRect(Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()), bgPaint);
  
  // Gold ring border
  final borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 20
    ..shader = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(size.toDouble(), size.toDouble()),
      [
        const Color(0xFFFFD700), // Gold
        const Color(0xFFFF8C00), // Orange gold
        const Color(0xFFFFD700), // Gold
      ],
    );
  
  canvas.drawCircle(
    Offset(size * 0.5, size * 0.5),
    size * 0.48,
    borderPaint,
  );
  
  // Main dollar symbol - large and bold
  final dollarPath = Path();
  final dollarCenter = Offset(size * 0.5, size * 0.52);
  final dollarSize = size * 0.35;
  
  // Create custom dollar sign path
  final dollarPaint = Paint()
    ..color = const Color(0xFFFFD700)
    ..style = PaintingStyle.fill;
  
  // Dollar sign body (S shape)
  final sPath = Path();
  sPath.moveTo(dollarCenter.dx + dollarSize * 0.3, dollarCenter.dy - dollarSize * 0.4);
  sPath.quadraticBezierTo(
    dollarCenter.dx - dollarSize * 0.3, dollarCenter.dy - dollarSize * 0.4,
    dollarCenter.dx - dollarSize * 0.3, dollarCenter.dy - dollarSize * 0.1,
  );
  sPath.quadraticBezierTo(
    dollarCenter.dx - dollarSize * 0.3, dollarCenter.dy + dollarSize * 0.1,
    dollarCenter.dx + dollarSize * 0.1, dollarCenter.dy + dollarSize * 0.1,
  );
  sPath.quadraticBezierTo(
    dollarCenter.dx + dollarSize * 0.3, dollarCenter.dy + dollarSize * 0.1,
    dollarCenter.dx + dollarSize * 0.3, dollarCenter.dy + dollarSize * 0.4,
  );
  sPath.quadraticBezierTo(
    dollarCenter.dx + dollarSize * 0.3, dollarCenter.dy + dollarSize * 0.5,
    dollarCenter.dx - dollarSize * 0.3, dollarCenter.dy + dollarSize * 0.5,
  );
  
  canvas.drawPath(sPath, dollarPaint);
  
  // Dollar sign vertical lines
  final linePaint = Paint()
    ..color = const Color(0xFFFFD700)
    ..strokeWidth = size * 0.03
    ..strokeCap = StrokeCap.round;
  
  canvas.drawLine(
    Offset(dollarCenter.dx, dollarCenter.dy - dollarSize * 0.6),
    Offset(dollarCenter.dx, dollarCenter.dy + dollarSize * 0.6),
    linePaint,
  );
  
  // Small money symbols around the main dollar
  final smallSymbolPaint = Paint()
    ..color = const Color(0xFFFF8C00).withOpacity(0.7)
    ..style = PaintingStyle.fill;
  
  for (int i = 0; i < 6; i++) {
    final angle = (i * math.pi * 2 / 6) - math.pi / 2;
    final x = dollarCenter.dx + math.cos(angle) * size * 0.25;
    final y = dollarCenter.dy + math.sin(angle) * size * 0.25;
    
    // Small dollar symbols
    canvas.save();
    canvas.translate(x, y);
    canvas.scale(0.3);
    
    final smallPath = Path();
    smallPath.addOval(Rect.fromCircle(center: Offset.zero, radius: 15));
    canvas.drawPath(smallPath, smallSymbolPaint);
    
    canvas.restore();
  }
  
  // Crown on top for "tycoon" feel
  final crownPaint = Paint()
    ..color = const Color(0xFFFFD700)
    ..style = PaintingStyle.fill;
  
  final crownPath = Path();
  final crownCenter = Offset(size * 0.5, size * 0.25);
  final crownWidth = size * 0.2;
  final crownHeight = size * 0.08;
  
  // Crown base
  crownPath.moveTo(crownCenter.dx - crownWidth * 0.5, crownCenter.dy + crownHeight * 0.5);
  crownPath.lineTo(crownCenter.dx + crownWidth * 0.5, crownCenter.dy + crownHeight * 0.5);
  
  // Crown points
  crownPath.lineTo(crownCenter.dx + crownWidth * 0.3, crownCenter.dy - crownHeight * 0.5);
  crownPath.lineTo(crownCenter.dx + crownWidth * 0.1, crownCenter.dy);
  crownPath.lineTo(crownCenter.dx, crownCenter.dy - crownHeight * 0.8);
  crownPath.lineTo(crownCenter.dx - crownWidth * 0.1, crownCenter.dy);
  crownPath.lineTo(crownCenter.dx - crownWidth * 0.3, crownCenter.dy - crownHeight * 0.5);
  crownPath.close();
  
  canvas.drawPath(crownPath, crownPaint);
  
  // Subtle shadow/glow effect
  final glowPaint = Paint()
    ..color = const Color(0xFFFFD700).withOpacity(0.3)
    ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.outer, 10);
  
  canvas.drawCircle(
    Offset(size * 0.5, size * 0.5),
    size * 0.4,
    glowPaint,
  );
  
  final picture = recorder.endRecording();
  final image = await picture.toImage(size, size);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  
  return byteData!.buffer.asUint8List();
}

void main() async {
  print('Creating Street Tycoon app icon...');
  
  final iconData = await createAppIcon();
  
  // Save high-res version
  await File('android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png')
      .create(recursive: true)
      .then((file) => file.writeAsBytes(iconData));
  
  print('App icon created successfully!');
  print('Saved to: android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png');
}
