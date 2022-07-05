import 'dart:math';

import 'package:bankingapp/banking/screen/BankingTransferDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<dynamic> getBankAcc(input, bank) async {
  var x;

  await FirebaseFirestore.instance
      .collection('users')
      .where('Account Number', isEqualTo: int.parse(input))
      .where('Bank', isEqualTo: bank)
      .get()
      .then(
    (QuerySnapshot querySnapshot) async {
      if (querySnapshot.docs.isEmpty) {
        // accName = '';
        // accBal = 0;
      } else {
        // print(querySnapshot.docs.first['Name']);
        String accName = await querySnapshot.docs.first['Name'];
        String accNumber =
            await querySnapshot.docs.first['Account Number'].toString();
        double accBal = await querySnapshot.docs.first['Balance'];
        x = {'name': accName, 'bal': accBal};
      }
    },
  );
  return x;
  // Map<String, dynamic> toMap() {

  // return toMap();
}
