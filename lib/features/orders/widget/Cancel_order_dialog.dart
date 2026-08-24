import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/orders/controller/order_controller.dart';

class CancelOrderDialog extends StatefulWidget {
  final String orderId;
  final OrderController controller;

  const CancelOrderDialog({super.key, required this.orderId, required this.controller});

  @override
  State<CancelOrderDialog> createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends State<CancelOrderDialog> {
  String? selectedReason;
  final customReasonController = TextEditingController();
  bool isSubmitting = false;

  @override
  void dispose() {
    customReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title:  Text('Cancel Order', style: GoogleSansRoundedStyles.regular(size: 18, color: Colors.black, fontWeight: FontWeight.bold),),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text('Why do you want to cancel?', style: GoogleSansRoundedStyles.regular(size: 14, color: Colors.black, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ...widget.controller.cancellationReasons.map((reason) => RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(reason, style: TextStyle(fontSize: 13)),
                  value: reason,
                  groupValue: selectedReason,
                  onChanged: (val) => setState(() => selectedReason = val),
                )),
            if (selectedReason == 'Other') ...[
               SizedBox(height: 8),
              TextField(
                controller: customReasonController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Type your reason...',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Back', style: TextStyle(color: Colors.grey))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary),
          onPressed: isSubmitting || selectedReason == null
              ? null
              : () async {
                  final reason = selectedReason == 'Other' ? customReasonController.text.trim() : selectedReason!;
                  if (reason.isEmpty) return;

                  setState(() => isSubmitting = true);
                  await widget.controller.requestCancellation(orderId: widget.orderId, reason: reason);

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cancellation request sent to admin')),
                    );
                  }
                },
          child: isSubmitting
              ?  SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              :  Text('Submit Request', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}