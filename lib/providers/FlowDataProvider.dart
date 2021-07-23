import 'package:agro_worlds/models/User.dart';

class FlowDataProvider {
  final String NA = "N/A";
  late String otp;
  late String phone;
  late String id;
  late User user;
  late String currClientId;
  late Map<String, dynamic> currClient;

  FlowDataProvider() {
    id = NA;
    otp = NA;
    phone = NA;
    currClientId = NA;
    user = User.error();
  }
}