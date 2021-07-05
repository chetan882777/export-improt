import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  static final String user_id = "uId";

  static Future<void> saveUserId(String value) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(user_id, value);
  }

  static Future<String?> getUserId() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(user_id);
  }


}