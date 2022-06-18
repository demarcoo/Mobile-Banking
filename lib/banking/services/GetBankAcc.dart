import 'dart:math';

import 'package:bankingapp/banking/screen/BankingTransferDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<dynamic> getBankAcc(input, bank) async {
  late var accName;
  late dynamic accNumber;
  late dynamic accDetails;

  await FirebaseFirestore.instance
      .collection('users')
      .where('Account Number', isEqualTo: int.parse(input))
      .where('Bank', isEqualTo: bank)
      .get()
      .then(
    (QuerySnapshot querySnapshot) async {
      if (querySnapshot.docs.isEmpty) {
        accName = '';
        return;
      } else {
        print(querySnapshot.docs.first['Name']);
        accName = await querySnapshot.docs.first['Name'];
        accNumber = await querySnapshot.docs.first['Account Number'].toString();
      }
    },
  );
  return accName;
}
