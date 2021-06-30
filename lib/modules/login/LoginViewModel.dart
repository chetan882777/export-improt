import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginViewModel extends BaseViewModel {

  static const String ERROR_MAINTENANCE = 'maintenance';
  static const String ERROR_NETWORK = 'network error';
  static const String ERROR_UNKNOWN = 'unknown error';
  static const String ERROR_MAINTENANCE_DESC_KEY = 'errorDesc';

  login(Map<String, dynamic> loginDetails) {}

}