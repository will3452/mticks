import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../services/api.dart';
import '../services/storage.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  String? _transaction = 'LOAD';
  String? _amount = '';
  String? _token = '';

  void _getToken() async {
    String? token = await storage.read(key: 'userToken');
    setState(() {
      _token = token;
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text("SELECT TRANSACTION: "),
              DropdownButton(
                items: const [
                DropdownMenuItem(value: "LOAD",child: Text("LOAD"),),
                DropdownMenuItem(value: "PAYMENT",child: Text("PAYMENT"),),
              ],
                onChanged: (value){
                  setState(() {
                    _transaction = value;
                  });
              }, isExpanded: true,
              value: _transaction ?? 'LOAD'),
              const SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter Amount',
                ),
                onChanged: (value) {
                  setState(() {
                    _amount = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _transaction != null &&  _transaction != null ?  () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => QRViewExample(amount: _amount, transaction: _transaction, token: _token, ),
                  ));
                }: null,
                child: const Text('SCAN'),
                ),
              ),
            ],
          ),
        ),
      ),
    ); 
  }
}


class QRViewExample extends StatefulWidget {
   QRViewExample({Key? key, required this.transaction , required this.amount, required this.token}) : super(key: key);

  String? transaction;
  String? amount;
  String? token;

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  int _count = 0;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      // setState(() {
      //   result = scanData;
      //   print('result >> ${result!.code}');
      // });

      if (scanData.code != null) {
        controller.stopCamera();
        setState(() {
          _count ++;
        });
      }

      dynamic data = {
        "model": "Transaction",
        "method": "create",
        "payload": {
          "bound": widget.transaction == 'LOAD' ? 'IN': 'OUT',
          'type': widget.transaction,
          'amount': widget.amount,
          'user_id': scanData.code,
          'status': 'SUCCESS',
        },
      };

      print("data >> $data");

      if (_count == 1) {
        var response = await dio.post('/resource',
            data: data,
            options: Options(headers: {
              'Authorization': 'Bearer ${widget.token}',
            }));

        Fluttertoast.showToast(msg: "Done!");

        Navigator.push(context, MaterialPageRoute(builder: (_) => const Scanner()));

      }



    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
