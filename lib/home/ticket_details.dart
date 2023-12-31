import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketDetails extends StatefulWidget {
  final String id;
  final dynamic payload;
  const TicketDetails({Key? key, required this.id, required this.payload}) : super(key: key);

  @override
  State<TicketDetails> createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TICKET GENERATED"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              QrImageView(data: widget.id, size: 150),
              ListTile(
                title: const Text("Route"),
                trailing: Text("${widget.payload['from']} - ${widget.payload['to']}"),
              ),
              ListTile(
                title: const Text("Date"),
                trailing: Text("${widget.payload['date']}"),
              ),
              ListTile(
                title: const Text("Time"),
                trailing: Text("${widget.payload['time']}"),
              ),
              ListTile(
                title: const Text("Total Fare"),
                trailing: Text("₱ ${(int.parse(widget.payload['fare']) * widget.payload['qty']).toStringAsFixed(2)}"),
              ),
              ListTile(
                title: const Text("Quantity"),
                trailing: Text("${widget.payload['qty']}"),
              ),
              ListTile(
                title: const Text("Status"),
                trailing: Text("${widget.payload['status']}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
