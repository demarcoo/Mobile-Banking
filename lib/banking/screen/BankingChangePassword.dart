import 'package:bankingapp/banking/utils/BankingColors.dart';
import 'package:bankingapp/banking/utils/secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool? _passwordVisible;
  TextEditingController _currentPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  Future<void> _showEmptyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Empty Field(s)'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Please input the password'),
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
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Banking_app_Background,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Banking_app_Background,
          body: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.arrow_back,
                  size: 28,
                ).onTap(() {
                  finish(context);
                }),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Change Password',
                  style:
                      TextStyle(fontSize: 28, fontWeight: fontWeightBoldGlobal),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Current Password',
                  style:
                      TextStyle(fontSize: 18, fontWeight: fontWeightBoldGlobal),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 30,
                  child: TextField(
                    controller: _currentPassword,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Password'),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'New Password',
                  style:
                      TextStyle(fontSize: 18, fontWeight: fontWeightBoldGlobal),
                ),
                Container(
                  height: 30,
                  child: TextField(
                    controller: _newPassword,
                    obscureText: _passwordVisible!,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible!;
                            });
                          },
                          icon: Icon(
                            Icons.lock,
                            color: Banking_Secondary,
                          ),
                          padding: EdgeInsets.only(bottom: 7.5),
                        ),
                        hintText: 'Min. 8 chars w/ Upper, Lower, Symbols'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Confirm Password',
                  style:
                      TextStyle(fontSize: 18, fontWeight: fontWeightBoldGlobal),
                ),
                Container(
                  height: 30,
                  child: TextField(
                    controller: _confirmPassword,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Re-type password'),
                  ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_currentPassword.text == '' ||
                            _newPassword.text == '' ||
                            _confirmPassword.text == '') {
                          return _showEmptyDialog(context);
                        }
                        final username =
                            await UserSecureStorage.getUsername() ?? '';
                        await FirebaseFirestore.instance
                            .collection('users')
                            .where('Username', isEqualTo: username)
                            .where('Password', isEqualTo: _currentPassword.text)
                            .get()
                            .then(
                          (QuerySnapshot querySnapshot) async {
                            if (querySnapshot.docs.isEmpty) {
                              await ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Incorrect password'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              if (_newPassword.text.length < 8 ||
                                  !_newPassword.text.contains(
                                    RegExp(
                                        r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"),
                                  )) {
                                await ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please create a stronger password'),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                _currentPassword.clear();
                                _newPassword.clear();
                                _confirmPassword.clear();
                                return;
                              }
                              if (_newPassword.text == _currentPassword.text) {
                                await ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Your new password cannot be the same as the old one.'),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              if (_newPassword.text == _confirmPassword.text &&
                                  _newPassword.text != _currentPassword.text) {
                                final newPassword = _newPassword.text;

                                //get firestore document reference
                                final userPost = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .where('Username', isEqualTo: username)
                                    .where('Password',
                                        isEqualTo: _currentPassword.text)
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
                                userBatch.update(
                                    userPost, {'Password': newPassword});
                                await userBatch.commit();

                                //notify user

                                await ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Password updated successfully'),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                //clear textfield

                                _currentPassword.clear();
                                _newPassword.clear();
                                _confirmPassword.clear();
                              } else {
                                await ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Password does not match. Please try again.'),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                return;
                              }
                            }
                          },
                        );
                      },
                      child: Text(
                        'Change Password',
                        style: TextStyle(
                            color: Banking_Secondary,
                            fontWeight: fontWeightBoldGlobal,
                            fontSize: 14),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Banking_Primary),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
