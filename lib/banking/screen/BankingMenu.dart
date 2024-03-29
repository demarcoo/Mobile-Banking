import 'package:bankingapp/banking/screen/BankingChangePassword.dart';
import 'package:bankingapp/banking/screen/BankingChooseBanks.dart';
import 'package:bankingapp/banking/screen/BankingQuestionAnswer.dart';
import 'package:bankingapp/banking/screen/BankingRateInfo.dart';
import 'package:bankingapp/banking/screen/BankingSignIn.dart';
import 'package:bankingapp/banking/screen/BankingTermsCondition.dart';
import 'package:bankingapp/banking/screen/BankingTransfer.dart';
import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/BankingContants.dart';
import 'package:bankingapp/banking/utils/BankingImages.dart';
import 'package:bankingapp/banking/utils/BankingStrings.dart';
import 'package:bankingapp/banking/utils/BankingWidget.dart';
import 'package:bankingapp/banking/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bankingapp/banking/utils/secure_storage.dart';

class BankingMenu extends StatefulWidget {
  static var tag = "/BankingMenu";

  @override
  _BankingMenuState createState() => _BankingMenuState();
}

class _BankingMenuState extends State<BankingMenu> {
  // FlutterSecureStorage _storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final name = await UserSecureStorage.getName() ?? '';
    final accNum = await UserSecureStorage.getAccNum() ?? '';
  }

  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      backgroundColor: Banking_app_Background,
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              10.height,
              Text(Banking_lbl_Menu,
                  style:
                      boldTextStyle(color: Banking_TextColorPrimary, size: 35)),
              16.height,
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                        backgroundImage: AssetImage(Banking_ic_user1),
                        radius: 40),
                    10.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        5.height,
                        Text(args['name'],
                            style: boldTextStyle(
                                color: Banking_TextColorPrimary, size: 18)),
                        5.height,
                        Text(args['accnumber'].toString(),
                            style: primaryTextStyle(
                                color: Banking_TextColorSecondary,
                                size: 16,
                                fontFamily: fontMedium)),
                        5.height,
                        Text(args['bank'],
                            style: primaryTextStyle(
                                color: Banking_TextColorSecondary,
                                size: 16,
                                fontFamily: fontMedium)),
                      ],
                    ).expand()
                  ],
                ),
              ),
              16.height,
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    10.height,
                    bankingOption(Banking_ic_News, Banking_lbl_News,
                            Banking_blueColor)
                        .onTap(() {
                      //TODO
                    }),
                    bankingOption(
                            Banking_ic_Chart,
                            Banking_lbl_Rate_Information,
                            Banking_greenLightColor)
                        .onTap(() {
                      BankingRateInfo().launch(context);
                    }),
                    bankingOption(Banking_ic_Pin, Banking_lbl_Location,
                            Banking_greenLightColor)
                        .onTap(() {
                      //insert TODO
                    }),
                    10.height,
                  ],
                ),
              ),
              16.height,
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: spacing_middle,
                    ),
                    bankingOption(Banking_ic_TC, Banking_lbl_Term_Conditions,
                            Banking_greenLightColor)
                        .onTap(() {
                      BankingTermsCondition().launch(context);
                    }),
                    bankingOption(Banking_ic_Question,
                            Banking_lbl_Questions_Answers, Banking_palColor)
                        .onTap(() {
                      BankingQuestionAnswer().launch(context);
                    }),
                    bankingOption(Banking_ic_Call, Banking_lbl_Contact,
                            Banking_blueColor)
                        .onTap(() {}),
                    SizedBox(
                      height: spacing_middle,
                    ),
                  ],
                ),
              ),
              16.height,
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    bankingOption(Banking_ic_security,
                            Banking_lbl_Change_Password, Banking_pinkColor)
                        .onTap(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePassword(),
                        ),
                      );
                    }),
                    bankingOption(Banking_ic_Logout, Banking_lbl_Logout,
                            Banking_pinkColor)
                        .onTap(() {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => logoutDialog(),
                      );
                    }),
                    bankingOption(Banking_ic_Remove, 'Remove Account',
                            Banking_pinkColor)
                        .onTap(() async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => removeDialog(),
                      );
                    })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class logoutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: logoutContent(context),
    );
  }
}

class removeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: removeContent(context),
    );
  }
}

logoutContent(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0)),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        16.height,
        Text(Banking_lbl_Confirmation, style: primaryTextStyle(size: 18))
            .onTap(() {
          finish(context);
        }).paddingOnly(top: 8, bottom: 8),
        Divider(height: 10, thickness: 1.0, color: Banking_greyColor),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("No", style: primaryTextStyle(size: 18)).onTap(() {
              finish(context);
            }).paddingRight(16),
            Container(width: 1.0, height: 40, color: Banking_greyColor)
                .center(),
            Text(
              "Yes",
              style: primaryTextStyle(size: 18, color: Banking_Primary),
            ).onTap(() {
              finish(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BankingSignIn(),
                ),
              );
            }).paddingLeft(16)
          ],
        ),
        16.height,
      ],
    ),
  );
}

removeContent(BuildContext context) {
  return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          16.height,
          Text(Banking_lbl_Confirmation, style: primaryTextStyle(size: 18))
              .onTap(() {
            finish(context);
          }).paddingOnly(top: 8, bottom: 8),
          Divider(height: 10, thickness: 1.0, color: Banking_greyColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("No", style: primaryTextStyle(size: 18)).onTap(() {
                finish(context);
              }).paddingRight(16),
              Container(width: 1.0, height: 40, color: Banking_greyColor)
                  .center(),
              Text("Yes",
                      style: primaryTextStyle(size: 18, color: Banking_Primary))
                  .onTap(() async {
                await UserSecureStorage.clearStorage();
                finish(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BankingSignIn(),
                  ),
                );
              }).paddingLeft(16)
            ],
          ),
          16.height,
        ],
      ));
}
