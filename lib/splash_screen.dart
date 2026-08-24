import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/auth/auth_screen.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:food_delivery/features/home/view/root_screen.dart';
import 'package:food_delivery/onboarding/onboardingscreen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    final results = await Future.wait([
      Future.delayed(const Duration(seconds: 2)),
      _resolveDestination(),
    ]);

    final destination = results[1] as Widget;
    if (mounted) Get.offAll(() => destination);
  }

  Future<Widget> _resolveDestination() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool('isOnboardingDone') ?? false;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return const RootScreen();
    }
    return onboardingDone ? AuthScreen() : const OnboardingScreen();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRect(
              child: Align(
                alignment: Alignment.center,
                heightFactor: 0.55,
                child: Image.asset(
                  'assets/images/app logo.png',
                  height: size.height * 0.55,
                  width: size.width * 0.55,
                ),
              ),
            ),
             SizedBox(height: 2), 
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Food ',
                    style: GoogleSansRoundedStyles.medium(
                      size: 30,
                      color: AppColor.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'For \nEveryone',
                    style: GoogleSansRoundedStyles.medium(
                      size:  30,
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
