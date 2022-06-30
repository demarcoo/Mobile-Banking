import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _keyUsername = 'username';
  static const _keyName = 'name';
  static const _keyBank = 'bank';
  static const _keyAccNum = 'accnumber';
  static const _keyBalance = 'balance';
  static const _keyPhone = 'phone';

  static Future setUsername(String username) async =>
      await _storage.write(key: _keyUsername, value: username);
  static Future setName(String name) async =>
      await _storage.write(key: _keyName, value: name);
  static Future setBank(String bank) async =>
      await _storage.write(key: _keyBank, value: bank);
  static Future setAccNum(int accnum) async =>
      await _storage.write(key: _keyAccNum, value: accnum.toString());
  static Future setBalance(double balance) async =>
      await _storage.write(key: _keyBalance, value: balance.toString());
  static Future setPhone(String phone) async =>
      await _storage.write(key: _keyPhone, value: phone);

  static Future<String?> getUsername() async =>
      await _storage.read(key: _keyUsername);
  static Future<String?> getName() async => await _storage.read(key: _keyName);
  static Future<String?> getBal() async =>
      await _storage.read(key: _keyBalance);
  static Future<String?> getAccNum() async =>
      await _storage.read(key: _keyAccNum);
  static Future<String?> getPhone() async =>
      await _storage.read(key: _keyPhone);

  static Future<void> clearStorage() async {
    _storage.deleteAll();
  }
}
