

// ignore_for_file: non_constant_identifier_names

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:taxi_booking_app/Models/Customer.dart';
import 'package:taxi_booking_app/methods/user_model/user_model.dart';

class UserRepository extends GetxController{
static UserRepository get instance => Get.find();

final _db = FirebaseStorage.instance;


/// Store user in FireStore
// createCustomer(UserModel customer) async {
// await _db.collection("customers").add(customer.toJson()).whenComplete; {
//   Get.snackbar(
//     "Success",
//     "You account has been created. " ,
//     snackPosition: SnackPosition.BOTTOM,
//     backgroundColor: Colors.blue.withOpacity(0.1),
//     colorText: Colors.green,
//     );
//   }).catchError((error, stackTrace){
  
//     Get.snackbar("Error", "Something went wrong. Try again",
//     snackPosition: SnackPosition.BOTTOM,
//     backgroundColor: Colors.redAccent.withOpacity(0.1),
//     colorText: Colors.red) ;
//     print("Error-$error");
//     });
//   }

//Future<CustomerModel> getCustomerDetaits(String email) async {
//final snapshot= await _db.collection("Customers").where("Email", isEqualTo: email).get();
//final CustomerData = snapshot.docs.map((e) => CustomerModel.fromSnapshot()).single;
//return CustomerData;
//}

//Future<List<CustomerModel>> allCustomers() async {
//final snapshot= await _db.collection("Customers").get();
//final CustomerData = snapshot.docs.map((e) => CustomerModel.fromSnapshot()).single;
//return CustomerData;
//}


}


