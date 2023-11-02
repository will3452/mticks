import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mticks/services/storage.dart';

import '../services/api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _userEmail = TextEditingController();
  TextEditingController _userPassword = TextEditingController();

  bool _loading = false;

  void save() async {
    setState(() {
      _loading = true;
    });
    try {
      var data = await dio.post('/login', data: {
        "email": _userEmail.text,
        "password": _userPassword.text,
      });


      Fluttertoast.showToast(msg: "Login success!");

      // save to storage

      await storage.write(key: 'userName', value: data.data['user']['name']);
      await storage.write(key: 'userType', value: data.data['user']['type']); 
      await storage.write(key: 'userEmail', value: data.data['user']['email']);
      await storage.write(key: 'userId', value: "${data.data['user']['id']}");
      await storage.write(key: 'userToken', value: data.data['token']);
      print("data ${data.data['token']}");
      Navigator.pushReplacementNamed(context, 'home');
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
      Fluttertoast.showToast(msg: "Login failed");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        "M-TICKS",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      Text("Mobile Bus Ticketing System",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          label: Text("Email"),
                          icon: Icon(Icons.email),
                        ),
                        controller: _userEmail,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          label: Text("Password"),
                          icon: Icon(Icons.password),
                        ),
                        obscureText: true,
                        controller: _userPassword,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            try {
                              if (_userEmail.text.isEmpty) throw Exception("email is required.");
                              if (_userPassword.text.isEmpty) throw Exception("password is required.");
                              save();
                            } catch (error) {
                              Fluttertoast.showToast(msg: error.toString());
                            }
                          },
                          child: Text("LOGIN"),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.redAccent),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white)),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      MaterialButton(
                        onPressed: () {},
                        child: Text("OR"),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, 'register');
                          },
                          child: Text("REGISTER"),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.yellow)),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
