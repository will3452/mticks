import 'package:flutter/material.dart';
import 'package:mticks/home/buses.dart';
import 'package:mticks/home/dashboard.dart';
import 'package:mticks/home/profile.dart';
import 'package:mticks/home/routes.dart';
import 'package:mticks/home/wallet.dart';
import 'package:mticks/receipts.dart';

import '../services/storage.dart';
import 'Scanner.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var _menu = [
    const ProfilePage(),
    const DashboardPage(),
    const WalletPage(),
  ];
  var _currentIndex = 1;
  String? _userName;
  String? _userEmail;
  String? _userId;
  String? _userType;

  void _loadAccount() async {
    String? userName = await storage.read(key: 'userName');
    String? userType = await storage.read(key: 'userType');
    String? userEmail = await storage.read(key: 'userEmail');
    String? userId = await storage.read(key: 'userId');

    setState(() {
      _userEmail = userEmail;
      _userName = userName;
      _userId = userId;
      _userType = userType;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(

              padding: EdgeInsets.zero,

              child: UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                ),

                accountName: Text(_userName ?? "user name"),
                accountEmail: Text(_userEmail ?? "user email"),
                currentAccountPicture: CircleAvatar(
                  child: Text(_userName![0], style: const TextStyle(
                    fontSize: 30,
                  ),),
                ),
                currentAccountPictureSize: const Size(50, 50),
              ),
            ),
             ListTile(
              leading: Icon(Icons.directions_bus_filled),
              title: Text("BUSES"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Buses())
                );
              },
            ),
             ListTile(
              leading: Icon(Icons.route),
              title: Text("ROUTES"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Routes())
                );
              },
            ),
            if (_userType == 'CONDUCTOR') ListTile(
              leading: Icon(Icons.scanner),
              title: Text("SCAN"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Scanner())
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leadingWidth: 40,
        title: const Text(
          "M-Ticks",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              print("HELLO");
              Navigator.push(context, MaterialPageRoute(builder: (e) => const ReceiptsPage(),),);
            },
            icon: const Icon(Icons.list),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: _menu[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts),
              label: "Profile",
              activeIcon: Icon(
                Icons.manage_accounts,
                size: 40,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Dashboard",
              activeIcon: Icon(
                Icons.dashboard,
                size: 40,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: "Wallet",
              activeIcon: Icon(
                Icons.wallet,
                size: 40,
              )),
        ],
      ),
    );
  }
}
