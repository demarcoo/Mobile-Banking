import 'package:bankingapp/banking/screen/BankingTransfer.dart';
import 'package:bankingapp/banking/screen/BankingTransferDetails.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/BankingContants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bankingapp/banking/screen/BankingTransferDetails.dart';

class TransferResult extends StatefulWidget {
  const TransferResult({Key? key}) : super(key: key);

  @override
  State<TransferResult> createState() => _TransferResultState();
}

class _TransferResultState extends State<TransferResult> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as TransferArguments;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Banking_app_Background,
      body: Column(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 60, horizontal: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/banking/check_symbol.gif',
                              height: 320,
                              width: 320,
                              repeat: ImageRepeat.noRepeat,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              'Transfer Successful',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: fontWeightBoldGlobal),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recipient Account No.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: fontWeightBoldGlobal),
                                ),
                                Text(
                                  '${args.recAccNum}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: fontWeightBoldGlobal),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Recipient Bank',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: fontWeightBoldGlobal)),
                                Text('${args.recBank}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: fontWeightBoldGlobal))
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Recipient Name',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: fontWeightBoldGlobal)),
                                Text('${args.recName}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: fontWeightBoldGlobal))
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Amount Transferred',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: fontWeightBoldGlobal)),
                                Text('RM' + '${args.transferAmount}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: fontWeightBoldGlobal)),
                              ],
                            ),
                          ],
                        ),
                        Center(
                          child: Container(
                            width: 120,
                            padding: EdgeInsets.only(top: 20),
                            child: ElevatedButton(
                              onPressed: () async {
                                int count = 0;
                                //pop 4 screens
                                Navigator.popUntil(
                                  context,
                                  (route) {
                                    return count++ == 4;
                                  },
                                );
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
                              child: Text(
                                'OK',
                                style: TextStyle(
                                    color: Colors.blueGrey[800],
                                    fontWeight: fontWeightBoldGlobal),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
