import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:praxis_afterhours/app_utils/basic_text_field.dart';
import 'package:praxis_afterhours/constants/colors.dart';
import 'package:praxis_afterhours/errors/flash_error.dart';
import 'package:praxis_afterhours/storage/secure_storage.dart';
import 'package:praxis_afterhours/views/bottom_nav_bar.dart';
import 'package:praxis_afterhours/apis/auth_api.dart';

class CreateAccountView extends StatelessWidget {
  CreateAccountView({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  "Create an Account",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: praxisBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Sign up to get started",
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
                  validatorError: "Please enter a username",
                ),
                const SizedBox(height: 16),
                BasicTextField(
                  labelText: "Full Name",
                  fieldType: BasicTextFieldType.custom,
                  editingController: fullNameController,
                  validatorError: "Please enter your name",
                ),
                const SizedBox(height: 16),
                BasicTextField(
                  labelText: "Email Address",
                  fieldType: BasicTextFieldType.email,
                  editingController: emailController,
                  validatorError: "Please enter your email",
                ),
                const SizedBox(height: 16),
                BasicTextField(
                  labelText: "Password",
                  fieldType: BasicTextFieldType.password,
                  editingController: passwordController,
                  validatorError: "Please enter a password",
                  obscureText: true,
                ),
                const SizedBox(height: 8),
                Text(
                  "Your password must have:",
                  style: GoogleFonts.poppins(
                    color: praxisBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "• At least 8 characters",
                  style: GoogleFonts.poppins(
                    color: praxisBlack,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "• At least one number",
                  style: GoogleFonts.poppins(
                    color: praxisBlack,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "• At least one special character",
                  style: GoogleFonts.poppins(
                    color: praxisBlack,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        var (token, exp, userId) = await signUp(
                          usernameController.text,
                          emailController.text,
                          fullNameController.text,
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
                          showFlashError(context, 'Invalid credentials');
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
                    "Sign Up",
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
                  "Sign Up With Facebook",
                  "images/facebook.png",
                  const Color(0xFF1877F2),
                  praxisWhite,
                  24,
                  34,
                ),
                const SizedBox(height: 16),
                _buildSocialButton(
                  context,
                  "Sign Up With Google",
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
                      "Already have an account?",
                      style: GoogleFonts.poppins(
                        color: praxisBlack,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Sign In",
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
