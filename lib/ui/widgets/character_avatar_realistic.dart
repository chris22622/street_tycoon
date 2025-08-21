import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../data/character_models.dart';

class RealisticCharacterAvatar extends StatelessWidget {
  final CharacterAppearance character;
  final double size;
  final bool showBorder;

  const RealisticCharacterAvatar({
    super.key,
    required this.character,
    this.size = 100,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder 
            ? Border.all(color: Colors.white.withOpacity(0.4), width: 3)
            : null,
        boxShadow: showBorder ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: ClipOval(
        child: CustomPaint(
          size: Size(size, size),
          painter: _RealisticFacePainter(character: character),
        ),
      ),
    );
  }
}

class _RealisticFacePainter extends CustomPainter {
  final CharacterAppearance character;

  _RealisticFacePainter({required this.character});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final faceRadius = size.width * 0.45;
    
    // Background
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFE8F4FD),
          const Color(0xFFD1E7DD),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: faceRadius));
    canvas.drawCircle(center, faceRadius, bgPaint);
    
    // Draw face base
    _drawFaceBase(canvas, size, center, faceRadius);
    
    // Draw hair
    if (character.hairStyle != HairStyle.bald) {
      _drawHair(canvas, size, center, faceRadius);
    }
    
    // Draw facial features
    _drawEyes(canvas, size, center);
    _drawNose(canvas, size, center);
    _drawMouth(canvas, size, center);
    _drawEyebrows(canvas, size, center);
    
    // Draw facial hair for males
    if (character.gender == Gender.male) {
      _drawFacialHair(canvas, size, center);
    }
    
    // Draw accessories
    _drawAccessories(canvas, size, center);
  }

  void _drawFaceBase(Canvas canvas, Size size, Offset center, double radius) {
    final skinColor = Color(int.parse('0xFF${character.skinTone.colorHex.substring(1)}'));
    
    // Face shape adjustment
    final faceRect = _getFaceRect(center, radius);
    final facePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          skinColor,
          skinColor.withOpacity(0.9),
          _darkenColor(skinColor, 0.1),
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(faceRect);
    
    // Draw face shape
    switch (character.faceShape) {
      case FaceShape.round:
        canvas.drawCircle(center, radius, facePaint);
        break;
      case FaceShape.oval:
        canvas.drawOval(
          Rect.fromCenter(center: center, width: radius * 1.6, height: radius * 1.8),
          facePaint,
        );
        break;
      case FaceShape.square:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: center, width: radius * 1.7, height: radius * 1.7),
            Radius.circular(radius * 0.1),
          ),
          facePaint,
        );
        break;
      case FaceShape.heart:
        _drawHeartShape(canvas, center, radius, facePaint);
        break;
      case FaceShape.diamond:
        _drawDiamondShape(canvas, center, radius, facePaint);
        break;
      case FaceShape.oblong:
        canvas.drawOval(
          Rect.fromCenter(center: center, width: radius * 1.4, height: radius * 2.0),
          facePaint,
        );
        break;
    }
    
    // Add subtle face highlights
    _addFaceHighlights(canvas, center, radius, skinColor);
  }

  void _drawHair(Canvas canvas, Size size, Offset center, double radius) {
    final hairColor = Color(int.parse('0xFF${character.hairColor.colorHex.substring(1)}'));
    final hairPaint = Paint()
      ..color = hairColor
      ..style = PaintingStyle.fill;
    
    switch (character.hairStyle) {
      case HairStyle.short:
        _drawShortHair(canvas, center, radius, hairPaint);
        break;
      case HairStyle.medium:
        _drawMediumHair(canvas, center, radius, hairPaint);
        break;
      case HairStyle.long:
        _drawLongHair(canvas, center, radius, hairPaint);
        break;
      case HairStyle.curly:
        _drawCurlyHair(canvas, center, radius, hairPaint);
        break;
      case HairStyle.wavy:
        _drawWavyHair(canvas, center, radius, hairPaint);
        break;
      case HairStyle.straight:
        _drawStraightHair(canvas, center, radius, hairPaint);
        break;
      case HairStyle.mohawk:
        _drawMohawk(canvas, center, radius, hairPaint);
        break;
      case HairStyle.dreadlocks:
        _drawDreadlocks(canvas, center, radius, hairPaint);
        break;
      case HairStyle.buzz:
        _drawBuzzCut(canvas, center, radius, hairPaint);
        break;
      case HairStyle.bald:
        break;
    }
  }

  void _drawEyes(Canvas canvas, Size size, Offset center) {
    final eyeColor = Color(int.parse('0xFF${character.eyeColor.colorHex.substring(1)}'));
    final eyeWidth = size.width * 0.12;
    final eyeHeight = size.width * 0.08;
    
    final leftEyeCenter = Offset(center.dx - size.width * 0.15, center.dy - size.height * 0.08);
    final rightEyeCenter = Offset(center.dx + size.width * 0.15, center.dy - size.height * 0.08);
    
    // Eye whites
    final eyeWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawOval(
      Rect.fromCenter(center: leftEyeCenter, width: eyeWidth, height: eyeHeight),
      eyeWhitePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: rightEyeCenter, width: eyeWidth, height: eyeHeight),
      eyeWhitePaint,
    );
    
    // Iris
    final irisPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          eyeColor,
          _darkenColor(eyeColor, 0.3),
        ],
      ).createShader(Rect.fromCircle(center: leftEyeCenter, radius: eyeWidth * 0.3));
    
    canvas.drawCircle(leftEyeCenter, eyeWidth * 0.3, irisPaint);
    canvas.drawCircle(rightEyeCenter, eyeWidth * 0.3, irisPaint);
    
    // Pupils
    final pupilPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(leftEyeCenter, eyeWidth * 0.15, pupilPaint);
    canvas.drawCircle(rightEyeCenter, eyeWidth * 0.15, pupilPaint);
    
    // Eye highlights
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(leftEyeCenter.dx - eyeWidth * 0.05, leftEyeCenter.dy - eyeWidth * 0.05),
      eyeWidth * 0.06,
      highlightPaint,
    );
    canvas.drawCircle(
      Offset(rightEyeCenter.dx - eyeWidth * 0.05, rightEyeCenter.dy - eyeWidth * 0.05),
      eyeWidth * 0.06,
      highlightPaint,
    );
    
    // Eyelashes
    _drawEyelashes(canvas, leftEyeCenter, rightEyeCenter, eyeWidth);
  }

  void _drawNose(Canvas canvas, Size size, Offset center) {
    final skinColor = Color(int.parse('0xFF${character.skinTone.colorHex.substring(1)}'));
    final nosePaint = Paint()
      ..color = _darkenColor(skinColor, 0.2)
      ..style = PaintingStyle.fill;
    
    final noseCenter = Offset(center.dx, center.dy + size.height * 0.02);
    final noseWidth = size.width * 0.06;
    final noseHeight = size.height * 0.12;
    
    // Draw nose shadow
    canvas.drawOval(
      Rect.fromCenter(center: noseCenter, width: noseWidth, height: noseHeight),
      nosePaint,
    );
    
    // Nostril details
    final nostrilPaint = Paint()
      ..color = _darkenColor(skinColor, 0.4)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(noseCenter.dx - noseWidth * 0.3, noseCenter.dy + noseHeight * 0.2),
      size.width * 0.01,
      nostrilPaint,
    );
    canvas.drawCircle(
      Offset(noseCenter.dx + noseWidth * 0.3, noseCenter.dy + noseHeight * 0.2),
      size.width * 0.01,
      nostrilPaint,
    );
  }

  void _drawMouth(Canvas canvas, Size size, Offset center) {
    final mouthCenter = Offset(center.dx, center.dy + size.height * 0.15);
    final mouthWidth = size.width * 0.15;
    
    // Lip color based on gender and skin tone
    final lipColor = character.gender == Gender.female 
        ? const Color(0xFFD4A574) 
        : Color(int.parse('0xFF${character.skinTone.colorHex.substring(1)}')).withRed(200);
    
    final mouthPaint = Paint()
      ..color = lipColor
      ..style = PaintingStyle.fill;
    
    // Draw mouth shape
    final mouthRect = Rect.fromCenter(
      center: mouthCenter, 
      width: mouthWidth, 
      height: size.height * 0.04,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(mouthRect, Radius.circular(mouthWidth * 0.5)),
      mouthPaint,
    );
    
    // Mouth line
    final mouthLinePaint = Paint()
      ..color = _darkenColor(lipColor, 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    canvas.drawLine(
      Offset(mouthCenter.dx - mouthWidth * 0.4, mouthCenter.dy),
      Offset(mouthCenter.dx + mouthWidth * 0.4, mouthCenter.dy),
      mouthLinePaint,
    );
  }

  void _drawEyebrows(Canvas canvas, Size size, Offset center) {
    final hairColor = Color(int.parse('0xFF${character.hairColor.colorHex.substring(1)}'));
    final browPaint = Paint()
      ..color = _darkenColor(hairColor, 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02
      ..strokeCap = StrokeCap.round;
    
    final browY = center.dy - size.height * 0.15;
    
    // Left eyebrow
    canvas.drawLine(
      Offset(center.dx - size.width * 0.20, browY),
      Offset(center.dx - size.width * 0.08, browY - size.height * 0.01),
      browPaint,
    );
    
    // Right eyebrow
    canvas.drawLine(
      Offset(center.dx + size.width * 0.08, browY - size.height * 0.01),
      Offset(center.dx + size.width * 0.20, browY),
      browPaint,
    );
  }

  void _drawFacialHair(Canvas canvas, Size size, Offset center) {
    final hairColor = Color(int.parse('0xFF${character.hairColor.colorHex.substring(1)}'));
    final facialHairPaint = Paint()
      ..color = _darkenColor(hairColor, 0.1)
      ..style = PaintingStyle.fill;
    
    // Simple beard/mustache for males
    final random = math.Random(character.skinTone.hashCode);
    if (random.nextBool()) {
      // Mustache
      final mustacheRect = Rect.fromCenter(
        center: Offset(center.dx, center.dy + size.height * 0.10),
        width: size.width * 0.12,
        height: size.height * 0.03,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(mustacheRect, Radius.circular(size.width * 0.02)),
        facialHairPaint,
      );
    }
    
    if (random.nextDouble() > 0.7) {
      // Goatee
      final goateeRect = Rect.fromCenter(
        center: Offset(center.dx, center.dy + size.height * 0.25),
        width: size.width * 0.08,
        height: size.height * 0.06,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(goateeRect, Radius.circular(size.width * 0.02)),
        facialHairPaint,
      );
    }
  }

  void _drawAccessories(Canvas canvas, Size size, Offset center) {
    final random = math.Random(character.skinTone.hashCode + character.hairColor.hashCode);
    
    // Sometimes add glasses
    if (random.nextDouble() > 0.7) {
      _drawGlasses(canvas, size, center);
    }
    
    // Sometimes add earrings for females
    if (character.gender == Gender.female && random.nextDouble() > 0.6) {
      _drawEarrings(canvas, size, center);
    }
  }

  void _drawGlasses(Canvas canvas, Size size, Offset center) {
    final glassesPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    final lensRadius = size.width * 0.08;
    final leftLensCenter = Offset(center.dx - size.width * 0.15, center.dy - size.height * 0.08);
    final rightLensCenter = Offset(center.dx + size.width * 0.15, center.dy - size.height * 0.08);
    
    // Lenses
    canvas.drawCircle(leftLensCenter, lensRadius, glassesPaint);
    canvas.drawCircle(rightLensCenter, lensRadius, glassesPaint);
    
    // Bridge
    canvas.drawLine(
      Offset(leftLensCenter.dx + lensRadius, leftLensCenter.dy),
      Offset(rightLensCenter.dx - lensRadius, rightLensCenter.dy),
      glassesPaint,
    );
  }

  void _drawEarrings(Canvas canvas, Size size, Offset center) {
    final earringPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;
    
    final earringSize = size.width * 0.02;
    
    // Left earring
    canvas.drawCircle(
      Offset(center.dx - size.width * 0.35, center.dy - size.height * 0.05),
      earringSize,
      earringPaint,
    );
    
    // Right earring
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.35, center.dy - size.height * 0.05),
      earringSize,
      earringPaint,
    );
  }

  // Hair style implementations
  void _drawShortHair(Canvas canvas, Offset center, double radius, Paint paint) {
    final hairPath = Path();
    hairPath.addArc(
      Rect.fromCircle(center: Offset(center.dx, center.dy - radius * 0.15), radius: radius * 0.8),
      -math.pi,
      math.pi,
    );
    canvas.drawPath(hairPath, paint);
  }

  void _drawMediumHair(Canvas canvas, Offset center, double radius, Paint paint) {
    final hairRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - radius * 0.2),
      width: radius * 1.6,
      height: radius * 1.2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(hairRect, Radius.circular(radius * 0.3)),
      paint,
    );
  }

  void _drawLongHair(Canvas canvas, Offset center, double radius, Paint paint) {
    final hairRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - radius * 0.1),
      width: radius * 1.8,
      height: radius * 1.6,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(hairRect, Radius.circular(radius * 0.4)),
      paint,
    );
  }

  void _drawCurlyHair(Canvas canvas, Offset center, double radius, Paint paint) {
    // Draw multiple small circles for curly texture
    for (int i = 0; i < 12; i++) {
      final angle = (i * math.pi * 2) / 12;
      final x = center.dx + math.cos(angle) * radius * 0.7;
      final y = center.dy - radius * 0.2 + math.sin(angle) * radius * 0.3;
      canvas.drawCircle(Offset(x, y), radius * 0.15, paint);
    }
  }

  void _drawWavyHair(Canvas canvas, Offset center, double radius, Paint paint) {
    final wavePath = Path();
    final startX = center.dx - radius * 0.8;
    final endX = center.dx + radius * 0.8;
    final y = center.dy - radius * 0.3;
    
    wavePath.moveTo(startX, y);
    for (double x = startX; x <= endX; x += radius * 0.1) {
      final waveY = y + math.sin((x - startX) * 0.1) * radius * 0.1;
      wavePath.lineTo(x, waveY);
    }
    
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = radius * 0.3;
    paint.strokeCap = StrokeCap.round;
    canvas.drawPath(wavePath, paint);
  }

  void _drawStraightHair(Canvas canvas, Offset center, double radius, Paint paint) {
    final hairRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - radius * 0.25),
      width: radius * 1.4,
      height: radius * 1.0,
    );
    canvas.drawRect(hairRect, paint);
  }

  void _drawMohawk(Canvas canvas, Offset center, double radius, Paint paint) {
    final mohawkRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - radius * 0.4),
      width: radius * 0.3,
      height: radius * 0.8,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(mohawkRect, Radius.circular(radius * 0.1)),
      paint,
    );
  }

  void _drawDreadlocks(Canvas canvas, Offset center, double radius, Paint paint) {
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = radius * 0.08;
    paint.strokeCap = StrokeCap.round;
    
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2) / 8;
      final startX = center.dx + math.cos(angle) * radius * 0.6;
      final startY = center.dy - radius * 0.2 + math.sin(angle) * radius * 0.2;
      final endX = startX + math.cos(angle) * radius * 0.4;
      final endY = startY + radius * 0.6;
      
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  void _drawBuzzCut(Canvas canvas, Offset center, double radius, Paint paint) {
    paint.color = paint.color.withOpacity(0.3);
    canvas.drawCircle(
      Offset(center.dx, center.dy - radius * 0.1),
      radius * 0.7,
      paint,
    );
  }

  void _drawEyelashes(Canvas canvas, Offset leftEye, Offset rightEye, double eyeWidth) {
    final lashPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    
    // Left eye lashes
    for (int i = 0; i < 5; i++) {
      final startX = leftEye.dx - eyeWidth * 0.4 + (i * eyeWidth * 0.2);
      final startY = leftEye.dy - eyeWidth * 0.4;
      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX, startY - eyeWidth * 0.15),
        lashPaint,
      );
    }
    
    // Right eye lashes
    for (int i = 0; i < 5; i++) {
      final startX = rightEye.dx - eyeWidth * 0.4 + (i * eyeWidth * 0.2);
      final startY = rightEye.dy - eyeWidth * 0.4;
      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX, startY - eyeWidth * 0.15),
        lashPaint,
      );
    }
  }

  // Helper methods
  Rect _getFaceRect(Offset center, double radius) {
    return Rect.fromCircle(center: center, radius: radius);
  }

  void _addFaceHighlights(Canvas canvas, Offset center, double radius, Color skinColor) {
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    // Forehead highlight
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - radius * 0.3),
        width: radius * 0.6,
        height: radius * 0.3,
      ),
      highlightPaint,
    );
    
    // Cheek highlights
    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy + radius * 0.1),
      radius * 0.15,
      highlightPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.3, center.dy + radius * 0.1),
      radius * 0.15,
      highlightPaint,
    );
  }

  void _drawHeartShape(Canvas canvas, Offset center, double radius, Paint paint) {
    final heartPath = Path();
    heartPath.moveTo(center.dx, center.dy + radius * 0.8);
    heartPath.quadraticBezierTo(
      center.dx - radius * 0.8, center.dy - radius * 0.2,
      center.dx - radius * 0.4, center.dy - radius * 0.6,
    );
    heartPath.quadraticBezierTo(
      center.dx, center.dy - radius * 0.8,
      center.dx + radius * 0.4, center.dy - radius * 0.6,
    );
    heartPath.quadraticBezierTo(
      center.dx + radius * 0.8, center.dy - radius * 0.2,
      center.dx, center.dy + radius * 0.8,
    );
    canvas.drawPath(heartPath, paint);
  }

  void _drawDiamondShape(Canvas canvas, Offset center, double radius, Paint paint) {
    final diamondPath = Path();
    diamondPath.moveTo(center.dx, center.dy - radius);
    diamondPath.lineTo(center.dx + radius * 0.6, center.dy);
    diamondPath.lineTo(center.dx, center.dy + radius);
    diamondPath.lineTo(center.dx - radius * 0.6, center.dy);
    diamondPath.close();
    canvas.drawPath(diamondPath, paint);
  }

  Color _darkenColor(Color color, double amount) {
    return Color.fromARGB(
      color.alpha,
      (color.red * (1 - amount)).round(),
      (color.green * (1 - amount)).round(),
      (color.blue * (1 - amount)).round(),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
