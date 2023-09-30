import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_live_location/main.dart';
import 'package:flutter_live_location/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TrackingApi {

  static Future getTrackedEmployees({name, employeeId, employeeFullId, date}) async {

    final response = await http.get(Uri.parse('${AppInfo.baseUrl}/api/hrm/employee-tracking-list?token=${TokenStore.token}'), headers: {
      'hrm-Api-Key': '5eKHR5SBi4Zflamk23q5akwQR72E7F3V2uBb'
    });

    print("employee tracked: ${response.body} statusCode: ${response.statusCode}");
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print("employee tracked: $jsonResponse");
      if(jsonResponse['status'] == 1) {
        return jsonResponse['data'];
      }else{
        return [];
      }
    } else {
      return [];
    }
  }

  static Future getEmployeeTrack({current, employeeId}) async {

    final response = await http.get(Uri.parse('${AppInfo.baseUrl}/api/hrm/get-employee-tracking?token=${TokenStore.token}&current=${current ?? ''}&employee_id=${employeeId ?? ''}'), headers: {
      'hrm-Api-Key': '5eKHR5SBi4Zflamk23q5akwQR72E7F3V2uBb'
    });

    print("employee tracked: ${response.body} statusCode: ${response.statusCode}");
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print("employee tracked: $jsonResponse");
      if(jsonResponse['status'] == 1) {
        return jsonResponse['data'];
      }else{
        return null;
      }
    } else {
      return null;
    }
  }

  static Future submitSortLeave(
      String longitude,
      String latitude) async {
    // try{
      final response = await http.post(
          Uri.parse(
              '${AppInfo.baseUrl}/api/hrm/set-employee-tracking?token=${TokenStore.token}'),
          headers: {
            'hrm-Api-Key': '5eKHR5SBi4Zflamk23q5akwQR72E7F3V2uBb'
          },
          body: {
            'token' : TokenStore.token,
            'longitude': longitude,
            'latitude': latitude,
            'status': 'Online',
          });

      print("body res: ${response.body } token: ${AppInfo.baseUrl}/api/hrm/set-employee-tracking?token=${TokenStore.token}");
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    // }catch(e) {
    //   return false;
    // }
    return false;
  }


}