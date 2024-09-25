// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praxis_afterhours/app_utils/basic_text_field.dart';
import 'package:praxis_afterhours/constants/colors.dart';
import 'package:praxis_afterhours/errors/flash_error.dart';
import 'package:praxis_afterhours/views/authentication/create_account_view.dart';
import 'package:praxis_afterhours/views/bottom_nav_bar.dart';
import 'package:praxis_afterhours/apis/auth_api.dart';
import 'package:praxis_afterhours/storage/secure_storage.dart';

class SignInView extends StatelessWidget {
  SignInView({super.key});

  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: praxisBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Sign in to your account",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: praxisBlack.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 32),
                BasicTextField(
                  labelText: "Username",
                  fieldType: BasicTextFieldType.username,
                  editingController: usernameController,
                  validatorError: "Please enter your username",
                ),
                const SizedBox(height: 16),
                BasicTextField(
                  labelText: "Password",
                  fieldType: BasicTextFieldType.custom,
                  editingController: passwordController,
                  validatorError: "Please enter your password",
                  obscureText: true,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.poppins(
                        color: praxisBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        var (token, exp, userId) = await logIn(
                          usernameController.text,
                          passwordController.text,
                        );
                        await storage.write(key: "token", value: token);
                        await storage.write(key: "exp", value: exp);
                        await storage.write(key: "user_id", value: userId);
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BottomNavBar(),
                            ),
                          );
                        }
                      } on FormatException {
                        if (context.mounted) {
                          showFlashError(
                              context, 'Invalid username or password');
                        }
                      } catch (err) {
                        if (context.mounted) {
                          showFlashError(context, 'Network error');
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: praxisRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  child: Text(
                    "Log In",
                    style: GoogleFonts.poppins(
                      color: praxisWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: praxisBlack,
                        thickness: 0.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "or",
                        style: GoogleFonts.poppins(
                          color: praxisBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: praxisBlack,
                        thickness: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSocialButton(
                  context,
                  "Sign In With Facebook",
                  "images/facebook.png",
                  const Color(0xFF1877F2),
                  praxisWhite,
                  24,
                  34,
                ),
                const SizedBox(height: 16),
                _buildSocialButton(
                  context,
                  "Sign In With Google",
                  "images/google.png",
                  praxisWhite.withAlpha(200),
                  praxisBlack,
                  24,
                  24,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: GoogleFonts.poppins(
                        color: praxisBlack,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateAccountView(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.poppins(
                          color: praxisRed,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    String text,
    String iconPath,
    Color backgroundColor,
    Color textColor,
    double iconWidth,
    double iconHeight,
  ) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Image.asset(
        iconPath,
        width: iconWidth,
        height: iconHeight,
      ),
      label: Text(
        text,
        style: GoogleFonts.poppins(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        minimumSize: const Size(double.infinity, 60),
      ),
    );
  }
}
