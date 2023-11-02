
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mticks/services/api.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
   TextEditingController _userName = TextEditingController();
   TextEditingController _userEmail = TextEditingController();
   TextEditingController _userPassword = TextEditingController();
   bool _loading = false;
   void save() async {
     setState(() {
       _loading = true;
     });
     try {
       var data = await dio.post('/register', data: {
         "name": _userName.text,
         "email": _userEmail.text,
         "password": _userPassword.text,
       });

       Fluttertoast.showToast(msg: "Registration success!");
       print("data $data");
     } catch (error) {
       Fluttertoast.showToast(msg: error.toString());
       Fluttertoast.showToast(msg: "Registration failed");
     } finally {
       setState(() {
         _loading = false;
       });
     }
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _loading ? Center(
          child: CircularProgressIndicator(),
        ): SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text("M-TICKS",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),),
                  const Text("Register Now",
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
                      label: Text("Name"),
                      icon: Icon(Icons.info),
                    ),
                    controller: _userName,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      label: Text("Email"),
                      icon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: _userEmail,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(

                    decoration: const InputDecoration(
                        label: Text("Password"), icon: Icon(Icons.password)),
                    obscureText: true,
                    controller: _userPassword,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: ()  {
                        try {
                          if (_userName.text.isEmpty) throw Exception('Name is required.');
                          if (_userEmail.text.isEmpty) throw Exception('Email is required.');
                          if (_userPassword.text.isEmpty) throw Exception('Password is required.');

                          save();
                        } catch (error) {
                            Fluttertoast.showToast(msg: error.toString());
                        }
                      },
                      child: const Text("REGISTER NOW"),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith((states) => Colors.redAccent),
                          foregroundColor: MaterialStateColor.resolveWith((states) => Colors.white)
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  MaterialButton(onPressed: () {}, child: const Text("OR"),),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, 'login');
                      },
                      child: const Text("Already Have an Account?"),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith((states) => Colors.yellow)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
