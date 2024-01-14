import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taxi_booking_app/controller/auth_controller.dart';
import 'package:taxi_booking_app/pages/login_screen.dart';
import 'package:taxi_booking_app/widgets/decision_button.dart';
import 'package:taxi_booking_app/widgets/intro_widget.dart';


class DecisionScreen extends StatelessWidget {
    DecisionScreen({Key? key}) : super(key: key);


    AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            greenIntroWidget(),

            const SizedBox(height: 50,),

            // DecisionButton(
            //   'assets/driver.png',
            //   'Login As Driver',
            //     (){
            //     authController.isLoginAsDriver = true;
            //       Get.to(()=> const LoginScreen());
            //     },
            //   Get.width*0.8
            // ),

            const SizedBox(height: 20,),
            DecisionButton(
                'assets/customer.png',
                'Login As User',
                    (){
                      // authController.isLoginAsDriver = false;
                   Get.to(()=> const LoginScreenG());



                    },
                Get.width*0.8
            ),
          ],
        ),
      ),
    );
  }
}
