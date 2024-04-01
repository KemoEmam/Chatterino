import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:scholar_chat/helper/show_snack_bar.dart';

void emailValidation(BuildContext context, email) {
  final bool isValid = EmailValidator.validate(email.trim());
  if (isValid) {
  } else {
    showSnackBar(context, 'Please enter a avalid email.');
  }
}
