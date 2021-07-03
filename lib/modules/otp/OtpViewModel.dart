import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/providers/FlowDataProvider.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class OtpViewModel extends BaseViewModel {
  late final FlowDataProvider flowDataProvider;

  OtpViewModel(BuildContext context) : super(context) {
    flowDataProvider = Provider.of(context, listen: false);
    print(" ====> OTP " + flowDataProvider.otp);
  }

}