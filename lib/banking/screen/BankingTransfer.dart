import 'package:bankingapp/banking/screen/PurchaseButton.dart';
import 'package:bankingapp/banking/utils/BankingImages.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

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
        body: SizedBox(
          width: context.width(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  decoration: boxDecorationDefault(shape: BoxShape.circle),
                  child: Image.asset(
                    Banking_app_logo,
                    height: 180,
                  )),
              22.height,
              Text(
                'Coming Soon',
                style: boldTextStyle(size: 22),
                textAlign: TextAlign.center,
              ),
              16.height,
              // PurchaseButton(),
            ],
          ),
        ).paddingAll(16),
      ),
    );
  }
}
