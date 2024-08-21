import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/login_screen.dart';
import 'package:todo_app/signup_screen.dart';
import 'package:todo_app/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase is initialized
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Todo",
      theme: ThemeData(primarySwatch: Colors.indigo, primaryColor: Colors.indigo),
      home: _auth.currentUser != null ? HomeScreen() : LoginScreen(),
    );
  }
}
