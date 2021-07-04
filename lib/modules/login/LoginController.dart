import 'package:agro_worlds/network/ApiService.dart';

class LoginController {
  dynamic login(String phone) async {
    print(" releaseLogs123  ====> logging in ");
    var response =
        await ApiService.dio.post("profile/logincheck", queryParameters: {"phone": phone});
    print(" releaseLogs123  ====> response in controller $response");
    print(" releaseLogs123  ====> status ${response.statusCode}");
    if (response.statusCode == 200)
      return response.data;
    else
      return {"error": "Failure", "data": response.data};
  }
}
