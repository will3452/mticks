import 'package:flutter/material.dart';

import '../services/api.dart';

class Buses extends StatefulWidget {
  const Buses({Key? key}) : super(key: key);

  @override
  State<Buses> createState() => _BusesState();
}

class _BusesState extends State<Buses> {

  var _buses = [];

  void _fetchBuses() async {

    var response = await dio.get('/test', queryParameters: {
      'model': 'Bus',
      'method': 'all',
    }
    );
    setState(() {
      _buses = response.data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchBuses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Buses"
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _buses.map((bus) => ListTile(
            title: Text("${bus['plate_number']} (${bus['status']})"),
            subtitle: Text("Type: ${bus['type']} Capacity: ${bus['capacity'] }"),
          )).toList(),
        ),
      ),
    );
  }
}
