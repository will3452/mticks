import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:mticks/services/storage.dart';

import 'services/api.dart';

class BookingDirectoryPage extends StatefulWidget {
  const BookingDirectoryPage({super.key});

  @override
  State<BookingDirectoryPage> createState() => _BookingDirectoryPageState();
}

var dayMap = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday",
];



class _BookingDirectoryPageState extends State<BookingDirectoryPage> {

  var _routes = [];

  var _schedules = [];
  DateTime _initialDate = DateTime.now();
  var _results = [];
  var _token;
  var _route;
  var _day;
  var _date = "--/--/--";
  var _currentWeekDay = -1;
  var _filteredSchedules = [];
  var _time;
  var _searching = false;

  Set<dynamic> _allowedDays = {};

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

  void _fetchSchedules() async {
    var response = await dio.get('/resource',
        queryParameters: {
          'model': 'Schedule',
          'method': 'all',
        },
        options: Options(headers: {
          'Authorization': 'Bearer $_token',
        }));
    setState(() {
      _schedules = response.data;
    });
  }

  void _fetchBookings() async {
    try {

      setState(() {
        _searching = true;
      });
      var payload = {
        'route_id': _route,
        'date': _date,
        'time': _time,
      };

      print("payload >> $payload");

      var response = await dio.get('/booking-filter',
          queryParameters: payload,
          options: Options(headers: {
            'Authorization': 'Bearer $_token',
          }));
      print("response >> $response");
      setState(() {
        _results = response.data;
      });
    } catch(error) {
      print('error! $error');
    } finally {
      setState(() {
        _searching = false;
      });
    }
  }

  void _getToken() async {
    String? token = await storage.read(key: 'userToken');
    setState(() {
      _token = token;
    });
    _fetchSchedules();
    _fetchRoute();
  }




  bool _isDateSelectable(DateTime day) {
    print("day >> $day");
    print("initial >> $_initialDate");
    // if (day.isBefore(_initialDate)) return false;
    var weekday = day.weekday;
    
    return _allowedDays.contains(dayMap[weekday - 1]);
  }


  DateTime getInitialDate(int weekday) {
    DateTime now = DateTime.now();

    // Specify the weekday you want to retrieve (1 for Monday, 2 for Tuesday, and so on)
    int desiredWeekday = weekday; // 1 represents Monday in this example

    DateTime currentDate = DateTime(now.year, now.month, now.day);
    int currentWeekday = currentDate.weekday;

    int daysToAdd = desiredWeekday - currentWeekday;
    if (daysToAdd <= 0) {
      daysToAdd += DateTime.daysPerWeek;
    }

    return currentDate.add(Duration(days: daysToAdd));
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
        title: const Text("Booking Directory"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Search Booking", style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 20,
                )),
                const Text("SELECT ROUTE: "),
                DropdownButton(
                  items: _routes.isNotEmpty ? _routes
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
                      .toList() : [],
                  onChanged: (val) {
                    setState(() {
                      _date = "--/--/--";
                      _time = null;
                      _route = val;
                      var schedules = _schedules.where((e) => e['route_id'] == val).map((e) => e['day']).toList();
                      _allowedDays = schedules.toSet();

                      int minDay = 6;

                      for (var d in _allowedDays.toList()) {
                        if (dayMap.indexOf(d) < minDay) {
                          minDay = dayMap.indexOf(d);
                        }
                      }
                      setState(() {
                        _initialDate = getInitialDate(minDay + 1);
                      });
                    });
                  },
                  value: _route,
                  isExpanded: true,
                ),
                const TextField(
                  decoration: InputDecoration(
                    label: Text("Enter Bus No."),
                    icon: Icon(Icons.numbers),
                  ),
                ),

                const SizedBox(height: 25,),

                const Text("SELECT DATE:"),
                InkWell(
                  child: Text(
                    _date,
                    style: const TextStyle(fontSize: 20),
                  ),
                  onTap: () async {
                    var date = await showDatePicker(
                        selectableDayPredicate: _isDateSelectable,
                        context: context,
                        initialDate: _initialDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 1000)));
                    setState(() {
                      _date = "${date!.month}/${date.day}/${date.year}";
                      _time = null;
                    });

                    int weekday = -1;
                    weekday = date!.weekday;

                    if (weekday != -1) {
                      setState(() {
                        _currentWeekDay = weekday;
                        _filteredSchedules = _schedules.where((element) => element['day'] == dayMap[weekday - 1] && element['route_id'] == _route).toList();
                      });
                    }
                  },
                ),
                const SizedBox(height: 25,),
                const Text("SELECT TIME: "),
                DropdownButton(
                  items: _filteredSchedules.isNotEmpty ? _filteredSchedules
                      .map((e) => DropdownMenuItem(
                    value: e['id'],
                    child: Text(
                      "${e['departure']}",
                      style: TextStyle(
                          fontWeight: (e['id'] == _time)
                              ? FontWeight.bold
                              : FontWeight.w300),
                    ),
                  ))
                      .toList() : [],
                  onChanged: (val) {
                    setState(() {
                      _time = val;
                    });
                  },
                  value: _time,
                  isExpanded: true,
                ),
                ElevatedButton(onPressed: _searching ? null: _fetchBookings , child: Text(_searching ? "Searching..." : "Search")),
                const SizedBox(
                  height: 30,
                ),
                Text("Result (${_results.length})", ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .4,
                  child: ListView.builder(itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.event_seat),
                      title: Text("${_results[index]['user']['name']} - ${_results[index]['seat_numbers']}"),
                    );
                  }, itemCount: _results.length,),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
