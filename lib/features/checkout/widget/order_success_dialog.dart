import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';

class OrderSuccessDialog extends StatefulWidget {
  const OrderSuccessDialog({super.key});

  @override
  State<OrderSuccessDialog> createState() => _OrderSuccessDialogState();
}

class _OrderSuccessDialogState extends State<OrderSuccessDialog> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding:  EdgeInsets.all(28),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scaleAnim,
              child: Container(
                width: 72,
                height: 72,
                decoration:  BoxDecoration(color: AppColor.primary, shape: BoxShape.circle),
                child:  Icon(Icons.check_rounded, color: Colors.white, size: 40),
              ),
            ),
             SizedBox(height: 16),
             Text('Order Placed!', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
             SizedBox(height: 4),
            Text('We\'re preparing your order', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}