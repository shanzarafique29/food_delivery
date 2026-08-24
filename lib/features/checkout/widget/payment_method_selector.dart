import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';

class PaymentMethodSelector extends StatelessWidget {
  final int selectedMethod;
  final ValueChanged<int> onMethodChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPaymentTile(
            title: 'Card',
            icon: Icons.credit_card,
            value: 0,
            bgColor: AppColor.text3,
          ),
          const SizedBox(height: 9),
          const Divider(height: 1, indent: 16, endIndent: 16),
          const SizedBox(height: 9),
          _buildPaymentTile(
            title: 'Bank account',
            icon: Icons.account_balance,
            value: 1,
            bgColor: AppColor.text1,
          ),
          const SizedBox(height: 9),
          const Divider(height: 1, indent: 16, endIndent: 16),
          const SizedBox(height: 9),
          _buildPaymentTile(
            title: 'Cash on delivery',
            icon: Icons.money_off_outlined,
            value: 2,
            bgColor: AppColor.text2,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTile({
    required String title,
    required IconData icon,
    required int value,
    required Color bgColor,
  }) {
    return InkWell(
      onTap: () => onMethodChanged(value),
      child: Row(
        children: [
          Radio<int>(
            value: value,
            groupValue: selectedMethod,
            activeColor: AppColor.primary,
            onChanged: (val) {
              if (val != null) onMethodChanged(val);
            },
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
           SizedBox(width: 12),
          Text(title),
        ],
      ),
    );
  }
}