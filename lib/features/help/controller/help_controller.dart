import 'package:get/get.dart';

class HelpController extends GetxController {
  int expandedIndex = -1;

  final List<Map<String, String>> helpItems = [
    {
      'title': 'Order issue',
      'answer':
          'If you are having a problem with your order, open the Orders section and check your order details and current status.',
    },
    {
      'title': 'Payment issue',
      'answer':
          'If your payment is not working, please check your selected payment method and try again. If the problem continues, contact support.',
    },
    {
      'title': 'Delivery issue',
      'answer':
          'For delivery problems, check your delivery address and selected delivery method. You can also contact support for further help.',
    },
    {
      'title': 'Account & profile',
      'answer':
          'You can update your personal information from the My Profile section by selecting Change.',
    },
    {
      'title': 'Refund & cancellation',
      'answer':
          'For cancellation or refund questions, please contact support with your order details so we can help you.',
    },
  ];

  void toggleItem(int index) {
    if (expandedIndex == index) {
      expandedIndex = -1;
    } else {
      expandedIndex = index;
    }

    update();
  }
}