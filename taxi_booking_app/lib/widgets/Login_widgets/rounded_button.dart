import 'package:flutter/material.dart';
import 'package:taxi_booking_app/pages/login_window/pallete.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.onPressed,
    required this.buttonName,
  }) : super(key: key);

  final String buttonName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.08,
      width: size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: kBlue,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          
          buttonName,
          style: kBodyText.copyWith(fontWeight: FontWeight.bold),
          
        ),
      ),
    );
  }
}