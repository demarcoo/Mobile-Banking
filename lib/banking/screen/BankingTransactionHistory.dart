import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  int currentIndexPage = 0;
  int? pageLength;
  @override
  void initState() {
    currentIndexPage = 0;
    pageLength = 2;
    super.initState();
    init();
  }

  Future init() async {
    final accnum = await UserSecureStorage.getAccNum() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    //get user accnum from prev screen
    final args = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Banking_Primary,
        leading: Icon(Icons.chevron_left).onTap(() {
          finish(context);
        }),
        elevation: 0,
        title: Text('Transaction History'),
      ),
      body: Stack(
        children: [
          Container(
            child: PageView(
              scrollDirection: Axis.horizontal,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: Text(
                        'Cash Inflow',
                        style: TextStyle(
                            fontSize: 26, fontWeight: fontWeightBoldGlobal),
                      ),
                    ),
                    Flexible(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('transactions')
                            .where('Recipient', isEqualTo: args)
                            .orderBy('Date', descending: true)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (!snapshot.hasData) {
                            return Text('No transactions recorded');
                          }

                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var senderAcc =
                                  snapshot.data!.docs[index]['Sender'];
                              var senderName =
                                  snapshot.data!.docs[index]['Sender Name'];
                              var inAmount =
                                  snapshot.data!.docs[index]['Amount'];
                              var inDate = (snapshot.data!.docs[index]['Date']
                                      as Timestamp)
                                  .toDate();
                              String formattedDate =
                                  DateFormat('dd MMM yyyy').format(inDate);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1, horizontal: 4),
                                    child: Card(
                                      child: ListTile(
                                        title: (senderAcc.runtimeType == int)
                                            ? Text(
                                                'Transfer from ' + senderName,
                                                style: TextStyle(
                                                    fontWeight:
                                                        fontWeightBoldGlobal),
                                              )
                                            : SizedBox.shrink(),
                                        trailing: Text(
                                          '+RM ' + inAmount.toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.green[400]),
                                        ),
                                        subtitle: Text(formattedDate),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: Text(
                        'Cash Outflow',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 26, fontWeight: fontWeightBoldGlobal),
                      ),
                    ),
                    Flexible(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('transactions')
                            .where('Sender', isEqualTo: args)
                            .orderBy('Date', descending: true)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                          if (snapshot2.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (!snapshot2.hasData) {
                            return Text('No transactions recorded');
                          }

                          return ListView.builder(
                            itemCount: snapshot2.data!.docs.length,
                            itemBuilder: (context, index) {
                              var recipient =
                                  snapshot2.data!.docs[index]['Recipient'];
                              var recName =
                                  snapshot2.data!.docs[index]['Recipient Name'];
                              var outAmount =
                                  snapshot2.data!.docs[index]['Amount'];
                              var outDate = (snapshot2.data!.docs[index]['Date']
                                      as Timestamp)
                                  .toDate();
                              String formattedDate =
                                  DateFormat('dd MMM yyyy').format(outDate);
//02 Feb 2022
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1, horizontal: 4),
                                    child: Card(
                                      child: ListTile(
                                        title: (recipient.runtimeType == int)
                                            ? Text(
                                                'Transfer to ' + recName,
                                                style: TextStyle(
                                                    fontWeight:
                                                        fontWeightBoldGlobal),
                                              )
                                            : Text(
                                                recipient + ' Payment',
                                                style: TextStyle(
                                                    fontWeight:
                                                        fontWeightBoldGlobal),
                                              ),
                                        trailing: Text(
                                          '- RM ' + outAmount.toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Banking_Primary),
                                        ),
                                        subtitle: Text(formattedDate),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
              onPageChanged: (value) {
                setState(
                  () {
                    currentIndexPage = value;
                  },
                );
              },
            ),
          ),
          Positioned(
            width: context.width(),
            height: 50,
            top: context.height() * 0.8,
            child: Align(
              alignment: Alignment.center,
              child: DotsIndicator(
                  dotsCount: 2,
                  position: currentIndexPage.toDouble(),
                  decorator: DotsDecorator(
                      color: Banking_view_color, activeColor: Banking_Primary)),
            ),
          ),
        ],
      ),

      //  StreamBuilder(
      //   stream: FirebaseFirestore.instance
      //       .collection('transactions')
      //       .where('Sender', isEqualTo: 123123123123)
      //       .snapshots(),
      //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return CircularProgressIndicator();
      //     }
      //     if (!snapshot.hasData) {
      //       return Text('No transactions recorded');
      //     }

      //     return ListView.builder(
      //       itemCount: snapshot.data!.docs.length,
      //       itemBuilder: (context, index) {
      //         var recipient = snapshot.data!.docs[index]['Recipient'];
      //         var outAmount = snapshot.data!.docs[index]['Amount'];
      //         var outDate = snapshot.data!.docs[index]['Date'];

      //         return Padding(
      //           padding: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      //           child: Card(
      //             child: ListTile(
      //               title: Text('Transfer from ' + recipient.toString()),
      //               trailing: Text('+RM ' + outAmount.toString()),
      //               subtitle: Text(outDate),
      //             ),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
