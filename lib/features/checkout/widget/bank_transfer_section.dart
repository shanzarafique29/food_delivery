import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/features/checkout/controller/payment_controller.dart';
import 'package:get/get.dart';

class BankTransferSection extends StatelessWidget {
  final PaymentController controller;

  const BankTransferSection({super.key, required this.controller});

  void _copyToClipboard(BuildContext context, String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label copied'), duration: const Duration(seconds: 1)));
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
          GestureDetector(
            onTap: () => _copyToClipboard(context, value, label),
            child: const Icon(Icons.copy, size: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingBankDetails.value) {
        return const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()));
      }

      final details = controller.bankDetails.value;
      if (details == null || details.accountNumber.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(14)),
          child: const Text('Bank details not configured yet. Please contact support.', style: TextStyle(color: Colors.orange, fontSize: 13)),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Transfer to this account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 12),
                _detailRow(context, 'Bank', details.bankName),
                _detailRow(context, 'Account Title', details.accountTitle),
                _detailRow(context, 'Account No.', details.accountNumber),
                _detailRow(context, 'IBAN', details.iban),
              ],
            ),
          ),
          const SizedBox(height: 16),

          const Text('Upload payment proof', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Obx(() {
            final hasProof = controller.proofImageUrl.value.isNotEmpty;
            return GestureDetector(
              onTap: controller.isUploadingProof.value ? null : controller.pickProofImage,
              child: Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: controller.isUploadingProof.value
                    ? const Center(child: CircularProgressIndicator())
                    : hasProof
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.network(controller.proofImageUrl.value, fit: BoxFit.cover)),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: GestureDetector(
                                  onTap: controller.removeProof,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                    child: const Icon(Icons.close, color: Colors.white, size: 16),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file_outlined, color: AppColor.primary, size: 30),
                              SizedBox(height: 6),
                              Text('Tap to upload screenshot', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
              ),
            );
          }),
          const SizedBox(height: 12),
          TextField(
            controller: controller.referenceNumberController,
            decoration: InputDecoration(
              labelText: 'Transaction Reference Number',
              hintText: 'e.g. TRX123456789',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ],
      );
    });
  }
}