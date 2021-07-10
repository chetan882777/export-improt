import 'dart:convert';

import 'package:agro_worlds/models/ListBuilder.dart';
import 'package:agro_worlds/models/Role.dart';
import 'package:agro_worlds/models/User.dart';
import 'package:agro_worlds/utils/SharedPrefUtils.dart';
import 'package:dio/dio.dart';

class ApiService {

  static final Dio dio = new Dio(
    BaseOptions(
      baseUrl: getEnvURL(),
      connectTimeout: 45000,
      receiveTimeout: 45000,
    ),
  );

  static String getEnvURL() {
    String env = "DEV";
    switch (env) {
      case "PROD":
        return "";
      case "DEV":
        return "https://i-engage.in.net/dev2/agroworlds/api/";
      default:
        return "https://i-engage.in.net/dev2/agroworlds/api/";
    }
  }

  static Future<List<Role>> rolesList() async {
    var response =
    await ApiService.dio.post("profile/roles");
    if (response.statusCode == 200)
      return ListBuilder.fromJson(json.decode(response.data), LIST_TYPE_ROLE).roleList;
    else
      return [];
  }


  static Future<User> getUser() async {
    var response =
    await ApiService.dio.post("profile", queryParameters: {
      "id" : await SharedPrefUtils.getUserId()
    });
    if (response.statusCode == 200)
      return User.fromJson(json.decode(response.data)["data"]);
    else
      return User.error();
  }



}