import 'package:flutter/material.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingscreenState();
}

class _OnboardingscreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppColor.primary, AppColor.text4],
              ),
            ),
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/applogo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned(
            bottom: size.height * 0.19,
            right: -size.width * 0.0,
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.9,
                  child: Image.asset(
                    'assets/images/ToyFaces_Tansparent_BG_29.png',
                    height: size.height * 0.34,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: size.height * 0.10, // sirf bottom 10% cover kare
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,// upar transparent
                          AppColor.primary, // niche halka blur/soft shadow
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: size.height * 0.19,
            left: -size.width * 0.0,
            child: Image.asset(
              'assets/images/ToyFaces_Tansparent_BG_49.png',
              height: size.height * 0.42,
              fit: BoxFit.contain,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/applogo.png',
                      height: 35,
                      width: 35,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: 24.0),

                  Text(
                    "Food for\nEveryone",
                    style: GoogleSansRoundedStyles.bold(
                      size: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),

                  Spacer(),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          "Get started",
                          style: GoogleSansRoundedStyles.bold(
                            size: 18,
                            color: const Color(0xFFFE4A1F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
