import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'services/api.dart';
import 'services/storage.dart';
class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();

}

class _OtpPageState extends State<OtpPage> {

  String? _token;
  String? _email;
  TextEditingController _code = TextEditingController(text: '');

  void _getToken() async {
    String? token = await storage.read(key: 'userToken');
    String? email = await storage.read(key: 'userEmail');
    setState(() {
      _token = token;
      _email = email;
    });
  }


  void _validateOTP() async {
    try {
      Fluttertoast.showToast(msg: "Submitting...");
      var response = await dio.post(
        "/validate-otp",
        data: {
          'code': _code.text,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $_token',
        }),
      );
      // KDzZM9
      print("KDzZM9");
      Fluttertoast.showToast(msg: "Email verified successfully!");

      await storage.write(key: 'email_verified_at', value: '1');
      Navigator.pushReplacementNamed(context, 'home');
    } catch (error) {
      print("Error $error");
      Fluttertoast.showToast(msg: "Something went wrong!");
    }
  }

  void _resendOtp() async {
    try {
      Fluttertoast.showToast(msg: "Submitting...");
      var response = await dio.post(
        "/send-otp",
        data: {
          'email': _email,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $_token',
        }),
      );

      Fluttertoast.showToast(msg: "OTP has been sent to your email.");
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                label: Text("Please enter OTP sent to your email."),
                icon: Icon(Icons.pin),
              ),
              controller: _code,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ElevatedButton(onPressed: () {
                  _resendOtp();
                }, child: Text("Resend OTP")),
                SizedBox(width: 10,),
                ElevatedButton(onPressed: () async {
                  _validateOTP();
                }, child: Text("Submit Code")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
