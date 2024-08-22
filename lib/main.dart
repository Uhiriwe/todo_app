import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/login_screen.dart';
import 'package:todo_app/signup_screen.dart';
import 'package:todo_app/home_screen.dart';
import 'package:todo_app/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    if (kDebugMode) {
      print("Firebase initialized successfully");
    }
    runApp(MyApp());
  } catch (e) {
    if (kDebugMode) {
      print("Failed to initialize Firebase: $e");
    }
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Failed to initialize app: $e'),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyApp({Key? key}) : super(key: key);

  Future<bool> _isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('first_time') ?? true;
    if (isFirstTime) {
      await prefs.setBool('first_time', false);
    }
    return isFirstTime;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Todo",
      theme: ThemeData(primarySwatch: Colors.indigo, primaryColor: Colors.indigo),
      home: FutureBuilder<bool>(
        future: _isFirstTime(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            bool isFirstTime = snapshot.data ?? true;
            if (isFirstTime) {
              return const OnboardingScreen();
            } else {
              return StreamBuilder<User?>(
                stream: _auth.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    User? user = snapshot.data;
                    if (kDebugMode) {
                      print("Auth state changed. User: ${user?.uid}");
                    }
                    if (user != null) {
                      return const HomeScreen();
                    } else {
                      return const LoginScreen();
                    }
                  }
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              );
            }
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}