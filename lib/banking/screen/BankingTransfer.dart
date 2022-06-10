import 'package:bankingapp/banking/screen/BankingChooseBanks.dart';
import 'package:bankingapp/banking/utils/BankingImages.dart';
import 'package:bankingapp/banking/utils/BankingWidget.dart';
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
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
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
                      name: 'JUANITO DAVID',
                      acctype: 'Savings Account',
                      acno: '114414111262',
                      bal: 'RM 5555',
                    ),
                  ),
                ),
                // Row(
                //   children: [
                //     EditText(
                //       text: ('Recipient Account'),
                //       isPassword: false,
                //     )
                //   ],
                // ),
                SizedBox(height: 100),

                // Container(
                //   child: TextFormField(
                //     readOnly: true,
                //     inputFormatters: <TextInputFormatter>[
                //       FilteringTextInputFormatter.digitsOnly,
                //     ],
                //     decoration: InputDecoration(
                //       hintText: "Bank Name",
                //       labelStyle: primaryTextStyle(
                //           size: textSizeLargeMedium.toInt(),
                //           color: Banking_greyColor),
                //       enabledBorder: UnderlineInputBorder(
                //           borderSide: BorderSide(color: Colors.black12)),
                //       focusedBorder: UnderlineInputBorder(
                //           borderSide: BorderSide(color: Banking_greyColor)),
                //     ),
                //   ),
                // ),
                // Container(
                //   child: TextFormField(
                //     keyboardType: TextInputType.number,
                //     inputFormatters: <TextInputFormatter>[
                //       FilteringTextInputFormatter.digitsOnly,
                //       LengthLimitingTextInputFormatter(12)
                //     ],
                //     decoration: InputDecoration(
                //       hintText: "Account No.",
                //       labelStyle: primaryTextStyle(
                //           size: textSizeLargeMedium.toInt(),
                //           color: Banking_greyColor),
                //       enabledBorder: UnderlineInputBorder(
                //           borderSide: BorderSide(color: Colors.black12)),
                //       focusedBorder: UnderlineInputBorder(
                //           borderSide: BorderSide(color: Banking_greyColor)),
                //     ),
                //   ),
                // ),
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
                                      settings:
                                          RouteSettings(name: '/choosebank')),
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
                                  backgroundColor: MaterialStateProperty.all(
                                      Banking_Primary),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
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
  }
}
