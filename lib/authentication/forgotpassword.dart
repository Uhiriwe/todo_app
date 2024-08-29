import 'package:flutter/material.dart';
import 'package:todo_app/services/auth_services.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({Key? key}) : super(key: key);

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final AuthServices _auth = AuthServices();
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1d2630),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text("Forgot Password",style: TextStyle(color: Colors.white),),
        backgroundColor:Color(0xff1d2630),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter email to send a password reset email",
              style: TextStyle(fontSize: 16,color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _email,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white60),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white60),
                ),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.white60),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Adjust this value to change the radius
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Optional: for better button size
                ),
                child: Text(
                  "Send email",
                  style: TextStyle(fontSize: 16, color: Color(0xff1d2630),), // Optional: for better text style
                ),
                onPressed: () async {
                  try {
                    await _auth.sendPasswordResetLink(_email.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("An email for password reset has been sent to your email"),
                      ),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error sending reset email: ${e.toString()}"),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}