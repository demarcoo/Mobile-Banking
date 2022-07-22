import 'dart:math';

import 'package:bankingapp/banking/screen/BankingTransferDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<dynamic> getBal(input, bank) async {
  late double accBal;

  await FirebaseFirestore.instance
      .collection('users')
      .where('Account Number', isEqualTo: int.parse(input))
      .where('Bank', isEqualTo: bank)
      .get()
      .then(
    (QuerySnapshot querySnapshot) async {
      if (querySnapshot.docs.isEmpty) {
        return;
      } else {
        print(querySnapshot.docs.first['Name']);
        accBal = await querySnapshot.docs.first['Balance'];
      }
    },
  );
  return accBal;
}
