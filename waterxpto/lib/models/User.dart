import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class WaterUser {
  String? userID;

  String name;
  String email;
  String password;
  String nationality;
  //String region;

  WaterUser({
    required this.userID,
    required this.name,
    required this.email,
    required this.password,
    required this.nationality,
    //required this.region,
  });
}



class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isUserLoggedIn() async {
    var user = _auth.currentUser;
    return user != null;
  }

  // Register user with email and password
  Future registerUser(String email, String password, String name, String nationality) async {
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
        'nationality': nationality,
        //'region': region,
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
        ? WaterUser(userID: currentUser.uid, email: currentUser.email!, password: "", name: "",  nationality: "", )
        : null;
  }
}
