import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'services/api.dart';
import 'services/storage.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {

  var _bookings = [];
  String? _token;
  String? _id;

  void _getToken() async {
    String? token = await storage.read(key: 'userToken');
    String? id = await storage.read(key: 'userId');
    setState(() {
      _token = token;
      _id = id;
    });
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
      // _bookings = response.data;
      _bookings = response.data.where((e) => '${e['user_id']}' == _id ).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getToken();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip Histories"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Trip as of ${DateTime.now()}",
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .9,
                  child: ListView.builder(itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      leading: Icon(Icons.history),
                      title: Text("${_bookings[index]['date']} ~ ${_bookings[index]['time']}"),
                      subtitle: Text("${_bookings[index]['from']} - ${_bookings[index]['to']}", style: TextStyle(fontSize: 10),),
                    );
                  }, itemCount: _bookings.length,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
