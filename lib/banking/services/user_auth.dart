import 'package:bankingapp/banking/screen/BankingTransferDetails.dart';
import 'package:bankingapp/banking/services/classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

//   factory User.fromFirestore(
//     DocumentSnapshot<Map<String, dynamic>> snapshot,
//     SnapshotOptions? options,
//   ) {
//     final data = snapshot.data();
//     return User(
//       name: data?['Name'],
//       accNum: data?['Account No.'],
//       phone: data?['Phone'],
//       bank: data?['Bank'],
//     );
//   }
//   Map<String, dynamic> toFirestore() {
//     return {
//       if (name != null) "Name": name,
//       if (accNum != null) "Account No.": accNum,
//       if (phone != null) "Phone": phone,
//       if (bank != null) "Bank": bank,
//     };
//   }

Future<List> userAuth(username, password) async {
  late bool isLoggedin;
  late String name;
  late int accNum;
  late String phone;
  late String bank;
  late List accInfo;

  await FirebaseFirestore.instance
      .collection('users')
      .where('Username', isEqualTo: username)
      .where('Password', isEqualTo: password)
      .get()
      .then(
    (QuerySnapshot querySnapshot) async {
      if (querySnapshot.docs.isEmpty) {
        isLoggedin = false;
        accInfo = List.empty();
        return;
      } else {
        isLoggedin = true;
        print(querySnapshot.docs.first['Name']);
        name = await querySnapshot.docs.first['Name'];
        accNum = await querySnapshot.docs.first['Account Number'];
        phone = await querySnapshot.docs.first['Phone'];
        bank = await querySnapshot.docs.first['Bank'];

        accInfo = querySnapshot.docs.map((doc) => doc.data()).toList();
      }
    },
  );
  print(accInfo);
  return accInfo;
}
// }
