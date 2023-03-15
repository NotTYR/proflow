import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<bool> attemptLogin() async {
  try {
    final GoogleUser = await GoogleSignIn().signIn();
    final GoogleAuth = await GoogleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: GoogleAuth.accessToken,
      idToken: GoogleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    return true;
    } catch (e) {
    return false;
  }
}

