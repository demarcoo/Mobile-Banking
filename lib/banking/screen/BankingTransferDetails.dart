import 'package:bankingapp/banking/screen/BankingTransferToAccount.dart';
import 'package:bankingapp/banking/services/classes.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bankingapp/banking/utils/BankingContants.dart';
import 'package:bankingapp/API/local_auth_api.dart';

class BankingTransferDetails extends StatefulWidget {
  const BankingTransferDetails({
    Key? key,
  }) : super(key: key);
  @override
  State<BankingTransferDetails> createState() => _BankingTransferDetailsState();
}

class _BankingTransferDetailsState extends State<BankingTransferDetails> {
  @override
  Widget build(BuildContext context) {
    // final bank = ModalRoute.of(context)!.settings.arguments as Banks;
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Banking_app_Background,
        body: Container(
          height: context.height(),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.chevron_left,
                    size: 35,
                  ).onTap(() {
                    finish(context);
                  }),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Fund Transfer',
                      style: boldTextStyle(
                          color: Banking_TextColorPrimary, size: 28)),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Expanded(
                      child: DecoratedBox(
                        decoration: boxDecorationWithRoundedCorners(
                          backgroundColor: Banking_Primary,
                          gradient: LinearGradient(
                            colors: <Color>[Banking_Primary, Banking_palColor],
                          ),
                        ),
                        position: DecorationPosition.background,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                // padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.wallet_rounded,
                                      size: 50,
                                    ),
                                    Text(
                                      'aa',
                                      style: TextStyle(
                                          fontWeight: fontWeightBoldGlobal),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 40,
                                        ),
                                      ]),
                                )),
                            Expanded(
                              flex: 4,
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet,
                                      size: 50,
                                    ),
                                    Text(
                                      args.accNumber.toString(),
                                      style: TextStyle(
                                          fontWeight: fontWeightBoldGlobal,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      args.accName,
                                      style: TextStyle(
                                          fontWeight: fontWeightBoldGlobal,
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 370,
                      child: TextField(
                        readOnly: false,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(12),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: 'Amount',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Banking_Primary),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final isAuthenticated =
                            await biomAuthentication.authenticate();
                        if (isAuthenticated == true) {
                          print('you in!');
                        }
                      },
                      icon: Icon(
                        Icons.next_plan,
                        color: Colors.black,
                      ),
                      label: Text(
                        'Transfer',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Banking_Primary)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
