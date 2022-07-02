import 'package:bankingapp/banking/model/BankingModel.dart';
import 'package:bankingapp/banking/screen/BankingTransfer.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/BankingContants.dart';
import 'package:bankingapp/banking/utils/BankingDataGenerator.dart';
import 'package:bankingapp/banking/utils/secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class BankingPaymentDetails extends StatefulWidget {
  static var tag = "/BankingPaymentDetails";
  String? headerText;
  String? paymentImg;
  Color? imgColor;
  Map? accInfo;

  BankingPaymentDetails(
      {this.headerText, required this.paymentImg, this.imgColor, this.accInfo});

  @override
  _BankingPaymentDetailsState createState() => _BankingPaymentDetailsState();
}

class _BankingPaymentDetailsState extends State<BankingPaymentDetails> {
  late List<BankingPaymentModel> mList1;
  late List<BankingPaymentModel> mList2;

  final amountController = TextEditingController();
  late int accNum;
  double? currentBal;

  @override
  void initState() {
    super.initState();
    mList1 = bankingPaymentDetailList();
    mList2 = bankingPaymentList();
  }

  @override
  Widget build(BuildContext context) {
    // final name = widget.accInfo!['name'];
    // print(UserSecureStorage.getAccNum() ?? '');
    return Scaffold(
      backgroundColor: Banking_app_Background,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('Account Number', isEqualTo: widget.accInfo!['accnumber'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            final double userCurrentBal =
                (snapshot.data?.docs.first['Balance']);
            return Container(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    30.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.chevron_left,
                                size: 25, color: Banking_blackColor)
                            .onTap(
                          () {
                            finish(context);
                          },
                        ),
                        20.height,
                        Text(widget.headerText!,
                            style: boldTextStyle(
                                size: 30, color: Banking_TextColorPrimary)),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                        child: Image.asset(
                      '${widget.paymentImg}',
                      width: 100,
                      height: 100,
                      color: widget.imgColor,
                    )),
                    SizedBox(
                      height: 20,
                    ),

                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        width: 180,
                        child: TextField(
                          cursorColor: Banking_Primary,
                          cursorHeight: 16,
                          controller: amountController,
                          style: TextStyle(fontSize: 17),
                          readOnly: false,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(8),
                            // FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(
                                RegExp('[0-9.]+')),
                          ],
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 15, 15, 17),
                              child: Text(
                                'RM',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            hintText: 'Amount',
                            alignLabelWithHint: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Banking_Primary)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Banking_Primary),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          double amountPay =
                              double.parse(amountController.text);

                          if (userCurrentBal < amountPay) {
                            print('Insufficient Balance');
                          } else {
                            // deduct current balance
                            final userNewBal = await userCurrentBal - amountPay;
                            print(userNewBal);

                            //get doc reference

                            final userPost = await FirebaseFirestore.instance
                                .collection('users')
                                .where('Account Number',
                                    isEqualTo: widget.accInfo!['accnumber'])
                                .limit(1)
                                .get()
                                .then(
                              (QuerySnapshot querySnapshot) async {
                                return querySnapshot.docs[0].reference;
                              },
                            );

                            //update document in firebase
                            var userBatch = FirebaseFirestore.instance.batch();
                            userBatch.update(userPost, {'Balance': userNewBal});
                            await userBatch.commit();
                          }
                        },
                        icon: Icon(
                          Icons.payment,
                          color: Banking_Secondary,
                        ),
                        label: Text(
                          'Pay',
                          style: TextStyle(color: Banking_Secondary),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Banking_Primary)),
                      ),
                    )

                    // ListView.builder(
                    //     scrollDirection: Axis.vertical,
                    //     itemCount: mList.length,
                    //     shrinkWrap: true,
                    //     physics: NeverScrollableScrollPhysics(),
                    //     itemBuilder: (BuildContext context, int index) {
                    //       return Container(
                    //         margin: EdgeInsets.only(top: 8, bottom: 8),
                    //         decoration: boxDecorationWithShadow(
                    //             borderRadius: BorderRadius.circular(10),
                    //             backgroundColor: Banking_whitePureColor),
                    //         child: Row(
                    //           children: <Widget>[
                    //             Container(
                    //               height: 60,
                    //               width: 60,
                    //               padding: EdgeInsets.all(16),
                    //               decoration: boxDecorationWithRoundedCorners(
                    //                   borderRadius: BorderRadius.circular(30),
                    //                   backgroundColor: Banking_Primary),
                    //               child: Image.asset(mList[index].img!,
                    //                   height: 20,
                    //                   width: 20,
                    //                   color: Banking_whitePureColor),
                    //             ).paddingAll(spacing_standard),
                    //             Text(mList[index].title!,
                    //                 style: primaryTextStyle(
                    //                     color: Banking_TextColorPrimary,
                    //                     size: 18,
                    //                     fontFamily: fontRegular)),
                    //           ],
                    //         ),
                    //       ).onTap(() {
                    //         if (index == 0) {
                    //           finish(context);
                    //         } else {
                    //           // PurchaseMoreScreen().launch(context);
                    //           // BankingPaymentHistory().launch(context);
                    //         }
                    //         setState(() {});
                    //       });
                    //     }),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
