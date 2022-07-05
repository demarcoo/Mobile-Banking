import 'package:bankingapp/banking/model/BankingModel.dart';
import 'package:bankingapp/banking/screen/BankingTransactionHistory.dart';

import 'package:bankingapp/banking/services/classes.dart';
import 'package:bankingapp/banking/services/getBal.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/BankingContants.dart';
import 'package:bankingapp/banking/utils/BankingDataGenerator.dart';
import 'package:bankingapp/banking/utils/BankingImages.dart';
import 'package:bankingapp/banking/utils/BankingWidget.dart';
import 'package:bankingapp/banking/utils/secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bankingapp/banking/screen/BankingHome1.dart';
import 'package:bankingapp/banking/services/classes.dart';

class BankingHome1 extends StatefulWidget {
  static String tag = '/BankingHome1';

  @override
  BankingHome1State createState() => BankingHome1State();
}

class BankingHome1State extends State<BankingHome1> {
  int currentIndexPage = 0;
  int? pageLength;
  double currentBal = 0;

  late List isLoggedin;
  late List<BankingHomeModel> mList1;
  late List<BankingHomeModel2> mList2;
  late List<transactionDetails> transactions;

  @override
  void initState() {
    super.initState();

    init();
    currentIndexPage = 0;
    pageLength = 3;
    mList1 = bankingHomeList1();
    mList2 = bankingHomeList2();
    transactions = transactionLogs();
  }

  Future init() async {
    final name = await UserSecureStorage.getName() ?? '';
    final accnum = await UserSecureStorage.getAccNum() ?? '';
    final accBank = await UserSecureStorage.getBank() ?? '';

    setState(() {
      TopCard(
        name: name,
        acctype: 'Savings Account',
        acno: accnum,
        bal: currentBal.toString(),
      );
    });

    // currentBal = await FirebaseFirestore.instance.collection('users').where('Account Number', isEqualTo:  )
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 330,
              floating: false,
              pinned: true,
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              backgroundColor:
                  innerBoxIsScrolled ? Banking_Primary : Banking_app_Background,
              actionsIconTheme: IconThemeData(opacity: 0.0),
              title: Container(
                padding: EdgeInsets.fromLTRB(16, 42, 16, 32),
                margin: EdgeInsets.only(bottom: 8, top: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundImage: AssetImage(Banking_ic_user1),
                        radius: 24),
                    10.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Hello,",
                            style: primaryTextStyle(
                                color: Banking_TextColorWhite,
                                size: 16,
                                fontFamily: fontRegular)),
                        Text(args['name'],
                            style: primaryTextStyle(
                                color: Banking_TextColorWhite,
                                size: 16,
                                fontFamily: fontRegular)),
                      ],
                    ).expand(),
                    Icon(Icons.notifications,
                        size: 30, color: Banking_whitePureColor)
                  ],
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topLeft,
                            colors: <Color>[Banking_Primary, Banking_palColor]),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 80, 16, 0),
                      padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                      decoration: boxDecorationWithRoundedCorners(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: defaultBoxShadow()),
                      child: Column(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .where('Account Number',
                                      isEqualTo: args['accnumber'])
                                  .where('Name', isEqualTo: args['name'])
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  currentBal =
                                      snapshot.data?.docs.first['Balance'];
                                }
                                print(currentBal);
                                // <DocumentSnapshot> balance = snapshot.dat;
                                return Container(
                                  height: 250,
                                  child: PageView(
                                    children: [
                                      TopCard(
                                        name: args['name'],
                                        acctype: "Savings Account",
                                        acno: args['accnumber'].toString(),
                                        bal: 'RM ' + currentBal.toString(),
                                      ).onTap(
                                        () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TransactionHistory(),
                                                settings: RouteSettings(
                                                    arguments:
                                                        args['accnumber'])),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                );
                              }),
                          Align(
                            alignment: Alignment.center,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            color: Banking_app_Background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: SizedBox.shrink(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
