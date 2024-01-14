import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxi_booking_app/pages/otp_verfication_screen.dart';
import 'package:taxi_booking_app/widgets/intro_widget.dart';
import 'package:taxi_booking_app/widgets/login_widget.dart';


class LoginScreenG extends StatefulWidget {
  const LoginScreenG({super.key});


  @override
  State<LoginScreenG> createState() => _LoginScreenGState();
}

class _LoginScreenGState extends State<LoginScreenG> {

  final countryPicker = const FlCountryCodePicker();

  CountryCode countryCode = const CountryCode(name: 'SriLanka', code: "LK", dialCode: "+94");


  onSubmit(String? input){
    Get.to(()=>OtpVerificationScreen(countryCode.dialCode+input!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              greenIntroWidget(),

              const SizedBox(height: 50,),

              loginWidget(countryCode,()async{
                final code = await countryPicker.showPicker(context: context);
                if (code != null)  countryCode = code;
                setState(() {

                });
              },onSubmit),


            ],
          ),
        ),
      ),
    );
  }
}
