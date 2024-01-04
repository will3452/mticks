
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
  final TextEditingController _userEmail = TextEditingController();
  final TextEditingController _userPassword = TextEditingController();

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
      await storage.write(key: 'email_verified_at', value: data.data['user']['email_verified_at']);
      print("email_verified_at-> ${data.data['user']['email_verified_at']}");
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
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        "M-TICKS",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      const Text("Mobile Bus Ticketing System",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          label: Text("Email"),
                          icon: Icon(Icons.email),
                        ),
                        controller: _userEmail,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          label: Text("Password"),
                          icon: Icon(Icons.password),
                        ),
                        obscureText: true,
                        controller: _userPassword,
                      ),
                      const SizedBox(
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
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.redAccent),
                              foregroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white)),
                          child: const Text("LOGIN"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      MaterialButton(
                        onPressed: () {},
                        child: const Text("OR"),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, 'register');
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.yellow)),
                          child: const Text("REGISTER"),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
