import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductGridShimmer extends StatelessWidget {
  const ProductGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6, // 6 Fake Loading Cards
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Box
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Title Line
                Container(
                  height: 15,
                  width: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.white,
                ),
                const SizedBox(height: 6),
                // Subtitle Line
                Container(
                  height: 12,
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                // Price Tag
                Container(
                  height: 20,
                  width: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}