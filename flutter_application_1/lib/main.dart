// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScoreSync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

// ----------------------------
// Home Screen (Responsive)
// ----------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ProfileHeader(),
      ),
      body: const ProfileCard(),
    );
  }
}

// ----------------------------
// Stateless Widget (Header) – Responsive font size
// ----------------------------
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth < 360 ? 18.0 : (screenWidth < 600 ? 22.0 : 28.0);

    return Text(
      "ScoreSync",
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// ----------------------------
// Stateful Widget – Responsive layout
// ----------------------------
class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  int likes = 0;
  bool isBlue = true;

  void incrementLikes() {
    setState(() {
      likes++;
    });
  }

  void toggleColor() {
    setState(() {
      isBlue = !isBlue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final cardWidth = isWide ? 400.0 : constraints.maxWidth * 0.85;
        final avatarRadius = isWide ? 50.0 : 40.0;
        final titleFontSize = isWide ? 24.0 : 20.0;

        return Center(
          child: Container(
            width: cardWidth,
            padding: EdgeInsets.all(isWide ? 30 : 20),
            decoration: BoxDecoration(
              color: isBlue ? Colors.blue[100] : Colors.green[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  child: Icon(Icons.person, size: avatarRadius),
                ),
                const SizedBox(height: 10),
                Text(
                  "Hamsha",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("Flutter Developer"),
                const SizedBox(height: 10),
                Text(
                  "🔥 Firebase Connected Successfully!",
                  style: TextStyle(fontSize: isWide ? 16.0 : 14.0),
                ),
                const SizedBox(height: 15),
                Text("Likes: $likes"),
                ElevatedButton(
                  onPressed: incrementLikes,
                  child: const Text("Like"),
                ),
                TextButton(
                  onPressed: toggleColor,
                  child: const Text("Change Background"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}