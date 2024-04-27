import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class WaterUser {
  String name;
  DateTime birthDate;
  String email;
  String password;
  String nationality;
  String region;

  WaterUser({
    required this.name,
    required this.birthDate,
    required this.email,
    required this.password,
    required this.nationality,
    required this.region,
  });
}



class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Register user with email and password
  Future registerUser(String email, String password, String name, DateTime birthDate, String nationality, String region) async {
    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user id
      String userId = userCredential.user!.uid;

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'birthDate': birthDate,
        'nationality': nationality,
        'region': region,
      });

      return "Registration successful";
    } catch (e) {
      return e.toString();
    }
  }

  // Sign in user with email and password
  Future signInUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Sign in successful";
    } catch (e) {
      return e.toString();
    }
  }

  // Sign out user
  Future signOut() async {
    await _auth.signOut();
  }

  // Get current user
  WaterUser? getCurrentUser() {
    User? currentUser = _auth.currentUser;
    return currentUser != null
        ? WaterUser(email: currentUser.email!, password: "", name: "", birthDate: DateTime.now(), nationality: "", region: "")
        : null;
  }
}
