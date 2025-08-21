import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Create a simple icon programmatically
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final size = const Size(512, 512);
  
  // Background
  final bgPaint = Paint()
    ..shader = const RadialGradient(
      colors: [Color(0xFFFFD700), Color(0xFFFF8C00), Color(0xFFDC143C)],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
  
  canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
  
  // Dollar sign
  final textPainter = TextPainter(
    text: const TextSpan(
      text: '\$',
      style: TextStyle(
        fontSize: 300,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  
  final textOffset = Offset(
    (size.width - textPainter.width) / 2,
    (size.height - textPainter.height) / 2,
  );
  
  textPainter.paint(canvas, textOffset);
  
  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  
  if (byteData != null) {
    final file = File('assets/splash_icon.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    print('Splash icon created successfully!');
  }
}
