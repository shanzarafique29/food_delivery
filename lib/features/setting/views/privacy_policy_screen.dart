import 'package:flutter/material.dart';
import 'package:food_delivery/features/setting/widgets/policy_section.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.privacy_tip_outlined, size: 48, color: Colors.black87),
            SizedBox(height: 12),
            Text(
              'Your privacy matters to us',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Last updated: August 2026',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            SizedBox(height: 24),
            PolicySection(
              title: 'Information We Collect',
              content:
                  'We collect your name, phone number, delivery address, and order history to process and deliver your orders. Payment details are handled securely and are never stored on our servers.',
            ),
             PolicySection(
              title: 'How We Use Your Information',
              content:
                  'Your information is used to process orders, send delivery updates, provide customer support, and improve our service. We may send you offers and promotions unless you opt out.',
            ),
            PolicySection(
              title: 'Location Data',
              content:
                  'We use your delivery address and, where enabled, your device location to show nearby restaurants and provide accurate delivery estimates.',
            ),
             PolicySection(
              title: 'Data Sharing',
              content:
                  'We share necessary order details with restaurants and delivery partners to fulfil your order. We do not sell your personal information to third parties.',
            ),
             PolicySection(
              title: 'Data Security',
              content:
                  'We use industry-standard encryption and security practices to protect your data. Access to your account is protected by your login credentials — keep them confidential.',
            ),
             PolicySection(
              title: 'Your Rights',
              content:
                  'You can request access to, correction of, or deletion of your personal data at any time from the Security settings in this app, or by contacting our support team.',
            ),
             PolicySection(
              title: 'Changes to This Policy',
              content:
                  'We may update this policy from time to time. Continued use of the app after changes means you accept the updated policy.',
            ),
             SizedBox(height: 12),
            Center(
              child: Text(
                'Questions? Contact support@fooddelivery.com',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
