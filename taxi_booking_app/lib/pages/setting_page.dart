import 'package:flutter/material.dart';
import 'package:taxi_booking_app/pages/home_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [

          const SizedBox(
            height: 30,
          ),
          
          ElevatedButton(
                  onPressed: () {
                       Navigator.push(
            context, MaterialPageRoute(builder: (c) => const HomePage()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 49, 206, 241),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 10)),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),

        const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontSize: 54
          ),
        ),
        ],
        ),
      ),
    ),
    );
  }
}