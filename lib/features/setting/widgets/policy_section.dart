import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';

class PolicySection extends StatelessWidget {
  final String title;
  final String content;

  const PolicySection({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 4, height: 16, decoration: BoxDecoration(color: AppColor.primary, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.6)),
        ],
      ),
    );
  }
}