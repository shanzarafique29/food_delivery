import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/onboarding/onboardingscreen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth= FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
       final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Home Screen"),
        leading: IconButton(onPressed: () {
         auth.signOut().then( (value) {
          Get.snackbar('Logout', 'Logout Successfully');
           Get.offAll(() => const OnboardingScreen());
         }).onError((error, stackTrace) {
           Get.snackbar("Error", error.toString());
         });
        }, icon: const Icon(Icons.logout)),
        centerTitle: true,
      ),
      body: Center(child: Text("Home Screen")),
    );
  }
}