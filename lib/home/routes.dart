import 'package:flutter/material.dart';

import '../services/api.dart';

class Routes extends StatefulWidget {
  const Routes({Key? key}) : super(key: key);

  @override
  State<Routes> createState() => _RouteState();
}

class _RouteState extends State<Routes> {

  var _routes = [];

  void _fetchroutes() async {

    var response = await dio.get('/test', queryParameters: {
      'model': 'Route',
      'method': 'all',
    }
    );
    setState(() {
      _routes = response.data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchroutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Routes"
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _routes.map((route) => ListTile(
            title: Text("${route['name']}"),
            subtitle: Text("Fare: ${route['fare']}"),
          )).toList(),
        ),
      ),
    );
  }
}
