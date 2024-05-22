import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waterxpto/models/User.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

void main() {
  group('AuthService', () {
    final MockFirebaseAuth mockAuth = MockFirebaseAuth();
    final MockFirebaseFirestore mockFirestore = MockFirebaseFirestore();
    final MockUserCredential mockUserCredential = MockUserCredential();
    final MockUser mockUser = MockUser();
    final AuthService authService = AuthService(auth: mockAuth, firestore: mockFirestore);

    test('isUserLoggedIn returns true when user is logged in', () async {
      when(mockAuth.currentUser).thenReturn(mockUser);
      expect(await authService.isUserLoggedIn(), true);
    });

    test('isUserLoggedIn returns false when user is not logged in', () async {
      when(mockAuth.currentUser).thenReturn(null);
      expect(await authService.isUserLoggedIn(), false);
    });
  });

}