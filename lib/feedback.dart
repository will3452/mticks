import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'services/api.dart';
import 'services/storage.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  var _stars = 2.5;
  var _comments = "";
  var _feedbacks = [];
  TextEditingController _commentController = TextEditingController(text: "");
  String? _token;

  void _getToken() async {
    String? token = await storage.read(key: 'userToken');
    setState(() {
      _token = token;
    });
    initFeedback();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getToken();
  }

  void _submitFeedback() async {
    try {
      Fluttertoast.showToast(msg: "Submitting...");
      var response = await dio.post(
        "/feedback",
        data: {
          'comment': _comments,
          'star': _stars,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $_token',
        }),
      );

      Fluttertoast.showToast(msg: "Feedback has been submitted.");
      _commentController.clear();
      setState(() {
        _comments = '';
        _stars = 2.5;
      });


    } catch (error) {
      Fluttertoast.showToast(msg: "Something went wrong!");
    }
  }

  void initFeedback () async {
    var response = await dio.get('/resource', queryParameters: {
      'model': 'Feedback',
      'method': 'all',
    },
        options: Options(
            headers: {
              'Authorization': 'Bearer $_token',
            }
        )
    );

    setState(() {
      _feedbacks = response.data;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                RatingBar.builder(
                  initialRating: _stars,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _stars = rating;
                    });
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    label: Text("Comments"),
                    icon: Icon(Icons.comment),
                  ),
                  controller: _commentController,
                  onChanged: (v) {
                    setState(() {
                      _comments = v;
                    });
                  },
                ),

                ElevatedButton(onPressed: () {
                   if (_comments.isEmpty) {
                      Fluttertoast.showToast(msg: "Please write comment.");
                      return;
                   }
                   _submitFeedback();
                } , child: const Text("Submit")),
                SizedBox(
                  height: 20,
                ),
                Text("Feedback"),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .5,
                  child: ListView.builder(itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.star),
                      title: Text("${_feedbacks[index]['category']} "),
                      subtitle: Text("${_feedbacks[index]['body']}"),
                    );
                  }, itemCount: _feedbacks.length,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
