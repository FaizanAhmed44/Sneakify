import 'package:ecommerce_app/theme/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TheamModal extends ChangeNotifier {
  late bool _isDark;
  late TheamSharredPreferences theamSharredPreferences;
  bool get isDark => _isDark;

  TheamModal() {
    _isDark = false;
    theamSharredPreferences = TheamSharredPreferences();
    getTheamPreferences();
  }

  set isDark(bool value) {
    _isDark = value;
    theamSharredPreferences.setTheam(value);
    notifyListeners();
  }

  getTheamPreferences() async {
    _isDark = await theamSharredPreferences.getTheam();
    notifyListeners();
  }
}
