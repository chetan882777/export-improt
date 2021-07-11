import 'package:agro_worlds/modules/BaseViewModel.dart';
import 'package:agro_worlds/utils/builders/MATForms.dart';
import 'package:flutter/src/widgets/framework.dart';

class AllClientsViewModel extends BaseViewModel {

  MATForms matForms;

  AllClientsViewModel(BuildContext context, this.matForms) : super(context);

}