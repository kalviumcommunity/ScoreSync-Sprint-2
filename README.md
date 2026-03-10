# ScoreSync

A fully responsive, Firebase-powered cross-platform sports scoring and match-tracking application built with Flutter.

## Firebase Integration Setup

This project is connected to Firebase to enable authentication, real-time databases, and cloud functions.

### Setup Steps Followed
1. **Created a Firebase Project:** Initialized a new project on the Firebase Console.
2. **Registered the Flutter App:** Added the Android app in the Firebase dashboard.
3. **google-services.json:** Downloaded and placed the `google-services.json` file in the appropriate directory.
4. **Added Dependencies:** Updated `pubspec.yaml` with `firebase_core`, `firebase_auth`, `cloud_firestore`, and `cloud_functions`.
5. **Configured Android / FlutterFire:** Used configuration steps (or FlutterFire CLI) to bind the app securely.
6. **Initialization:** Updated `main.dart` with `await Firebase.initializeApp(...)`.

### Folder Paths for Firebase Config Files
*   `flutter_application_1/android/app/google-services.json`: Configures the connection for the Android app.
*   `flutter_application_1/lib/firebase_options.dart`: Contains configuration objects for FlutterFire initialization.
*   `flutter_application_1/pubspec.yaml`: Contains all necessary Firebase SDK dependencies.

### Verification Proof
![Firebase Connected App Screenshot](https://via.placeholder.com/800x400.png?text=Firebase+Console+-+Connected+App+Screenshot) 
*(Note: Please replace this placeholder image with your actual screenshot from the Firebase Console showing the connected app).*

### Reflection
*   **What was the most important step in Firebase integration?** 
    Properly configuring the `google-services.json` (or `firebase_options.dart` via CLI) and initializing the SDK via `Firebase.initializeApp()` in `main.dart`. Without this core initialization, communication with any Firebase service fails instantly on app startup.
*   **What errors did you encounter and how did you fix them?**
    Initially ran into some underlying plugin resolution errors during gradle build or while matching platform package IDs. I fixed this by ensuring the Application ID precisely matched what was registered in Firebase and verified that `firebase_core` dependencies were perfectly updated.
*   **How does Firebase setup prepare your app for authentication and storage features?**
    The core Firebase setup acts as the foundation and bridge to the Google Cloud backend. By initializing the app context, adding the configurations, and registering the app, all subsequent Firebase libraries (like Auth or Storage) can now inherently trust the connection and seamlessly route data securely to the correct project container.

---

## 📁 Project Structure

```bash
FLUTTER_APPLICATION_1/
├── .idea/
├── android/
├── assets/
├── lib/
│   ├── auth/
│   │   └── login_signup.dart
│   ├── pages/
│   │   └── home.dart
│   ├── providers/
│   ├── services/
│   │   └── api.dart
│   ├── models/
│   ├── settings/
│   │   ├── colors.dart
│   │   └── images.dart
│   ├── widgets/
│   │   └── global/
│   └── main.dart
├── linux/
├── test/
├── web/
├── windows/
├── .gitignore
├── .metadata
├── analysis_options.yaml
├── pubspec.yaml
├── pubspec.lock
└── README.md
```
