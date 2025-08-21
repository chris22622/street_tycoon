import 'package:flutter/material.dart';
import '../../data/character_models.dart';
import 'dart:math' as math;

class EnhancedCharacterAvatar extends StatelessWidget {
  final Gender gender;
  final Ethnicity ethnicity;
  final SkinTone skinTone;
  final HairColor hairColor;
  final HairStyle hairStyle;
  final FaceShape faceShape;
  final EyeColor eyeColor;
  final double size;
  final bool showDetails;

  const EnhancedCharacterAvatar({
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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 8),
        child: CustomPaint(
          painter: BitLifeStylePainter(
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
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class BitLifeStylePainter extends CustomPainter {
  final Gender gender;
  final Ethnicity ethnicity;
  final SkinTone skinTone;
  final HairColor hairColor;
  final HairStyle hairStyle;
  final FaceShape faceShape;
  final EyeColor eyeColor;
  final double size;

  BitLifeStylePainter({
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
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final faceRadius = size.width * 0.32;
    
    // Enhanced BitLife-style rendering with better proportions
    _drawBackground(canvas, size);
    _drawHairBack(canvas, center, faceRadius);
    _drawFace(canvas, center, faceRadius);
    _drawEyes(canvas, center, faceRadius);
    _drawNose(canvas, center, faceRadius);
    _drawMouth(canvas, center, faceRadius);
    _drawEyebrows(canvas, center, faceRadius);
    if (gender == Gender.male) {
      _drawFacialHair(canvas, center, faceRadius);
    }
    _drawHairFront(canvas, center, faceRadius);
    _drawAccessories(canvas, center, faceRadius);
  }

  void _drawBackground(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF74b9ff).withOpacity(0.9),
          const Color(0xFF0984e3).withOpacity(0.8),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
  }

  void _drawHairBack(Canvas canvas, Offset center, double faceRadius) {
    if (hairStyle == HairStyle.bald) return;
    
    final hairColor = _getHairColor();
    final hairPaint = Paint()
      ..color = hairColor
      ..style = PaintingStyle.fill;
    
    final hairShadowPaint = Paint()
      ..color = hairColor.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    
    switch (hairStyle) {
      case HairStyle.short:
        _drawShortHair(canvas, center, faceRadius, hairPaint, hairShadowPaint);
        break;
      case HairStyle.medium:
        _drawMediumHair(canvas, center, faceRadius, hairPaint, hairShadowPaint);
        break;
      case HairStyle.long:
        _drawLongHair(canvas, center, faceRadius, hairPaint, hairShadowPaint);
        break;
      case HairStyle.curly:
        _drawCurlyHair(canvas, center, faceRadius, hairPaint, hairShadowPaint);
        break;
      case HairStyle.wavy:
        _drawWavyHair(canvas, center, faceRadius, hairPaint, hairShadowPaint);
        break;
      case HairStyle.buzz:
        _drawBuzzCut(canvas, center, faceRadius, hairPaint, hairShadowPaint);
        break;
      case HairStyle.mohawk:
        _drawMohawk(canvas, center, faceRadius, hairPaint, hairShadowPaint);
        break;
      case HairStyle.dreadlocks:
        _drawDreadlocks(canvas, center, faceRadius, hairPaint, hairShadowPaint);
        break;
      default:
        _drawShortHair(canvas, center, faceRadius, hairPaint, hairShadowPaint);
    }
  }

  void _drawFace(Canvas canvas, Offset center, double faceRadius) {
    final skinColor = _getSkinColor();
    
    // Face shadow for 3D effect
    final shadowPaint = Paint()
      ..color = skinColor.withOpacity(0.6)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    
    // Main face with proper shape
    final facePaint = Paint()
      ..color = skinColor
      ..style = PaintingStyle.fill;
    
    final faceWidth = faceRadius * 1.8;
    final faceHeight = faceRadius * 2.1;
    
    // Draw face shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + 2, center.dy + 2),
        width: faceWidth,
        height: faceHeight,
      ),
      shadowPaint,
    );
    
    // Draw main face based on face shape
    switch (faceShape) {
      case FaceShape.oval:
        canvas.drawOval(
          Rect.fromCenter(center: center, width: faceWidth, height: faceHeight),
          facePaint,
        );
        break;
      case FaceShape.round:
        canvas.drawCircle(center, faceRadius * 1.1, facePaint);
        break;
      case FaceShape.square:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: center, width: faceWidth, height: faceHeight),
            Radius.circular(faceRadius * 0.15),
          ),
          facePaint,
        );
        break;
      case FaceShape.heart:
        _drawHeartFace(canvas, center, faceRadius, facePaint);
        break;
      case FaceShape.diamond:
        _drawDiamondFace(canvas, center, faceRadius, facePaint);
        break;
      default:
        canvas.drawOval(
          Rect.fromCenter(center: center, width: faceWidth, height: faceHeight),
          facePaint,
        );
    }
    
    // Add subtle cheek highlights
    _drawCheeks(canvas, center, faceRadius);
  }

  void _drawEyes(Canvas canvas, Offset center, double faceRadius) {
    final eyeColor = _getEyeColor();
    final eyeSize = faceRadius * 0.15;
    final eyeSpacing = faceRadius * 0.4;
    final eyeY = center.dy - faceRadius * 0.15;
    
    // Eye whites
    final eyeWhitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    // Iris
    final irisPaint = Paint()
      ..color = eyeColor
      ..style = PaintingStyle.fill;
    
    // Pupil
    final pupilPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    // Eye shine
    final shinePaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    // Left eye
    final leftEyeCenter = Offset(center.dx - eyeSpacing, eyeY);
    canvas.drawOval(
      Rect.fromCenter(center: leftEyeCenter, width: eyeSize * 2.2, height: eyeSize * 1.5),
      eyeWhitePaint,
    );
    canvas.drawCircle(leftEyeCenter, eyeSize * 0.8, irisPaint);
    canvas.drawCircle(leftEyeCenter, eyeSize * 0.4, pupilPaint);
    canvas.drawCircle(
      Offset(leftEyeCenter.dx - eyeSize * 0.2, leftEyeCenter.dy - eyeSize * 0.2),
      eyeSize * 0.15,
      shinePaint,
    );
    
    // Right eye
    final rightEyeCenter = Offset(center.dx + eyeSpacing, eyeY);
    canvas.drawOval(
      Rect.fromCenter(center: rightEyeCenter, width: eyeSize * 2.2, height: eyeSize * 1.5),
      eyeWhitePaint,
    );
    canvas.drawCircle(rightEyeCenter, eyeSize * 0.8, irisPaint);
    canvas.drawCircle(rightEyeCenter, eyeSize * 0.4, pupilPaint);
    canvas.drawCircle(
      Offset(rightEyeCenter.dx - eyeSize * 0.2, rightEyeCenter.dy - eyeSize * 0.2),
      eyeSize * 0.15,
      shinePaint,
    );
    
    // Eyelashes
    _drawEyelashes(canvas, leftEyeCenter, rightEyeCenter, eyeSize);
  }

  void _drawNose(Canvas canvas, Offset center, double faceRadius) {
    final nosePaint = Paint()
      ..color = _getSkinColor().withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    final noseSize = faceRadius * 0.1;
    final noseCenter = Offset(center.dx, center.dy + faceRadius * 0.05);
    
    // Nose bridge
    canvas.drawOval(
      Rect.fromCenter(center: noseCenter, width: noseSize * 0.6, height: noseSize * 1.5),
      nosePaint,
    );
    
    // Nostrils
    final nostrilPaint = Paint()
      ..color = _getSkinColor().withOpacity(0.6)
      ..style = PaintingStyle.fill;
    
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(noseCenter.dx - noseSize * 0.3, noseCenter.dy + noseSize * 0.4),
        width: noseSize * 0.25,
        height: noseSize * 0.4,
      ),
      nostrilPaint,
    );
    
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(noseCenter.dx + noseSize * 0.3, noseCenter.dy + noseSize * 0.4),
        width: noseSize * 0.25,
        height: noseSize * 0.4,
      ),
      nostrilPaint,
    );
  }

  void _drawMouth(Canvas canvas, Offset center, double faceRadius) {
    final mouthY = center.dy + faceRadius * 0.5;
    final mouthWidth = faceRadius * 0.35;
    
    // Lips
    final lipPaint = Paint()
      ..color = gender == Gender.female 
          ? const Color(0xFFE91E63).withOpacity(0.8)
          : _getSkinColor().withOpacity(0.9)
      ..style = PaintingStyle.fill;
    
    // Upper lip
    final upperLipPath = Path();
    upperLipPath.moveTo(center.dx - mouthWidth, mouthY);
    upperLipPath.quadraticBezierTo(
      center.dx - mouthWidth * 0.3, mouthY - faceRadius * 0.05,
      center.dx, mouthY - faceRadius * 0.02,
    );
    upperLipPath.quadraticBezierTo(
      center.dx + mouthWidth * 0.3, mouthY - faceRadius * 0.05,
      center.dx + mouthWidth, mouthY,
    );
    
    // Lower lip
    upperLipPath.quadraticBezierTo(
      center.dx, mouthY + faceRadius * 0.08,
      center.dx - mouthWidth, mouthY,
    );
    
    canvas.drawPath(upperLipPath, lipPaint);
    
    // Mouth highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, mouthY - faceRadius * 0.01),
        width: mouthWidth * 0.6,
        height: faceRadius * 0.03,
      ),
      highlightPaint,
    );
  }

  void _drawEyebrows(Canvas canvas, Offset center, double faceRadius) {
    final eyebrowPaint = Paint()
      ..color = _getHairColor().withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = faceRadius * 0.04
      ..strokeCap = StrokeCap.round;
    
    final eyebrowY = center.dy - faceRadius * 0.35;
    final eyebrowWidth = faceRadius * 0.35;
    final eyebrowSpacing = faceRadius * 0.4;
    
    // Left eyebrow
    canvas.drawLine(
      Offset(center.dx - eyebrowSpacing - eyebrowWidth * 0.5, eyebrowY),
      Offset(center.dx - eyebrowSpacing + eyebrowWidth * 0.5, eyebrowY - faceRadius * 0.05),
      eyebrowPaint,
    );
    
    // Right eyebrow
    canvas.drawLine(
      Offset(center.dx + eyebrowSpacing - eyebrowWidth * 0.5, eyebrowY - faceRadius * 0.05),
      Offset(center.dx + eyebrowSpacing + eyebrowWidth * 0.5, eyebrowY),
      eyebrowPaint,
    );
  }

  // Hair style implementations
  void _drawShortHair(Canvas canvas, Offset center, double faceRadius, Paint hairPaint, Paint shadowPaint) {
    final hairPath = Path();
    hairPath.addOval(Rect.fromCenter(
      center: Offset(center.dx, center.dy - faceRadius * 0.1),
      width: faceRadius * 2.2,
      height: faceRadius * 1.8,
    ));
    canvas.drawPath(hairPath, shadowPaint);
    canvas.drawPath(hairPath, hairPaint);
  }

  void _drawMediumHair(Canvas canvas, Offset center, double faceRadius, Paint hairPaint, Paint shadowPaint) {
    final hairPath = Path();
    hairPath.addOval(Rect.fromCenter(
      center: Offset(center.dx, center.dy - faceRadius * 0.05),
      width: faceRadius * 2.4,
      height: faceRadius * 2.2,
    ));
    canvas.drawPath(hairPath, shadowPaint);
    canvas.drawPath(hairPath, hairPaint);
  }

  void _drawLongHair(Canvas canvas, Offset center, double faceRadius, Paint hairPaint, Paint shadowPaint) {
    final hairPath = Path();
    hairPath.addOval(Rect.fromCenter(
      center: center,
      width: faceRadius * 2.6,
      height: faceRadius * 2.8,
    ));
    canvas.drawPath(hairPath, shadowPaint);
    canvas.drawPath(hairPath, hairPaint);
  }

  void _drawCurlyHair(Canvas canvas, Offset center, double faceRadius, Paint hairPaint, Paint shadowPaint) {
    // Draw multiple circles to simulate curls
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * (math.pi / 180);
      final x = center.dx + math.cos(angle) * faceRadius * 1.1;
      final y = center.dy + math.sin(angle) * faceRadius * 0.8 - faceRadius * 0.2;
      canvas.drawCircle(Offset(x, y), faceRadius * 0.15, hairPaint);
    }
  }

  void _drawWavyHair(Canvas canvas, Offset center, double faceRadius, Paint hairPaint, Paint shadowPaint) {
    final hairPath = Path();
    hairPath.moveTo(center.dx - faceRadius * 1.2, center.dy - faceRadius * 0.8);
    
    for (int i = 0; i < 10; i++) {
      final x = center.dx - faceRadius * 1.2 + (i * faceRadius * 0.24);
      final y = center.dy - faceRadius * 0.8 + math.sin(i * 0.5) * faceRadius * 0.1;
      hairPath.lineTo(x, y);
    }
    
    hairPath.lineTo(center.dx + faceRadius * 1.2, center.dy + faceRadius * 0.8);
    hairPath.lineTo(center.dx - faceRadius * 1.2, center.dy + faceRadius * 0.8);
    hairPath.close();
    
    canvas.drawPath(hairPath, hairPaint);
  }

  void _drawBuzzCut(Canvas canvas, Offset center, double faceRadius, Paint hairPaint, Paint shadowPaint) {
    final buzzPaint = Paint()
      ..color = _getHairColor().withOpacity(0.4)
      ..style = PaintingStyle.fill;
    
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - faceRadius * 0.1),
        width: faceRadius * 2.0,
        height: faceRadius * 1.6,
      ),
      buzzPaint,
    );
  }

  void _drawMohawk(Canvas canvas, Offset center, double faceRadius, Paint hairPaint, Paint shadowPaint) {
    final mohawkPath = Path();
    mohawkPath.moveTo(center.dx, center.dy - faceRadius * 1.2);
    mohawkPath.lineTo(center.dx - faceRadius * 0.2, center.dy - faceRadius * 0.6);
    mohawkPath.lineTo(center.dx + faceRadius * 0.2, center.dy - faceRadius * 0.6);
    mohawkPath.close();
    
    canvas.drawPath(mohawkPath, hairPaint);
  }

  void _drawDreadlocks(Canvas canvas, Offset center, double faceRadius, Paint hairPaint, Paint shadowPaint) {
    final dreadWidth = faceRadius * 0.08;
    
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (math.pi / 180);
      final startX = center.dx + math.cos(angle) * faceRadius * 0.9;
      final startY = center.dy + math.sin(angle) * faceRadius * 0.7 - faceRadius * 0.3;
      final endX = startX + math.cos(angle) * faceRadius * 0.6;
      final endY = startY + math.sin(angle) * faceRadius * 0.6;
      
      final dreadPaint = Paint()
        ..color = _getHairColor()
        ..style = PaintingStyle.stroke
        ..strokeWidth = dreadWidth
        ..strokeCap = StrokeCap.round;
      
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), dreadPaint);
    }
  }

  void _drawHairFront(Canvas canvas, Offset center, double faceRadius) {
    // Hair strands that fall over the face
    if (hairStyle == HairStyle.long || hairStyle == HairStyle.medium) {
      final strandPaint = Paint()
        ..color = _getHairColor().withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = faceRadius * 0.03
        ..strokeCap = StrokeCap.round;
      
      // Left strand
      canvas.drawLine(
        Offset(center.dx - faceRadius * 0.8, center.dy - faceRadius * 0.5),
        Offset(center.dx - faceRadius * 0.6, center.dy + faceRadius * 0.3),
        strandPaint,
      );
      
      // Right strand
      canvas.drawLine(
        Offset(center.dx + faceRadius * 0.8, center.dy - faceRadius * 0.5),
        Offset(center.dx + faceRadius * 0.6, center.dy + faceRadius * 0.3),
        strandPaint,
      );
    }
  }

  void _drawFacialHair(Canvas canvas, Offset center, double faceRadius) {
    final facialHairPaint = Paint()
      ..color = _getHairColor().withOpacity(0.6)
      ..style = PaintingStyle.fill;
    
    // Mustache
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + faceRadius * 0.35),
        width: faceRadius * 0.4,
        height: faceRadius * 0.08,
      ),
      facialHairPaint,
    );
    
    // Beard outline
    final beardPath = Path();
    beardPath.moveTo(center.dx - faceRadius * 0.7, center.dy + faceRadius * 0.4);
    beardPath.quadraticBezierTo(
      center.dx, center.dy + faceRadius * 0.9,
      center.dx + faceRadius * 0.7, center.dy + faceRadius * 0.4,
    );
    beardPath.lineTo(center.dx + faceRadius * 0.6, center.dy + faceRadius * 0.3);
    beardPath.lineTo(center.dx - faceRadius * 0.6, center.dy + faceRadius * 0.3);
    beardPath.close();
    
    canvas.drawPath(beardPath, facialHairPaint);
  }

  void _drawAccessories(Canvas canvas, Offset center, double faceRadius) {
    // Optional glasses, earrings, etc. can be added here
    if (gender == Gender.female) {
      _drawEarrings(canvas, center, faceRadius);
    }
  }

  void _drawEarrings(Canvas canvas, Offset center, double faceRadius) {
    final earringPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;
    
    // Left earring
    canvas.drawCircle(
      Offset(center.dx - faceRadius * 0.85, center.dy),
      faceRadius * 0.05,
      earringPaint,
    );
    
    // Right earring
    canvas.drawCircle(
      Offset(center.dx + faceRadius * 0.85, center.dy),
      faceRadius * 0.05,
      earringPaint,
    );
  }

  void _drawEyelashes(Canvas canvas, Offset leftEye, Offset rightEye, double eyeSize) {
    final lashPaint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    
    // Left eye lashes
    for (int i = 0; i < 5; i++) {
      final angle = (i * 0.3) - 0.6;
      final startX = leftEye.dx + math.cos(angle) * eyeSize * 1.1;
      final startY = leftEye.dy - eyeSize * 0.75;
      final endX = startX + math.cos(angle - 0.3) * eyeSize * 0.3;
      final endY = startY - eyeSize * 0.3;
      
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), lashPaint);
    }
    
    // Right eye lashes
    for (int i = 0; i < 5; i++) {
      final angle = (i * 0.3) + 0.3;
      final startX = rightEye.dx + math.cos(angle) * eyeSize * 1.1;
      final startY = rightEye.dy - eyeSize * 0.75;
      final endX = startX + math.cos(angle + 0.3) * eyeSize * 0.3;
      final endY = startY - eyeSize * 0.3;
      
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), lashPaint);
    }
  }

  void _drawCheeks(Canvas canvas, Offset center, double faceRadius) {
    final cheekPaint = Paint()
      ..color = Colors.pink.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    // Left cheek
    canvas.drawCircle(
      Offset(center.dx - faceRadius * 0.5, center.dy + faceRadius * 0.2),
      faceRadius * 0.15,
      cheekPaint,
    );
    
    // Right cheek
    canvas.drawCircle(
      Offset(center.dx + faceRadius * 0.5, center.dy + faceRadius * 0.2),
      faceRadius * 0.15,
      cheekPaint,
    );
  }

  void _drawHeartFace(Canvas canvas, Offset center, double faceRadius, Paint facePaint) {
    final heartPath = Path();
    heartPath.moveTo(center.dx, center.dy + faceRadius * 0.8);
    heartPath.quadraticBezierTo(
      center.dx - faceRadius * 0.8, center.dy + faceRadius * 0.2,
      center.dx - faceRadius * 0.6, center.dy - faceRadius * 0.3,
    );
    heartPath.quadraticBezierTo(
      center.dx, center.dy - faceRadius * 0.8,
      center.dx + faceRadius * 0.6, center.dy - faceRadius * 0.3,
    );
    heartPath.quadraticBezierTo(
      center.dx + faceRadius * 0.8, center.dy + faceRadius * 0.2,
      center.dx, center.dy + faceRadius * 0.8,
    );
    
    canvas.drawPath(heartPath, facePaint);
  }

  void _drawDiamondFace(Canvas canvas, Offset center, double faceRadius, Paint facePaint) {
    final diamondPath = Path();
    diamondPath.moveTo(center.dx, center.dy - faceRadius);
    diamondPath.lineTo(center.dx + faceRadius * 0.7, center.dy);
    diamondPath.lineTo(center.dx, center.dy + faceRadius);
    diamondPath.lineTo(center.dx - faceRadius * 0.7, center.dy);
    diamondPath.close();
    
    canvas.drawPath(diamondPath, facePaint);
  }

  // Color getters
  Color _getSkinColor() {
    switch (skinTone) {
      case SkinTone.veryLight:
        return const Color(0xFFFBE5D6);
      case SkinTone.light:
        return const Color(0xFFF4D1AE);
      case SkinTone.medium:
        return const Color(0xFFD4A574);
      case SkinTone.tan:
        return const Color(0xFFAD7A47);
      case SkinTone.dark:
        return const Color(0xFF8B5A3C);
      case SkinTone.veryDark:
        return const Color(0xFF5D372E);
    }
  }

  Color _getHairColor() {
    switch (hairColor) {
      case HairColor.black:
        return const Color(0xFF2C1B18);
      case HairColor.brown:
        return const Color(0xFF5D4037);
      case HairColor.blonde:
        return const Color(0xFFFFF176);
      case HairColor.red:
        return const Color(0xFFD32F2F);
      case HairColor.gray:
        return const Color(0xFF9E9E9E);
      case HairColor.white:
        return const Color(0xFFFFFFFF);
      case HairColor.blue:
        return const Color(0xFF2196F3);
      case HairColor.green:
        return const Color(0xFF4CAF50);
      case HairColor.purple:
        return const Color(0xFF9C27B0);
      case HairColor.pink:
        return const Color(0xFFE91E63);
    }
  }

  Color _getEyeColor() {
    switch (eyeColor) {
      case EyeColor.brown:
        return const Color(0xFF5D4037);
      case EyeColor.blue:
        return const Color(0xFF2196F3);
      case EyeColor.green:
        return const Color(0xFF4CAF50);
      case EyeColor.hazel:
        return const Color(0xFF8BC34A);
      case EyeColor.gray:
        return const Color(0xFF607D8B);
      case EyeColor.amber:
        return const Color(0xFFFF8F00);
      case EyeColor.violet:
        return const Color(0xFF9C27B0);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
