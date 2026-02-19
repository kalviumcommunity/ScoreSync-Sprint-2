// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileCard(),
    );
  }
}

class ProfileCard extends StatefulWidget {
  @override
  _ProfileCardState createState() => _ProfileCardState();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Widget Tree Demo"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isBlue ? Colors.blue[100] : Colors.green[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 40),
              ),
              SizedBox(height: 10),
              Text(
                "Hamsha",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text("Flutter Developer"),
              SizedBox(height: 15),
              Text("Likes: $likes"),
              ElevatedButton(
                onPressed: incrementLikes,
                child: Text("Like"),
              ),
              TextButton(
                onPressed: toggleColor,
                child: Text("Change Background"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
