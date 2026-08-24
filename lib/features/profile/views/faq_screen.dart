import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:get/get.dart';

import '../controller/faq_controller.dart';
import '../widget/faq_item.dart';

class FaqScreen extends StatelessWidget {
  FaqScreen({super.key});

  final FaqController controller = Get.put(FaqController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 21),
          onPressed: () => Get.back(),
        ),

        title: Text(
          'FAQ',
          style: GoogleSansRoundedStyles.regular(
            size: 10,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding:  EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Text(
              'Frequently asked questions',
              style:GoogleSansRoundedStyles.bold(
                                      size: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
            ),
           SizedBox(height: 8),
            Text(
              'Find answers to the most common questions.',
              style: GoogleSansRoundedStyles.light(
                                      size: 18,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
            ),
SizedBox(height: 22),
            Obx(
              () => Column(
                children: List.generate(controller.faqs.length, (index) {
                  final faq = controller.faqs[index];

                  return FaqItem(
                    question: faq['question']!,
                    answer: faq['answer']!,
                    isExpanded: controller.expandedIndex.value == index,
                    onTap: () {
                      controller.toggleQuestion(index);
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
