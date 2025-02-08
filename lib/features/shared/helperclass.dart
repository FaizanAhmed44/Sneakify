import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

class SharedPreferencesHelper {
  static String userCartItems = FirebaseAuth.instance.currentUser!.uid;

  // Function to store a list of maps in SharedPreferences
  Future<bool> storeListOfMaps(List<Map<String, dynamic>> listOfMaps) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(listOfMaps);
    return prefs.setString(userCartItems, jsonString);
  }

  // Function to retrieve the list of maps from SharedPreferences
  Future<List<Map<String, dynamic>>> retrieveListOfMaps() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(userCartItems);
    if (jsonString != null) {
      // Convert the JSON string back to a List of Maps
      List<dynamic> jsonList = jsonDecode(jsonString);
      // Convert List<dynamic> to List<Map<String, dynamic>>
      List<Map<String, dynamic>> listOfMaps =
          List<Map<String, dynamic>>.from(jsonList);
      return listOfMaps;
    }
    return [];
  }
}
