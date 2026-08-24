import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class StripePaymentController extends GetxController {
  static const String _backendUrl = 'https://food-delivery-phi-ebon.vercel.app/api/create-payment-intent';

  var isProcessing = false.obs;
  var paymentSuccess = false.obs;
  var errorMessage = Rxn<String>();

  Future<bool> payWithCard({required double amount, required String orderId}) async {
    try {
      isProcessing.value = true;
      errorMessage.value = null;

      final user = FirebaseAuth.instance.currentUser;

      final response = await http.post(
        Uri.parse(_backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': amount,
          'orderId': orderId,
          'userId': user?.uid ?? 'unknown',
        }),
      );

      if (response.statusCode != 200) {
        errorMessage.value = 'Unable to start payment';
        return false;
      }

      final data = json.decode(response.body);
      final clientSecret = data['clientSecret'] as String;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Food Delivery',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      paymentSuccess.value = true;
      return true;
    } on StripeException catch (e) {
      errorMessage.value = e.error.localizedMessage ?? 'Payment cancelled';
      return false;
    } catch (e) {
      errorMessage.value = 'Payment failed: $e';
      return false;
    } finally {
      isProcessing.value = false;
    }
  }
}