import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(10),
        child: Column(
          children: [

          Image.asset(
            "assets/images/logo.png"
          ),

         const Text(
            "Create user Account",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          ],
        ),
        ),
      ),
    );
  }
}