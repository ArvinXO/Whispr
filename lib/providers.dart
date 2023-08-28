// providers.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firestore_service.dart';

// Provider for FirebaseAuth instance
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// StreamProvider for auth state changes
final authStateChangesProvider = StreamProvider<User?>((ref) {
  // Watch the firebaseAuthProvider to access FirebaseAuth instance
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

// Provider for FirestoreService instance
final databaseProvider = Provider<FirestoreService?>((ref) {
  // Watch the authStateChangesProvider to access auth state changes
  final auth = ref.watch(authStateChangesProvider);
  String? uid = auth.asData?.value?.uid;

  // Create and return a FirestoreService instance if a UID is available
  if (uid != null) {
    return FirestoreService(uid: uid);
  }
  return null;
});

// ChangeNotifierProvider for NameText class
final nameProvider = ChangeNotifierProvider<NameText>((ref) => NameText());

// ChangeNotifier class to manage a user's name
class NameText extends ChangeNotifier {
  String name = ""; // Initialize an empty name

  // Method to set the user's name and notify listeners
  setName(String n) {
    name = n;
    notifyListeners();
  }
}
