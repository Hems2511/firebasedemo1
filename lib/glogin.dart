import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo1/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GLogin extends StatefulWidget {
  const GLogin({Key? key}) : super(key: key);

  @override
  State<GLogin> createState() => _GLoginState();
}

class _GLoginState extends State<GLogin> {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("User Login"),),
    body:  ElevatedButton(onPressed: () {
      signInWithGoogle().then((value) {
        print(value.user!.displayName);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
      });
    },child: Text("Google Login"),),
    );
  }
}
