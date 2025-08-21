import 'package:flutter/material.dart';
import 'dart:math' as math;

enum ParticleType {
  money,
  smoke,
  blood,
  explosion,
  sparks,
  stars,
  fire,
  water,
  dust,
  leaves,
  snow,
  rain,
  magic,
  hearts,
  skulls,
}

class Particle {
  Offset position;
  Offset velocity;
  double size;
  Color color;
  double life;
  double maxLife;
  double rotation;
  double rotationSpeed;
  ParticleType type;
  double opacity;
  bool isAlive;

  Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
    required this.maxLife,
    required this.type,
    this.rotation = 0,
    this.rotationSpeed = 0,
  }) : life = maxLife, opacity = 1.0, isAlive = true;

  void update(double deltaTime) {
    if (!isAlive) return;

    position += velocity * deltaTime;
    velocity += const Offset(0, 100) * deltaTime; // Gravity
    rotation += rotationSpeed * deltaTime;
    life -= deltaTime;
    
    // Fade out over time
    opacity = (life / maxLife).clamp(0.0, 1.0);
    
    if (life <= 0) {
      isAlive = false;
    }
  }
}

class ParticleSystem extends StatefulWidget {
  final Widget child;
  final bool isActive;
  final ParticleType particleType;
  final int maxParticles;
  final double emissionRate;
  final Offset? emissionPoint;
  final Color? particleColor;
  final double particleSize;

  const ParticleSystem({
    super.key,
    required this.child,
    this.isActive = false,
    this.particleType = ParticleType.money,
    this.maxParticles = 50,
    this.emissionRate = 10.0,
    this.emissionPoint,
    this.particleColor,
    this.particleSize = 8.0,
  });

  @override
  State<ParticleSystem> createState() => _ParticleSystemState();
}

class _ParticleSystemState extends State<ParticleSystem>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final math.Random _random = math.Random();
  double _lastTime = 0;
  double _accumulator = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ParticleSystem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateParticles(double deltaTime) {
    // Remove dead particles
    _particles.removeWhere((particle) => !particle.isAlive);
    
    // Update existing particles
    for (final particle in _particles) {
      particle.update(deltaTime);
    }
    
    // Emit new particles
    if (widget.isActive && _particles.length < widget.maxParticles) {
      _accumulator += deltaTime;
      final emissionInterval = 1.0 / widget.emissionRate;
      
      while (_accumulator >= emissionInterval && _particles.length < widget.maxParticles) {
        _emitParticle();
        _accumulator -= emissionInterval;
      }
    }
  }

  void _emitParticle() {
    final size = widget.particleSize + _random.nextDouble() * widget.particleSize * 0.5;
    final position = widget.emissionPoint ?? 
        Offset(_random.nextDouble() * 300, _random.nextDouble() * 300);
    
    final velocity = _getVelocityForType();
    final color = widget.particleColor ?? _getColorForType();
    final life = _getLifeForType();
    final rotationSpeed = (_random.nextDouble() - 0.5) * 10;
    
    _particles.add(Particle(
      position: position,
      velocity: velocity,
      size: size,
      color: color,
      maxLife: life,
      type: widget.particleType,
      rotationSpeed: rotationSpeed,
    ));
  }

  Offset _getVelocityForType() {
    switch (widget.particleType) {
      case ParticleType.money:
        return Offset(
          (_random.nextDouble() - 0.5) * 100,
          -_random.nextDouble() * 150 - 50,
        );
      case ParticleType.smoke:
        return Offset(
          (_random.nextDouble() - 0.5) * 30,
          -_random.nextDouble() * 80 - 20,
        );
      case ParticleType.explosion:
        final angle = _random.nextDouble() * 2 * math.pi;
        final speed = _random.nextDouble() * 200 + 100;
        return Offset(
          math.cos(angle) * speed,
          math.sin(angle) * speed,
        );
      case ParticleType.fire:
        return Offset(
          (_random.nextDouble() - 0.5) * 50,
          -_random.nextDouble() * 120 - 30,
        );
      case ParticleType.sparks:
        final angle = _random.nextDouble() * 2 * math.pi;
        final speed = _random.nextDouble() * 300 + 50;
        return Offset(
          math.cos(angle) * speed,
          math.sin(angle) * speed,
        );
      case ParticleType.snow:
        return Offset(
          (_random.nextDouble() - 0.5) * 20,
          _random.nextDouble() * 50 + 20,
        );
      case ParticleType.rain:
        return Offset(
          (_random.nextDouble() - 0.5) * 10,
          _random.nextDouble() * 300 + 200,
        );
      case ParticleType.hearts:
        return Offset(
          (_random.nextDouble() - 0.5) * 80,
          -_random.nextDouble() * 100 - 30,
        );
      case ParticleType.skulls:
        return Offset(
          (_random.nextDouble() - 0.5) * 60,
          -_random.nextDouble() * 80 - 20,
        );
      default:
        return Offset(
          (_random.nextDouble() - 0.5) * 100,
          -_random.nextDouble() * 100,
        );
    }
  }

  Color _getColorForType() {
    switch (widget.particleType) {
      case ParticleType.money:
        return const Color(0xFF00FF00);
      case ParticleType.smoke:
        return Color.fromARGB(
          150,
          100 + _random.nextInt(50),
          100 + _random.nextInt(50),
          100 + _random.nextInt(50),
        );
      case ParticleType.blood:
        return Color.fromARGB(
          255,
          150 + _random.nextInt(105),
          _random.nextInt(50),
          _random.nextInt(50),
        );
      case ParticleType.explosion:
        final colors = [
          const Color(0xFFFF4500),
          const Color(0xFFFF6347),
          const Color(0xFFFFD700),
          const Color(0xFFFF0000),
        ];
        return colors[_random.nextInt(colors.length)];
      case ParticleType.fire:
        final colors = [
          const Color(0xFFFF4500),
          const Color(0xFFFF6347),
          const Color(0xFFFFD700),
          const Color(0xFFFF8C00),
        ];
        return colors[_random.nextInt(colors.length)];
      case ParticleType.sparks:
        return const Color(0xFFFFD700);
      case ParticleType.stars:
        return const Color(0xFFFFFFFF);
      case ParticleType.water:
        return Color.fromARGB(
          180,
          _random.nextInt(100),
          100 + _random.nextInt(155),
          200 + _random.nextInt(55),
        );
      case ParticleType.snow:
        return const Color(0xFFFFFFFF);
      case ParticleType.rain:
        return Color.fromARGB(
          200,
          _random.nextInt(50),
          _random.nextInt(50),
          150 + _random.nextInt(105),
        );
      case ParticleType.hearts:
        return const Color(0xFFFF69B4);
      case ParticleType.skulls:
        return const Color(0xFFDDDDDD);
      default:
        return Colors.white;
    }
  }

  double _getLifeForType() {
    switch (widget.particleType) {
      case ParticleType.money:
        return 2.0 + _random.nextDouble() * 1.0;
      case ParticleType.smoke:
        return 3.0 + _random.nextDouble() * 2.0;
      case ParticleType.explosion:
        return 1.0 + _random.nextDouble() * 0.5;
      case ParticleType.sparks:
        return 0.5 + _random.nextDouble() * 0.5;
      case ParticleType.fire:
        return 1.5 + _random.nextDouble() * 1.0;
      case ParticleType.snow:
        return 5.0 + _random.nextDouble() * 3.0;
      case ParticleType.rain:
        return 2.0 + _random.nextDouble() * 1.0;
      default:
        return 2.0 + _random.nextDouble() * 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isActive)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final currentTime = _controller.value * 1000;
                final deltaTime = (currentTime - _lastTime) / 1000;
                _lastTime = currentTime;
                
                if (deltaTime > 0 && deltaTime < 0.1) {
                  _updateParticles(deltaTime);
                }
                
                return CustomPaint(
                  painter: _ParticlePainter(_particles, widget.particleType),
                  child: Container(),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final ParticleType particleType;

  _ParticlePainter(this.particles, this.particleType);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      if (!particle.isAlive) continue;
      
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;
      
      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);
      
      _drawParticle(canvas, particle, paint);
      
      canvas.restore();
    }
  }

  void _drawParticle(Canvas canvas, Particle particle, Paint paint) {
    switch (particleType) {
      case ParticleType.money:
        _drawMoney(canvas, particle, paint);
        break;
      case ParticleType.smoke:
        _drawSmoke(canvas, particle, paint);
        break;
      case ParticleType.explosion:
      case ParticleType.fire:
        _drawFire(canvas, particle, paint);
        break;
      case ParticleType.sparks:
        _drawSpark(canvas, particle, paint);
        break;
      case ParticleType.stars:
        _drawStar(canvas, particle, paint);
        break;
      case ParticleType.hearts:
        _drawHeart(canvas, particle, paint);
        break;
      case ParticleType.skulls:
        _drawSkull(canvas, particle, paint);
        break;
      default:
        canvas.drawCircle(Offset.zero, particle.size / 2, paint);
    }
  }

  void _drawMoney(Canvas canvas, Particle particle, Paint paint) {
    // Draw dollar sign
    final textPainter = TextPainter(
      text: TextSpan(
        text: '\$',
        style: TextStyle(
          color: paint.color,
          fontSize: particle.size,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
  }

  void _drawSmoke(Canvas canvas, Particle particle, Paint paint) {
    paint.style = PaintingStyle.fill;
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(Offset.zero, particle.size / 2, paint);
  }

  void _drawFire(Canvas canvas, Particle particle, Paint paint) {
    final firePath = Path();
    final radius = particle.size / 2;
    
    // Create flame shape
    firePath.moveTo(0, radius);
    firePath.quadraticBezierTo(-radius * 0.5, radius * 0.3, -radius * 0.3, 0);
    firePath.quadraticBezierTo(-radius * 0.1, -radius * 0.8, 0, -radius);
    firePath.quadraticBezierTo(radius * 0.1, -radius * 0.8, radius * 0.3, 0);
    firePath.quadraticBezierTo(radius * 0.5, radius * 0.3, 0, radius);
    
    canvas.drawPath(firePath, paint);
  }

  void _drawSpark(Canvas canvas, Particle particle, Paint paint) {
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    paint.strokeCap = StrokeCap.round;
    
    // Draw spark as a line
    canvas.drawLine(
      Offset(-particle.size / 2, 0),
      Offset(particle.size / 2, 0),
      paint,
    );
  }

  void _drawStar(Canvas canvas, Particle particle, Paint paint) {
    final starPath = Path();
    final radius = particle.size / 2;
    final innerRadius = radius * 0.4;
    
    for (int i = 0; i < 10; i++) {
      final angle = (i * math.pi) / 5;
      final currentRadius = i.isEven ? radius : innerRadius;
      final x = math.cos(angle) * currentRadius;
      final y = math.sin(angle) * currentRadius;
      
      if (i == 0) {
        starPath.moveTo(x, y);
      } else {
        starPath.lineTo(x, y);
      }
    }
    starPath.close();
    
    canvas.drawPath(starPath, paint);
  }

  void _drawHeart(Canvas canvas, Particle particle, Paint paint) {
    final heartPath = Path();
    final size = particle.size;
    
    heartPath.moveTo(0, size * 0.3);
    heartPath.cubicTo(-size * 0.5, -size * 0.1, -size * 0.5, size * 0.2, 0, size * 0.5);
    heartPath.cubicTo(size * 0.5, size * 0.2, size * 0.5, -size * 0.1, 0, size * 0.3);
    
    canvas.drawPath(heartPath, paint);
  }

  void _drawSkull(Canvas canvas, Particle particle, Paint paint) {
    final size = particle.size;
    
    // Skull outline
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: size, height: size * 0.8),
      paint,
    );
    
    // Eye sockets
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset(-size * 0.2, -size * 0.1), size * 0.1, eyePaint);
    canvas.drawCircle(Offset(size * 0.2, -size * 0.1), size * 0.1, eyePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Utility widget for easy particle effects
class ParticleEffectWidget extends StatefulWidget {
  final ParticleType type;
  final Duration duration;
  final VoidCallback? onComplete;
  final double size;
  final Color? color;

  const ParticleEffectWidget({
    super.key,
    required this.type,
    this.duration = const Duration(seconds: 2),
    this.onComplete,
    this.size = 200,
    this.color,
  });

  @override
  State<ParticleEffectWidget> createState() => _ParticleEffectWidgetState();
}

class _ParticleEffectWidgetState extends State<ParticleEffectWidget> {
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.duration, () {
      if (mounted) {
        setState(() {
          _isActive = false;
        });
        widget.onComplete?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: ParticleSystem(
        isActive: _isActive,
        particleType: widget.type,
        particleColor: widget.color,
        child: Container(),
      ),
    );
  }
}
