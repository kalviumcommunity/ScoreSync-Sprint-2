// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'widgets/custom_button.dart';
import 'widgets/info_card.dart';
import 'screens/asset_demo_screen.dart';
import 'screens/scrollable_views.dart';
import 'screens/animations_screen.dart';
import 'auth/login_signup.dart';
import 'pages/tasks_screen.dart';

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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ScoreSync",
      home: AuthWrapper(),
    );
  }
}

// Shows Login screen if not logged in, Tasks screen if logged in
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
          return const ProfileCard(); // user is logged in → old app
        }
        return const LoginSignupScreen(); // user is not logged in
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
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
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

              CustomButton(
                label: "Like",
                onPressed: incrementLikes,
                color: Colors.pink,
              ),

              CustomButton(
                label: "Change Background",
                onPressed: toggleColor,
                color: Colors.orange,
              ),

              CustomButton(
                label: "Go to Form",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UserInputForm()),
                  );
                },
              ),

              CustomButton(
                label: "Go to Counter Demo",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => StateManagementDemo()),
                  );
                },
              ),

              CustomButton(
                label: "Go to Responsive UI",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ResponsiveHome()),
                  );
                },
              ),

              // ✅ NEW BUTTON FOR ASSET DEMO
              CustomButton(
                label: "Go to Assets Demo",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AssetDemoScreen()),
                  );
                },
                color: Colors.teal,
              ),

              // 📜 SCROLLABLE VIEWS
              CustomButton(
                label: "Scrollable Views",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ScrollableViews()),
                  );
                },
                color: Colors.indigo,
              ),

              // 🎬 ANIMATIONS
              CustomButton(
                label: "Animations",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AnimationsScreen()),
                  );
                },
                color: Colors.deepOrange,
              ),

              // 🔥 FIREBASE TASKS
              CustomButton(
                label: "Firebase Tasks",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TasksScreen()),
                  );
                },
                color: Colors.deepPurple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= RESPONSIVE SCREEN =================
class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(title: const Text("Responsive UI")),
      body: Column(
        children: [
          InfoCard(
            title: "Responsive Layout",
            subtitle: isTablet ? "Tablet Mode" : "Phone Mode",
            icon: Icons.devices,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: isTablet ? 2 : 1,
              padding: const EdgeInsets.all(16),
              children: List.generate(
                4,
                (index) => Card(
                  child: Center(
                      child: Text(
                    "Card ${index + 1}",
                    style: const TextStyle(fontSize: 18),
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= FORM SCREEN =================
class UserInputForm extends StatefulWidget {
  @override
  _UserInputFormState createState() => _UserInputFormState();
}

class _UserInputFormState extends State<UserInputForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  void submitForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Form Submitted Successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Input Form")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 20),
            CustomButton(
              label: "Submit",
              onPressed: submitForm,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

// ================= COUNTER SCREEN =================
class StateManagementDemo extends StatefulWidget {
  @override
  _StateManagementDemoState createState() =>
      _StateManagementDemoState();
}

class _StateManagementDemoState extends State<StateManagementDemo> {
  int counter = 0;

  void increment() => setState(() => counter++);
  void decrement() => setState(() => counter--);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Counter Demo")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Counter: $counter",
              style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 20),
          CustomButton(label: "Increment", onPressed: increment),
          CustomButton(
              label: "Decrement",
              onPressed: decrement,
              color: Colors.red),
        ],
      ),
    );
  }
}