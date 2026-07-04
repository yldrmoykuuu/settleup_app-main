import 'dart:math';

import 'package:flutter/material.dart';

class LuckyWheel extends StatefulWidget {
  final List<String> labels;
  final ValueChanged<int> onSpinComplete;

  const LuckyWheel({
    super.key,
    required this.labels,
    required this.onSpinComplete,
  });

  @override
  State<LuckyWheel> createState() => LuckyWheelState();
}

class LuckyWheelState extends State<LuckyWheel>
    with SingleTickerProviderStateMixin {
  static const List<Color> _palette = [
    Color(0xFF6366F1),
    Color(0xFFEC4899),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFFEF4444),
    Color(0xFF14B8A6),
  ];

  late final AnimationController _controller;
  Animation<double>? _spinAnimation;
  double _rotation = 0;
  bool isSpinning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _normalize(double angle) {
    const twoPi = 2 * pi;
    var a = angle % twoPi;
    if (a < 0) a += twoPi;
    return a;
  }

  void spin() {
    if (isSpinning || widget.labels.length < 2) return;

    final n = widget.labels.length;
    final segmentAngle = 2 * pi / n;
    final winnerIndex = Random().nextInt(n);
    final requiredMod = _normalize(
      -(winnerIndex * segmentAngle + segmentAngle / 2),
    );
    final baseTurns = _rotation - (_rotation % (2 * pi));
    final target = baseTurns + 5 * 2 * pi + requiredMod;

    _spinAnimation = Tween<double>(begin: _rotation, end: target).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    setState(() => isSpinning = true);

    _controller
      ..reset()
      ..forward().whenComplete(() {
        _rotation = target;
        if (!mounted) return;
        setState(() => isSpinning = false);
        widget.onSpinComplete(winnerIndex);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final angle = _spinAnimation?.value ?? _rotation;
            return Transform.rotate(angle: angle, child: child);
          },
          child: SizedBox(
            width: 260,
            height: 260,
            child: CustomPaint(
              painter: _WheelPainter(
                labels: widget.labels,
                colors: _palette,
              ),
            ),
          ),
        ),
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface,
              width: 2,
            ),
          ),
        ),
        Positioned(
          top: -4,
          child: Icon(
            Icons.arrow_drop_down,
            size: 44,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _WheelPainter extends CustomPainter {
  final List<String> labels;
  final List<Color> colors;

  _WheelPainter({required this.labels, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final n = labels.length;
    if (n == 0) return;
    final segmentAngle = 2 * pi / n;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < n; i++) {
      final startAngle = -pi / 2 + i * segmentAngle;
      fillPaint.color = colors[i % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        fillPaint,
      );
    }

    final separatorPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 2;
    for (var i = 0; i < n; i++) {
      final angle = -pi / 2 + i * segmentAngle;
      final edge = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawLine(center, edge, separatorPaint);
    }

    for (var i = 0; i < n; i++) {
      final midAngle = -pi / 2 + i * segmentAngle + segmentAngle / 2;
      final labelRadius = radius * 0.62;
      final pos = Offset(
        center.dx + labelRadius * cos(midAngle),
        center.dy + labelRadius * sin(midAngle),
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: radius * 0.85);

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(midAngle + pi / 2);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }

    canvas.drawCircle(
      center,
      radius - 1,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _WheelPainter oldDelegate) {
    return oldDelegate.labels != labels;
  }
}
