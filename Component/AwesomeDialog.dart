import 'package:awesome_dialog/awesome_dialog.dart';
Future customDialog(context,String title,String desc,DialogType dialogType,){
  return AwesomeDialog(
    context: context,
    dialogType: dialogType,
    animType: AnimType.rightSlide,
    title: title,
    desc: desc,
  ).show();
}