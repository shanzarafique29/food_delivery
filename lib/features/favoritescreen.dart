import 'package:flutter/material.dart';
import 'package:food_delivery/widgets/customappbar.dart';

class Favoritescreen extends StatefulWidget {
  const Favoritescreen({super.key});

  @override
  State<Favoritescreen> createState() => _FavoritescreenState();
}

class _FavoritescreenState extends State<Favoritescreen> {
  @override
  Widget build(BuildContext context) {
       final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
       
      ),
      body: Center(child: Text("Favorite Screen"),
      ) ,
    );
  }
}