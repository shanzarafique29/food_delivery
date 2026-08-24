import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_fonts.dart';

class ProductInfoSection extends StatelessWidget {
  final String title;
  final String content;

  const ProductInfoSection({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: GoogleSansRoundedStyles.bold(
              size: 16,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
         SizedBox(height: 6),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            content,
            style: GoogleSansRoundedStyles.light(
                      size: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w300,
                      height: 1.4
                    ),
          ),
        ),
      ],
    );
  }
}
