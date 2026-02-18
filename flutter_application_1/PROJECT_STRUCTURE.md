📝 Introduction

When a Flutter project is created, it generates a structured set of folders and files. This structure helps organize code, manage assets, and support cross-platform development for Android and iOS. Understanding it ensures clean, scalable, and maintainable applications.

📂 Key Folders & Files
🔹 lib/

Main folder containing all Dart code.
Includes main.dart (entry point), screens, widgets, models, and services.

🔹 android/

Android-specific build configuration and settings.

🔹 ios/

iOS-specific configuration used with Xcode.

🔹 assets/

Stores images, fonts, and static files. Must be declared in pubspec.yaml.

🔹 test/

Contains unit and widget test files.

🔹 pubspec.yaml

Manages dependencies, assets, fonts, and environment settings.

🔹 Other Supporting Files

.gitignore → Files ignored by Git

build/ → Auto-generated build files

README.md → Project documentation

🗂 Folder Hierarchy Example
my_flutter_app/
 ┣ lib/
 ┣ android/
 ┣ ios/
 ┣ test/
 ┣ assets/
 ┣ pubspec.yaml
 ┗ README.md

