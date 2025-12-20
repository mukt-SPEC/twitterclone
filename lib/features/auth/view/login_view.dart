import 'package:flutter/material.dart';
import 'package:twitterclone/Theme/theme.dart';
import 'package:twitterclone/common/rounded_small_button.dart';
import 'package:twitterclone/constants/ui_constants.dart';

import '../widget/auth_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final appBar = UiConstants.appBar();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            spacing: 16,
            children: [
              AuthField(
                key: _formKey,
                controller: _emailController,
                hintText: 'Email Address',
                obscureText: false,
              ),
              AuthField(
                key: _formKey,
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              Align(
                alignment: AlignmentGeometry.centerRight,
                child: RoundedSmallButton(
                  onTap: () {},
                  buttonText: 'Done',
                  buttonColor: Pallete.whiteColor,
                  textColor: Pallete.backgroundColor,
                ),
              ),

              RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  children: [TextSpan(text: 'Join now')],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
