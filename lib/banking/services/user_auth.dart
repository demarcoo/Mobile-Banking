import 'package:bankingapp/banking/screen/BankingTransferDetails.dart';
import 'package:bankingapp/banking/services/classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tuple/tuple.dart';

Future<dynamic> userAuth(username, password) async {
  late bool isLoggedin;
  late String? name;
  late int? accNum;
  late String? phone;
  late String? bank;
  late double? balance;
  late Map myMap;

  await FirebaseFirestore.instance
      .collection('users')
      .where('Username', isEqualTo: username)
      .where('Password', isEqualTo: password)
      .get()
      .then(
    (QuerySnapshot querySnapshot) async {
      if (querySnapshot.docs.isEmpty) {
        isLoggedin = false;
        myMap = <String, dynamic>{};
      } else {
        isLoggedin = true;
        //print(querySnapshot.docs.first['Name']);
        name = await querySnapshot.docs.first['Name'];
        accNum = await querySnapshot.docs.first['Account Number'];
        phone = await querySnapshot.docs.first['Phone'];
        bank = await querySnapshot.docs.first['Bank'];
        balance = await querySnapshot.docs.first['Balance'];
        myMap = <String, dynamic>{
          'name': name,
          'accnumber': accNum,
          'phone': phone,
          'bank': bank,
          'bal': balance
        };
      }
    },
  );
  return myMap;
}
