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
      itemCount: 6, 
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
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                 SizedBox(height: 10),
                Container(
                  height: 15,
                  width: 120,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.white,
                ),
                SizedBox(height: 6),
                Container(
                  height: 12,
                  width: 80,
                  margin:  EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.white,
                ),
                 SizedBox(height: 10),
                Container(
                  height: 20,
                  width: 60,
                  margin:EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.white,
                ),
                 SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}