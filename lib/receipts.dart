import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mticks/home/app.dart';
import 'package:mticks/services/api.dart';

import 'services/storage.dart';

class ReceiptsPage extends StatefulWidget {
  const ReceiptsPage({super.key});

  @override
  State<ReceiptsPage> createState() => _ReceiptsPageState();
}

class _ReceiptsPageState extends State<ReceiptsPage> {
  TextEditingController _reference = TextEditingController(text: '');
  PlatformFile? _file = null;
  Future<void> submit() async {
    print("reference >> ${_reference.text}");
    try {
      FormData fd = FormData.fromMap({
        'file': await MultipartFile.fromFile(_file!.path ?? ''),
        'reference': _reference.text,
      });

      String? token = await storage.read(key: 'userToken');

      var response = await dio.post(
        '/upload-receipt',
        data: fd,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      // set up the button
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (e) => const App()));
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Success"),
        content: Text("Success, Your request has been submitted, please wait for approval."),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );

      print("response >> $response");
    } catch (e) {
      print("error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receipts"),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upload New Receipt",
                  style: TextStyle(
                    fontSize: 19,
                  ),
                ),
                TextField(
                  controller: _reference,
                  decoration: InputDecoration(
                    label: Text("Reference No."),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['png', 'jpg', 'jpeg'],
                    );

                    print("file picked >> ${result!.files.first.path}");

                    if (result != null) {
                      _file = result.files.first;
                      print("_file ${_file}");
                    }
                  },
                  child: Text( _file != null ? _file!.path ?? '' :  "Click here to choose file.",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      submit();
                    },
                    child: Text("Submit"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
