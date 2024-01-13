import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:taxi_booking_app/authentication/signup.dart';
import 'package:taxi_booking_app/global/global_var.dart';
import 'package:taxi_booking_app/methods/common_methods.dart';
import 'package:taxi_booking_app/pages/dashboard.dart';
import 'package:taxi_booking_app/widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetworkAvailabe() {
    cMethods.checkConnectivity(context);
    signInFormValidation();
  }

  signInFormValidation() {
    if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("Please enter a valid email address", context);
    } else if (passwordTextEditingController.text.trim().length < 5) {
      cMethods.displaySnackBar(
          "Your password must have 4 or more characters", context);
    } else {
      signInUser();
    }
  }

  signInUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Login in your account...."),
    );
    final User? userFirebase = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),

      // ignore: body_might_complete_normally_catch_error
    )
            // ignore: body_might_complete_normally_catch_error
            .catchError((errorMessage) {
      Navigator.pop(context);
      cMethods.displaySnackBar(errorMessage.toString(), context);
    }))
        .user;

    if (!context.mounted) return;
    Navigator.pop(context);

    if (userFirebase != null) {
      DatabaseReference usersRef = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(userFirebase.uid);
      usersRef.once().then((snap) {
        if (snap.snapshot.value != null) {
          if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
            userName = (snap.snapshot.value as Map)["name"];
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => const Dashboard()));
          } else {
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar("Your Account has been blocked. \n Contact RuhunaRide", context);
          }
        } else {
          FirebaseAuth.instance.signOut();
          cMethods.displaySnackBar("User not exist", context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Image.asset("assets/images/logo.png"),
          const Text(
            "Login Here",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          //text + button
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                TextField(
                  controller: emailTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: "Email Address",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                      hintText: "Enter Your Email Address",
                      hintStyle: TextStyle(
                        fontSize: 14,
                      )),
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                TextField(
                  controller: passwordTextEditingController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                      fontSize: 14,
                    ),
                    hintText: "Enter Your Password",
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                ElevatedButton(
                  onPressed: () {
                    checkIfNetworkAvailabe();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 49, 206, 241),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 10)),
                  child: const Text(
                    "Log In",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an Account?",
                style: TextStyle(color: Colors.grey),
              ),

              // text button
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (C) => const SignupScreen()));
                  },
                  child: const Text(
                    "Register here",
                    style: TextStyle(color: Colors.grey),
                  ))
            ],
          )
        ]),
      ),
    ));
  }
}
