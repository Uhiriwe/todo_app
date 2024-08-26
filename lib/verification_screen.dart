import 'package:flutter/material.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController _codeController = TextEditingController();
  bool _isResendEnabled = false;
  int _remainingTime = 30; // Countdown timer in seconds

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
        startTimer();
      } else {
        setState(() {
          _isResendEnabled = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter the verification code sent to your email/phone:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Verification Code',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {

                print('Verification code submitted: ${_codeController.text}');
              },
              child: Text('Verify'),
            ),
            SizedBox(height: 20.0),
            Text(
              _isResendEnabled
                  ? 'Didn\'t receive the code?'
                  : 'Resend code in $_remainingTime seconds',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            if (_isResendEnabled)
              TextButton(
                onPressed: () {
                  setState(() {
                    _remainingTime = 30;
                    _isResendEnabled = false;
                  });
                  startTimer();
                  // Handle resend code logic here
                  print('Resend code');
                },
                child: Text('Resend Code'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
