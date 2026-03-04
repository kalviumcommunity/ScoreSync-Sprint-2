// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/responsive_home.dart' show ResponsiveHome;
import 'package:flutter_application_1/screens/state_management_demo.dart' show StateManagementDemo;
import 'package:flutter_application_1/screens/user_input_form.dart' show UserInputForm;

import 'firebase_options.dart';
import 'widgets/custom_button.dart';
import 'widgets/info_card.dart';
import 'screens/asset_demo_screen.dart';
import 'screens/scrollable_views.dart';
import 'screens/animations_screen.dart';
import 'screens/home_screen.dart';
import 'screens/details_screen.dart';
import 'auth/login_signup.dart';
import 'pages/tasks_screen.dart';
import 'screens/form_validation_screen.dart';
import 'screens/live_items_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ScoreSync",
      home: const AuthWrapper(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/details': (context) => const DetailsScreen(),
      },
    );
  }
}

// ================= AUTH WRAPPER =================

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const ProfileCard();
        }
        return const LoginSignupScreen();
      },
    );
  }
}

// ================= PROFILE SCREEN =================

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  int likes = 0;
  bool isBlue = true;
  bool isPressed = false;

  void incrementLikes() {
    setState(() {
      likes++;
      isPressed = true;
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        isPressed = false;
      });
    });
  }

  void toggleColor() {
    setState(() {
      isBlue = !isBlue;
    });
  }

  // 🔹 Custom Slide Transition
  void navigateWithAnimation(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => page,
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: AnimatedContainer(
          // 🔥 Animated Background
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(20),
          color: isBlue ? Colors.blue[50] : Colors.green[50],
          child: Column(
            children: [

              const InfoCard(
                title: "Hamsha",
                subtitle: "Flutter Developer",
                icon: Icons.person,
              ),

              const SizedBox(height: 20),

              Text("Likes: $likes",
                  style: const TextStyle(fontSize: 18)),

              const SizedBox(height: 10),

              // 🔥 Animated Like Button
              AnimatedScale(
                scale: isPressed ? 0.9 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: CustomButton(
                  label: "Like",
                  onPressed: incrementLikes,
                  color: Colors.pink,
                ),
              ),

              CustomButton(
                label: "Change Background",
                onPressed: toggleColor,
                color: Colors.orange,
              ),

              CustomButton(
                label: "Go to Form",
                onPressed: () =>
                    navigateWithAnimation(context, UserInputForm()),
              ),

              CustomButton(
                label: "Go to Counter Demo",
                onPressed: () =>
                    navigateWithAnimation(context, StateManagementDemo()),
              ),

              CustomButton(
                label: "Go to Responsive UI",
                onPressed: () =>
                    navigateWithAnimation(context, const ResponsiveHome()),
              ),

              CustomButton(
                label: "Go to Assets Demo",
                onPressed: () =>
                    navigateWithAnimation(context, const AssetDemoScreen()),
                color: Colors.teal,
              ),

              CustomButton(
                label: "Scrollable Views",
                onPressed: () =>
                    navigateWithAnimation(context, const ScrollableViews()),
                color: Colors.indigo,
              ),

              CustomButton(
                label: "Animations",
                onPressed: () =>
                    navigateWithAnimation(context, const AnimationsScreen()),
                color: Colors.deepOrange,
              ),

              CustomButton(
                label: "Navigation Demo",
                onPressed: () =>
                    navigateWithAnimation(context, const HomeScreen()),
                color: Colors.teal,
              ),

              CustomButton(
                label: "Firebase Tasks",
                onPressed: () =>
                    navigateWithAnimation(context, const TasksScreen()),
                color: Colors.deepPurple,
              ),

              CustomButton(
                label: "Profile Form",
                onPressed: () =>
                    navigateWithAnimation(context, const FormValidationScreen()),
                color: Colors.cyan,
              ),

              CustomButton(
                label: "Live Items Viewer",
                onPressed: () =>
                    navigateWithAnimation(context, const LiveItemsScreen()),
                color: Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}