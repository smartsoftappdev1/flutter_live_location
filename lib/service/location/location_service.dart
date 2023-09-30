import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static LocationPermission? permission;
  static late LocationSettings locationSettings;
  static late StreamSubscription<Position> positionStream;

  static init(BuildContext context) async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      showWarning(context);
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showWarning(context, title: "This is required to keep enable to you location service to share live lcoation");
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showWarning(context, title: "This is required to keep enable to you location service to share live lcoation");
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  static Future<Position> getLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  static enableBackgroundLocationService(Function(Position? position) onStream) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
            "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          )
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }
     positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(onStream);
  }

}



void showWarning(BuildContext context, {String? title}) => showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(title ?? "Your location service is currently disable"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("ok"),
          )
        ],
      );
    });
