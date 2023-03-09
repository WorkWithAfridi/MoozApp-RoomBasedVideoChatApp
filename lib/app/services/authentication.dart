import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mooz/app/model/user.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<UserModel?> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      User? user = userCredential.user;
      if (user != null) {
        UserModel? userModel = UserModel(
          uid: user.uid,
          photoUrl: user.photoURL ?? "",
          userName: user.displayName ?? "MoozUser-${user.uid}",
        );
        if (userCredential.additionalUserInfo!.isNewUser) {
          await _firebaseFirestore.collection('users').doc(user.uid).set(
                userModel.toMap(),
              );
        }
        return userModel;
      }
    } on FirebaseAuthException catch (err) {
      log(err.toString());
    }
    return null;
  }

  Future<UserModel?> isUserSignedIn() async {
    if (_auth.currentUser != null) {
      DocumentSnapshot userSnapshot = await _firebaseFirestore.collection('users').doc(_auth.currentUser!.uid).get();
      UserModel? userModel = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
      return userModel;
    }
    return null;
  }
}
