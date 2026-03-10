// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/screens/stateless_stateful_demo.dart';
import 'package:flutter_application_1/pages/tabs/home.dart';

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
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ----------------------------
// Custom Fade-Slide Page Route Transition
// ----------------------------
class FadeSlideRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeSlideRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final offsetTween = Tween<Offset>(
              begin: const Offset(0.0, 0.15),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCubic));

            final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeIn));

            return SlideTransition(
              position: animation.drive(offsetTween),
              child: FadeTransition(
                opacity: animation.drive(fadeTween),
                child: child,
              ),
            );
          },
        );
}

// ----------------------------
// Home Screen (Responsive + Animated)
// ----------------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ProfileHeader(),
        actions: [
          IconButton(
            icon: const Icon(Icons.science),
            tooltip: 'Widget Demo',
            onPressed: () {
              Navigator.push(
                context,
                FadeSlideRoute(page: const StatelessStatefulDemo()),
              );
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: const ProfileCard(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Players',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Matches',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              FadeSlideRoute(page: PlayersScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              FadeSlideRoute(page: MatchesScreen()),
            );
          }
        },
      ),
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
// Stateful Widget – Responsive layout + Animations
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

class _ProfileCardState extends State<ProfileCard> with SingleTickerProviderStateMixin {
  int likes = 0;
  bool isBlue = true;

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  bool isPressed = false;


  void incrementLikes() {
    _scaleController.forward().then((_) => _scaleController.reverse());
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: cardWidth,
            padding: EdgeInsets.all(isWide ? 30 : 20),
            decoration: BoxDecoration(
              color: isBlue ? Colors.blue[100] : Colors.green[100],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: (isBlue ? Colors.blue : Colors.green).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: 'profile-avatar',
                  child: CircleAvatar(
                    radius: avatarRadius,
                    child: Icon(Icons.person, size: avatarRadius),
                  ),
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
                // Animated like counter with scale bounce
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Text(
                    "Likes: $likes",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: incrementLikes,
                  icon: const Icon(Icons.thumb_up),
                  label: const Text("Like"),
                ),
                TextButton(
                  onPressed: toggleColor,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      isBlue ? "Switch to Green" : "Switch to Blue",
                      key: ValueKey<bool>(isBlue),
                    ),
                  ),
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