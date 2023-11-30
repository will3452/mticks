import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mticks/bookings/SelectTrip.dart';
import 'package:mticks/services/storage.dart';

import '../services/api.dart';

class SetDateAndDestinationPage extends StatefulWidget {
  const SetDateAndDestinationPage({super.key});

  @override
  State<SetDateAndDestinationPage> createState() =>
      _SetDateAndDestinationPageState();
}

class _SetDateAndDestinationPageState extends State<SetDateAndDestinationPage> {
  var _routeId;
  var _date = "--/--/--";
  var _passenger = 1;
  late String _token;
  var _routes = [];

  Future<void> loadRoutes() async {
    try {
      var response = await dio.get('/resource',
          queryParameters: {
            'model': 'Route',
            'method': 'all',
          },
          options: Options(headers: {
            'Authorization': 'Bearer $_token',
          }));
      setState(() {
        _routes = response.data;
        print("terminal >> $_routes");
      });
    } catch (err) {
      print('err. $err');
    }
  }

  void _getToken() async {
    String? token = await storage.read(key: 'userToken');
    setState(() {
      _token = token ?? '';
    });

    loadRoutes();
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
        title: const Text("BOOK MY TRIP"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Select Trip"),
              DropdownButton(
                isExpanded: true,
                items: _routes.isNotEmpty != 0 ? _routes.map((e) => DropdownMenuItem(
                      value: e['id'],
                      child: Text(e['name'], style: TextStyle(
                        fontSize: 12.0,
                      ),),
                    ),
                ).toList(): [],
                onChanged: (v) {
                  setState(() {
                    _routeId = v;
                  });
                },
                value: _routeId,
              ),
              SizedBox(height: 20,),
              const Text("Select Date:"),
              InkWell(
                child: Text(
                  _date,
                  style: const TextStyle(fontSize: 18),
                ),
                onTap: () async {
                  var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 10)));
                  setState(() {
                    _date = "${date!.month}/${date.day}/${date.year}";
                  });
                },
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: Text("Passenger/s: $_passenger"),
                  ),
                  SizedBox(
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _passenger ++;
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                  ),
                  SizedBox(
                    child: IconButton(
                      onPressed: _passenger == 1 ? null: () {
                        setState(() {
                          _passenger --;
                        });
                      },
                      icon: Icon(Icons.remove),
                    ),
                  )
                ],
              ), 
              SizedBox(height: 20,),
              ElevatedButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) =>  SelectTrip(date: _date, route: _routes.firstWhere((element) => element['id'] == _routeId), passenger: _passenger)));
              } , child: Text("Search"))
            ],
          ),
        ),
      ),
    );
  }
}
