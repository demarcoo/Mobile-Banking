class Banks {
  String logo; //url to an asset bank logo icon
  String name;
  // late bool isDaytime; //true or false if daytime or not

  Banks({required this.logo, required this.name});
}

class User {
  late bool? isLoggedin;
  late String? name;
  late String? accNum;
  late String? phone;
  late String? bank;
  late List? details;

  User({
    this.name,
    this.accNum,
    this.phone,
    this.bank,
  });
}

class transactionDetails {
  String? dateTime;
  int? senderAcc;
  int? recipientAcc;
  double? amountTransferred;

  transactionDetails(
      {required this.dateTime,
      required this.senderAcc,
      required this.recipientAcc,
      required this.amountTransferred});
}
// class BankAccount {
//   String name;
//   int accNumber;

//   BankAccount({required this.name, required this.accNumber});
// }
