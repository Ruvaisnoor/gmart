import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Login using email and password.
  Future<UserCredential?> login(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print("Login Error: ${e.message}");
      return null;
    }
  }

  /// Sign up using email and password.
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print("Sign Up Error: ${e.message}");
      return null;
    }
  }

  /// Sign out.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Sign in with Google.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the Google sign-in flow.
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled the sign-in.
        return null;
      }
      // Obtain the authentication details.
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // Create a credential using the obtained tokens.
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Sign in to Firebase with the Google credential.
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  /// Static Facebook Sign-In Method.
  static Future<UserCredential?> signInWithFacebook() async {
    try {
      // Trigger the Facebook sign-in flow.
      final LoginResult result = await FacebookAuth.instance.login();

      switch (result.status) {
        case LoginStatus.success:
          // If login succeeded, retrieve the access token.
          final AccessToken? fbAccessToken = result.accessToken;
          // Use only the proper 'token' property.
          final String? tokenValue = fbAccessToken?.tokenString;
          if (tokenValue == null || tokenValue.isEmpty) {
            print("No valid Facebook access token received.");
            return null;
          }
          // Create a credential using the token.
          final OAuthCredential credential =
              FacebookAuthProvider.credential(tokenValue);
          // Sign in to Firebase with the Facebook credential.
          return await FirebaseAuth.instance.signInWithCredential(credential);

        case LoginStatus.cancelled:
          print("Facebook Sign-In cancelled by user.");
          return null;

        case LoginStatus.failed:
          print("Facebook Sign-In failed: ${result.message ?? 'Unknown error'}");
          return null;

        default:
          print("Unexpected Facebook login status: ${result.status}");
          return null;
      }
    } catch (e) {
      print("Facebook Sign-In Error: $e");
      return null;
    }
  }

  /// Reset password by sending a password reset email.
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent");
    } on FirebaseAuthException catch (e) {
      print("Reset Password Error: ${e.message}");
    }
  }
}
