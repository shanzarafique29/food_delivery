import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/faq_controller.dart';
import 'widget/faq_item.dart';

class FaqScreen extends StatelessWidget {
  FaqScreen({super.key});

  final FaqController controller = Get.put(FaqController());

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
          'FAQ',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frequently asked questions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Find answers to the most common questions.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 22),

           Obx(
              () => Column(
                children: List.generate(
                  controller.faqs.length,
                  (index) {
                    final faq = controller.faqs[index];

                    return FaqItem(
                      question: faq['question']!,
                      answer: faq['answer']!,
                      isExpanded: controller.expandedIndex.value == index,
                      onTap: () {
                        controller.toggleQuestion(index);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}