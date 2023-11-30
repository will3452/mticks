import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mticks/home/ticket_details.dart';

import '../services/api.dart';
import '../services/storage.dart';

class Booking extends StatefulWidget {
  const Booking({Key? key}) : super(key: key);

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  var _date = "--/--/--";
  var _time = "--:--";
  var _route;
  var _fare = 0;
  var _qty = 0;
  var _token;
  var _routes = [];

  void _getToken() async {
    String? token = await storage.read(key: 'userToken');
    setState(() {
      _token = token;
    });
    _fetchAll();
  }

  void _fetchAll() async {
    _fetchRoute();
  }

  void _fetchRoute() async {
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
    });
  }

  void _submitBooking() async {
    try {
      Fluttertoast.showToast(msg: "Submitting...");
      var response = await dio.post(
        "/booking",
        data: {
          'fare': _fare,
          'time': _time,
          'date': _date,
          'route_id': _route,
          'qty': _qty,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $_token',
        }),
      );

      Fluttertoast.showToast(msg: "Booking successfully!");
      print("${response.data['booking']['id']}");
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TicketDetails(id: response.data['booking']['id'].toString(), payload: response.data['booking'],))
      );
    } catch (error) {
      Fluttertoast.showToast(msg: "Something went wrong!");
    }
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
        title: const Text("Booking form"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("SELECT DATE:"),
                InkWell(
                  child: Text(
                    _date,
                    style: const TextStyle(fontSize: 28),
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
                const SizedBox(
                  height: 20,
                ),
                const Text("SELECT TIME:"),
                InkWell(
                  child: Text(
                    _time,
                    style: const TextStyle(fontSize: 28),
                  ),
                  onTap: () async {
                    var time = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    setState(() {
                      _time = "${time!.hour}:${time.minute}";
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("SELECT ROUTE: "),
                DropdownButton(
                  items: _routes
                      .map((e) => DropdownMenuItem(
                            value: e['id'],
                            enabled: !(e['id'] == _route),
                            child: Text(
                              "${e['name']}",
                              style: TextStyle(
                                  fontWeight: (e['id'] == _route)
                                      ? FontWeight.bold
                                      : FontWeight.w300),
                            ),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _route = val;
                      _fare = _routes.where((element) => _route == element['id']).toList().first['fare'];
                    });
                  },
                  value: _route,
                  isExpanded: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("QUANTITY:"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$_qty",
                      style: const TextStyle(fontSize: 25),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                _qty++;
                              });
                            },
                            icon: const Icon(Icons.add)),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_qty == 1) return;
                              _qty--;
                            });
                          },
                          icon: const Icon(Icons.remove),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("TOTAL FARE:"),
                Text(
                  "₱  ${_route != null ? (_fare * _qty).toStringAsFixed(2) : 0.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 32,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {

                        _submitBooking();
                      },
                      child: const Text("SUBMIT"),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
