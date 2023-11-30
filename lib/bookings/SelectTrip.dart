import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mticks/booking_directory.dart';
import 'package:mticks/bookings/BookingSummary.dart';
import 'package:mticks/services/api.dart';

class SelectTrip extends StatefulWidget {
  SelectTrip({super.key, required this.date, required this.route, required this.passenger});
  var date;
  var route;
  var passenger; 
  @override
  State<SelectTrip> createState() => _SelectTripState();
}

class _SelectTripState extends State<SelectTrip> {

  var _day = "Monday";
  var _offers = []; 

  void _setDay() {

    var dd = widget.date.toString().split('/');
    print("$dd");
    var d = DateTime(int.parse(dd[2]), int.parse(dd[0]), int.parse(dd[1])).weekday;
    setState(() {
      _day = dayMap[d-1];

      _loadOffers();
    });
  }
  
  Future<void> _loadOffers() async {
    try {
      var response = await dio.get("/get-offers", queryParameters: {
        "day": _day,
        "route_id": widget.route['id'],
      });

      setState(() {
        _offers = response.data;
      });
      print("response >> $_offers");
    } catch (error) {
      print('error'); 
    }
  }

  int _getAvailable(offer) {
    var busCap = offer['bus']['capacity'];
    var books = (offer['bookings'] ?? [])
        .where( (b) => b['date'] == widget.date && b['status'] == 'APPROVED')
        .toList();

    int occupiedSeat = 0;

    for(int i = 0; i < books.length; i++) {
      occupiedSeat = books[i]['qty'] + occupiedSeat;
      print("books[i]['qty'] >> ${books[i]['qty']}");
    }
    print("offer >> ${occupiedSeat} / ${busCap}");
    return busCap - occupiedSeat;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _setDay();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SELECT OFFER"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * .8,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("$_day", style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          )),
                          Text("${widget.date}"),
                          Text("${widget.route['name']}", style: TextStyle(
                              fontSize: 12,
                          )),
                          Text("Total Passenger: ${widget.passenger}", style: TextStyle(
                            fontSize: 12,
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .5,
                  child: _offers.isNotEmpty ? ListView.builder(itemBuilder: (context, index) {
                    var offer = _offers[index];
                    return ListTile(

                      dense: true,
                      title: Text("${offer['bus']['type']}"),
                      subtitle:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Fare: ${NumberFormat.currency(symbol: "₱ ").format(offer['route']['fare'] + int.parse(offer['bus']['additional_fee']))}"),
                          Text("Departure: ${offer['departure']}"),
                          Text("Available: ${_getAvailable(offer).toString()}")
                        ],
                      ),
                      isThreeLine: true,
                      trailing:  ElevatedButton(
                        child: const Text("Book Now"),
                        onPressed: _getAvailable(offer) < widget.passenger ? null: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => BookingSummary(
                            passenger: widget.passenger,
                            route: widget.route,
                            schedule: offer,
                            date: widget.date,
                            day: _day,
                          )));
                        },
                      ),
                    );
                  }, itemCount: _offers.length,): const Text("No Schedule"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
