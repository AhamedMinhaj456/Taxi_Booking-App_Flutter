import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_booking_app/authentication/login.dart';
import 'package:taxi_booking_app/authentication/signup.dart';
import 'package:taxi_booking_app/global/global_var.dart';
import 'package:taxi_booking_app/methods/common_methods.dart';
import 'package:taxi_booking_app/pages/dashboard.dart';
import 'package:taxi_booking_app/pages/otp_verfication_screen.dart';
import 'package:taxi_booking_app/widgets/loading_dialog.dart';
import 'package:taxi_booking_app/widgets/login_widget.dart';
import 'package:taxi_booking_app/widgets/phone_number_widget.dart';

class LoginScreenF extends StatefulWidget {
  const LoginScreenF({super.key});

  @override
  State<LoginScreenF> createState() => _LoginScreenFState();
}

class _LoginScreenFState extends State<LoginScreenF> {
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
    myColor = Colors.blue;
    mediaSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
          color: myColor,
          image: DecorationImage(
              image: const AssetImage("assets/images/backimg2.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  myColor.withOpacity(0.5), BlendMode.dstATop))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 50, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_sharp,
            size: 100,
            color: Colors.white,
          ),
          Text(
            "Ruhuna Ride",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
                letterSpacing: 2),
          )
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child:

                
                Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  
                  alignment: Alignment.center,
                  child: Text(
                    "Profile",
                    style: TextStyle(
                        color: myColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                // const SizedBox(height: 10),
                // _buildGreyText("Please Signup with your information"),
                // const SizedBox(height: 0),
                

                TextField(
                  controller: userNameTextEditingController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "User Name",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                      hintText: "Enter Your user Name",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      )),
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
              //   phoneNumberWidget(countryCode,()async{
              //   final code = await countryPicker.showPicker(context: context);
              //   if (code != null)  countryCode = code;
              //   setState(() {

              //   });
              // },onSubmit),
          

                TextField(
                  controller: phoneNumberTextEditingController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      labelText: "Phone Number",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                      hintText: "Enter Your phone Number",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      )),
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                _emailPassword(),
                const SizedBox(height: 20),
                _buildSignUpButton(),
                const SizedBox(height: 10),
                // _dontHaveAccount(),
                // const SizedBox(height: 0),
               // _buildOtherLogin(),
              ],
            )));
  }

  Widget _emailPassword() {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            TextField(
              controller: emailTextEditingController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Email Address",
                  labelStyle: TextStyle(
                    fontSize: 14,
                  ),
                  hintText: "Enter Your Email Address",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.green,
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
                prefixIcon: Icon(Icons.key),
                labelText: "Password",
                labelStyle: TextStyle(
                  fontSize: 14,
                ),
                hintText: "Enter Your Password",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                ),
              ),
              style: const TextStyle(
                color: Colors.green,
                fontSize: 15,
              ),
            ),
          ],
        ));
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  // Widget _dontHaveAccount() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       const Text(
  //         "Already have an Account?",
  //         style: TextStyle(color: Colors.grey),
  //       ),

  //       // text button
  //       TextButton(
  //           onPressed: () {
  //             Navigator.push(context,
  //                 MaterialPageRoute(builder: (C) => const LoginScreen()));
  //           },
  //           child: const Text(
  //             "Login here",
  //             style: TextStyle(color: Colors.grey),
  //           ))
  //     ],
  //   );
  // }

  Widget _buildInputField(TextEditingController controller,
      {isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon:
            isPassword ? const Icon(Icons.key) : const Icon(Icons.email),
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
                value: rememberUser,
                onChanged: (value) {
                  setState(() {
                    rememberUser = value!;
                  });
                }),
            _buildGreyText("Remember Me")
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "Forgot my password",
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
        onPressed: () {
          checkIfNetworkAvailabe();
        },
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            elevation: 5,
            shadowColor: myColor,
            minimumSize: const Size.fromHeight(60)),
        child: const Text(
          "SIGN UP",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            //     color: Colors.black
          ),
        ));
  }

  // Widget _buildOtherLogin() {
  //   return Center(
  //     child: Column(
  //       children: [
  //         _buildGreyText("-- Or Signup With --"),
  //         const SizedBox(height: 20),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             Tab(icon: Image.asset("assets/images/facebook.png")),
  //             Tab(icon: Image.asset("assets/images/instagram.png")),
  //             Tab(icon: Image.asset("assets/images/x.png")),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }
}
