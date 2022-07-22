import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
//collection reference
  final CollectionReference mBankCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> get bankAcc {
    return mBankCollection.snapshots();
  }
}
