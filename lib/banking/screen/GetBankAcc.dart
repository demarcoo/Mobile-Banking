import 'package:bankingapp/banking/screen/BankingTransferDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void getBankAcc(input) {
  var accName;

  FirebaseFirestore.instance
      .collection('users')
      .where('Account Number', isEqualTo: int.parse(input))
      .get()
      .then(
    (QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length == 0) {
        print('no data');
      } else {
        accName = querySnapshot.docs.first['Name'];
        print(accName);
      }
    },
  );
}
