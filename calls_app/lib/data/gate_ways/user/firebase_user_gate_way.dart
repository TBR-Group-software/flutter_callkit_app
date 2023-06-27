import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../models/user.dart';
import '../firebase/firebase_initializer_gate_way.dart';
import 'user_gate_way.dart';

@LazySingleton(as: UserGateWay)
class FirebaseUserGateWay implements UserGateWay {
  FirebaseUserGateWay(this._firebaseInitializer);

  final FirebaseInitializerGateWay _firebaseInitializer;

  static const _userCollection = 'users';

  @override
  Future<User?> getCurrentUser() async {
    final firebaseAuth = await _firebaseInitializer.firebaseAuth;
    final currentUser = firebaseAuth.currentUser;

    if (currentUser == null) return null;

    return User(id: currentUser.uid, phoneNumber: currentUser.phoneNumber);
  }

  @override
  Future<void> addUser(User user) async {
    final firestore = await _firebaseInitializer.firestore;

    final userRef = firestore.collection(_userCollection).doc(user.id);
    await firestore.runTransaction<void>((transaction) async {
      final userDoc = await userRef.get();
      if (userDoc.exists) return;

      await userRef.set(<String, dynamic>{
        'phoneNumber': user.phoneNumber,
        'platform': Platform.operatingSystem,
      });
    });
  }

  @override
  Future<void> addUserName(String id, String name) async {
    final firestore = await _firebaseInitializer.firestore;

    final userRef = firestore.collection(_userCollection).doc(id);
    await userRef.set(
      <String, dynamic>{'name': name},
      SetOptions(merge: true),
    );
  }

  @override
  Future<User?> findUserByPhoneNumber(String phoneNumber) async {
    final firestore = await _firebaseInitializer.firestore;

    final userDocs = await firestore
        .collection(_userCollection)
        .where('phoneNumber', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    if (userDocs.docs.isEmpty) return null;

    final userDoc = userDocs.docs.first;
    return User.fromJson(userDoc.id, userDoc.data());
  }

  @override
  Future<User?> findUserById(String id) async {
    final firestore = await _firebaseInitializer.firestore;

    final userDoc = await firestore.collection(_userCollection).doc(id).get();

    final userData = userDoc.data();
    if (userData == null) return null;

    return User.fromJson(userDoc.id, userData);
  }
}
