import 'dart:async';
import 'dart:ffi';

import 'package:bankingapp/banking/screen/BankingTransferResult.dart';
import 'package:bankingapp/banking/screen/BankingTransferToAccount.dart';
import 'package:bankingapp/banking/services/classes.dart';
import 'package:bankingapp/banking/services/phone_auth.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/BankingDataGenerator.dart';
import 'package:bankingapp/banking/utils/secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bankingapp/banking/utils/BankingContants.dart';
import 'package:bankingapp/API/local_auth_api.dart';
import 'package:intl/intl.dart';
import 'package:bankingapp/banking/utils/BankingDataGenerator.dart';

class TransferArguments {
  final String recName;
  final int recAccNum;
  final String recBank;
  final double transferAmount;

  TransferArguments(
      this.recName, this.recAccNum, this.recBank, this.transferAmount);
}

class BankingTransferDetails extends StatefulWidget {
  const BankingTransferDetails({
    Key? key,
  }) : super(key: key);
  @override
  State<BankingTransferDetails> createState() => _BankingTransferDetailsState();
}

class _BankingTransferDetailsState extends State<BankingTransferDetails> {
  final userController = TextEditingController();
  final accnumController = TextEditingController();
  final amountController = TextEditingController();

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
                Text('Please specify the amount to be transferred'),
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
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final name = await UserSecureStorage.getName() ?? '';
    final accnum = await UserSecureStorage.getAccNum() ?? '';
    setState(() {
      this.userController.text = name;
      this.accnumController.text = accnum;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Banking_app_Background,
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('Account Number', isEqualTo: args.accNumber)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              final double userCurrentBal =
                  (snapshot.data?.docs.first['Balance']);
              print(userCurrentBal);
              return Container(
                height: context.height(),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.chevron_left,
                          size: 35,
                        ).onTap(() {
                          finish(context);
                        }),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Fund Transfer',
                            style: boldTextStyle(
                                color: Banking_TextColorPrimary, size: 28)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Expanded(
                            child: DecoratedBox(
                              decoration: boxDecorationWithRoundedCorners(
                                backgroundColor: Banking_Primary,
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Banking_Primary,
                                    Banking_palColor
                                  ],
                                ),
                              ),
                              position: DecorationPosition.background,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      // padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.wallet_rounded,
                                            size: 50,
                                          ),
                                          Container(
                                            height: 20,
                                            alignment: Alignment.center,
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              controller: accnumController,
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none),
                                              style: TextStyle(
                                                  fontWeight:
                                                      fontWeightBoldGlobal),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(top: 30),
                                            height: 20,
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              controller: userController,
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none),
                                              style: TextStyle(
                                                  fontWeight:
                                                      fontWeightBoldGlobal),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 40,
                                              ),
                                            ]),
                                      )),
                                  Expanded(
                                    flex: 4,
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.account_balance_wallet,
                                            size: 50,
                                          ),
                                          Container(
                                            height: 20,
                                            child: Text(
                                              args.recAccNum.toString(),
                                              style: TextStyle(
                                                  fontWeight:
                                                      fontWeightBoldGlobal,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 20,
                                            child: Text(
                                              args.recName,
                                              style: TextStyle(
                                                  fontWeight:
                                                      fontWeightBoldGlobal,
                                                  fontSize: 16),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              width: 250,
                              child: TextField(
                                cursorColor: Banking_Primary,
                                cursorHeight: 16,
                                controller: amountController,
                                style: TextStyle(fontSize: 17),
                                readOnly: false,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(8),
                                  // FilteringTextInputFormatter.digitsOnly,
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9.]+')),
                                ],
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 15, 15, 17),
                                    child: Text(
                                      'RM',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  hintText: 'Amount',
                                  alignLabelWithHint: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Banking_Primary)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Banking_Primary),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (amountController.text == '') {
                                return _showEmptyDialog(context);
                              }
                              final amountTransfer =
                                  double.parse(amountController.text);
                              final isAuthenticated =
                                  await biomAuthentication.authenticate();
                              if (isAuthenticated == true) {
                                if (userCurrentBal < amountTransfer) {
                                  //print error msg here
                                  print('not enough balance!');
                                } else {
                                  // update user balance

                                  final userNewBal =
                                      await userCurrentBal - amountTransfer;

                                  print(userNewBal);

                                  final userPost = await FirebaseFirestore
                                      .instance
                                      .collection('users')
                                      .where('Account Number',
                                          isEqualTo:
                                              int.parse(accnumController.text))
                                      .where('Name',
                                          isEqualTo: userController.text)
                                      .limit(1)
                                      .get()
                                      .then(
                                    (QuerySnapshot querySnapshot) async {
                                      return querySnapshot.docs[0].reference;
                                    },
                                  );
                                  var userBatch =
                                      FirebaseFirestore.instance.batch();
                                  userBatch.update(
                                      userPost, {'Balance': userNewBal});
                                  await userBatch.commit();

                                  //update recipient balance

                                  final recNewBal =
                                      await args.recBal + amountTransfer;

                                  final recPost = await FirebaseFirestore
                                      .instance
                                      .collection('users')
                                      .where('Account Number',
                                          isEqualTo: args.recAccNum)
                                      .where('Name', isEqualTo: args.recName)
                                      .limit(1)
                                      .get()
                                      .then(
                                    (QuerySnapshot querySnapshot) async {
                                      return querySnapshot.docs[0].reference;
                                    },
                                  );
                                  var recBatch =
                                      FirebaseFirestore.instance.batch();
                                  recBatch
                                      .update(recPost, {'Balance': recNewBal});
                                  await recBatch.commit();

                                  DateTime now = DateTime.now();
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd').format(now);
                                  print(formattedDate);

                                  //store transaction details

                                  final transaction = (transactionDetails(
                                      dateTime: formattedDate,
                                      senderAcc: args.accNumber,
                                      recipientAcc: args.recAccNum,
                                      amountTransferred: amountTransfer));

                                  await FirebaseFirestore.instance
                                      .collection('transactions')
                                      .add({
                                    'Amount': amountTransfer,
                                    'Recipient': args.recAccNum,
                                    'Sender': args.accNumber,
                                    'Date': formattedDate
                                  });

                                  // print(transactionLogs[1]);

                                  // print(transactionDet());

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TransferResult(),
                                      settings: RouteSettings(
                                          arguments: TransferArguments(
                                              args.recName,
                                              args.recAccNum,
                                              args.recBank,
                                              amountTransfer)),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: Icon(
                              Icons.next_plan,
                              color: Colors.black,
                            ),
                            label: Text(
                              'Transfer',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all(Banking_Primary)),
                          ),
                          Text('Or'),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (amountController.text == '') {
                                return _showEmptyDialog(context);
                              }
                              final phoneNum =
                                  await UserSecureStorage.getPhone() ?? '';

                              //push to phone auth screen
                              phoneAuthentication.phoneAuth(context, phoneNum);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Banking_Primary),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                            icon: Icon(
                              Icons.pin,
                              color: Colors.black,
                            ),
                            label: Text(
                              'Use OTP Instead',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
