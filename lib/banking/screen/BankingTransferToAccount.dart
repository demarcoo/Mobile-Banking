import 'package:bankingapp/banking/screen/BankingTransferDetails.dart';
import 'package:bankingapp/banking/services/database.dart';
import 'package:bankingapp/banking/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/services/classes.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:bankingapp/banking/services/database.dart';
import 'package:bankingapp/banking/services/GetBankAcc.dart';
import 'package:bankingapp/banking/utils/BankingWidget.dart';

class ScreenArguments {
  final String recName;
  final int recAccNum;
  final String recBank;
  final double recBal;
  final String accName;
  final int accNumber;
  // final Map userAcc;

  ScreenArguments(this.recName, this.recAccNum, this.recBank, this.recBal,
      this.accName, this.accNumber);
}

class SearchBankAccount extends StatefulWidget {
  const SearchBankAccount({Key? key}) : super(key: key);

  @override
  State<SearchBankAccount> createState() => _SearchBankAccountState();
}

class _SearchBankAccountState extends State<SearchBankAccount> {
  TextEditingController recAccountController = TextEditingController();
  final db = FirebaseFirestore.instance;

  Future<void> _showEmptyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Input'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'Invalid account number, please input the correct account and try again'),
                // Text('Please try again with the correct account number.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showErrorDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Input'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Please input the recipient account number and try again'),
                // Text('Please try again with the correct account number.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final userAcc = ModalRoute.of(context)!.settings.arguments as Map;
    final bank = ModalRoute.of(context)!.settings.arguments as Banks;
    return Scaffold(
      backgroundColor: Banking_app_Background,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                10.height,
                Row(
                  children: [
                    Icon(
                      Icons.chevron_left,
                      size: 35,
                    ).onTap(() {
                      finish(context);
                    }),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Fund Transfer',
                        style: boldTextStyle(
                            color: Banking_TextColorPrimary, size: 28)),
                  ],
                ),
                8.height,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                          width: 360,
                          height: 100,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/banking/${bank.logo}'),
                                radius: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 240,
                                child: Text(
                                  bank.name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: fontWeightBoldGlobal),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      width: 350,
                      child: TextField(
                        controller: recAccountController,
                        style: TextStyle(fontSize: 18),
                        readOnly: false,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(12),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: 'Recipient Account No.',
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15.0),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Banking_Primary),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: ElevatedButton.icon(
                          onPressed: () async {
                            if (recAccountController.text != '' ||
                                recAccountController.text.length == 12) {
                              final recAccNum =
                                  await int.parse(recAccountController.text);
                              final accName =
                                  await UserSecureStorage.getName() ?? '';
                              final accNum =
                                  await UserSecureStorage.getAccNum() ?? '';
                              // print(accNum + 'aaaa');
                              if (recAccountController.text.length != 0) {
                                final recDetails = await getBankAcc(
                                    recAccountController.text, bank.name);
                                if (recDetails != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BankingTransferDetails(),
                                      settings: RouteSettings(
                                        arguments: ScreenArguments(
                                            recDetails['name'],
                                            recAccNum,
                                            bank.name,
                                            recDetails['bal'],
                                            accName,
                                            int.parse(accNum)),
                                      ),
                                    ),
                                  );
                                } else {
                                  _showEmptyDialog(context);
                                }
                              } else {
                                _showErrorDialog(context);
                              }
                            } else {
                              await ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Invalid input, please specify the correct recipient account number.'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Banking_Primary)),
                          icon: Icon(
                            Icons.next_plan,
                            color: Colors.black,
                          ),
                          label: Text(
                            'Continue',
                            style: TextStyle(color: Colors.black),
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
