// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());

import 'package:provider/provider.dart';

import 'services/providers/authProvider.dart';
import 'services/providers/scoreProvider.dart';
import 'services/providers/cloudFunctionsProvider.dart';
import 'auth/login_signup.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ScoreProvider()),
        ChangeNotifierProvider(create: (_) => CloudFunctionsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        home: const AuthWrapper(),
        home: const LoginSignupScreen(),

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
import 'screens/quick_tabs_screen.dart';
import 'screens/theme_switcher_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());

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
  State<ProfileCard> createState() => _ProfileCardState();
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

              CustomButton(
                label: "QuickTabs Nav",
                onPressed: () =>
                    navigateWithAnimation(context, const QuickTabsScreen()),
                color: Colors.blueAccent,
              ),

              CustomButton(
                label: "Theme Switcher",
                onPressed: () =>
                    navigateWithAnimation(context, const ThemeSwitcherScreen()),
                color: Colors.purple,
              ),
            ],
          ),
        ),

      ),
    );
  }
}

/// Listens to [AuthProvider] and routes to either the login screen
/// or the home page depending on the user's authentication state.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // User is logged in → show home page with CRUD.
    if (authProvider.user != null) {
      return const HomePage();
    }

    // Not logged in → show login/signup.
    return const LoginSignupScreen();
  }
}