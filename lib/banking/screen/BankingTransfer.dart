import 'package:bankingapp/banking/utils/BankingImages.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bankingapp/banking/model/BankingModel.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/BankingContants.dart';
import 'package:bankingapp/banking/utils/BankingDataGenerator.dart';
import 'package:bankingapp/banking/utils/BankingStrings.dart';

class BankingTransfer extends StatefulWidget {
  const BankingTransfer({Key? key}) : super(key: key);

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
                Card(
                  color: Banking_Primary,
                  child: Text('yess'),
                ),
                // TextFormField(
                //   decoration: InputDecoration(
                //     hintText: "Search Payment",
                //     labelStyle: primaryTextStyle(
                //         size: textSizeLargeMedium.toInt(),
                //         color: Banking_greyColor),
                //     suffixIcon:
                //         Icon(Icons.search, size: 30, color: Banking_greyColor),
                //     enabledBorder: UnderlineInputBorder(
                //         borderSide: BorderSide(color: Colors.black12)),
                //     focusedBorder: UnderlineInputBorder(
                //         borderSide: BorderSide(color: Banking_greyColor)),
                //   ),
                // ),
                20.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
