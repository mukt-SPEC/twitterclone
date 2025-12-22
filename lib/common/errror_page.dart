import 'package:flutter/material.dart';

class Errorpage extends StatelessWidget {
  final String errorText;
  const Errorpage({super.key, required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ErrorText(errorText: errorText)),
    );
  }
}

class ErrorText extends StatelessWidget {
  final String errorText;
  const ErrorText({super.key, required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(errorText));
  }
}
