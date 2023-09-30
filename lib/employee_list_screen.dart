import 'package:flutter/material.dart';
import 'package:flutter_live_location/api/tracking_api.dart';
import 'package:flutter_live_location/employee_location_track_view_screen.dart';
import 'package:flutter_live_location/service/location/location_service.dart';
import 'package:geolocator/geolocator.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  bool willShareLocation = false;
  String lat = '',lon = '';

  @override
  void initState() {
    LocationService.init(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tracking List"),
          elevation: 0,
          leading: const Icon(Icons.track_changes),
          actions: [
            Switch(
                trackColor: MaterialStateProperty.all(Colors.white70),
                activeColor: Colors.white,
                value: willShareLocation,
                onChanged: (value) {
                  if (value) {
                    showLocationShareConfirmation();
                  } else {
                    setState(() {
                      willShareLocation = !willShareLocation;
                      LocationService.positionStream.cancel();
                    });
                  }
                })
          ],
        ),
        body: FutureBuilder(
          future: TrackingApi.getTrackedEmployees(),
          builder: (context, AsyncSnapshot snapshot) {
            if(!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(),);
            }

            if(snapshot.data.isEmpty) {
              return Center(child: Text("No Tracking Found"),);
            }
            return ListView.separated(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${snapshot.data[index]['employee']['name']}"),
                    trailing: const Icon(Icons.directions_run),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => EmployeeLocationTrackViewScreen(id: "${snapshot.data[index]['employee_id'] }", name: "${snapshot.data[index]['employee']['name']}",)));
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                });
          },
        ),
        bottomSheet: Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))
          ),
          child: Text("Latitude: $lat Longitude: $lon"),
        ),
    );
  }

  void streamCallBack(Position? position) async {
    if(position != null){
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
      lat = position.latitude.toStringAsFixed(2);
      lon = position.longitude.toStringAsFixed(2);
      setState((){});

      var  result  = await TrackingApi.submitSortLeave(position.latitude.toString(), position.longitude.toString());
      if(result) {
        print('location has been updated');
      }else{
        print('location update failed');
      }
    }
  }

  void showLocationShareConfirmation() => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: const Text(
              "Are you sure you want to share your live location? This service will be running in the background.",
              textAlign: TextAlign.justify,
              style: TextStyle(

              ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(25, 40, 25, 0),
          actionsPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          actions: [
            OutlinedButton(
                onPressed: () {
                  setState(() {
                    willShareLocation = !willShareLocation;
                  });
                  LocationService.enableBackgroundLocationService(streamCallBack);
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(
                        color: Colors.blue,
                        width: 1.8
                    ),
                ),
                child: const Text("Yes")),
            OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: Colors.blue, width: 1.8)),
                child: const Text("No"))
          ],
        );
      });
}
