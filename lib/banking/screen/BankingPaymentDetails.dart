import 'package:bankingapp/banking/model/BankingModel.dart';
import 'package:bankingapp/banking/screen/BankingPaymentResult.dart';
import 'package:bankingapp/banking/screen/BankingTransfer.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/BankingContants.dart';
import 'package:bankingapp/banking/utils/BankingDataGenerator.dart';
import 'package:bankingapp/banking/utils/secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bankingapp/API/local_auth_api.dart';
import 'dart:math' as math;

// ignore: must_be_immutable

class PaymentArguments {
  final String utilityType;

  final double paymentAmount;

  PaymentArguments(this.utilityType, this.paymentAmount);
}

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

  Future<void> _showInvalidDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Input'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Only one .(decimal) is allowed'),
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
                          // onChanged: (value) async {
                          //   if (value.contains('.')) {
                          //     FilteringTextInputFormatter.deny(RegExp(''));
                          //   }
                          // },
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            //get 2 decimal places only
                            DecimalTextInputFormatter(decimalRange: 2),
                            LengthLimitingTextInputFormatter(8),
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d*'))
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
                          if (amountController.text == '' ||
                              int.parse(amountController.text) == 0) {
                            return _showEmptyDialog(context);
                          }
                          double amountPay =
                              double.parse(amountController.text);
                          //check whether user balance is enough

                          if (userCurrentBal < amountPay) {
                            print('Insufficient Balance');
                          } else {
                            final isAuthenticated =
                                await biomAuthentication.authenticate();
                            if (isAuthenticated == true) {
                              // deduct current balance
                              final userNewBal =
                                  await userCurrentBal - amountPay;
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
                              var userBatch =
                                  FirebaseFirestore.instance.batch();
                              userBatch
                                  .update(userPost, {'Balance': userNewBal});
                              await userBatch.commit();

                              //record transaction to firestore database

                              DateTime now = DateTime.now();

                              //store transaction detail

                              await FirebaseFirestore.instance
                                  .collection('transactions')
                                  .add(
                                {
                                  'Amount': amountPay,
                                  'Recipient': widget.headerText,
                                  'Recipient Name': '',
                                  'Sender': widget.accInfo!['accnumber'],
                                  'Date': now
                                },
                              );

                              //push to payment result screen

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentResult(),
                                  settings: RouteSettings(
                                    arguments: PaymentArguments(
                                        widget.headerText!, amountPay),
                                  ),
                                ),
                              );
                            }
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
                  ],
                ),
              ),
            );
          }),
    );
  }
}

//define the decimalformatter class
class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
