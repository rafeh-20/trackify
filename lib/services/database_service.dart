import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addHabit(String uid, Map<String, dynamic> habitData) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('habits')
        .add(habitData);
  }

  Stream<QuerySnapshot> getHabits(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('habits')
        .snapshots();
  }

  Future<void> updateHabit(
      String uid, String habitId, Map<String, dynamic> updatedData) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('habits')
        .doc(habitId)
        .update(updatedData);
  }

  Future<void> deleteHabit(String uid, String habitId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('habits')
        .doc(habitId)
        .delete();
  }
}
