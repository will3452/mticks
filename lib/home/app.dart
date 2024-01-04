import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mticks/booking_directory.dart';
import 'package:mticks/feedback.dart';
import 'package:mticks/home/buses.dart';
import 'package:mticks/home/dashboard.dart';
import 'package:mticks/home/profile.dart';
import 'package:mticks/home/routes.dart';
import 'package:mticks/home/wallet.dart';
import 'package:mticks/otp.dart';
import 'package:mticks/receipts.dart';
import 'package:mticks/terms_and_condition.dart';
import 'package:mticks/trip_histories.dart';

import '../services/storage.dart';
import 'Scanner.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _menu = [
    const ProfilePage(),
    const DashboardPage(),
    const WalletPage(),
  ];
  var _currentIndex = 1;
  String? _userName;
  String? _userEmail;
  String? _userId;
  String? _email_verified_at;
  String? _userType;

  void _loadAccount() async {
    String? userName = await storage.read(key: 'userName');
    String? userType = await storage.read(key: 'userType');
    String? userEmail = await storage.read(key: 'userEmail');
    String? userId = await storage.read(key: 'userId');
    String? email_verified_at = await storage.read(key: 'email_verified_at');

    setState(() {
      _userEmail = userEmail;
      _userName = userName;
      _userId = userId;
      _userType = userType;
      _email_verified_at = email_verified_at;
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
              leading: const Icon(Icons.directions_bus_filled),
              title: const Text("BUSES"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const Buses())
                );
              },
            ),
             ListTile(
              leading: const Icon(Icons.route),
              title: const Text("ROUTES"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const Routes())
                );
              },
            ),
            if (_userType == 'DRIVER') ListTile(
              leading: const Icon(Icons.event_seat),
              title: const Text("BOOKING RECORDS"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const BookingDirectoryPage())
                );
              },
            ),
            if (_userType == 'CONDUCTOR') ListTile(
              leading: const Icon(Icons.scanner),
              title: const Text("SCAN"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const Scanner())
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text("FEEDBACK"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FeedbackPage())
                );
              }
            ),
            ListTile(
                leading: const Icon(Icons.history),
                title: const Text("TRIP HISTORY"),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TripPage())
                  );
                }
            ),
            ListTile(
              leading: const Icon(Icons.directions_bus_filled),
              title: const Text("TERMS & CONDITIONS"),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TermsAndCondition())
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
        child: _email_verified_at == null ? OtpPage() : _menu[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (_email_verified_at == null) {
            Fluttertoast.showToast(msg: "Please verify your email.");
            return;
          }
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
              ),
          ),
        ],
      ),
    );
  }
}
