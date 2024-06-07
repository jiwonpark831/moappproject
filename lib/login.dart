import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'MainScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () async {
            UserCredential userCredential = await signInWithGoogle();
            if (userCredential != null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MainScreenPage()),
              );
            }
            FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).get().then((doc){
              if(doc.exists){
              FirebaseFirestore.instance
                  .collection('user')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .set(<String, dynamic>{
                    'name':'아무개',
                    'gender': '남/여',
                    'major':'전공',
                    'birth':'1995.01.01',
                    'status':'한 줄 소개',
                    'uid': FirebaseAuth.instance.currentUser!.uid,
                    'imageURL': 'https://firebasestorage.googleapis.com/v0/b/final-project-4d542.appspot.com/o/default.jpg?alt=media&token=06ed8ea3-58a5-4787-b3a0-f44826650e29',
                    'tagCheck': [false,false,false,false],
                    'isGonggang':false,
                    // 'schedule':
                    // 'friendsList':
                });
              
              }
            }
            );
          },
          icon: Image.asset(
            'assets/googlesingin.png',
            height: 80,
          ),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
