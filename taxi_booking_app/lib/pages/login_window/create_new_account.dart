import 'dart:io';

import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_booking_app/global/global_var.dart';
import 'package:taxi_booking_app/methods/common_methods.dart';
import 'package:taxi_booking_app/pages/dashboard.dart';
import 'package:taxi_booking_app/pages/login_window/login_screen.dart';
import 'package:taxi_booking_app/pages/otp_verfication_screen.dart';
import 'package:taxi_booking_app/widgets/Login_widgets/background_image.dart';
import 'package:taxi_booking_app/widgets/Login_widgets/password_input.dart';
import 'package:taxi_booking_app/widgets/Login_widgets/rounded_button.dart';
import 'package:taxi_booking_app/widgets/Login_widgets/text_field_input.dart';
import 'package:taxi_booking_app/widgets/loading_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import './pallete.dart';


class CreateNewAccount extends StatefulWidget {
  const CreateNewAccount({super.key});

  @override
  State<CreateNewAccount> createState() => _CreateNewAccountFState();
}

class _CreateNewAccountFState extends State<CreateNewAccount> {
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController phoneNumberTextEditingController =
      TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();
  XFile? imageFile;
  String urlOfUploadedImage = "";
  late Color myColor;
  late Size mediaSize;
  bool rememberUser = false;

    final countryPicker = const FlCountryCodePicker();

  CountryCode countryCode = const CountryCode(name: 'SriLanka', code: "LK", dialCode: "+94");


  onSubmit(String? input){
    Get.to(()=>OtpVerificationScreen(countryCode.dialCode+input!));
  }

  checkIfNetworkAvailabe() {
    cMethods.checkConnectivity(context);

    
      signUpFormValidation();
    
  }

  uploadImageToStorage() async {
    String imageIdName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceImage =
        FirebaseStorage.instance.ref().child("Images").child(imageIdName);
    UploadTask uploadTask = referenceImage.putFile(File(imageFile!.path));
    TaskSnapshot snapshot = await uploadTask;
    urlOfUploadedImage = await snapshot.ref.getDownloadURL();

    setState(() {
      urlOfUploadedImage;
    });

    registerNewUser();
  }

  signUpFormValidation() {
    if (userNameTextEditingController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          "Your name Must have 4 or more characters", context);
    } else if (phoneNumberTextEditingController.text.trim().length < 8) {
      cMethods.displaySnackBar(
          "Your phone number must be 8 or more characters", context);
    } else if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("Please enter a valid email address", context);
    } else if (passwordTextEditingController.text.trim().length < 5) {
      cMethods.displaySnackBar(
          "Your password must have 4 or more characters", context);
    } else {
      // uploadImageToStorage();
      registerNewUser();
    }
  }

  registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Registering Your account.."),
    );

    final User? userFirebase = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
           
            .catchError((errorMessage) {
      Navigator.pop(context);
      cMethods.displaySnackBar(errorMessage.toString(), context);
    }))
        .user;

    if (!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);

    Map userDataMap = {
      "photo": urlOfUploadedImage,
      "name": userNameTextEditingController.text.trim(),
      "email": emailTextEditingController.text.trim(),
      "phone": phoneNumberTextEditingController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no",
    };

    usersRef.set(userDataMap);

    Navigator.push(
        context, MaterialPageRoute(builder: (c) => const Dashboard()));
  }

 
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        const BackgroundImage(image: 'assets/images/taxi.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.width * 0.1,
                ),
                Stack(
                  children: [
                    Center(
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: CircleAvatar(
                            radius: size.width * 0.14,
                            backgroundColor: Colors.grey[400]!.withOpacity(
                              0.4,
                            ),
                            child: Icon(
                              FontAwesomeIcons.user,
                              color: kWhite,
                              size: size.width * 0.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.08,
                      left: size.width * 0.56,
                      child: Container(
                        height: size.width * 0.1,
                        width: size.width * 0.1,
                        decoration: BoxDecoration(
                          color: kBlue,
                          shape: BoxShape.circle,
                          border: Border.all(color: kWhite, width: 2),
                        ),
                        child: Icon(
                          FontAwesomeIcons.arrowUp,
                          color: kWhite,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: size.width * 0.1,
                ),
                Column(
                  children: [
                                     SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: userNameTextEditingController,
                    //obscureText: true,
                    style: const TextStyle(color: Colors.white), // Set the input text color to white
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        FontAwesomeIcons.user,
                        color: Colors.white,
                      ),
                      labelText: "User Name",
                      labelStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      hintText: "Enter Your User Name",
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
                    controller: phoneNumberTextEditingController,
                    //obscureText: true,
                    style: const TextStyle(color: Colors.white), // Set the input text color to white
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      labelText: "Phone Number",
                      labelStyle: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      hintText: "Enter Your Phone Number",
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
                      height: 20,),
                    
                     RoundedButton(
                      
                    buttonName: 'Register',
                    onPressed: () {
    
                      checkIfNetworkAvailabe();}
                     ),
    
                    const SizedBox(
                      height: 20,
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
                        'Or Signup With ',
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: kBodyText,
                          
                          
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                  MaterialPageRoute(builder: (C) => const LoginScreenLast()));
                          },
                          child: Text(
                            'Login',
                            style: kBodyText.copyWith(
                                color: kBlue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                

                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}