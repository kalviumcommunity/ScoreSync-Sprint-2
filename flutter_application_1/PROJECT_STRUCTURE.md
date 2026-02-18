## ScoreSync – Flutter Project Structure Overview
## Introduction

The ScoreSync Flutter project follows a structured folder organization that separates core application logic from platform-specific configurations. This structure supports clean development, scalability, and efficient teamwork while building a cross-platform sports tournament management app.

## Key Folders & Their Purpose
🔹 lib/

## he main folder containing all Dart source code for ScoreSync.
Includes:

main.dart → Entry point of the application

screens/ → Match screens, scoreboard UI, player stats pages

widgets/ → Reusable UI components (score cards, buttons, etc.)

models/ → Data models (Player, Match, Tournament)

services/ → Business logic and API integration

🔹 android/

Contains Android-specific build configurations and Gradle files required to run ScoreSync on Android devices.

🔹 ios/

Contains iOS-specific configuration files used to build the app on Apple devices via Xcode.

🔹 assets/

Stores static resources like:

Team logos

Player images

Icons

Fonts

All assets are declared inside pubspec.yaml.

🔹 test/

Contains test files used to verify UI and app functionality.

🔹 pubspec.yaml

The central configuration file used to:

Manage dependencies

Register assets

Define app environment settings

🔹 Supporting Files

.gitignore → Prevents unnecessary files from being pushed to Git

build/ → Auto-generated compiled files (not manually edited)

README.md → Project documentation

## Example Folder Hierarchy
ScoreSync/
 ┣ lib/
 ┃ ┣ main.dart
 ┃ ┣ screens/
 ┃ ┣ widgets/
 ┃ ┣ models/
 ┃ ┗ services/
 ┣ android/
 ┣ ios/
 ┣ assets/
 ┣ test/
 ┣ pubspec.yaml
 ┣ README.md
 ┗ PROJECT_STRUCTURE.md

## Reflection

Understanding the project structure helps ensure that ScoreSync remains organized and scalable as new features like live scoring, match history, and analytics are added. A clean folder structure improves collaboration in a team environment and makes maintaining cross-platform builds for Android and iOS more efficient.