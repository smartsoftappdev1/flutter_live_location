import 'dart:convert';
import 'dart:io';
import 'package:flutter_live_location/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EmployeeApi {
  static Future fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _baseUrl = (prefs.getString('url') ?? "");
    var _token = (prefs.getString('token') ?? "");
    var _hrmApiKey = (prefs.getString('hrmApiKey') ?? '');
    final response =
    await http.post(Uri.parse('$_baseUrl/api/hrm/profile'), headers: {
      'hrm-Api-Key': _hrmApiKey
    }, body: {
      'token': _token,
    });

    if (response.statusCode != 200) throw Exception('Request sent failed!');
    // EmployeeProfileResponse employeeData =
    // employeeProfileResponseFromJson(response.body);
    // try {
    //   if (employeeData.status == false)
    //     throw Exception('${employeeData.message}');
    //   return employeeData.profile;
    // } catch (e) {
    //   print("error from fetchProfile: $e");
    // }
  }
}