import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/services/bank_list.dart';
import 'package:nb_utils/nb_utils.dart';

class SearchBankAccount extends StatefulWidget {
  const SearchBankAccount({Key? key}) : super(key: key);

  @override
  State<SearchBankAccount> createState() => _SearchBankAccountState();
}

class _SearchBankAccountState extends State<SearchBankAccount> {
  @override
  Widget build(BuildContext context) {
    final bank = ModalRoute.of(context)!.settings.arguments as Banks;
    return Scaffold(
      backgroundColor: Banking_app_Background,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                10.height,
                Row(
                  children: [
                    Icon(
                      Icons.chevron_left,
                      size: 35,
                    ).onTap(() {
                      finish(context);
                    }),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Fund Transfer',
                        style: boldTextStyle(
                            color: Banking_TextColorPrimary, size: 28)),
                  ],
                ),
                8.height,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                          width: 360,
                          height: 100,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/banking/${bank.logo}'),
                                radius: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 240,
                                child: Text(
                                  bank.name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: fontWeightBoldGlobal),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      width: 350,
                      child: TextField(
                        style: TextStyle(fontSize: 18),
                        readOnly: false,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(12),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: 'Recipient Account No.',
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 15.0),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Banking_Primary),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: ElevatedButton.icon(
                          onPressed: () {
                            //searchExistingAcc
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Banking_Primary)),
                          icon: Icon(
                            Icons.next_plan,
                            color: Colors.black,
                          ),
                          label: Text(
                            'Continue',
                            style: TextStyle(color: Colors.black),
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
