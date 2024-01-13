import 'package:flutter/material.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => TripsePageState();
}

class TripsePageState extends State<TripsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Trips",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24
          ),
        ),
      ),
    );
  }
}