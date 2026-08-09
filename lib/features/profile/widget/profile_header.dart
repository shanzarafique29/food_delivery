
import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String profileImage;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 55,
              height: 55,
              child: profileImage.isNotEmpty
                  ? Image.network(
                      profileImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFFFD8D0),
                          child: Icon(
                            Icons.person,
                            size: 32,
                            color: AppColor.primary,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: const Color(0xFFFFD8D0),
                      child: Icon(
                        Icons.person,
                        size: 32,
                        color: AppColor.primary,
                      ),
                    ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                const Divider(
                  height: 1,
                  thickness: 0.7,
                  color: Color(0xFFD9D9D9),
                ),

                const SizedBox(height: 4),

                Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 4),

                const Divider(
                  height: 1,
                  thickness: 0.7,
                  color: Color(0xFFD9D9D9),
                ),

                const SizedBox(height: 4),

                Text(
                  address,
                  style: const TextStyle(
                    fontSize: 8.5,
                    color: Colors.grey,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
