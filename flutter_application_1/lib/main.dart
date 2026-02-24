// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'widgets/custom_button.dart';
import 'widgets/info_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Modular Demo",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ProfileCard(),
    );
  }
}

// ================= PROFILE SCREEN =================
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
      appBar: AppBar(title: const Text("Profile")),
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

              Text("Likes: $likes"),
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
            ],
          ),
        ),
      ),
    );
  }
}

// ================= RESPONSIVE SCREEN =================
class ResponsiveHome extends StatelessWidget {
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
                  child: Center(child: Text("Card ${index + 1}")),
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
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Form Submitted Successfully!")),
      );
    }
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
          Text("Counter: $counter", style: const TextStyle(fontSize: 22)),
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