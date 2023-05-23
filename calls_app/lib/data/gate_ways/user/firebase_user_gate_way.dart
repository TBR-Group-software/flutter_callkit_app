import '../../models/user.dart';
import '../firebase/firebase_initializer_gate_way.dart';
import 'user_gate_way.dart';

class FirebaseUserGateWay implements UserGateWay {
  final _firebaseInitializer = FirebaseInitializerGateWay.instance;

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

      await userRef.set(<String, dynamic>{'phoneNumber': user.phoneNumber});
    });
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
}
