import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:flutter/src/widgets/framework.dart';

class ClientProfileViewModel extends BaseViewModel {
  MATForms matForms;

  ClientProfileViewModel(BuildContext context, this.matForms) : super(context);
}
