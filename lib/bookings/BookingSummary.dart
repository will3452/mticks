import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:intl/intl.dart";
import "package:mticks/home/app.dart";
import "package:mticks/services/api.dart";
import "package:mticks/services/storage.dart";

class BookingSummary extends StatefulWidget {
  BookingSummary(
      {super.key,
      required this.schedule,
      required this.route,
      required this.passenger,
      required this.date,
      required this.day});
  var schedule;
  var route;
  var passenger;
  var date;
  var day;


  @override
  State<BookingSummary> createState() => _BookingSummaryState();
}

class _BookingSummaryState extends State<BookingSummary> {


  bool _isLoading = false;
  var _token;

  void _getToken() async {
    String? token = await storage.read(key: 'userToken');
    setState(() {
      _token = token ?? '';
    });
  }



  Future<void> _submit () async {
    try {
      setState(() {
        _isLoading = true;
      });

      print("_token >> $_token");

      Fluttertoast.showToast(msg: "Submitting...");
      var payload = {
        'date': widget.date,
        'schedule_id': widget.schedule['id'],
        'passenger': widget.passenger,
      };

      print("payload>> $payload");
      var response = await dio.post(
        "/booking",
        data: payload,
        options: Options(headers: {
          'Authorization': 'Bearer $_token',
        }),
      );
      var msg = response.data['message'];
      Fluttertoast.showToast(msg: msg);

      if (msg == 'success') {
        showDialog(context: context, builder: (_) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Proceed to Trip Transaction?"),
            actions: [ElevatedButton(onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => App()));
            }, child: Text("OK"))],
          );
        });
      }


    } catch(err) {
      print('error >> ${err.toString()}');
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
        title: Text("Summary"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.route),
                  title: Text("Route"),
                  subtitle: Text("${widget.route['name']}"),
                  dense: true,
                ),
                ListTile(
                  leading: Icon(Icons.calendar_month),
                  title: Text("Schedule"),
                  subtitle: Text(
                      "${widget.date} ${widget.schedule['departure']} (${widget.day})"),
                  dense: true,
                ),
                ListTile(
                  leading: Icon(Icons.money),
                  title: Text("Total Amount: Passenger x Fare"),
                  subtitle: Text(
                    "${NumberFormat.currency(symbol: "₱ ").format((widget.route['fare'] + int.parse(widget.schedule['bus']['additional_fee'])) * widget.passenger)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  dense: true,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(context: context, builder: (_) {
                          return AlertDialog(
                            title: Text("Confirmation"),
                            content: Text("Are you sure you want to book ticket/s?"),
                            actions: [
                              ElevatedButton(onPressed: _isLoading ? null: (){
                                Navigator.of(context).pop();
                                _submit();
                              }, child: Text("Yes")),
                              ElevatedButton(onPressed: (){
                                Navigator.of(context).pop();
                                setState(() {
                                  _isLoading = false;
                                });
                              }, child: Text("No")),
                            ],
                          );
                        });
                      },
                      child: Text("SUBMIT"),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
