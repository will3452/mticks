

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mticks/bookings/SetDateAndDestination.dart';
import 'package:mticks/home/ticket_details.dart';

import '../services/api.dart';
import '../services/storage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  int _bus = 0;
  int _route = 0;
  int _terminal = 0;
  var _bookings = [];
  bool _fetchingBookings = true;

  String? _token;
  String? _id;

  void _getToken() async {
    String? token = await storage.read(key: 'userToken');
    String? id = await storage.read(key: 'userId');
    setState(() {
      _token = token;
      _id = id;
    });
    _fetchAll();
  }

  void _fetchAll() async {

    _fetchBus();
    _fetchRoute();
    _fetchTerminal();
    _fetchBooking();
  }


  void _fetchBooking() async {
    var response = await dio.get('/resource', queryParameters: {
      'model': 'Booking',
      'method': 'all',
    },
        options: Options(
            headers: {
              'Authorization': 'Bearer $_token',
            }
        )
    );

    setState(() {
      _bookings = response.data.where((e) => '${e['user_id']}' == _id ).toList();
      _fetchingBookings = false;
    });
  }

  void _fetchBus() async {
    var response = await dio.get('/resource', queryParameters: {
      'model': 'Bus',
      'method': 'all',
    },
        options: Options(
            headers: {
              'Authorization': 'Bearer $_token',
            }
        )
    );
    setState(() {
      _bus = response.data.length;
    });
  }

  void _fetchRoute() async {
    var response = await dio.get('/resource', queryParameters: {
      'model': 'Route',
      'method': 'all',
    },
        options: Options(
            headers: {
              'Authorization': 'Bearer $_token',
            }
        )
    );
    setState(() {
      _route = response.data.length;
    });
  }

  void _fetchTerminal() async {
    var response = await dio.get('/resource', queryParameters: {
      'model': 'Terminal',
      'method': 'all',
    },
        options: Options(
            headers: {
              'Authorization': 'Bearer $_token',
            }
        )
    );
    setState(() {
      _terminal = response.data.length;
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  var _position;
  void _initDashboard () async {
    var position = await _determinePosition();

    setState(() {
      _position = position;
      print('position $_position');
    });

    _getToken();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initDashboard();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SetDateAndDestinationPage()));
        },
        child: const Icon(Icons.playlist_add_check),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [

            _position != null ? Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  child: FlutterMap(options: MapOptions(
                    center: LatLng(_position!.latitude, _position!.longitude),
                    zoom: 15,
                  ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'net.elezerk',
                      ),

                      MarkerLayer(
                        markers: [
                          Marker(
                              point: LatLng(_position!.latitude, _position!.longitude),
                              height: 25,
                              width: 25,
                              builder: (context) => Image.asset('assets/pin.png')
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ): const LinearProgressIndicator(),

            Row(
              children: [
                Expanded(flex: 1,child:  Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.bus_alert, size: 32),
                        Text(
                          "$_bus",
                          style:
                          const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, ),
                        ),
                      ],
                    ),
                  ),
                ),),

                Expanded(flex: 1,child:  Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.route, size: 32),
                        Text(
                          "$_route",
                          style:
                          const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, ),
                        ),
                      ],
                    ),
                  ),
                ),),
                Expanded(flex: 1,child:  Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_city, size: 32),
                        Text(
                          "$_terminal",
                          style:
                          const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, ),
                        ),
                      ],
                    ),
                  ),
                ),),
              ],
            ),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: (){
            //       Navigator.pushNamed(context, 'qr');
            //     },
            //     child: const Text(
            //       'PAY WITH QR'
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: (){},
            //     child: const Text(
            //         'BOOK NOW'
            //     ),
            //   ),
            // ),

            const SizedBox(
              height: 10,
            ),

            Text("BOOKINGS (${_bookings.length})", style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),),
            _fetchingBookings ? const LinearProgressIndicator():SizedBox(
              height: MediaQuery.of(context).size.height * .4,
              child: ListView.builder(itemBuilder: (_, index) {
                return ListTile(
                  title: Text("${_bookings[index]['from']} - ${_bookings[index]['to']}"),
                  subtitle: Text("${_bookings[index]['date']}"),
                  dense: true,
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => TicketDetails(payload: _bookings[index], id: _bookings[index]['id'].toString(),))
                      );
                    },
                    icon: const Icon(Icons.qr_code),
                  ),
                ); 
              }, itemCount: _bookings.length),
            )

            // Text("Welcome user!"),
          ],
        ),
      ),

    );
  }
}
