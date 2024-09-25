import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum BasicTextFieldType {
  email,
  password,
  username,
  custom,
}

class BasicTextField extends StatelessWidget {
  final TextEditingController editingController;
  final String labelText;
  final BasicTextFieldType fieldType;
  final String validatorError;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function(String)? onChange;

  const BasicTextField({
    super.key,
    required this.editingController,
    required this.labelText,
    this.fieldType = BasicTextFieldType.custom,
    required this.validatorError,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChange,
  });

  String? validatorFunction(String? value) {
    if (value == null || value.isEmpty) {
      return validatorError;
    }
    switch (fieldType) {
      case BasicTextFieldType.email:
        final emailRegex =
            RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
        if (!emailRegex.hasMatch(value)) {
          return 'Invalid email format';
        }
        break;
      case BasicTextFieldType.password:
        if (value.length < 6) {
          return 'Password should be at least 6 characters long';
        }

        final passwordRegex = RegExp(
            r'(?=.*?[a-z])(?=.*?[0-9])(?=.*?[`~!@#$%^&*()\-_=+[{\]}\\|";:,<.>\/?]).{8,}');

        if (!passwordRegex.hasMatch(value)) {
          return 'Invalid password';
        }
        break;
      case BasicTextFieldType.username:
        if (value.length < 3) {
          return 'Username should be at least 3 characters long';
        }
        break;
      case BasicTextFieldType.custom:
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validatorFunction,
      controller: editingController,
      onChanged: onChange,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(),
        border: const UnderlineInputBorder(),
      ),
    );
  }
}
