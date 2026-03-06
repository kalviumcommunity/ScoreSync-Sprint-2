import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/providers/authProvider.dart';
import '../services/providers/scoreProvider.dart';
import 'scores/score_list_page.dart';
import 'scores/score_form_page.dart';
import 'cloud_functions_page.dart';

/// The main home screen shown after login.
/// Starts the Firestore listener, renders the score list,
/// and provides FAB to add scores + logout action.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Start listening to the current user's scores.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final scoreProvider = Provider.of<ScoreProvider>(context, listen: false);
      final uid = authProvider.user?.uid;
      if (uid != null) {
        scoreProvider.listenToScores(uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ScoreSync'),
        actions: [
          // Logged-in user indicator
          if (authProvider.user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  authProvider.user!.email ?? '',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          // Cloud Functions button
          IconButton(
            icon: const Icon(Icons.cloud),
            tooltip: 'Cloud Functions',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CloudFunctionsPage(),
                ),
              );
            },
          ),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              final scoreProvider =
                  Provider.of<ScoreProvider>(context, listen: false);
              scoreProvider.stopListening();
              await authProvider.logout();
              // AuthWrapper in main.dart handles navigation back to login.
            },
          ),
        ],
      ),
      body: const ScoreListPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScoreFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
