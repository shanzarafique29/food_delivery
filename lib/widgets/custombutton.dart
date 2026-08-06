import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color; 

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = AppColor.primary, 
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        decoration: BoxDecoration(
          color: widget.color, 
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style:  GoogleSansRoundedStyles.light(size: 18, color: AppColor.primary, fontWeight: FontWeight.w700  ),
          ),
        ),
      ),
    );
  }
}
