import 'package:flutter/material.dart';
import 'package:food_delivery/auth/auth_screen.dart';
import 'package:food_delivery/const/app_colors.dart';
import 'package:food_delivery/const/app_fonts.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColor.text4, AppColor.primary],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
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
              ),

              SizedBox(height: 28),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  "Food for\nEveryone",
                  style: GoogleSansRoundedStyles.bold(
                    size: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                  ),
                ),
              ),

              SizedBox(height: 12),

              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      right: -size.width * 0.02,
                      bottom: size.height * 0.05,
                        child: _FadedCharacter(
                          imagePath: 'assets/images/ToyFaces_Tansparent_BG_29.png',
                          height: size.height * 0.35,
                        ),  
                    ),
                    Positioned(
                      left: -size.width * 0.02,
                      bottom: size.height * 0.05,
                      child: _FadedCharacter(
                        imagePath: 'assets/images/ToyFaces_Tansparent_BG_49.png',
                        height: size.height * 0.42,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 40, left: 30, right: 30),
                child: GestureDetector(
                  onTap: () {
                 Get.to( () =>  AuthScreen());
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Get started",
                        style: GoogleSansRoundedStyles.bold(
                          size: 18,
                          color: AppColor.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
 SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
class _FadedCharacter extends StatelessWidget {
  final String imagePath;
  final double height;
  final double fadeStart; 
  final double fadeEnd;   
 
  const _FadedCharacter({
    required this.imagePath,
    required this.height,
    this.fadeStart = 0.65, 
    this.fadeEnd = 1.0,   
  });
 
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Colors.white,
            Colors.white,
            Colors.transparent, 
          ],
          stops: [0.0, fadeStart, fadeEnd],
        ).createShader(bounds);
      },
      child: Image.asset(
        imagePath,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}