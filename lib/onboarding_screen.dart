import 'package:flutter/material.dart';
import 'package:todo_app/signup_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.Webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Todo App!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 50),

              ElevatedButton(
                child: Text('Get Started'),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => SignupScreen()),
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