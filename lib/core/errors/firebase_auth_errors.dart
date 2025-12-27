import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthErrors {
  static String message(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This user account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      default:
        return e.message ?? 'Authentication failed';
    }
  }
}
