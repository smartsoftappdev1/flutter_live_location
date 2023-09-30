import 'package:flutter/material.dart';
import 'package:flutter_live_location/api/tracking_api.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class EmployeeLocationTrackViewScreen extends StatefulWidget {

  String id;
  String name;
  EmployeeLocationTrackViewScreen({Key? key, required this.id, required this.name}) : super(key: key);

  @override
  State<EmployeeLocationTrackViewScreen> createState() =>
      _EmployeeLocationTrackViewScreenState();
}

class _EmployeeLocationTrackViewScreenState
    extends State<EmployeeLocationTrackViewScreen>
    with SingleTickerProviderStateMixin {

  LatLng currentLoc = LatLng(23.7515713, 90.3859329);
  LatLng startLocation = LatLng(23.751337, 90.378216);

  List locationList = [];

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  MapController mapController = MapController();


  @override
  void dispose() {
    mapController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                showFilterBottomSheet();
              },
              splashRadius: 20,
              icon: const Icon(Icons.filter_list))
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white
        ),
        child: FutureBuilder(
          future: TrackingApi.getEmployeeTrack(employeeId: widget.id),
          builder: (context, AsyncSnapshot snapshot) {
            if(!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }

            var  data = snapshot.data[0];
            locationList = data['tracking_details'];

            return SafeArea(
              child: Center(
                child: Container(
                  child: Column(
                    children: [
                      Flexible(
                          child: FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                              center: LatLng(double.parse(locationList.last['latitude']), double.parse(locationList.last['longitude'])), zoom: 15.8,
                            ),
                            layers: [
                              TileLayerOptions(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: const ['a', 'b', 'c'],
                                maxNativeZoom: 21,
                                maxZoom: 21,
                                tileProvider: FMTC.instance('mapStore').getTileProvider(),
                                userAgentPackageName: 'com.example.flutter_live_location',
                                retinaMode: MediaQuery.of(context).devicePixelRatio > 1.0,
                                errorImage: const NetworkImage(
                                    'https://tile.openstreetmap.org/18/0/0.png'),
                              ),
                              PolylineLayerOptions(
                                polylineCulling: true,
                                polylines: [
                                  Polyline(
                                    strokeWidth: 10,
                                    color: Colors.red,
                                    points: List.generate(locationList.length, (index1) => LatLng(double.parse(locationList[index1]['latitude']), double.parse(locationList[index1]['longitude']))),
                                  ),
                                ],
                              ),
                              MarkerLayerOptions(
                                markers: [
                                  Marker(
                                    point: LatLng(double.parse(locationList.first['latitude']), double.parse(locationList.first['longitude'])),
                                    builder: (context) => const Icon(
                                      Icons.location_on_rounded,
                                      size: 35,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Marker(
                                      point: LatLng(double.parse(locationList.last['latitude']), double.parse(locationList.last['longitude'])),
                                      builder: (context) => const Icon(
                                        Icons.location_on_rounded,
                                        size: 35,
                                        color: Colors.blue,
                                      ))
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.lightBlue,
      bottomSheet: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        width: double.maxFinite,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15.0,
                spreadRadius: 15,
                offset: const Offset(
                  20,
                  20,
                ),
              )
            ]),
        child: Column(
          children: [
            Text(
              DateFormat("MMM d yyyy h:mm a").format(DateTime.now()),
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            Expanded(
              child: Center(
                child: Row(
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          mapController.move(LatLng(double.parse(locationList.first['latitude']), double.parse(locationList.first['longitude'])), mapController.zoom);
                        },
                        style: OutlinedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            side: const BorderSide(color: Colors.white, width: 1.5),
                            primary: Colors.white),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text("Start"),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.start),
                          ],
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(
                        onPressed: () {
                          mapController.move(LatLng(double.parse(locationList.last['latitude']), double.parse(locationList.last['longitude'])), mapController.zoom);
                        },
                        style: OutlinedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            side: const BorderSide(color: Colors.white, width: 1.5),
                            primary: Colors.white),
                        child:  Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text("Current"),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(Icons.share_location_rounded),
                          ],
                        )),
                    const Spacer(),
                    OutlinedButton(
                        onPressed: () {
                          mapController.move(
                              mapController.center, mapController.zoom + 0.1);
                        },
                        style: OutlinedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            side: const BorderSide(color: Colors.white, width: 1.5),
                            primary: Colors.white),
                        child: const Icon(Icons.add)),
                    const SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(
                        onPressed: () {
                          mapController.move(
                              mapController.center, mapController.zoom - 0.1);
                        },
                        style: OutlinedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            side: const BorderSide(color: Colors.white, width: 1.5),
                            primary: Colors.white),
                        child: const Icon(Icons.remove)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showFilterBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        backgroundColor: Colors.blue,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    BackButton(
                      color: Colors.white,
                    ),
                    Text(
                      "FILTER TRACKING",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 1.5, color: Colors.white)
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.calendar_month, color: Colors.blue, size: 16,),
                          SizedBox(width: 5,),
                          Text(
                            "DATE",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      if(selectedDate == null)OutlinedButton(
                          onPressed: () async {
                            selectedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2050));
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            side: const BorderSide(color: Colors.blue, width: 1.5)
                          ),
                          child: const Text("Select Date", style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),)),
                      if(selectedDate !=null) Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                            margin: const EdgeInsets.only(right: 10),
                            decoration:BoxDecoration(
                                border: Border.all(color: Colors.blue, width: 1.5),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(
                              DateFormat("MMMM d yyyy").format(selectedDate!),
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          OutlinedButton(
                              onPressed: () async {
                                selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate ?? DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2050));
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: const BorderSide(color: Colors.blue, width: 1.5)
                              ),
                              child: const Text("Change", style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600
                              ),))
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 1.5, color: Colors.white)
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.access_time_filled, color: Colors.blue, size: 16,),
                          SizedBox(width: 5,),
                          Text(
                            "TIME",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      if(selectedTime == null)OutlinedButton(
                          onPressed: () async {
                            selectedTime = await showTimePicker(context: context, initialTime: selectedTime ?? TimeOfDay.now());
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              side: const BorderSide(color: Colors.blue, width: 1.5)
                          ),
                          child: const Text("Select Time", style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),)),
                      if(selectedTime !=null) Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                            margin: const EdgeInsets.only(right: 10),
                            decoration:BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 1.5),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(
                                selectedTime!.format(context),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600
                                ),
                            ),
                          ),
                          OutlinedButton(
                              onPressed: () async {
                                selectedTime = await showTimePicker(context: context, initialTime: selectedTime ?? TimeOfDay.now());
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: const BorderSide(color: Colors.blue, width: 1.5)
                              ),
                              child: const Text("Change", style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600
                              ),))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
