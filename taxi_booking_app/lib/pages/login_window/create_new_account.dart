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
          LoadingDialog(messageText: "Registering Your account..."),
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
                      TextInputField(
                      controller: userNameTextEditingController,
                      icon: FontAwesomeIcons.user,
                      hint: 'User',
                      inputType: TextInputType.name,
                      inputAction: TextInputAction.next,
                    ),
                     TextInputField(
                      controller: emailTextEditingController,
                      icon: FontAwesomeIcons.envelope,
                      hint: 'Email',
                      inputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                    ),
                     PasswordInput(
                      controller: passwordTextEditingController,
                      icon: FontAwesomeIcons.lock,
                      hint: 'Password',
                      inputAction: TextInputAction.next,
                    ),
                     
                    const SizedBox(
                      height: 25,
                    ),
                    const RoundedButton(buttonName: 'Register'),
                    const SizedBox(
                      height: 30,
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