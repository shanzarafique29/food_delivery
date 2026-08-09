import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 43,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        dense: true,

        title: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 11,
          color: Colors.black,
        ),
      ),
    );
  }
}