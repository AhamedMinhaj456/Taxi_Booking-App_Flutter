import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taxi_booking_app/authentication/signup.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyBY8UZ-CDeg0Bk5ISZ6TDpzmKxoHVwDQZM',
        appId: "1:362838339117:android:bb299a78f6392c15e412a4",
        messagingSenderId: '362838339117',
        projectId: 'taxi-booking-app-9d565'),
  );

  await Permission.locationWhenInUse.isDenied.then((valueOfPermission) {
    if (valueOfPermission) {
      Permission.locationWhenInUse.request();
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RuhunaRide',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignupScreen(),
    );
  }
}
