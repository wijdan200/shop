import 'package:google_sign_in/google_sign_in.dart' as gsi;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttershop/core/config/app_config.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  // Auth state stream
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges();
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: password,
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final gsi.GoogleSignIn googleSignIn = gsi.GoogleSignIn(
      serverClientId: AppConfig.googleClientId,
    );
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw 'Google Sign-In canceled.';
    }

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null && idToken == null) {
      throw 'No Access Token or ID Token found.';
    }

    final credential = GoogleAuthProvider.credential(
      idToken: idToken,
      accessToken: accessToken,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await gsi.GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }
}
