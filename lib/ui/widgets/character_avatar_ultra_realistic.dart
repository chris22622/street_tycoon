import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../data/character_models.dart';

class UltraRealisticCharacterAvatar extends StatelessWidget {
  final CharacterAppearance character;
  final double size;
  final bool showBorder;

  const UltraRealisticCharacterAvatar({
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
            ? Border.all(color: Colors.white.withOpacity(0.6), width: 2)
            : null,
        boxShadow: showBorder ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ] : null,
      ),
      child: ClipOval(
        child: CustomPaint(
          size: Size(size, size),
          painter: _UltraRealisticFacePainter(character: character),
        ),
      ),
    );
  }
}

class _UltraRealisticFacePainter extends CustomPainter {
  final CharacterAppearance character;

  _UltraRealisticFacePainter({required this.character});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final faceRadius = size.width * 0.45;
    
    // Background gradient
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFF0F8FF),
          const Color(0xFFE6F3FF),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: faceRadius));
    canvas.drawCircle(center, faceRadius, bgPaint);
    
    // Draw face with proper proportions
    _drawRealisticFace(canvas, size, center, faceRadius);
    
    // Draw hair first (background layer)
    if (character.hairStyle != HairStyle.bald) {
      _drawRealisticHair(canvas, size, center, faceRadius);
    }
    
    // Draw facial features in proper order
    _drawRealisticEyes(canvas, size, center);
    _drawRealisticNose(canvas, size, center);
    _drawRealisticMouth(canvas, size, center);
    _drawRealisticEyebrows(canvas, size, center);
    
    // Gender-specific features
    if (character.gender == Gender.male) {
      _drawMasculineFeatures(canvas, size, center);
    } else if (character.gender == Gender.female) {
      _drawFeminineFeatures(canvas, size, center);
    }
    
    // Add realistic shading and highlights
    _addRealisticShading(canvas, size, center, faceRadius);
  }

  void _drawRealisticFace(Canvas canvas, Size size, Offset center, double radius) {
    final skinColor = Color(int.parse('0xFF${character.skinTone.colorHex.substring(1)}'));
    
    // Create realistic skin gradient
    final facePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.4), // Light from top-left
        colors: [
          _lightenColor(skinColor, 0.15),
          skinColor,
          _darkenColor(skinColor, 0.1),
          _darkenColor(skinColor, 0.2),
        ],
        stops: const [0.0, 0.4, 0.8, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    // Draw face shape with more realistic proportions
    
    switch (character.faceShape) {
      case FaceShape.round:
        canvas.drawCircle(center, radius * 0.9, facePaint);
        break;
      case FaceShape.oval:
        canvas.drawOval(
          Rect.fromCenter(center: center, width: radius * 1.6, height: radius * 1.9),
          facePaint,
        );
        break;
      case FaceShape.square:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: center, width: radius * 1.7, height: radius * 1.8),
            Radius.circular(radius * 0.15),
          ),
          facePaint,
        );
        break;
      case FaceShape.heart:
        _drawRealisticHeartShape(canvas, center, radius, facePaint);
        break;
      case FaceShape.diamond:
        _drawRealisticDiamondShape(canvas, center, radius, facePaint);
        break;
      case FaceShape.oblong:
        canvas.drawOval(
          Rect.fromCenter(center: center, width: radius * 1.4, height: radius * 2.1),
          facePaint,
        );
        break;
    }
  }

  void _drawRealisticHair(Canvas canvas, Size size, Offset center, double radius) {
    final hairColor = Color(int.parse('0xFF${character.hairColor.colorHex.substring(1)}'));
    
    // Create hair gradient for depth
    final hairPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _lightenColor(hairColor, 0.1),
          hairColor,
          _darkenColor(hairColor, 0.2),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.2));
    
    switch (character.hairStyle) {
      case HairStyle.short:
        _drawRealisticShortHair(canvas, center, radius, hairPaint);
        break;
      case HairStyle.medium:
        _drawRealisticMediumHair(canvas, center, radius, hairPaint);
        break;
      case HairStyle.long:
        _drawRealisticLongHair(canvas, center, radius, hairPaint);
        break;
      case HairStyle.curly:
        _drawRealisticCurlyHair(canvas, center, radius, hairPaint);
        break;
      case HairStyle.wavy:
        _drawRealisticWavyHair(canvas, center, radius, hairPaint);
        break;
      case HairStyle.straight:
        _drawRealisticStraightHair(canvas, center, radius, hairPaint);
        break;
      case HairStyle.mohawk:
        _drawRealisticMohawk(canvas, center, radius, hairPaint);
        break;
      case HairStyle.dreadlocks:
        _drawRealisticDreadlocks(canvas, center, radius, hairPaint);
        break;
      case HairStyle.buzz:
        _drawRealisticBuzzCut(canvas, center, radius, hairPaint);
        break;
      case HairStyle.bald:
        break;
    }
  }

  void _drawRealisticEyes(Canvas canvas, Size size, Offset center) {
    final eyeColor = Color(int.parse('0xFF${character.eyeColor.colorHex.substring(1)}'));
    final eyeWidth = size.width * 0.14;
    final eyeHeight = size.width * 0.09;
    
    // Eye positioning with realistic spacing
    final leftEyeCenter = Offset(center.dx - size.width * 0.16, center.dy - size.height * 0.08);
    final rightEyeCenter = Offset(center.dx + size.width * 0.16, center.dy - size.height * 0.08);
    
    for (final eyeCenter in [leftEyeCenter, rightEyeCenter]) {
      // Eye socket shadow
      final socketPaint = Paint()
        ..color = Colors.black.withOpacity(0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawOval(
        Rect.fromCenter(center: eyeCenter, width: eyeWidth * 1.2, height: eyeHeight * 1.2),
        socketPaint,
      );
      
      // Eye white with realistic shape
      final eyeWhitePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      
      final eyePath = Path();
      eyePath.addOval(Rect.fromCenter(center: eyeCenter, width: eyeWidth, height: eyeHeight));
      canvas.drawPath(eyePath, eyeWhitePaint);
      
      // Iris with realistic gradient
      final irisPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            _lightenColor(eyeColor, 0.3),
            eyeColor,
            _darkenColor(eyeColor, 0.4),
          ],
          stops: const [0.0, 0.6, 1.0],
        ).createShader(Rect.fromCircle(center: eyeCenter, radius: eyeWidth * 0.35));
      
      canvas.drawCircle(eyeCenter, eyeWidth * 0.35, irisPaint);
      
      // Pupil
      final pupilPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;
      canvas.drawCircle(eyeCenter, eyeWidth * 0.18, pupilPaint);
      
      // Multiple realistic highlights
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.9)
        ..style = PaintingStyle.fill;
      
      // Main highlight
      canvas.drawCircle(
        Offset(eyeCenter.dx - eyeWidth * 0.08, eyeCenter.dy - eyeWidth * 0.08),
        eyeWidth * 0.08,
        highlightPaint,
      );
      
      // Secondary highlight
      canvas.drawCircle(
        Offset(eyeCenter.dx + eyeWidth * 0.15, eyeCenter.dy - eyeWidth * 0.05),
        eyeWidth * 0.03,
        highlightPaint,
      );
      
      // Detailed eyelashes
      _drawDetailedEyelashes(canvas, eyeCenter, eyeWidth, eyeHeight);
      
      // Eye contour
      final contourPaint = Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawOval(
        Rect.fromCenter(center: eyeCenter, width: eyeWidth, height: eyeHeight),
        contourPaint,
      );
    }
  }

  void _drawRealisticNose(Canvas canvas, Size size, Offset center) {
    final skinColor = Color(int.parse('0xFF${character.skinTone.colorHex.substring(1)}'));
    final noseCenter = Offset(center.dx, center.dy + size.height * 0.02);
    
    // Nose bridge highlight
    final bridgePaint = Paint()
      ..color = _lightenColor(skinColor, 0.2)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);
    
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(noseCenter.dx, noseCenter.dy - size.height * 0.03),
        width: size.width * 0.04,
        height: size.height * 0.08,
      ),
      bridgePaint,
    );
    
    // Nose tip
    final tipPaint = Paint()
      ..color = skinColor
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(noseCenter.dx, noseCenter.dy + size.height * 0.01),
      size.width * 0.025,
      tipPaint,
    );
    
    // Nostril shadows
    final nostrilPaint = Paint()
      ..color = _darkenColor(skinColor, 0.4)
      ..style = PaintingStyle.fill;
    
    final nostrilRadius = size.width * 0.012;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(noseCenter.dx - size.width * 0.025, noseCenter.dy + size.height * 0.025),
        width: nostrilRadius * 2,
        height: nostrilRadius,
      ),
      nostrilPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(noseCenter.dx + size.width * 0.025, noseCenter.dy + size.height * 0.025),
        width: nostrilRadius * 2,
        height: nostrilRadius,
      ),
      nostrilPaint,
    );
  }

  void _drawRealisticMouth(Canvas canvas, Size size, Offset center) {
    final mouthCenter = Offset(center.dx, center.dy + size.height * 0.15);
    final mouthWidth = size.width * (character.gender == Gender.female ? 0.16 : 0.14);
    
    // Gender-specific lip color
    Color lipColor;
    if (character.gender == Gender.female) {
      lipColor = const Color(0xFFCD5C5C); // Natural rose color
    } else {
      final skinColor = Color(int.parse('0xFF${character.skinTone.colorHex.substring(1)}'));
      lipColor = _darkenColor(skinColor, 0.1);
    }
    
    // Upper lip
    final upperLipPaint = Paint()
      ..color = _darkenColor(lipColor, 0.1)
      ..style = PaintingStyle.fill;
    
    final upperLipPath = Path();
    upperLipPath.moveTo(mouthCenter.dx - mouthWidth * 0.5, mouthCenter.dy);
    upperLipPath.quadraticBezierTo(
      mouthCenter.dx - mouthWidth * 0.25, mouthCenter.dy - size.height * 0.02,
      mouthCenter.dx, mouthCenter.dy - size.height * 0.01,
    );
    upperLipPath.quadraticBezierTo(
      mouthCenter.dx + mouthWidth * 0.25, mouthCenter.dy - size.height * 0.02,
      mouthCenter.dx + mouthWidth * 0.5, mouthCenter.dy,
    );
    canvas.drawPath(upperLipPath, upperLipPaint);
    
    // Lower lip
    final lowerLipPaint = Paint()
      ..color = lipColor
      ..style = PaintingStyle.fill;
    
    final lowerLipPath = Path();
    lowerLipPath.moveTo(mouthCenter.dx - mouthWidth * 0.5, mouthCenter.dy);
    lowerLipPath.quadraticBezierTo(
      mouthCenter.dx, mouthCenter.dy + size.height * 0.025,
      mouthCenter.dx + mouthWidth * 0.5, mouthCenter.dy,
    );
    canvas.drawPath(lowerLipPath, lowerLipPaint);
    
    // Lip highlight for females
    if (character.gender == Gender.female) {
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..style = PaintingStyle.fill;
      
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(mouthCenter.dx, mouthCenter.dy + size.height * 0.01),
          width: mouthWidth * 0.6,
          height: size.height * 0.015,
        ),
        highlightPaint,
      );
    }
  }

  void _drawRealisticEyebrows(Canvas canvas, Size size, Offset center) {
    final hairColor = Color(int.parse('0xFF${character.hairColor.colorHex.substring(1)}'));
    final browPaint = Paint()
      ..color = _darkenColor(hairColor, 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.015
      ..strokeCap = StrokeCap.round;
    
    final browY = center.dy - size.height * 0.15;
    
    // Gender-specific eyebrow shapes
    if (character.gender == Gender.female) {
      // Thinner, more arched eyebrows for females
      final leftBrowPath = Path();
      leftBrowPath.moveTo(center.dx - size.width * 0.22, browY + size.height * 0.01);
      leftBrowPath.quadraticBezierTo(
        center.dx - size.width * 0.15, browY - size.height * 0.02,
        center.dx - size.width * 0.08, browY + size.height * 0.005,
      );
      canvas.drawPath(leftBrowPath, browPaint);
      
      final rightBrowPath = Path();
      rightBrowPath.moveTo(center.dx + size.width * 0.08, browY + size.height * 0.005);
      rightBrowPath.quadraticBezierTo(
        center.dx + size.width * 0.15, browY - size.height * 0.02,
        center.dx + size.width * 0.22, browY + size.height * 0.01,
      );
      canvas.drawPath(rightBrowPath, browPaint);
    } else {
      // Thicker, straighter eyebrows for males
      browPaint.strokeWidth = size.width * 0.02;
      
      canvas.drawLine(
        Offset(center.dx - size.width * 0.20, browY),
        Offset(center.dx - size.width * 0.08, browY - size.height * 0.01),
        browPaint,
      );
      
      canvas.drawLine(
        Offset(center.dx + size.width * 0.08, browY - size.height * 0.01),
        Offset(center.dx + size.width * 0.20, browY),
        browPaint,
      );
    }
  }

  void _drawMasculineFeatures(Canvas canvas, Size size, Offset center) {
    final hairColor = Color(int.parse('0xFF${character.hairColor.colorHex.substring(1)}'));
    final facialHairPaint = Paint()
      ..color = _darkenColor(hairColor, 0.2)
      ..style = PaintingStyle.fill;
    
    final random = math.Random(character.skinTone.hashCode);
    
    // More prominent jawline
    final jawPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);
    
    canvas.drawArc(
      Rect.fromCenter(center: Offset(center.dx, center.dy + size.height * 0.1), width: size.width * 0.8, height: size.height * 0.6),
      math.pi * 0.2,
      math.pi * 0.6,
      false,
      jawPaint,
    );
    
    // Facial hair variations
    if (random.nextDouble() > 0.6) {
      // Mustache
      final mustachePath = Path();
      mustachePath.addOval(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + size.height * 0.10),
          width: size.width * 0.14,
          height: size.height * 0.025,
        ),
      );
      canvas.drawPath(mustachePath, facialHairPaint);
    }
    
    if (random.nextDouble() > 0.7) {
      // Beard/goatee
      final beardPath = Path();
      beardPath.addOval(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + size.height * 0.22),
          width: size.width * 0.12,
          height: size.height * 0.08,
        ),
      );
      canvas.drawPath(beardPath, facialHairPaint);
    }
  }

  void _drawFeminineFeatures(Canvas canvas, Size size, Offset center) {
    // Softer cheek definition
    final cheekPaint = Paint()
      ..color = const Color(0xFFFFB6C1).withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    
    // Blush on cheeks
    canvas.drawCircle(
      Offset(center.dx - size.width * 0.25, center.dy + size.height * 0.05),
      size.width * 0.08,
      cheekPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.25, center.dy + size.height * 0.05),
      size.width * 0.08,
      cheekPaint,
    );
    
    // Optional earrings
    final random = math.Random(character.skinTone.hashCode + character.hairColor.hashCode);
    if (random.nextDouble() > 0.5) {
      final earringPaint = Paint()
        ..color = const Color(0xFFFFD700) // Gold color
        ..style = PaintingStyle.fill;
      
      // Left earring
      canvas.drawCircle(
        Offset(center.dx - size.width * 0.38, center.dy - size.height * 0.02),
        size.width * 0.02,
        earringPaint,
      );
      
      // Right earring
      canvas.drawCircle(
        Offset(center.dx + size.width * 0.38, center.dy - size.height * 0.02),
        size.width * 0.02,
        earringPaint,
      );
    }
  }

  void _addRealisticShading(Canvas canvas, Size size, Offset center, double radius) {
    // Overall face shading
    final shadingPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.3, -0.3),
        colors: [
          Colors.transparent,
          Colors.black.withOpacity(0.05),
          Colors.black.withOpacity(0.15),
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..blendMode = BlendMode.multiply;
    
    canvas.drawCircle(center, radius * 0.9, shadingPaint);
  }

  // Hair style implementations with more detail
  void _drawRealisticShortHair(Canvas canvas, Offset center, double radius, Paint paint) {
    final hairPath = Path();
    hairPath.addArc(
      Rect.fromCircle(center: Offset(center.dx, center.dy - radius * 0.1), radius: radius * 0.85),
      -math.pi * 1.1,
      math.pi * 1.2,
    );
    canvas.drawPath(hairPath, paint);
    
    // Add hair texture
    _addHairTexture(canvas, center, radius * 0.85, paint.shader!);
  }

  void _drawRealisticMediumHair(Canvas canvas, Offset center, double radius, Paint paint) {
    final hairRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - radius * 0.15),
      width: radius * 1.7,
      height: radius * 1.3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(hairRect, Radius.circular(radius * 0.4)),
      paint,
    );
    _addHairTexture(canvas, center, radius, paint.shader!);
  }

  void _drawRealisticLongHair(Canvas canvas, Offset center, double radius, Paint paint) {
    final hairRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - radius * 0.05),
      width: radius * 1.9,
      height: radius * 1.8,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(hairRect, Radius.circular(radius * 0.5)),
      paint,
    );
    _addHairTexture(canvas, center, radius * 1.2, paint.shader!);
  }

  void _drawRealisticCurlyHair(Canvas canvas, Offset center, double radius, Paint paint) {
    // Create curly texture with multiple overlapping circles
    for (int i = 0; i < 15; i++) {
      final angle = (i * math.pi * 2) / 15;
      final x = center.dx + math.cos(angle) * radius * 0.8;
      final y = center.dy - radius * 0.2 + math.sin(angle) * radius * 0.4;
      canvas.drawCircle(Offset(x, y), radius * 0.18, paint);
    }
  }

  void _drawRealisticWavyHair(Canvas canvas, Offset center, double radius, Paint paint) {
    final wavePath = Path();
    final hairRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - radius * 0.1),
      width: radius * 1.6,
      height: radius * 1.1,
    );
    
    wavePath.addRRect(RRect.fromRectAndRadius(hairRect, Radius.circular(radius * 0.3)));
    canvas.drawPath(wavePath, paint);
    
    // Add wave texture
    final wavePaint = Paint()
      ..color = paint.color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.05;
    
    for (int i = 0; i < 5; i++) {
      final waveY = center.dy - radius * 0.4 + (i * radius * 0.15);
      final wavePath = Path();
      wavePath.moveTo(center.dx - radius * 0.6, waveY);
      
      for (double x = center.dx - radius * 0.6; x <= center.dx + radius * 0.6; x += radius * 0.1) {
        final waveOffset = math.sin((x - center.dx) * 0.1) * radius * 0.05;
        wavePath.lineTo(x, waveY + waveOffset);
      }
      
      canvas.drawPath(wavePath, wavePaint);
    }
  }

  void _drawRealisticStraightHair(Canvas canvas, Offset center, double radius, Paint paint) {
    final hairRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - radius * 0.2),
      width: radius * 1.5,
      height: radius * 1.1,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(hairRect, Radius.circular(radius * 0.1)),
      paint,
    );
    
    // Add straight hair strands
    final strandPaint = Paint()
      ..color = paint.color.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    for (int i = 0; i < 10; i++) {
      final x = center.dx - radius * 0.6 + (i * radius * 0.12);
      canvas.drawLine(
        Offset(x, center.dy - radius * 0.7),
        Offset(x, center.dy - radius * 0.1),
        strandPaint,
      );
    }
  }

  void _drawRealisticMohawk(Canvas canvas, Offset center, double radius, Paint paint) {
    final mohawkRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - radius * 0.4),
      width: radius * 0.4,
      height: radius * 0.9,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(mohawkRect, Radius.circular(radius * 0.05)),
      paint,
    );
  }

  void _drawRealisticDreadlocks(Canvas canvas, Offset center, double radius, Paint paint) {
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = radius * 0.1;
    paint.strokeCap = StrokeCap.round;
    
    for (int i = 0; i < 12; i++) {
      final angle = (i * math.pi * 2) / 12;
      final startX = center.dx + math.cos(angle) * radius * 0.7;
      final startY = center.dy - radius * 0.1 + math.sin(angle) * radius * 0.3;
      final endX = startX + math.cos(angle) * radius * 0.5;
      final endY = startY + radius * 0.8;
      
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  void _drawRealisticBuzzCut(Canvas canvas, Offset center, double radius, Paint paint) {
    paint.color = paint.color.withOpacity(0.4);
    final buzzPath = Path();
    buzzPath.addArc(
      Rect.fromCircle(center: Offset(center.dx, center.dy - radius * 0.05), radius: radius * 0.75),
      -math.pi,
      math.pi,
    );
    canvas.drawPath(buzzPath, paint);
  }

  void _addHairTexture(Canvas canvas, Offset center, double radius, Shader shader) {
    final texturePaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.black.withOpacity(0.1);
    
    // Add subtle hair strands for texture
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2) / 8;
      final startX = center.dx + math.cos(angle) * radius * 0.6;
      final startY = center.dy + math.sin(angle) * radius * 0.6;
      final endX = center.dx + math.cos(angle) * radius * 0.9;
      final endY = center.dy + math.sin(angle) * radius * 0.9;
      
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), texturePaint);
    }
  }

  void _drawDetailedEyelashes(Canvas canvas, Offset eyeCenter, double eyeWidth, double eyeHeight) {
    final lashPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round;
    
    // Upper lashes
    for (int i = 0; i < 8; i++) {
      final x = eyeCenter.dx - eyeWidth * 0.4 + (i * eyeWidth * 0.1);
      final startY = eyeCenter.dy - eyeHeight * 0.4;
      final endY = startY - eyeWidth * 0.12;
      
      canvas.drawLine(Offset(x, startY), Offset(x, endY), lashPaint);
    }
    
    // Lower lashes (shorter)
    lashPaint.strokeWidth = 0.5;
    for (int i = 0; i < 5; i++) {
      final x = eyeCenter.dx - eyeWidth * 0.3 + (i * eyeWidth * 0.15);
      final startY = eyeCenter.dy + eyeHeight * 0.35;
      final endY = startY + eyeWidth * 0.06;
      
      canvas.drawLine(Offset(x, startY), Offset(x, endY), lashPaint);
    }
  }

  // Helper methods

  void _drawRealisticHeartShape(Canvas canvas, Offset center, double radius, Paint paint) {
    final heartPath = Path();
    heartPath.moveTo(center.dx, center.dy + radius * 0.9);
    
    // Left curve
    heartPath.quadraticBezierTo(
      center.dx - radius * 0.9, center.dy - radius * 0.1,
      center.dx - radius * 0.5, center.dy - radius * 0.7,
    );
    heartPath.quadraticBezierTo(
      center.dx - radius * 0.2, center.dy - radius * 0.9,
      center.dx, center.dy - radius * 0.8,
    );
    
    // Right curve
    heartPath.quadraticBezierTo(
      center.dx + radius * 0.2, center.dy - radius * 0.9,
      center.dx + radius * 0.5, center.dy - radius * 0.7,
    );
    heartPath.quadraticBezierTo(
      center.dx + radius * 0.9, center.dy - radius * 0.1,
      center.dx, center.dy + radius * 0.9,
    );
    
    canvas.drawPath(heartPath, paint);
  }

  void _drawRealisticDiamondShape(Canvas canvas, Offset center, double radius, Paint paint) {
    final diamondPath = Path();
    diamondPath.moveTo(center.dx, center.dy - radius * 1.1);
    diamondPath.lineTo(center.dx + radius * 0.7, center.dy - radius * 0.2);
    diamondPath.lineTo(center.dx + radius * 0.5, center.dy + radius * 0.8);
    diamondPath.lineTo(center.dx - radius * 0.5, center.dy + radius * 0.8);
    diamondPath.lineTo(center.dx - radius * 0.7, center.dy - radius * 0.2);
    diamondPath.close();
    canvas.drawPath(diamondPath, paint);
  }

  Color _lightenColor(Color color, double amount) {
    return Color.fromARGB(
      color.alpha,
      (color.red + (255 - color.red) * amount).round().clamp(0, 255),
      (color.green + (255 - color.green) * amount).round().clamp(0, 255),
      (color.blue + (255 - color.blue) * amount).round().clamp(0, 255),
    );
  }

  Color _darkenColor(Color color, double amount) {
    return Color.fromARGB(
      color.alpha,
      (color.red * (1 - amount)).round().clamp(0, 255),
      (color.green * (1 - amount)).round().clamp(0, 255),
      (color.blue * (1 - amount)).round().clamp(0, 255),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
