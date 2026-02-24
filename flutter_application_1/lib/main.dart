// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Complete Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfileCard(),
    );
  }
}

// ===============================
// Stateless Widget (Header)
// ===============================
class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      "Flutter Demo App",
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }
}

// ===============================
// PROFILE CARD SCREEN
// ===============================
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
        title: ProfileHeader(),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isBlue ? Colors.blue[100] : Colors.green[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Hamsha",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text("Flutter Developer"),
                const SizedBox(height: 15),
                Text("Likes: $likes"),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: incrementLikes,
                  child: const Text("Like"),
                ),
                TextButton(
                  onPressed: toggleColor,
                  child: const Text("Change Background"),
                ),
                const SizedBox(height: 15),

                // Navigate to Form
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserInputForm(),
                      ),
                    );
                  },
                  child: const Text("Go to Form"),
                ),

                const SizedBox(height: 10),

                // Navigate to Counter Demo
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StateManagementDemo(),
                      ),
                    );
                  },
                  child: const Text("Go to Counter Demo"),
                ),

                const SizedBox(height: 10),

                // Navigate to Responsive UI
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResponsiveHome(),
                      ),
                    );
                  },
                  child: const Text("Go to Responsive UI"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===============================
// RESPONSIVE HOME SCREEN
// ===============================
class ResponsiveHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Responsive Mobile UI"),
      ),
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isTablet ? 32 : 16),
            color: Colors.blue[100],
            child: Text(
              "Welcome to Responsive Design",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isTablet ? 28 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // MAIN CONTENT
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 24 : 12),
              child: GridView.builder(
                itemCount: 6,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 2 : 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Card ${index + 1}",
                        style: TextStyle(
                          fontSize: isTablet ? 22 : 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // FOOTER
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================
// USER INPUT FORM SCREEN
// ===============================
class UserInputForm extends StatefulWidget {
  @override
  _UserInputFormState createState() => _UserInputFormState();
}

class _UserInputFormState extends State<UserInputForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Form Submitted Successfully!"),
        ),
      );
      _nameController.clear();
      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Input Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  if (!value.contains("@")) {
                    return "Enter a valid email address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: submitForm,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===============================
// STATE MANAGEMENT DEMO SCREEN
// ===============================
class StateManagementDemo extends StatefulWidget {
  @override
  _StateManagementDemoState createState() =>
      _StateManagementDemoState();
}

class _StateManagementDemoState extends State<StateManagementDemo> {
  int _counter = 0;

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  void _decrement() {
    setState(() {
      if (_counter > 0) _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("State Management Demo"),
      ),
      body: Container(
        color: _counter >= 5 ? Colors.green[100] : Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Counter Value:",
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              Text(
                "$_counter",
                style: const TextStyle(
                    fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _increment,
                    child: const Text("Increment"),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: _decrement,
                    child: const Text("Decrement"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}