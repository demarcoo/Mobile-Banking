import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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

  void init() async {
    final inTransactionDoc = await FirebaseFirestore.instance
        .collection('transactions')
        .where('Recipient', isEqualTo: 123123123123)
        .snapshots();

    print(inTransactionDoc.length);
    final outTransactionDoc = await FirebaseFirestore.instance
        .collection('transactions')
        .where('Sender', isEqualTo: 123123123123)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Banking_Primary,
        leading: Icon(Icons.chevron_left).onTap(() {
          finish(context);
        }),
        elevation: 0,
        title: Text('Transaction History'),
      ),
      body: Stack(children: [
        Container(
          child: PageView(
              scrollDirection: Axis.horizontal,
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('transactions')
                      .where('Recipient', isEqualTo: 123123123123)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (!snapshot.hasData) {
                      return Text('No transactions recorded');
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var sender = snapshot.data!.docs[index]['Sender'];
                        var inAmount = snapshot.data!.docs[index]['Amount'];
                        var inDate = snapshot.data!.docs[index]['Date'];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                              child: Text(
                                'Cash Inflow',
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: fontWeightBoldGlobal),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 4),
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    'Transfer from ' + sender.toString(),
                                    style: TextStyle(
                                        fontWeight: fontWeightBoldGlobal),
                                  ),
                                  trailing: Text(
                                    '+RM ' + inAmount.toString(),
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.green[400]),
                                  ),
                                  subtitle: Text(inDate.toString()),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('transactions')
                      .where('Sender', isEqualTo: 123123123123)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                    if (snapshot2.connectionState == ConnectionState.waiting) {
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
                        var outAmount = snapshot2.data!.docs[index]['Amount'];
                        var outDate = snapshot2.data!.docs[index]['Date'];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                              child: Text(
                                'Cash Outflow',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: fontWeightBoldGlobal),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 4),
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                    'Transfer to ' + recipient.toString(),
                                    style: TextStyle(
                                        fontWeight: fontWeightBoldGlobal),
                                  ),
                                  trailing: Text(
                                    '- RM ' + outAmount.toString(),
                                    style: TextStyle(
                                        fontSize: 18, color: Banking_Primary),
                                  ),
                                  subtitle: Text(outDate.toString()),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              ],
              onPageChanged: (value) {
                setState(() {
                  currentIndexPage = value;
                });
              }),
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
      ]),

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
