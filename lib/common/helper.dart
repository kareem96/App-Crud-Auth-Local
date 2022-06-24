import 'package:flutter/material.dart';
import 'package:toast/toast.dart';


alertDialog(BuildContext context, Widget msg) {
  /*Toast.show(msg, textStyle: context, duration: Toast.lengthShort, gravity: Toast.bottom);*/
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: msg));
}

validateEmail(String email) {
  final emailReg = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  return emailReg.hasMatch(email);
}