import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxi_booking_app/global/global_var.dart';
import 'package:taxi_booking_app/methods/common_methods.dart';
import 'package:taxi_booking_app/pages/dashboard.dart';
import 'package:taxi_booking_app/pages/forgetpw_page.dart';
import 'package:taxi_booking_app/pages/login_window/create_new_account.dart';
import 'package:taxi_booking_app/widgets/Login_widgets/background_image.dart';
import 'package:taxi_booking_app/widgets/Login_widgets/password_input.dart';
import 'package:taxi_booking_app/widgets/Login_widgets/rounded_button.dart';
import 'package:taxi_booking_app/widgets/Login_widgets/text_field_input.dart';
import 'package:taxi_booking_app/widgets/loading_dialog.dart';
import './pallete.dart';

class LoginScreenLast extends StatefulWidget {
  const LoginScreenLast({super.key});

  @override
  State<LoginScreenLast> createState() => _LoginScreenLastState();
}

class _LoginScreenLastState extends State<LoginScreenLast> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();
  late Color myColor;
  late Size mediaSize;
  bool rememberUser = false;

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
          LoadingDialog(messageText: "Login in your account.."),
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
            cMethods.displaySnackBar(
                "Your Account has been blocked. \n Contact RuhunaRide",
                context);
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
    return Stack(
      children: [
        const BackgroundImage(
          image: 'assets/images/taxi.jpg',
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              const Flexible(
                child: Center(
                  child: Text(
                    'RuhunaRide',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [const SizedBox(
                      height: 20,
                    ),

                     SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: emailTextEditingController,
                    //obscureText: true,
                    style: const TextStyle(color: Colors.white), // Set the input text color to white
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        FontAwesomeIcons.envelope,
                        color: Colors.white,
                      ),
                      labelText: "Email Address",
                      labelStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      hintText: "Enter Your Email Address",
                      hintStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      // Set text color for user typing
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.white, // Set text color when not focused
                        ),
                      ),
                    ),
                  ),
                ),

                  const SizedBox(
                      height: 25,
                    ),

                                    SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: passwordTextEditingController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white), // Set the input text color to white
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.key,
                        color: Colors.white,
                      ),
                      labelText: "Password",
                      labelStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      hintText: "Enter Your Password",
                      hintStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      // Set text color for user typing
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Colors.white, // Set text color when not focused
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (C) => const ForgetPasswordPage())),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                      ),
                      
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                   RoundedButton(
                    
                    buttonName: 'Login',
                    onPressed: () {
                      checkIfNetworkAvailabe();
                    }
    
    
                    
                    
                  ),
                  const SizedBox(height: 20),
                  
              
                  // Text with lines before and after
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        height: 1,
                        width: 50, // Width of the line before text
                        color: Colors.white,
                      ),
                      const Text(
                        'Or Login With ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        height: 1,
                        width: 50, // Width of the line after text
                        color: Colors.white,
                      ),
                    ],
                  ),
                
                   Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: (){}, icon:const Icon(FontAwesomeIcons.facebook,size: 40,),
                   ),
                    const SizedBox(width: 20),

                   //Tab(icon: Image.asset("assets/images/facebook.png")),
                   IconButton(onPressed: (){}, icon:const Icon(FontAwesomeIcons.instagram,size: 40,),
                        
                    ),
                     const SizedBox(width: 20),
                     IconButton(onPressed: (){}, icon:const Icon(FontAwesomeIcons.instagram,size: 40,),
                     ),
                       const SizedBox(width: 20),
                       

                ],
                
              ),
                ],
                
              ),
             
              
              GestureDetector(
                onTap: () {Navigator.push(context,
                  MaterialPageRoute(builder: (C) => const CreateNewAccount()));},
                    child: Container(
                  // decoration: BoxDecoration(
                  //     border:
                  //         Border(bottom: BorderSide(width: 1, color: kWhite))),
                  child: const Text(
                    'Create New Account',
                    
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue
                    )
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ],
    );
  }
  
  
}