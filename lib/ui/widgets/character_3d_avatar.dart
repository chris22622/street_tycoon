import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../data/character_models.dart';

class Character3DAvatar extends StatefulWidget {
  final CharacterAppearance character;
  final double size;
  final bool showBorder;
  final bool isAnimated;

  const Character3DAvatar({
    super.key,
    required this.character,
    this.size = 100,
    this.showBorder = true,
    this.isAnimated = true,
  });

  @override
  State<Character3DAvatar> createState() => _Character3DAvatarState();
}

class _Character3DAvatarState extends State<Character3DAvatar>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _breathingController;
  late AnimationController _blinkController;
  
  late Animation<double> _rotationAnimation;
  late Animation<double> _breathingAnimation;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    
    // Rotation animation (slow turn)
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
    
    // Breathing animation
    _breathingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _breathingAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));
    
    // Blinking animation
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _blinkAnimation = Tween<double>(
      begin: 1.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    ));
    
    if (widget.isAnimated) {
      _rotationController.repeat();
      _breathingController.repeat(reverse: true);
      _startRandomBlinking();
    }
  }

  void _startRandomBlinking() {
    Future.delayed(Duration(milliseconds: 2000 + math.Random().nextInt(3000)), () {
      if (mounted) {
        _blinkController.forward().then((_) {
          _blinkController.reverse();
          _startRandomBlinking();
        });
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _breathingController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationAnimation, _breathingAnimation, _blinkAnimation]),
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateY(_rotationAnimation.value * 0.3) // Subtle 3D rotation
            ..scale(_breathingAnimation.value), // Breathing effect
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: widget.showBorder 
                  ? Border.all(color: Colors.white.withOpacity(0.6), width: 3)
                  : null,
              boxShadow: widget.showBorder ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                ),
              ] : null,
            ),
            child: ClipOval(
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _Character3DPainter(
                  character: widget.character,
                  rotationValue: _rotationAnimation.value,
                  breathingValue: _breathingAnimation.value,
                  blinkValue: _blinkAnimation.value,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Character3DPainter extends CustomPainter {
  final CharacterAppearance character;
  final double rotationValue;
  final double breathingValue;
  final double blinkValue;

  _Character3DPainter({
    required this.character,
    required this.rotationValue,
    required this.breathingValue,
    required this.blinkValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final faceRadius = size.width * 0.45;
    
    // 3D lighting calculation
    final lightAngle = rotationValue;
    final lightIntensity = (math.sin(lightAngle) + 1) / 2;
    
    // Dynamic background with depth
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Color.lerp(const Color(0xFFF0F8FF), const Color(0xFF4A90E2), lightIntensity * 0.3)!,
          Color.lerp(const Color(0xFFE6F3FF), const Color(0xFF2C5282), lightIntensity * 0.2)!,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: faceRadius));
    canvas.drawCircle(center, faceRadius, bgPaint);
    
    // Draw 3D face with dynamic lighting
    _draw3DFace(canvas, size, center, faceRadius, lightIntensity);
    
    // Draw animated hair
    if (character.hairStyle != HairStyle.bald) {
      _draw3DHair(canvas, size, center, faceRadius, lightIntensity);
    }
    
    // Draw 3D facial features
    _draw3DEyes(canvas, size, center, lightIntensity);
    _draw3DNose(canvas, size, center, lightIntensity);
    _draw3DMouth(canvas, size, center, lightIntensity);
    _draw3DEyebrows(canvas, size, center, lightIntensity);
    
    // Gender-specific 3D features
    if (character.gender == Gender.male) {
      _draw3DMasculineFeatures(canvas, size, center, lightIntensity);
    } else if (character.gender == Gender.female) {
      _draw3DFeminineFeatures(canvas, size, center, lightIntensity);
    }
    
    // Add 3D depth and highlights
    _add3DDepthEffects(canvas, size, center, faceRadius, lightIntensity);
  }

  void _draw3DFace(Canvas canvas, Size size, Offset center, double radius, double lightIntensity) {
    final skinColor = Color(int.parse('0xFF${character.skinTone.colorHex.substring(1)}'));
    
    // Create 3D skin gradient with dynamic lighting
    final facePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(-0.3 + lightIntensity * 0.6, -0.4), // Moving light source
        colors: [
          _adjustColorBrightness(skinColor, 0.3 + lightIntensity * 0.2),
          skinColor,
          _adjustColorBrightness(skinColor, -0.2 - lightIntensity * 0.1),
          _adjustColorBrightness(skinColor, -0.4 - lightIntensity * 0.2),
        ],
        stops: const [0.0, 0.4, 0.8, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    // Draw face with 3D depth
    switch (character.faceShape) {
      case FaceShape.round:
        canvas.drawCircle(center, radius * 0.9, facePaint);
        break;
      case FaceShape.oval:
        _draw3DOval(canvas, center, radius, facePaint);
        break;
      case FaceShape.square:
        _draw3DSquare(canvas, center, radius, facePaint);
        break;
      case FaceShape.heart:
        _draw3DHeart(canvas, center, radius, facePaint);
        break;
      case FaceShape.diamond:
        _draw3DDiamond(canvas, center, radius, facePaint);
        break;
      case FaceShape.oblong:
        _draw3DOblong(canvas, center, radius, facePaint);
        break;
    }
  }

  void _draw3DHair(Canvas canvas, Size size, Offset center, double radius, double lightIntensity) {
    final hairColor = Color(int.parse('0xFF${character.hairColor.colorHex.substring(1)}'));
    
    // 3D hair with dynamic lighting
    final hairPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          _adjustColorBrightness(hairColor, 0.3 + lightIntensity * 0.2),
          hairColor,
          _adjustColorBrightness(hairColor, -0.3 - lightIntensity * 0.1),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.2));
    
    // Add hair strands for 3D effect
    _draw3DHairStrands(canvas, center, radius, hairPaint);
  }

  void _draw3DEyes(Canvas canvas, Size size, Offset center, double lightIntensity) {
    final eyeColor = Color(int.parse('0xFF${character.eyeColor.colorHex.substring(1)}'));
    final eyeWidth = size.width * 0.14;
    final eyeHeight = size.width * 0.09 * blinkValue; // Blinking effect
    
    final leftEyeCenter = Offset(center.dx - size.width * 0.16, center.dy - size.height * 0.08);
    final rightEyeCenter = Offset(center.dx + size.width * 0.16, center.dy - size.height * 0.08);
    
    for (final eyeCenter in [leftEyeCenter, rightEyeCenter]) {
      if (blinkValue > 0.1) { // Only draw if not fully closed
        // 3D eye socket
        final socketPaint = Paint()
          ..color = Colors.black.withOpacity(0.2 + lightIntensity * 0.1)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawOval(
          Rect.fromCenter(center: eyeCenter, width: eyeWidth * 1.3, height: eyeHeight * 1.3),
          socketPaint,
        );
        
        // 3D eyeball
        final eyeballPaint = Paint()
          ..shader = RadialGradient(
            center: Alignment(-0.2, -0.3),
            colors: [
              Colors.white,
              const Color(0xFFF8F8F8),
              const Color(0xFFE8E8E8),
            ],
          ).createShader(Rect.fromCenter(center: eyeCenter, width: eyeWidth, height: eyeHeight));
        
        canvas.drawOval(
          Rect.fromCenter(center: eyeCenter, width: eyeWidth, height: eyeHeight),
          eyeballPaint,
        );
        
        // 3D iris with depth
        final irisPaint = Paint()
          ..shader = RadialGradient(
            center: const Alignment(0.2, 0.2),
            colors: [
              _adjustColorBrightness(eyeColor, 0.4),
              eyeColor,
              _adjustColorBrightness(eyeColor, -0.4),
              _adjustColorBrightness(eyeColor, -0.6),
            ],
            stops: const [0.0, 0.3, 0.8, 1.0],
          ).createShader(Rect.fromCircle(center: eyeCenter, radius: eyeWidth * 0.35));
        
        canvas.drawCircle(eyeCenter, eyeWidth * 0.35, irisPaint);
        
        // 3D pupil
        final pupilPaint = Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.black,
              const Color(0xFF2A2A2A),
            ],
          ).createShader(Rect.fromCircle(center: eyeCenter, radius: eyeWidth * 0.18));
        canvas.drawCircle(eyeCenter, eyeWidth * 0.18, pupilPaint);
        
        // Multiple 3D highlights
        _add3DEyeHighlights(canvas, eyeCenter, eyeWidth, lightIntensity);
      }
    }
  }

  void _draw3DNose(Canvas canvas, Size size, Offset center, double lightIntensity) {
    final skinColor = Color(int.parse('0xFF${character.skinTone.colorHex.substring(1)}'));
    final noseCenter = Offset(center.dx, center.dy + size.height * 0.02);
    
    // 3D nose bridge with dynamic lighting
    final bridgePaint = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(-1, -1),
        end: const Alignment(1, 1),
        colors: [
          _adjustColorBrightness(skinColor, 0.3 + lightIntensity * 0.2),
          skinColor,
          _adjustColorBrightness(skinColor, -0.2),
        ],
      ).createShader(Rect.fromCenter(
        center: noseCenter,
        width: size.width * 0.08,
        height: size.height * 0.12,
      ));
    
    // 3D nose shape
    final nosePath = Path();
    nosePath.moveTo(noseCenter.dx, noseCenter.dy - size.height * 0.05);
    nosePath.quadraticBezierTo(
      noseCenter.dx - size.width * 0.02, noseCenter.dy,
      noseCenter.dx - size.width * 0.025, noseCenter.dy + size.height * 0.02,
    );
    nosePath.lineTo(noseCenter.dx + size.width * 0.025, noseCenter.dy + size.height * 0.02);
    nosePath.quadraticBezierTo(
      noseCenter.dx + size.width * 0.02, noseCenter.dy,
      noseCenter.dx, noseCenter.dy - size.height * 0.05,
    );
    canvas.drawPath(nosePath, bridgePaint);
  }

  void _draw3DMouth(Canvas canvas, Size size, Offset center, double lightIntensity) {
    final mouthCenter = Offset(center.dx, center.dy + size.height * 0.15);
    final mouthWidth = size.width * (character.gender == Gender.female ? 0.16 : 0.14);
    
    // 3D lip color with lighting
    Color lipColor;
    if (character.gender == Gender.female) {
      lipColor = const Color(0xFFCD5C5C);
    } else {
      final skinColor = Color(int.parse('0xFF${character.skinTone.colorHex.substring(1)}'));
      lipColor = _adjustColorBrightness(skinColor, -0.1);
    }
    
    // 3D upper lip
    final upperLipPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _adjustColorBrightness(lipColor, -0.2),
          lipColor,
        ],
      ).createShader(Rect.fromCenter(center: mouthCenter, width: mouthWidth, height: size.height * 0.04));
    
    // 3D lower lip
    final lowerLipPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lipColor,
          _adjustColorBrightness(lipColor, 0.2 + lightIntensity * 0.1),
        ],
      ).createShader(Rect.fromCenter(center: mouthCenter, width: mouthWidth, height: size.height * 0.04));
    
    // Draw 3D mouth
    _draw3DLips(canvas, mouthCenter, mouthWidth, size.height, upperLipPaint, lowerLipPaint);
  }

  void _draw3DEyebrows(Canvas canvas, Size size, Offset center, double lightIntensity) {
    final hairColor = Color(int.parse('0xFF${character.hairColor.colorHex.substring(1)}'));
    final browPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          _adjustColorBrightness(hairColor, 0.1 + lightIntensity * 0.1),
          _adjustColorBrightness(hairColor, -0.3),
        ],
      ).createShader(Rect.fromCenter(center: center, width: size.width * 0.4, height: size.height * 0.1))
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * (character.gender == Gender.female ? 0.012 : 0.018)
      ..strokeCap = StrokeCap.round;
    
    final browY = center.dy - size.height * 0.15;
    
    // 3D eyebrow shapes with depth
    _draw3DBrows(canvas, center, browY, browPaint, size);
  }

  void _draw3DMasculineFeatures(Canvas canvas, Size size, Offset center, double lightIntensity) {
    // Enhanced masculine features with 3D depth
    _draw3DJawline(canvas, center, size, lightIntensity);
    _draw3DFacialHair(canvas, center, size, lightIntensity);
  }

  void _draw3DFeminineFeatures(Canvas canvas, Size size, Offset center, double lightIntensity) {
    // Enhanced feminine features with 3D depth
    _draw3DBlush(canvas, center, size, lightIntensity);
    _draw3DEarrings(canvas, center, size, lightIntensity);
  }

  void _add3DDepthEffects(Canvas canvas, Size size, Offset center, double radius, double lightIntensity) {
    // Overall 3D shading with dynamic lighting
    final shadingPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(0.3 - lightIntensity * 0.6, -0.3),
        colors: [
          Colors.transparent,
          Colors.black.withOpacity(0.1 + lightIntensity * 0.05),
          Colors.black.withOpacity(0.2 + lightIntensity * 0.1),
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..blendMode = BlendMode.multiply;
    
    canvas.drawCircle(center, radius * 0.9, shadingPaint);
    
    // Add rim lighting for 3D pop
    final rimPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.7, -0.7),
        colors: [
          Colors.transparent,
          Colors.white.withOpacity(0.1 + lightIntensity * 0.2),
        ],
        stops: const [0.8, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..blendMode = BlendMode.screen;
    
    canvas.drawCircle(center, radius * 0.9, rimPaint);
  }

  // Helper methods for 3D shapes
  void _draw3DOval(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawOval(
      Rect.fromCenter(center: center, width: radius * 1.6, height: radius * 1.9),
      paint,
    );
  }

  void _draw3DSquare(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: radius * 1.7, height: radius * 1.8),
        Radius.circular(radius * 0.15),
      ),
      paint,
    );
  }

  void _draw3DHeart(Canvas canvas, Offset center, double radius, Paint paint) {
    final heartPath = Path();
    heartPath.moveTo(center.dx, center.dy + radius * 0.9);
    heartPath.quadraticBezierTo(
      center.dx - radius * 0.9, center.dy - radius * 0.1,
      center.dx - radius * 0.5, center.dy - radius * 0.7,
    );
    heartPath.quadraticBezierTo(
      center.dx - radius * 0.2, center.dy - radius * 0.9,
      center.dx, center.dy - radius * 0.8,
    );
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

  void _draw3DDiamond(Canvas canvas, Offset center, double radius, Paint paint) {
    final diamondPath = Path();
    diamondPath.moveTo(center.dx, center.dy - radius * 1.1);
    diamondPath.lineTo(center.dx + radius * 0.7, center.dy - radius * 0.2);
    diamondPath.lineTo(center.dx + radius * 0.5, center.dy + radius * 0.8);
    diamondPath.lineTo(center.dx - radius * 0.5, center.dy + radius * 0.8);
    diamondPath.lineTo(center.dx - radius * 0.7, center.dy - radius * 0.2);
    diamondPath.close();
    canvas.drawPath(diamondPath, paint);
  }

  void _draw3DOblong(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawOval(
      Rect.fromCenter(center: center, width: radius * 1.4, height: radius * 2.1),
      paint,
    );
  }

  void _draw3DHairStrands(Canvas canvas, Offset center, double radius, Paint paint) {
    // Add individual hair strands for 3D texture
    final strandPaint = Paint()
      ..shader = paint.shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    
    for (int i = 0; i < 20; i++) {
      final angle = (i * math.pi * 2) / 20;
      final startX = center.dx + math.cos(angle) * radius * 0.7;
      final startY = center.dy - radius * 0.2 + math.sin(angle) * radius * 0.4;
      final endX = center.dx + math.cos(angle) * radius * 1.1;
      final endY = center.dy - radius * 0.1 + math.sin(angle) * radius * 0.6;
      
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), strandPaint);
    }
  }

  void _add3DEyeHighlights(Canvas canvas, Offset eyeCenter, double eyeWidth, double lightIntensity) {
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.8 + lightIntensity * 0.2)
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
    
    // Rim light
    final rimPaint = Paint()
      ..color = Colors.white.withOpacity(0.3 + lightIntensity * 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(eyeCenter, eyeWidth * 0.35, rimPaint);
  }

  void _draw3DLips(Canvas canvas, Offset center, double width, double height, Paint upperPaint, Paint lowerPaint) {
    // Upper lip
    final upperLipPath = Path();
    upperLipPath.moveTo(center.dx - width * 0.5, center.dy);
    upperLipPath.quadraticBezierTo(
      center.dx - width * 0.25, center.dy - height * 0.02,
      center.dx, center.dy - height * 0.01,
    );
    upperLipPath.quadraticBezierTo(
      center.dx + width * 0.25, center.dy - height * 0.02,
      center.dx + width * 0.5, center.dy,
    );
    canvas.drawPath(upperLipPath, upperPaint);
    
    // Lower lip
    final lowerLipPath = Path();
    lowerLipPath.moveTo(center.dx - width * 0.5, center.dy);
    lowerLipPath.quadraticBezierTo(
      center.dx, center.dy + height * 0.025,
      center.dx + width * 0.5, center.dy,
    );
    canvas.drawPath(lowerLipPath, lowerPaint);
  }

  void _draw3DBrows(Canvas canvas, Offset center, double browY, Paint paint, Size size) {
    if (character.gender == Gender.female) {
      // Arched feminine brows
      final leftBrowPath = Path();
      leftBrowPath.moveTo(center.dx - size.width * 0.22, browY + size.height * 0.01);
      leftBrowPath.quadraticBezierTo(
        center.dx - size.width * 0.15, browY - size.height * 0.02,
        center.dx - size.width * 0.08, browY + size.height * 0.005,
      );
      canvas.drawPath(leftBrowPath, paint);
      
      final rightBrowPath = Path();
      rightBrowPath.moveTo(center.dx + size.width * 0.08, browY + size.height * 0.005);
      rightBrowPath.quadraticBezierTo(
        center.dx + size.width * 0.15, browY - size.height * 0.02,
        center.dx + size.width * 0.22, browY + size.height * 0.01,
      );
      canvas.drawPath(rightBrowPath, paint);
    } else {
      // Straight masculine brows
      canvas.drawLine(
        Offset(center.dx - size.width * 0.20, browY),
        Offset(center.dx - size.width * 0.08, browY - size.height * 0.01),
        paint,
      );
      
      canvas.drawLine(
        Offset(center.dx + size.width * 0.08, browY - size.height * 0.01),
        Offset(center.dx + size.width * 0.20, browY),
        paint,
      );
    }
  }

  void _draw3DJawline(Canvas canvas, Offset center, Size size, double lightIntensity) {
    final jawPaint = Paint()
      ..color = Colors.black.withOpacity(0.15 + lightIntensity * 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    
    canvas.drawArc(
      Rect.fromCenter(center: Offset(center.dx, center.dy + size.height * 0.1), width: size.width * 0.8, height: size.height * 0.6),
      math.pi * 0.2,
      math.pi * 0.6,
      false,
      jawPaint,
    );
  }

  void _draw3DFacialHair(Canvas canvas, Offset center, Size size, double lightIntensity) {
    final hairColor = Color(int.parse('0xFF${character.hairColor.colorHex.substring(1)}'));
    final facialHairPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          _adjustColorBrightness(hairColor, 0.1 + lightIntensity * 0.1),
          _adjustColorBrightness(hairColor, -0.2),
        ],
      ).createShader(Rect.fromCenter(center: center, width: size.width * 0.3, height: size.height * 0.2))
      ..style = PaintingStyle.fill;
    
    final random = math.Random(character.skinTone.hashCode);
    
    if (random.nextDouble() > 0.6) {
      // 3D Mustache
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
  }

  void _draw3DBlush(Canvas canvas, Offset center, Size size, double lightIntensity) {
    final blushPaint = Paint()
      ..color = const Color(0xFFFFB6C1).withOpacity(0.4 + lightIntensity * 0.1)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    
    canvas.drawCircle(
      Offset(center.dx - size.width * 0.25, center.dy + size.height * 0.05),
      size.width * 0.08,
      blushPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + size.width * 0.25, center.dy + size.height * 0.05),
      size.width * 0.08,
      blushPaint,
    );
  }

  void _draw3DEarrings(Canvas canvas, Offset center, Size size, double lightIntensity) {
    final random = math.Random(character.skinTone.hashCode + character.hairColor.hashCode);
    if (random.nextDouble() > 0.5) {
      final earringPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            const Color(0xFFFFD700).withOpacity(0.9 + lightIntensity * 0.1),
            const Color(0xFFB8860B),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.05))
        ..style = PaintingStyle.fill;
      
      // 3D earrings with depth
      canvas.drawCircle(
        Offset(center.dx - size.width * 0.38, center.dy - size.height * 0.02),
        size.width * 0.02,
        earringPaint,
      );
      
      canvas.drawCircle(
        Offset(center.dx + size.width * 0.38, center.dy - size.height * 0.02),
        size.width * 0.02,
        earringPaint,
      );
    }
  }

  Color _adjustColorBrightness(Color color, double amount) {
    if (amount > 0) {
      return Color.fromARGB(
        color.alpha,
        (color.red + (255 - color.red) * amount).round().clamp(0, 255),
        (color.green + (255 - color.green) * amount).round().clamp(0, 255),
        (color.blue + (255 - color.blue) * amount).round().clamp(0, 255),
      );
    } else {
      return Color.fromARGB(
        color.alpha,
        (color.red * (1 + amount)).round().clamp(0, 255),
        (color.green * (1 + amount)).round().clamp(0, 255),
        (color.blue * (1 + amount)).round().clamp(0, 255),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
