import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../services/storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String? _userEmail;
  String? _userToken;
  String? _userId;
  String? _userType;
  String? _userName;


  void _initUser () async {
    String? email = await storage.read(key: 'userEmail');
    String? token = await storage.read(key: 'userToken');
    String? id = await storage.read(key: 'userId');
    String? userType = await storage.read(key: 'userType');
    String? userName = await storage.read(key: 'userName');
    setState(() {
      _userEmail = email ?? '';
      _userToken = token ?? '';
      _userId = id ?? '';
      _userName = userName ?? '';
      _userType = userType ?? '';
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initUser();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Text("Basic Information: "),
            const SizedBox(
              height: 32,
            ),
            const CircleAvatar(
              radius: 32,
              child: Text("W"),
            ),
            const SizedBox(
              height: 24,
            ),
            ListTile(
              title: const Text("Name"),
              trailing: Text("$_userName"),
            ),
            ListTile(
              title: const Text("Email"),
              trailing: Text("$_userEmail"),
            ),
            ListTile(
              title: const Text("Account Type"),
              trailing: Text("$_userType"),
            ),
            QrImageView(data: "$_userId", size: 150),
          ],
        ),
      ),
    ); 
  }
}
