import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/pending_reviews_controller.dart';
import 'widget/pending_review_card.dart';

class PendingReviewsScreen extends StatelessWidget {
  PendingReviewsScreen({super.key});

  final PendingReviewsController controller =
      Get.put(PendingReviewsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 21,
          ),
          onPressed: () => Get.back(),
        ),

        title: const Text(
          'Pending reviews',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),

        centerTitle: true,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFFF4B3A),
            ),
          );
        }

        if (controller.pendingReviews.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.rate_review_outlined,
                  size: 75,
                  color: Colors.grey.shade400,
                ),

                const SizedBox(height: 18),

                const Text(
                  'No pending reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Your completed orders will appear here.',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFFFF4B3A),
          onRefresh: controller.fetchPendingReviews,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
            itemCount: controller.pendingReviews.length,
            itemBuilder: (context, index) {
              final product = controller.pendingReviews[index];

              return PendingReviewCard(
                product: product,
                onRate: () {
                  _showRatingDialog(
                    context,
                    product,
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }

  void _showRatingDialog(
    BuildContext context,
    Map<String, dynamic> product,
  ) {
    int selectedRating = 0;

    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),

              title: Text(
                'Rate ${product['name'] ?? 'Product'}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'How was your experience?',
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) {
                        final starNumber = index + 1;

                        return IconButton(
                          onPressed: () {
                            setState(() {
                              selectedRating = starNumber;
                            });
                          },
                          icon: Icon(
                            starNumber <= selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Write a review...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    commentController.dispose();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4B3A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: selectedRating == 0
                      ? null
                      : () async {
                          Navigator.pop(dialogContext);

                          await controller.submitReview(
                            product: product,
                            rating: selectedRating,
                            comment: commentController.text.trim(),
                          );

                          commentController.dispose();
                        },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}