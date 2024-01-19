import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_booking_app/controller/auth_controller.dart';
import 'package:taxi_booking_app/widgets/intro_widget.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({Key? key}) : super(key: key);

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  TextEditingController nameController = TextEditingController();
  TextEditingController homeController = TextEditingController();
  TextEditingController businessController = TextEditingController();
  TextEditingController shopController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthController authController = Get.find<AuthController>();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Get.height * 0.2,
              child: Stack(
                children: [
                  greenIntroWidgetWithoutLogos(),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(height: 20,)

                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFieldWidget(
                        'Name', Icons.person_outlined, nameController,(String? input){

                          if(input!.isEmpty){
                            return 'Name is required!';
                          }

                          if(input.length<5){
                            return 'Please enter a valid name!';
                          }

                          return null;

                    }),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    TextFieldWidget(
                        'email', Icons.email, nameController,(String? input){

                          if(input!.isEmpty){
                            return 'Email is required!';
                          }

                          if(input.length<5){
                            return 'Please enter a valid Email!';
                          }

                          return null;

                    }),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    TextFieldWidget(
                        'Address', Icons.location_city, nameController,(String? input){

                          if(input!.isEmpty){
                            return 'Address is required!';
                          }

                          if(input.length<5){
                            return 'Please enter a valid Address!';
                          }

                          return null;

                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(
                        'Phone Number', Icons.phone, nameController,(String? input){

                          if(input!.isEmpty){
                            return 'Phone Number is required!';
                          }

                          if(input.length<5){
                            return 'Please enter a valid Phone Number!';
                          }

                          return null;

                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(
                        'Gender', Icons.person_outlined, nameController,(String? input){

                          if(input!.isEmpty){
                            return 'Gender is required!';
                          }

                          if(input.length<5){
                            return 'Please enter a valid Gender!';
                          }

                          return null;

                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(
                        'User Name', Icons.verified_user_outlined, nameController,(String? input){

                          if(input!.isEmpty){
                            return 'User Name is required!';
                          }

                          if(input.length<5){
                            return 'Please enter a valid User Name!';
                          }

                          return null;

                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(
                        'Password', Icons.key, nameController,(String? input){

                          if(input!.isEmpty){
                            return 'Password is required!';
                          }

                          if(input.length<5){
                            return 'Please enter a valid Password!';
                          }

                          return null;

                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    
                    const SizedBox(
                      height: 30,
                    ),
                    Obx(() => authController.isProfileUploading.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : greenButton('Submit', () {


                            if(!formKey.currentState!.validate()){
                              return;
                            }

                          
                          })),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextFieldWidget(
      String title, IconData iconData, TextEditingController controller,Function validator,{Function? onTap,bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xffA7A7A7)),
        ),
        const SizedBox(
          height: 6,
        ),
        Container(
          width: Get.width,
          // height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 1)
              ],
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            readOnly: readOnly,
            onTap: ()=> onTap!(),
            validator: (input)=> validator(input),
            controller: controller,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xffA7A7A7)),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  iconData,
                  color: Colors.blue,
                ),
              ),
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }

  Widget greenButton(String title, Function onPressed) {
    return MaterialButton(
      minWidth: Get.width,
      height: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: Colors.blue,
      onPressed: () => onPressed(),
      child: Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
