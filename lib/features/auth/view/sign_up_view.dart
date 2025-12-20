import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:twitterclone/Theme/theme.dart';
import 'package:twitterclone/common/common.dart';
import 'package:twitterclone/constants/constants.dart';
import 'package:twitterclone/features/auth/view/login_view.dart';
import 'package:twitterclone/features/auth/widget/auth_field.dart';

class SignUpView extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpView());
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
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
                  text: "Already have an account? ",
                  children: [
                    TextSpan(
                      text: 'Log in',
                      style: TextStyle(color: Pallete.blueColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(context, LoginView.route());
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
