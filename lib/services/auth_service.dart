import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Get current user
  static User? get currentUser => _auth.currentUser;
  
  // Check if user is logged in
  static bool get isLoggedIn => _auth.currentUser != null;
  
  // Sign up with email and password
  static Future<UserCredential?> signUpWithEmailAndPassword(
    String email, 
    String password
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveUserSession();
      return result;
    } catch (e) {
      print('Sign up error: $e');
      return null;
    }
  }
  
  // Sign in with email and password
  static Future<UserCredential?> signInWithEmailAndPassword(
    String email, 
    String password
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveUserSession();
      return result;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }
  
  // Sign out
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _clearUserSession();
    } catch (e) {
      print('Sign out error: $e');
    }
  }
  
  // Save user session
  static Future<void> _saveUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    if (currentUser != null) {
      await prefs.setString('userId', currentUser!.uid);
      await prefs.setString('userEmail', currentUser!.email ?? '');
    }
  }
  
  // Clear user session
  static Future<void> _clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userId');
    await prefs.remove('userEmail');
  }
  
  // Check saved session
  static Future<bool> checkSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}

