import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BounceTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const BounceTap({super.key, required this.child, this.onTap});

  @override
  State<BounceTap> createState() => _BounceTapState();
}

class _BounceTapState extends State<BounceTap> {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.94);
  void _onTapUp(_) {
    setState(() => _scale = 1.0);
    HapticFeedback.lightImpact(); 
    widget.onTap?.call();
  }
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}