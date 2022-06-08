import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/BankingContants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bankingapp/banking/services/bank_list.dart';

class ChooseBank extends StatefulWidget {
  const ChooseBank({Key? key}) : super(key: key);

  @override
  State<ChooseBank> createState() => _ChooseBankState();
}

class _ChooseBankState extends State<ChooseBank> {
  List<Banks> banks = [
    Banks(logo: 'maybank_logo.jpg', name: 'Maybank/Maybank Islamic'),
    Banks(logo: 'RHB_logo.jpg', name: 'RHB Bank'),
    Banks(logo: 'publicbank_logo.png', name: 'Public Bank'),
    Banks(logo: 'CIMB_logo.png', name: 'CIMB'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Banking_app_Background,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 30,
                  ).onTap(
                    () {
                      finish(context);
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Choose Bank',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30, fontWeight: fontWeightBoldGlobal),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 15),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: banks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 4.0),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              // updateTime(index);
                            },
                            title: Text(banks[index].name),
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                  'images/banking/${banks[index].logo}'),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
