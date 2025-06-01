import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healthy_bite_project/services/firestore_service.dart';

class SignInGoogleProvider extends ChangeNotifier {
  final fire = FireStoreService();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  User? user;
  bool isSignedIn = false;

  SignInGoogleProvider() {
    _auth.authStateChanges().listen((user) {
      this.user = user;
      isSignedIn = user != null;
      notifyListeners();
    });
  }

  Future<void> signIn(
      String gender, String height, String weight, DateTime birthday) async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credentials = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credentials);

      user = userCredential.user;

      if (user != null) {
        await fire.uploadUserData(user!.uid, gender, height, weight, birthday);
        print('User id ----------> ${user!.uid}');
        notifyListeners();
      }
    } catch (e) {
      print('Sign in error --------->${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      print('Sign out error ------>${e.toString()}');
    }
  }
}
