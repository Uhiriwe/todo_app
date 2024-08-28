import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/login_screen.dart';

class VerificationScreen extends StatefulWidget {
  final User user;
  const VerificationScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool _isEmailVerified = false;
  Timer? _timer;
  bool _canResendEmail = false;

  @override
  void initState() {
    super.initState();
    _isEmailVerified = widget.user.emailVerified;
    if (!_isEmailVerified) {
      sendVerificationEmail();
      _timer = Timer.periodic(
        const Duration(seconds: 3),
            (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    await widget.user.reload();
    setState(() {
      _isEmailVerified = widget.user.emailVerified;
    });
    if (_isEmailVerified) {
      _timer?.cancel();
      // Sign out the user before redirecting to login screen
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email verified. Please log in.')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await widget.user.sendEmailVerification();
      setState(() => _canResendEmail = false);
      await Future.delayed(const Duration(seconds: 60));
      setState(() => _canResendEmail = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending email: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1d2630),
      appBar: AppBar(
        backgroundColor: Color(0xff1d2630),
        foregroundColor: Colors.white,
        title: const Text('Verify Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'A verification email has been sent to your email.',
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              'Please check your email and click on the verification link to verify your account.',
              style: TextStyle(fontSize: 16, color: Colors.white60),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.white,
                foregroundColor: Color(0xff1d2630),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.email, size: 32),
              label: Text(
                _canResendEmail ? 'Resend Email' : 'Email Sent',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: _canResendEmail ? sendVerificationEmail : null,
            ),
            const SizedBox(height: 16),
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}