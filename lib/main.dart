import 'package:flutter/material.dart';
import 'package:flutter_live_location/employee_list_screen.dart';
import 'package:flutter_live_location/login/login_screen.dart';
import 'package:flutter_live_location/service/location/location_service.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterMapTileCaching.initialise(await RootDirectory.normalCache);
  await FMTC.instance('mapStore').manage.createAsync();
  await TokenStore.getToken();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: TokenStore.token.isNotEmpty ? const EmployeeListScreen() :  SignInScreen(),
    );
  }
}

class TokenStore {
  static String token = '';
  static Future<void> getToken() async {
    token = (await SharedPreferences.getInstance()).getString('token') ?? '';
  }

}
