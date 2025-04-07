import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  // Change to Future<SharedPreferences> since getInstance() is asynchronous
  static final Future<SharedPreferences> appPref =
      SharedPreferences.getInstance();

  static var accessToken = 'accessToken';
  static var attemptCount = 'attemptCount';

  // Make getAttemptCount return Future<int?>
  static Future<int?> getAttemptCount() async {
    return await getIntFromSF(attemptCount);
  }

  // Make incrementAttemptCount return Future<void>
  static Future<void> incrementAttemptCount() async {
    final currentCount = await getAttemptCount();
    final newCount = currentCount != null ? currentCount + 1 : 1;
    await addIntToSF(attemptCount, newCount);
  }

  // Make saveJsonToPrefs return Future<void>
  static Future<void> saveJsonToPrefs(String mKey, dynamic mValue) async {
    final mPref = await appPref; // Await the Future<SharedPreferences>
    final jsonString = jsonEncode(mValue);
    final base64String = base64Encode(utf8.encode(jsonString));
    await mPref.setString(mKey, base64String);
  }

  // Make getJsonFromPrefs return Future<dynamic>
  static Future<dynamic> getJsonFromPrefs(String mKey) async {
    final mPref = await appPref; // Await the Future<SharedPreferences>
    final base64String = mPref.getString(mKey);
    if (base64String != null) {
      final jsonString = utf8.decode(base64Decode(base64String));
      return jsonDecode(jsonString);
    }
    return null;
  }

  // Make addStringToSF return Future<void>
  static Future<void> addStringToSF(String mKey, String mValue) async {
    final mPref = await appPref; // Await the Future<SharedPreferences>
    final base64String = base64Encode(utf8.encode(mValue));
    await mPref.setString(mKey, base64String);
  }

  // Make addStringListToSF return Future<void>
  static Future<void> addStringListToSF(
    String mKey,
    List<String> mValueList,
  ) async {
    final mPref = await appPref; // Await the Future<SharedPreferences>
    final base64StringList =
        mValueList.map((item) => base64Encode(utf8.encode(item))).toList();
    await mPref.setStringList(mKey, base64StringList);
  }

  // Make getStringListValuesSF return Future<List<String>>
  static Future<List<String>> getStringListValuesSF(String mKey) async {
    final mPref = await appPref; // Await the Future<SharedPreferences>
    final base64StringList = mPref.getStringList(mKey) ?? [];
    final originalStringList = base64StringList
        .map((item) => utf8.decode(base64Decode(item)))
        .toList();
    return originalStringList;
  }

  // Make getStringFromSF return Future<String?>
  static Future<String?> getStringFromSF(String mKey) async {
    final mPref = await appPref; // Await the Future<SharedPreferences>
    final base64String = mPref.getString(mKey);
    if (base64String != null) {
      return utf8.decode(base64Decode(base64String));
    }
    return null;
  }

  // Make addIntToSF return Future<void>
  static Future<void> addIntToSF(String mKey, int mValue) async {
    final mPref = await appPref; // Await the Future<SharedPreferences>
    final base64String = base64Encode(utf8.encode(mValue.toString()));
    await mPref.setString(mKey, base64String);
  }

  // Make getIntFromSF return Future<int?>
  static Future<int?> getIntFromSF(String mKey) async {
    final mPref = await appPref; // Await the Future<SharedPreferences>
    final base64String = mPref.getString(mKey);
    if (base64String != null) {
      return int.tryParse(utf8.decode(base64Decode(base64String)));
    }
    return null;
  }

  // Make addDoubleToSF return Future<void>
  static Future<void> addDoubleToSF(String mKey, double mValue) async {
    final mPref = await appPref; // Await the Future<SharedPreferences>
    final base64String = base64Encode(utf8.encode(mValue.toString()));
    await mPref.setString(mKey, base64String);
  }

  // Make getDoubleFromSF return Future<double?>
  static Future<double?> getDoubleFromSF(String mKey) async {
    final mPref = await appPref; // Await the Future<SharedPreferences>
    final base64String = mPref.getString(mKey);
    if (base64String != null) {
      return double.tryParse(utf8.decode(base64Decode(base64String)));
    }
    return null;
  }

  // Make addBoolToSF return Future<void>
  static Future<void> addBoolToSF(String mKey, bool mValue) async {
    final mPref = await appPref; // Await the Future<SharedPreferences>
    final base64String = base64Encode(utf8.encode(mValue.toString()));
    await mPref.setString(mKey, base64String);
  }

  // Make getBoolFromSF return Future<bool?>
  static Future<bool?> getBoolFromSF(String mKey) async {
    final mPref = await appPref; // Await the Future<SharedPreferences>
    final base64String = mPref.getString(mKey);
    if (base64String != null) {
      return utf8.decode(base64Decode(base64String)) == 'true';
    }
    return null;
  }

  // Make removeToSF return Future<void>
  static Future<void> removeToSF(String mKey) async {
    final mPref = await appPref; // Await the Future<SharedPreferences>
    await mPref.remove(mKey);
  }

  // Make clearSharedPreferences return Future<void>
  static Future<void> clearSharedPreferences() async {
    final mPref = await appPref; // Await the Future<SharedPreferences>
    await mPref.clear();
  }
}
