// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxi_booking_app/widgets/text_widget.dart';

Widget phoneNumberWidget(CountryCode countryCode, Function onCountryChange,Function onSubmit) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
              //color: Colors.white,
              boxShadow: const [
                
                BoxShadow(
                    
                    color: Colors.transparent,
                    spreadRadius: 3,
                    blurRadius: 3)
              ],
              border: const Border(
      bottom: BorderSide(
        color: Colors.grey, // Set the color of the bottom line
        width: 1.0, // Set the width of the bottom line
      ),
    ),
              borderRadius: BorderRadius.circular(0)),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => onCountryChange(),
                    child: Container(
                      child: Row(
                        children: [
                          const SizedBox(width: 5),

                          Expanded(
                            child: Container(
                              child: countryCode.flagImage,
                            ),
                          ),

                          
                          textWidget(text: countryCode.dialCode),

                          // const SizedBox(width: 10,),

                          const Icon(Icons.keyboard_arrow_down_rounded)
                        ],
                      ),
                    ),
                  )),
              // Container(
              //   width: 1,
              //   height: 55,
              //   color: Colors.black.withOpacity(0.2),
              // ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    onSubmitted: (String? input)=> onSubmit(input),
                    decoration: InputDecoration(
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 14, 
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                        hintText: "Enter Your Phone Number",
                        border: InputBorder.none),
                  ),
                ),
              ),
            ],
          ),
        ),
               ],
    ),
  );
}
