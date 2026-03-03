import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AssetDemoScreen extends StatelessWidget {
  const AssetDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assets Demo"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // Local Image
            const SizedBox(height: 20),
            Image.asset(
              "assets/images/image-1.png",
              width: 150,
            ),

            const SizedBox(height: 20),

            const Text(
              "Flutter Asset Demo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Background Image Container
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/image-2.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Center(
                child: Text(
                  "Welcome to Flutter",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Built-in Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.star, color: Colors.amber, size: 32),
                SizedBox(width: 15),
                Icon(Icons.android, color: Colors.green, size: 32),
                SizedBox(width: 15),
                Icon(Icons.apple, color: Colors.grey, size: 32),
              ],
            ),

            const SizedBox(height: 20),

            // Cupertino Icon
            const Icon(
              CupertinoIcons.heart,
              color: Colors.red,
              size: 40,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}