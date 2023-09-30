import 'dart:convert';
import 'dart:io';
import 'package:flutter_live_location/main.dart';
import 'package:flutter_live_location/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  static Future authenticateUser(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.post(Uri.parse('${AppInfo.baseUrl}/api/login'), body: {
        'email': email ?? '',
        'password': password ?? '',
        'device_token': '',
      });
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if(jsonResponse['status']){

          prefs.setString("token", jsonResponse['token']);
          await TokenStore.getToken();
          return jsonResponse;
        }else{
          return null;
        }
      } else {
        return null;
      }
    } on SocketException {
      return null;
    }
    return null;
  }
}
