<p align="center">
  <row>
    <img src="https://badgen.net/badge/types/flutter/blue?icon=flutter" alt="flutter app"/>
    <img src="https://badgen.net/badge/platform/android,ios?list=|" alt="flutter app"/>
  </row>
</p>

<div align="center">
  <h3>Paintball Zone Flutter App</h3>
  <p>Paintball Zone Flutter APP is a mobile application in development using Flutter.
</div>

<br />

# Paintball Zone

Paintball flutter app.

## Overview
1. **[Description 📝](#description-)**
2. **[Screenshots 📝](#screenshots-)**
3. **[Technologies 📝](#technologies-)**
4. **[Requirements 📝](#requirements-)**
5. **[Developing 👷](#developing-)**
6. **[Releasing 🏷️](#releasing-)**

## Description 📚
This project aims to assist in managing games at a paintball field. The platform features two types of user profiles:

- Client: This profile allows users to access their virtual loyalty card. As the card is filled through played games, the client unlocks benefits defined by the administrator.
- Administrator: The administrator profile has the ability to view all non-administrator users. Additionally, they can add points to clients' loyalty cards. Beyond these functions, the administrator is responsible for registering detailed information about each match. This provides complete control over costs and the ability to determine individual charges for each client.

In this way, the platform aims to simplify and optimize the organization of paintball games, making the experience more advantageous for both clients and the administration.

## Screenshots  📚
<div align="center">
    <img src="/screenshots/login.png" width="400px"/>  
</div>

![Alt text](/screenshots/login.png?raw=true "Login Screen")
![Alt text](/screenshots/home_admin.png?raw=true "Admin Home Screen")
![Alt text](/screenshots/home_client.png?raw=true "Client Home Screen")
![Alt text](/screenshots/new_game1.png?raw=true "New Game 1 Screen")
![Alt text](/screenshots/new_game2.png?raw=true "New Game 2 Screen")
![Alt text](/screenshots/register_charge.png?raw=true "Register Charge Screen")
![Alt text](/screenshots/view_client.png?raw=true "View Client Screen")

## Main technologies used  📚
- Firebase
- Bloc
- Hydrated Bloc
- Push Notifications
- Clean Architecture

## Requirements 📝
#### To execute this project it is necessary to have the following dependencies installed and configured on your machine:

**Required**
- [Flutter](https://flutter.dev/)
- [Android SDK](https://developer.android.com/studio)
- [IOS SDK](https://developer.apple.com/xcode/)

**Versions**
- [Flutter](https://flutter.dev/) `3.0.5`
- [Dart](https://dart.dev/) `2.17.6`

## Developing 👷
#### Use a local development environment:

1. [Clone this repo](https://docs.gitlab.com/ee/gitlab-basics/start-using-git.html) with git.
2. Install dependencies by running `flutter packages get` or `flutter pub get` within the directory that you cloned (probably `app`).
2. Run Flutter_Bloc or genetate new routes with `flutter packages pub run build_runner build` or to avoid conflicts and observe changes `flutter pub run build_runner build --delete-conflicting-outputs` or `flutter packages pub run build_runner watch --delete-conflicting-outputs` (Recommended).
3. Open any mobile device emulator of your choice.
4. Execute your app with `flutter run` or F5 (debug mode).

## Releasing 🏷️

1. [Clone this repo](https://docs.gitlab.com/ee/gitlab-basics/start-using-git.html) with git.
2. Install dependencies by running `flutter packages get` or `flutter pub get` within the directory that you cloned (probably `app`).
3. Build the release files with `flutter build apk`.
4. Find the your release in `build/app/outputs/apk/release` or `build/app/outputs/flutter-apk/release`.

## Architecture 📚

This Project uses the `DDD (Domain Driven Design)` pattern and the [Clean Architecture](https://www.google.com/search?q=clean+architecture) pattern with `Flutter_Bloc` as the State Management solution, `Freezed` for Union classes, `GetIt` for dependency Injection, `Dartz` for functional programming with Dart, `AutoRoute` for routing and `Hive` for persisent storage.
