import 'package:flutter/material.dart';

void main() {
  runApp(const XClone());
}

class XClone extends StatelessWidget {
  const XClone({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Placeholder(), debugShowCheckedModeBanner: false);
  }
}

class Placeholder extends StatelessWidget {
  const Placeholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
