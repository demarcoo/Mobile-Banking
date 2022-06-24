import 'dart:async';

import 'package:bankingapp/banking/screen/BankingTransferToAccount.dart';
import 'package:bankingapp/banking/services/classes.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
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
    // final bank = ModalRoute.of(context)!.settings.arguments as Banks;
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    // print(this.accnumController.text);
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
              final double currentBal = (snapshot.data?.docs.first['Balance']);
              print(currentBal);
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
                                            height: 30,
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
                                          Text(
                                            args.recAccNum.toString(),
                                            style: TextStyle(
                                                fontWeight:
                                                    fontWeightBoldGlobal,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            args.recName,
                                            style: TextStyle(
                                                fontWeight:
                                                    fontWeightBoldGlobal,
                                                fontSize: 15),
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
                              final isAuthenticated =
                                  await biomAuthentication.authenticate();
                              if (isAuthenticated == true) {
                                print(accnumController.text);
                                print(userController.text);

                                if (currentBal <
                                    double.parse(amountController.text)) {
                                  //print error msg here
                                  print('not enough balance!');
                                } else {
                                  final newBal = await currentBal -
                                      double.parse(amountController.text);
                                  print(newBal);

                                  final post = await FirebaseFirestore.instance
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
                                  var batch =
                                      FirebaseFirestore.instance.batch();
                                  batch.update(post, {'Balance': newBal});
                                  batch.commit();
                                  setState(() {});

                                  //   // print(docUser);
                                  //   //deduct money from database

                                  //   //push to transfer successful

                                }
                              }
                            },
                            icon: Icon(
                              Icons.next_plan,
                              color: Colors.black,
                            ),
                            label: Text(
                              'Transfer',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Banking_Primary)),
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
