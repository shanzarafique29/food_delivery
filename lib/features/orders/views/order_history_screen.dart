import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/orders/controller/order_controller.dart';
import 'package:food_delivery/features/orders/widget/order_list_view.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title:  Text('History', style: GoogleSansRoundedStyles.bold(color: Colors.black, size: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body:  OrderListView(
        statuses: OrderController.historyStatuses,
        emptyIcon: Icons.receipt_long_outlined,
        emptyTitle: 'No history yet',
        emptySubtitle: 'Hit the orange button down below to Create an order',
      ),
    );
  }
}
