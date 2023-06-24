import 'package:firebase_auth/firebase_auth.dart';

class EmailLinkAuthentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendSignInLink(String email) async {
    final actionCodeSettings = ActionCodeSettings(
      url: 'YOUR_DYNAMIC_LINK_URL',
      handleCodeInApp: true,
      androidPackageName: 'com.example.app',
      iOSBundleId: 'com.example.app',
      androidInstallApp: true,
      androidMinimumVersion: '12',
    );

    await _auth.sendSignInLinkToEmail(
        email: email, actionCodeSettings: actionCodeSettings);
  }

  Future<UserCredential?> completeSignIn(String email, String emailLink) async {
    if (_auth.isSignInWithEmailLink(emailLink)) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailLink(
          email: email,
          emailLink: emailLink,
        );

        if (userCredential.user != null) {
          return userCredential;
        }
      } catch (e) {
        print('Error completing sign-in with email link: $e');
      }
    }

    return null;
  }

  void signOut() async {
    await _auth.signOut();
  }
}
