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
}