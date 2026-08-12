import 'package:get/get.dart';

class FaqController extends GetxController {
  final RxInt expandedIndex = (-1).obs;

  final List<Map<String, String>> faqs = [
    {
      'question': 'How can I place an order?',
      'answer':
          'Choose your favorite food from the home screen, add it to your cart, and proceed to checkout to place your order.',
    },
    {
      'question': 'How can I cancel my order?',
      'answer':
          'You can cancel your order before it is processed. Open your order details and select the cancel option if it is available.',
    },
    {
      'question': 'How can I track my order?',
      'answer':
          'Open the Orders section from your profile to view the current status of your order.',
    },
    {
      'question': 'What payment methods are available?',
      'answer':
          'You can select the available payment method during checkout, such as Card or Bank account.',
    },
    {
      'question': 'How long does delivery take?',
      'answer':
          'Delivery time depends on your selected delivery method and your delivery location.',
    },
    {
      'question': 'Can I change my delivery address?',
      'answer':
          'Yes. You can change your delivery details from the address section during checkout.',
    },
  ];

  void toggleQuestion(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1;
    } else {
      expandedIndex.value = index;
    }
  }
}