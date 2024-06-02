<!--# tera chat 🦖

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
-->

# Tera Chat 🦖

Tera Chat is a new Flutter project designed to enable seamless and engaging chat experiences. This document provides a comprehensive overview of the project, including setup instructions, key features, and the structure of the application.

## Getting Started

This section will guide you through setting up the project on your local machine.

### Prerequisites

Before you begin, ensure you have met the following requirements:
- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK: Included with Flutter
- Firebase account: [Set up Firebase](https://firebase.google.com/)

### Installation

1. **Clone the repository:**
    ```bash
    git clone https://github.com/your-repo/tera-chat.git
    cd tera-chat
    ```

2. **Install dependencies:**
    ```bash
    flutter pub get
    ```

3. **Configure Firebase:**
   - Create a Firebase project.
   - Add an Android/iOS app to your Firebase project.
   - Follow the instructions to download the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) file and place it in the appropriate directory (`android/app` or `ios/Runner`).
   - Add Firebase configuration to your `pubspec.yaml`:
     ```yaml
     dependencies:
       firebase_core: latest_version
       firebase_auth: latest_version
       cloud_firestore: latest_version
     ```

4. **Run the app:**
    ```bash
    flutter run
    ```

## Features

- **User Authentication**: Sign up and log in using Firebase Authentication.
- **Real-time Messaging**: Exchange messages in real-time using Cloud Firestore.
- **User Profiles**: Manage user profiles with display names and email addresses.

## Project Structure

The project is structured as follows:
lib
├── data
│ ├── datasources
│ │ └── firebase_datasources.dart
│ ├── model
│ │ ├── channel_model.dart
│ │ ├── message_model.dart
│ │ └── user_model.dart
├── pages
│ ├── home_page.dart
│ ├── login_page.dart
│ ├── register_page.dart
│ └── widgets
│ ├── chat_bubble.dart
│ └── chat_footer.dart
├── main.dart

### Key Files and Directories

- **data/datasources/firebase_datasources.dart**: Handles data operations using Firebase.
- **data/model/channel_model.dart**: Defines the data model for a chat channel.
- **data/model/message_model.dart**: Defines the data model for a message.
- **data/model/user_model.dart**: Defines the data model for a user.
- **pages/home_page.dart**: The home page of the application.
- **pages/login_page.dart**: The login page for user authentication.
- **pages/register_page.dart**: The registration page for new users.
- **pages/widgets/chat_bubble.dart**: A widget for displaying individual chat messages.
- **pages/widgets/chat_footer.dart**: A widget for composing and sending messages.

## Additional Resources
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.