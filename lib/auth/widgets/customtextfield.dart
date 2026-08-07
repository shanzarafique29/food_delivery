import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Color focusColor;
 
  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.focusColor = AppColor.primary,
  });
 
  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style:  GoogleSansRoundedStyles.regular(size: 14, color: Colors.grey.shade600)),
        
        TextField(
          controller: controller,
          obscureText: obscureText,
          cursorColor: focusColor,
          obscuringCharacter: '*',  
          keyboardType: keyboardType,
          style:  GoogleSansRoundedStyles.regular(size: 16, color: Colors.black),
          decoration: InputDecoration(
            border:  UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder:  UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: focusColor),
            ),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ],
    );
  }
}