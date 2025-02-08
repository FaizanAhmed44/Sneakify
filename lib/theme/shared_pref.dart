import 'package:shared_preferences/shared_preferences.dart';

class TheamSharredPreferences {
  static const prefKey = "preferences";

  setTheam(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(prefKey, value);
  }

  getTheam() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(prefKey) ?? false;
  }
}
