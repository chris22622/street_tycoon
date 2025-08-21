import 'package:flutter/material.dart';
import '../../data/character_models.dart';
import 'dart:math' as math;

class CharacterAvatar extends StatelessWidget {
  final Gender gender;
  final Ethnicity ethnicity;
  final SkinTone skinTone;
  final HairColor hairColor;
  final HairStyle hairStyle;
  final FaceShape faceShape;
  final EyeColor eyeColor;
  final double size;
  final bool showDetails;

  const CharacterAvatar({
    super.key,
    required this.gender,
    required this.ethnicity,
    required this.skinTone,
    required this.hairColor,
    required this.hairStyle,
    required this.faceShape,
    required this.eyeColor,
    this.size = 120,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.withOpacity(0.3),
            Colors.purple.withOpacity(0.3),
            Colors.pink.withOpacity(0.2),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 8),
        child: CustomPaint(
          painter: CharacterPainter(
            gender: gender,
            ethnicity: ethnicity,
            skinTone: skinTone,
            hairColor: hairColor,
            hairStyle: hairStyle,
            faceShape: faceShape,
            eyeColor: eyeColor,
            size: size,
          ),
          child: showDetails ? _buildDetailsOverlay() : null,
        ),
      ),
    );
  }

  Widget _buildDetailsOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            gender.emoji,
            style: TextStyle(
              fontSize: size / 6,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class CharacterPainter extends CustomPainter {
  final Gender gender;
  final Ethnicity ethnicity;
  final SkinTone skinTone;
  final HairColor hairColor;
  final HairStyle hairStyle;
  final FaceShape faceShape;
  final EyeColor eyeColor;
  final double size;

  CharacterPainter({
    required this.gender,
    required this.ethnicity,
    required this.skinTone,
    required this.hairColor,
    required this.hairStyle,
    required this.faceShape,
    required this.eyeColor,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final faceRadius = canvasSize.width * 0.35;
    
    // Draw background pattern
    _drawBackground(canvas, canvasSize);
    
    // Draw hair (back layer)
    _drawHairBack(canvas, center, faceRadius);
    
    // Draw face
    _drawFace(canvas, center, faceRadius);
    
    // Draw facial features
    _drawEyes(canvas, center, faceRadius);
    _drawNose(canvas, center, faceRadius);
    _drawMouth(canvas, center, faceRadius);
    
    // Draw hair (front layer)
    _drawHairFront(canvas, center, faceRadius);
    
    // Draw accessories/details
    _drawAccessories(canvas, center, faceRadius);
  }

  void _drawBackground(Canvas canvas, Size canvasSize) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          _getSkinColor().withOpacity(0.1),
          _getHairColor().withOpacity(0.1),
          _getEyeColor().withOpacity(0.1),
        ],
      ).createShader(Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height));
    
    canvas.drawRect(Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height), paint);
    
    // Draw subtle pattern
    final patternPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;
    
    for (int i = 0; i < canvasSize.width; i += 20) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), canvasSize.height),
        patternPaint,
      );
    }
  }

  void _drawFace(Canvas canvas, Offset center, double radius) {
    final facePaint = Paint()
      ..color = _getSkinColor()
      ..style = PaintingStyle.fill;
    
    final highlightPaint = Paint()
      ..color = _getSkinColor().withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw face shape based on selected face shape
    Path facePath = Path();
    
    switch (faceShape) {
      case FaceShape.oval:
        facePath.addOval(Rect.fromCircle(center: center, radius: radius));
        break;
      case FaceShape.round:
        facePath.addRRect(RRect.fromRectAndRadius(
          Rect.fromCircle(center: center, radius: radius),
          Radius.circular(radius * 0.8),
        ));
        break;
      case FaceShape.square:
        facePath.addRRect(RRect.fromRectAndRadius(
          Rect.fromCircle(center: center, radius: radius),
          Radius.circular(radius * 0.2),
        ));
        break;
      case FaceShape.heart:
        _drawHeartShape(facePath, center, radius);
        break;
      case FaceShape.diamond:
        _drawDiamondShape(facePath, center, radius);
        break;
      case FaceShape.oblong:
        facePath.addRRect(RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: radius * 1.6, height: radius * 2.2),
          Radius.circular(radius * 0.5),
        ));
        break;
    }
    
    canvas.drawPath(facePath, facePaint);
    
    // Add subtle highlighting
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(facePath, shadowPaint);
    
    // Add highlight on forehead
    canvas.drawCircle(
      Offset(center.dx, center.dy - radius * 0.3),
      radius * 0.2,
      highlightPaint,
    );
  }

  void _drawEyes(Canvas canvas, Offset center, double radius) {
    final eyeColor = _getEyeColor();
    final eyePaint = Paint()
      ..color = eyeColor
      ..style = PaintingStyle.fill;
    
    final eyeWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final pupilPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final eyeWidth = radius * 0.25;
    final eyeHeight = radius * 0.15;
    final eyeSpacing = radius * 0.4;

    // Left eye
    final leftEyeCenter = Offset(center.dx - eyeSpacing, center.dy - radius * 0.1);
    _drawDetailedEye(canvas, leftEyeCenter, eyeWidth, eyeHeight, eyeWhitePaint, eyePaint, pupilPaint, highlightPaint);

    // Right eye
    final rightEyeCenter = Offset(center.dx + eyeSpacing, center.dy - radius * 0.1);
    _drawDetailedEye(canvas, rightEyeCenter, eyeWidth, eyeHeight, eyeWhitePaint, eyePaint, pupilPaint, highlightPaint);

    // Eyelashes
    _drawEyelashes(canvas, leftEyeCenter, rightEyeCenter, eyeWidth, eyeHeight);
  }

  void _drawDetailedEye(Canvas canvas, Offset center, double width, double height, 
                       Paint whitePaint, Paint irisPaint, Paint pupilPaint, Paint highlightPaint) {
    // Eye white
    canvas.drawOval(Rect.fromCenter(center: center, width: width * 2, height: height * 2), whitePaint);
    
    // Iris
    canvas.drawCircle(center, width * 0.7, irisPaint);
    
    // Pupil
    canvas.drawCircle(center, width * 0.4, pupilPaint);
    
    // Highlight
    canvas.drawCircle(Offset(center.dx - width * 0.2, center.dy - width * 0.2), width * 0.15, highlightPaint);
    
    // Eye outline
    final outlinePaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawOval(Rect.fromCenter(center: center, width: width * 2, height: height * 2), outlinePaint);
  }

  void _drawEyelashes(Canvas canvas, Offset leftEye, Offset rightEye, double eyeWidth, double eyeHeight) {
    final lashPaint = Paint()
      ..color = _getHairColor().withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Left eye lashes
    for (int i = 0; i < 5; i++) {
      final angle = (i - 2) * 0.3;
      final startX = leftEye.dx + (i - 2) * eyeWidth * 0.3;
      final startY = leftEye.dy - eyeHeight;
      final endX = startX + math.sin(angle) * 8;
      final endY = startY - math.cos(angle) * 8;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), lashPaint);
    }

    // Right eye lashes
    for (int i = 0; i < 5; i++) {
      final angle = (i - 2) * 0.3;
      final startX = rightEye.dx + (i - 2) * eyeWidth * 0.3;
      final startY = rightEye.dy - eyeHeight;
      final endX = startX + math.sin(angle) * 8;
      final endY = startY - math.cos(angle) * 8;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), lashPaint);
    }
  }

  void _drawNose(Canvas canvas, Offset center, double radius) {
    final nosePaint = Paint()
      ..color = _getSkinColor().withAlpha(200)
      ..style = PaintingStyle.fill;
    
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final noseCenter = Offset(center.dx, center.dy + radius * 0.1);
    final noseWidth = radius * 0.1;
    final noseHeight = radius * 0.15;

    // Nose shape
    Path nosePath = Path();
    nosePath.moveTo(noseCenter.dx, noseCenter.dy - noseHeight);
    nosePath.quadraticBezierTo(
      noseCenter.dx - noseWidth, noseCenter.dy,
      noseCenter.dx - noseWidth * 0.5, noseCenter.dy + noseHeight * 0.3,
    );
    nosePath.lineTo(noseCenter.dx + noseWidth * 0.5, noseCenter.dy + noseHeight * 0.3);
    nosePath.quadraticBezierTo(
      noseCenter.dx + noseWidth, noseCenter.dy,
      noseCenter.dx, noseCenter.dy - noseHeight,
    );

    canvas.drawPath(nosePath, nosePaint);
    
    // Nose shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(noseCenter.dx + 2, noseCenter.dy + 2),
        width: noseWidth,
        height: noseHeight * 0.5,
      ),
      shadowPaint,
    );
  }

  void _drawMouth(Canvas canvas, Offset center, double radius) {
    final mouthPaint = Paint()
      ..color = const Color(0xFFE91E63).withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    final teethPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final mouthCenter = Offset(center.dx, center.dy + radius * 0.4);
    final mouthWidth = radius * 0.4;
    final mouthHeight = radius * 0.08;

    // Mouth shape
    Path mouthPath = Path();
    mouthPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: mouthCenter, width: mouthWidth, height: mouthHeight),
        Radius.circular(mouthHeight),
      ),
    );

    canvas.drawPath(mouthPath, mouthPaint);
    
    // Teeth highlight
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(mouthCenter.dx, mouthCenter.dy - 1),
          width: mouthWidth * 0.8,
          height: mouthHeight * 0.3,
        ),
        Radius.circular(mouthHeight * 0.15),
      ),
      teethPaint,
    );
  }

  void _drawHairBack(Canvas canvas, Offset center, double radius) {
    if (hairStyle == HairStyle.bald) return;
    
    final hairPaint = Paint()
      ..color = _getHairColor()
      ..style = PaintingStyle.fill;

    switch (hairStyle) {
      case HairStyle.short:
        _drawShortHair(canvas, center, radius, hairPaint, true);
        break;
      case HairStyle.medium:
        _drawMediumHair(canvas, center, radius, hairPaint, true);
        break;
      case HairStyle.long:
        _drawLongHair(canvas, center, radius, hairPaint, true);
        break;
      case HairStyle.curly:
        _drawCurlyHair(canvas, center, radius, hairPaint, true);
        break;
      default:
        _drawShortHair(canvas, center, radius, hairPaint, true);
    }
  }

  void _drawHairFront(Canvas canvas, Offset center, double radius) {
    if (hairStyle == HairStyle.bald) return;
    
    final hairPaint = Paint()
      ..color = _getHairColor()
      ..style = PaintingStyle.fill;

    switch (hairStyle) {
      case HairStyle.short:
        _drawShortHair(canvas, center, radius, hairPaint, false);
        break;
      case HairStyle.medium:
        _drawMediumHair(canvas, center, radius, hairPaint, false);
        break;
      case HairStyle.long:
        _drawLongHair(canvas, center, radius, hairPaint, false);
        break;
      case HairStyle.curly:
        _drawCurlyHair(canvas, center, radius, hairPaint, false);
        break;
      default:
        _drawShortHair(canvas, center, radius, hairPaint, false);
    }
  }

  void _drawShortHair(Canvas canvas, Offset center, double radius, Paint paint, bool isBack) {
    if (isBack) {
      // Back hair
      Path hairPath = Path();
      hairPath.addOval(Rect.fromCircle(center: Offset(center.dx, center.dy - radius * 0.1), radius: radius * 1.1));
      canvas.drawPath(hairPath, paint);
    } else {
      // Front bangs
      Path bangsPath = Path();
      bangsPath.moveTo(center.dx - radius * 0.8, center.dy - radius * 0.8);
      bangsPath.quadraticBezierTo(center.dx, center.dy - radius * 1.2, center.dx + radius * 0.8, center.dy - radius * 0.8);
      bangsPath.lineTo(center.dx + radius * 0.6, center.dy - radius * 0.6);
      bangsPath.quadraticBezierTo(center.dx, center.dy - radius * 0.9, center.dx - radius * 0.6, center.dy - radius * 0.6);
      canvas.drawPath(bangsPath, paint);
    }
  }

  void _drawMediumHair(Canvas canvas, Offset center, double radius, Paint paint, bool isBack) {
    if (isBack) {
      Path hairPath = Path();
      hairPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx, center.dy - radius * 0.2), width: radius * 2.4, height: radius * 2.6),
        Radius.circular(radius * 0.8),
      ));
      canvas.drawPath(hairPath, paint);
    }
  }

  void _drawLongHair(Canvas canvas, Offset center, double radius, Paint paint, bool isBack) {
    if (isBack) {
      Path hairPath = Path();
      hairPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx, center.dy), width: radius * 2.8, height: radius * 3.5),
        Radius.circular(radius * 0.6),
      ));
      canvas.drawPath(hairPath, paint);
    }
  }

  void _drawCurlyHair(Canvas canvas, Offset center, double radius, Paint paint, bool isBack) {
    if (isBack) {
      // Draw multiple overlapping circles for curly texture
      for (int i = 0; i < 8; i++) {
        final angle = (i / 8) * 2 * math.pi;
        final x = center.dx + math.cos(angle) * radius * 0.9;
        final y = center.dy + math.sin(angle) * radius * 0.9 - radius * 0.2;
        canvas.drawCircle(Offset(x, y), radius * 0.3, paint);
      }
    }
  }

  void _drawAccessories(Canvas canvas, Offset center, double radius) {
    // Add subtle glow effect
    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    canvas.drawCircle(center, radius + 5, glowPaint);
    
    // Add gender-specific accessories
    switch (gender) {
      case Gender.male:
        _drawMaleAccessories(canvas, center, radius);
        break;
      case Gender.female:
        _drawFemaleAccessories(canvas, center, radius);
        break;
      case Gender.nonBinary:
        _drawNeutralAccessories(canvas, center, radius);
        break;
    }
  }

  void _drawMaleAccessories(Canvas canvas, Offset center, double radius) {
    // Subtle beard shadow
    final beardPaint = Paint()
      ..color = _getHairColor().withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.5),
        width: radius * 0.8,
        height: radius * 0.3,
      ),
      beardPaint,
    );
  }

  void _drawFemaleAccessories(Canvas canvas, Offset center, double radius) {
    // Subtle makeup highlights
    final makeupPaint = Paint()
      ..color = const Color(0xFFE91E63).withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    // Blush
    canvas.drawCircle(Offset(center.dx - radius * 0.5, center.dy + radius * 0.1), radius * 0.15, makeupPaint);
    canvas.drawCircle(Offset(center.dx + radius * 0.5, center.dy + radius * 0.1), radius * 0.15, makeupPaint);
  }

  void _drawNeutralAccessories(Canvas canvas, Offset center, double radius) {
    // Subtle artistic touches
    final accentPaint = Paint()
      ..color = Colors.purple.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(center, radius + 2, accentPaint);
  }

  void _drawHeartShape(Path path, Offset center, double radius) {
    path.moveTo(center.dx, center.dy + radius);
    path.quadraticBezierTo(center.dx - radius, center.dy - radius * 0.5, center.dx - radius * 0.5, center.dy - radius);
    path.quadraticBezierTo(center.dx, center.dy - radius * 1.2, center.dx + radius * 0.5, center.dy - radius);
    path.quadraticBezierTo(center.dx + radius, center.dy - radius * 0.5, center.dx, center.dy + radius);
  }

  void _drawDiamondShape(Path path, Offset center, double radius) {
    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(center.dx + radius * 0.7, center.dy);
    path.lineTo(center.dx, center.dy + radius);
    path.lineTo(center.dx - radius * 0.7, center.dy);
    path.close();
  }

  Color _getSkinColor() {
    switch (skinTone) {
      case SkinTone.veryLight:
        return const Color(0xFFFDBCAB);
      case SkinTone.light:
        return const Color(0xFFF1C27D);
      case SkinTone.medium:
        return const Color(0xFFE0AC69);
      case SkinTone.tan:
        return const Color(0xFFC68642);
      case SkinTone.dark:
        return const Color(0xFF8D5524);
      case SkinTone.veryDark:
        return const Color(0xFF5D4037);
    }
  }

  Color _getHairColor() {
    switch (hairColor) {
      case HairColor.black:
        return const Color(0xFF212121);
      case HairColor.brown:
        return const Color(0xFF6D4C41);
      case HairColor.blonde:
        return const Color(0xFFF9A825);
      case HairColor.red:
        return const Color(0xFFD32F2F);
      case HairColor.gray:
        return const Color(0xFF9E9E9E);
      case HairColor.white:
        return const Color(0xFFF5F5F5);
      case HairColor.blue:
        return const Color(0xFF1976D2);
      case HairColor.green:
        return const Color(0xFF388E3C);
      case HairColor.purple:
        return const Color(0xFF7B1FA2);
      case HairColor.pink:
        return const Color(0xFFE91E63);
    }
  }

  Color _getEyeColor() {
    switch (eyeColor) {
      case EyeColor.brown:
        return const Color(0xFF6D4C41);
      case EyeColor.blue:
        return const Color(0xFF1976D2);
      case EyeColor.green:
        return const Color(0xFF388E3C);
      case EyeColor.hazel:
        return const Color(0xFF8BC34A);
      case EyeColor.gray:
        return const Color(0xFF9E9E9E);
      case EyeColor.amber:
        return const Color(0xFFFF8F00);
      case EyeColor.violet:
        return const Color(0xFF9C27B0);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
