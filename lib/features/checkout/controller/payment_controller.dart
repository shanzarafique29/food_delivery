import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class BankDetailsData {
  final String bankName;
  final String accountTitle;
  final String accountNumber;
  final String iban;

  BankDetailsData({required this.bankName, required this.accountTitle, required this.accountNumber, required this.iban});

  factory BankDetailsData.fromMap(Map<String, dynamic>? data) {
    return BankDetailsData(
      bankName: data?['bankName'] ?? '',
      accountTitle: data?['accountTitle'] ?? '',
      accountNumber: data?['accountNumber'] ?? '',
      iban: data?['iban'] ?? '',
    );
  }
}

class PaymentController extends GetxController {
  final _firestore = FirebaseFirestore.instance;

  var bankDetails = Rxn<BankDetailsData>();
  var isLoadingBankDetails = true.obs;

  var proofImageBytes = Rxn<Uint8List>();
  var proofImageUrl = ''.obs;
  var isUploadingProof = false.obs;

  final referenceNumberController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadBankDetails();
  }

  Future<void> _loadBankDetails() async {
    try {
      final doc = await _firestore.collection('settings').doc('bankDetails').get();
      bankDetails.value = BankDetailsData.fromMap(doc.data());
    } catch (_) {
      bankDetails.value = BankDetailsData(bankName: '', accountTitle: '', accountNumber: '', iban: '');
    } finally {
      isLoadingBankDetails.value = false;
    }
  }

  Future<void> pickProofImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      proofImageBytes.value = await picked.readAsBytes();
      await _uploadProof();
    }
  }

  Future<void> _uploadProof() async {
    if (proofImageBytes.value == null) return;

    try {
      isUploadingProof.value = true;

      const cloudName = "f4vugqmv"; 
      const uploadPreset = "food_delivery_preset"; 

      final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
      final request = http.MultipartRequest("POST", uri)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(http.MultipartFile.fromBytes('file', proofImageBytes.value!, filename: "proof_${DateTime.now().millisecondsSinceEpoch}.png"));

      final response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final data = json.decode(res.body);
        proofImageUrl.value = data['secure_url'];
      } else {
        Get.snackbar('Error', 'Proof upload failed', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isUploadingProof.value = false;
    }
  }

  void removeProof() {
    proofImageBytes.value = null;
    proofImageUrl.value = '';
  }

  bool validateForBankTransfer() {
    if (proofImageUrl.value.isEmpty) {
      Get.snackbar('Error', 'Payment proof screenshot lazmi hai', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (referenceNumberController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Transaction reference number likho', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    return true;
  }

  void resetProof() {
    proofImageBytes.value = null;
    proofImageUrl.value = '';
    referenceNumberController.clear();
  }

  @override
  void onClose() {
    referenceNumberController.dispose();
    super.onClose();
  }
}