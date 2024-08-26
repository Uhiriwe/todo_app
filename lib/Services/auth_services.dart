import 'package:firebase_auth/firebase_auth.dart';
class AuthServices{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Sign in

  Future<User?> _signInWithPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
          User? user = result.user;
          return user;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign up
  Future<User?> _registerWithPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }
  //forgot password
  Future<void> sendPasswordResetLink (String email) async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
    }
    catch(e){
      print(e.toString());
    }
  }
  Future<void> sendEmailVerificationLink () async{
    try{
      await _auth.currentUser?.sendEmailVerification();
    }
    catch(e){
      print(e.toString());
    }
  }

}