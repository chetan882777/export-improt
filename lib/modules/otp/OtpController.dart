import 'package:agro_worlds/network/ApiService.dart';

class OtpController {
  dynamic loginCheck(String otp) async {
    var response = await ApiService.dio.get("profile/logincheck", queryParameters: {
      "otp" : otp
    });
    if (response.statusCode == 200)
      return response.data;
    else
      return {"error": "Failure", "data": response.data};
  }
}