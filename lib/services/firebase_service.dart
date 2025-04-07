import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unstudio_ai/models/user_model.dart';
import 'package:unstudio_ai/utils/app_preferences.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<UserCredential> signUp(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> uploadProfilePic(String uid, File file) async {
    final ref = _storage.ref().child("profilePic/$uid");
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> saveUserToFirestore(UserModel user) async {
    await _firestore.collection("users").doc(user.uid).set(user.toMap());
  }

  Future<bool> checkUserExists(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    return doc.exists;
  }

  Future<UserModel> getUserData(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    return UserModel.fromMap(doc.data()!);
  }

  Future<void> saveUserToLocal(UserModel user) async {
    await AppPreference.saveJsonToPrefs("user_model", jsonEncode(user.toMap()));
  }

  Future<UserModel?> getUserFromLocal() async {
    final data = await AppPreference.getStringFromSF("user_model");
    if (data != null && data.isNotEmpty) {
      return UserModel.fromMap(jsonDecode(data));
    }
    return null;
  }
}
