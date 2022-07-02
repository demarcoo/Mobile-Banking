import 'package:bankingapp/banking/screen/BankingChooseBanks.dart';
import 'package:bankingapp/banking/screen/BankingTransactionHistory.dart';
import 'package:bankingapp/banking/utils/BankingImages.dart';
import 'package:bankingapp/banking/utils/BankingWidget.dart';
import 'package:bankingapp/banking/utils/secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bankingapp/banking/model/BankingModel.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/BankingContants.dart';
import 'package:bankingapp/banking/utils/BankingDataGenerator.dart';
import 'package:bankingapp/banking/utils/BankingStrings.dart';

class BankingTransfer extends StatefulWidget {
  const BankingTransfer({Key? key}) : super(key: key);
  static var tag = "/transfer";

  @override
  _BankingTransferState createState() => _BankingTransferState();
}

class _BankingTransferState extends State<BankingTransfer> {
  double currentBal = 0;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final name = await UserSecureStorage.getName() ?? '';
    final accnum = await UserSecureStorage.getAccNum() ?? '';
    setState(() {
      TopCard(
        name: name,
        acctype: 'Savings Account',
        acno: accnum,
        bal: currentBal.toString(),
      );
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('Account Number', isEqualTo: args['accnum'])
            .where('Name', isEqualTo: args['name'])
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          currentBal = snapshot.data?.docs.first['Balance'];
          // print(currentBal);
          return SafeArea(
            child: Scaffold(
              backgroundColor: Banking_app_Background,
              body: Container(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      10.height,
                      Text('Fund Transfer',
                          style: boldTextStyle(
                              color: Banking_TextColorPrimary, size: 35)),
                      8.height,
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 8),
                        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                        height: 240,
                        decoration: boxDecorationWithRoundedCorners(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: defaultBoxShadow()),
                        child: Container(
                          height: 130,
                          child: TopCard(
                            name: args['name'],
                            acctype: 'Savings Account',
                            acno: args['accnumber'].toString(),
                            bal: 'RM' + currentBal.toString(),
                          ).onTap(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionHistory(),
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: 100),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                width: 120,
                                child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChooseBank(),
                                          settings: RouteSettings(
                                              name: '/choosebank',
                                              arguments: currentBal),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.money,
                                      color: Colors.black,
                                    ),
                                    label: Text(
                                      'Choose Bank',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Banking_Primary),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        )))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      20.height,
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
