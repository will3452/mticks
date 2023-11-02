import 'package:dio/dio.dart';

var dio = Dio(
  BaseOptions(
    baseUrl: 'https://bus-ticket.elezerk.net/api/',
  ),
);
