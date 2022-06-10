import 'package:bankingapp/banking/screen/BankingChooseBanks.dart';
import 'package:bankingapp/banking/screen/BankingSplash.dart';
import 'package:bankingapp/banking/screen/BankingTransfer.dart';
import 'package:bankingapp/banking/screen/BankingTransferDetails.dart';
import 'package:bankingapp/banking/screen/BankingTransferToAccount.dart';
import 'package:bankingapp/banking/services/bank_list.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capital Bank',
      scrollBehavior: SBehavior(),
      home: BankingSplash(),
      // home: BankingSplash(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/choosebank': (context) => ChooseBank(),
        '/transfer': (context) => BankingTransfer(),
        '/transferdetails': (context) => BankingTransferDetails()
        // '/location': (context) => ChooseLocation(),
      },
    );
  }
}
