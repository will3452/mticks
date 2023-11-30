import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mticks/services/api.dart';
import 'package:mticks/services/storage.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  var _userEmail = '';
  var _userToken = '';
  var _userId = '';
  var _loading = true;
  double _balance = 0;
  var _transactions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initEmail();
  }

  void initEmail () async {
    String? email = await storage.read(key: 'userEmail');
    String? token = await storage.read(key: 'userToken');
    String? id = await storage.read(key: 'userId');
    setState(() {
      _userEmail = email ?? '';
      _userToken = token ?? '';
      _userId = id ?? '';
    });

    initTransactions();
  }

  void initTransactions () async {
    print("token: $_userToken");
    var response = await dio.get('/resource', queryParameters: {
      'model': 'Transaction',
      'method': 'all',
    },
      options: Options(
        headers: {
          'Authorization': 'Bearer $_userToken',
        }
      )
    );

    setState(() {
      _transactions = (response.data).where((element) => "${element['user_id']}" == _userId).toList();
      for (var element in _transactions) {
        if (element['bound'] == 'IN') {
          _balance += double.parse(element['amount']);
        } else {
          _balance -= double.parse(element['amount']);
        }
      }

      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 64,
              ),
              const Text("Your current Balance:"),
               ! _loading ? Text(
                "₱ ${_balance.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 32),
              ): const Text("--", style: TextStyle(fontSize: 32),),
              const SizedBox(
                height: 20,
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     showDialog(context: context, builder: (_)  {
              //       return AlertDialog(
              //         backgroundColor: Colors.white,
              //         content: SizedBox(
              //           width: 200,
              //           height: 200,
              //           child: Center(
              //             child: QrImageView(
              //               data: 'https://bus-ticket.elezerk.net/api/top-up/${_userEmail}',
              //               version: QrVersions.auto,
              //               size: 200.0,
              //             ),
              //           ),
              //         ),
              //       );
              //     });
              //   },
              //   child: const Text("TOP UP"),
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .7,
                child: ListView.builder(itemBuilder: (_, index)  {
                  var item =_transactions[index];
                  return ListTile(
                    dense: true,
                    leading: item['bound'] == 'IN' ? const Icon(Icons.add, color: Colors.green): const Icon(Icons.remove, color: Colors.red,),
                    title: Text("${item['amount']}"),
                    subtitle: Text("${item['type']}"),
                    trailing: Text("${item['created_at']}"),
                  );
                }, itemCount: _transactions.length, ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
