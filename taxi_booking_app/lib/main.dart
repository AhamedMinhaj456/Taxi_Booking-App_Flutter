import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_booking_app/authentication/signup.dart';
import 'package:taxi_booking_app/devoloping_windows/signup.dart';
import 'package:taxi_booking_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taxi_booking_app/authentication/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:taxi_booking_app/controller/auth_controller.dart';
import 'package:taxi_booking_app/pages/account_page.dart';
import 'package:taxi_booking_app/pages/add_payment_card_page.dart';
import 'package:taxi_booking_app/pages/dashboard.dart';
import 'package:taxi_booking_app/pages/login_window/login_screen.dart';
import 'package:taxi_booking_app/pages/payment_page.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,
    // const FirebaseOptions(
  //       apiKey: 'AIzaSyBY8UZ-CDeg0Bk5ISZ6TDpzmKxoHVwDQZM',
  //       appId: "1:362838339117:android:bb299a78f6392c15e412a4",
  //       messagingSenderId: '362838339117',
  //       projectId: 'taxi-booking-app-9d565'
  // ),
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
    //Get.lazyPut(() => DataClass());
  AuthController authController = Get.put(AuthController());
     authController.decideRoute();
     final textTheme = Theme.of(context).textTheme;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RuhunaRide',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  //FirebaseAuth.instance.currentUser ==  null ? const LoginScreenLast(): const Dashboard(),
        const AddPaymentCardScreen(),
       //const PaymentScreen()
        //const SettingPage(),
     
    );
  }
}


