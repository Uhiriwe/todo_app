import 'package:flutter/material.dart';
import 'package:todo_app/authentication/signup_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background2.Webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0), // Optional: Add padding to the bottom
                child: SizedBox(
                  height: 50,
                  width: double.infinity, // Make the button full-width
                  child: ElevatedButton(
                    child: Text(
                      'Get Started',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => SignupScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff1d2630), // Set the background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Set the border radius
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
