import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServer {
  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credetials = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);

    return FirebaseAuth.instance.signInWithCredential(credetials);
  }
}