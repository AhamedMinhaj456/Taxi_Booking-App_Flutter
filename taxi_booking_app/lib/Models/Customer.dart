// ignore_for_file: file_names
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'Booking.dart';
import 'OnlinePayment.dart';

class CustomerModel {
  final String? customerId;
  final String name;
  final String email;
  final String address;
  final String phoneNo;
  final String gender;
  final String username;
  final String password;

  CustomerModel({
    this.customerId,
    required this.name,
    required this.email,
    required this.address,
    required this.phoneNo,
    required this.gender,
    required this.username,
    required this.password,
  });

  toJson() {
    return {
      "Name": name,
      "Email": email,
      "Address": address,
      "phoneNo": phoneNo,
      "Gender": gender,
      "Username": username,
      "password": password
    };
  }

  factory CustomerModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CustomerModel(
        customerId: document.id,
        name: data["Name"],
        email: data["Email"],
        address: data["Address"],
        phoneNo: data["PhoneNo"],
        gender: data["Gender"],
        username: data["Username"],
        password: data["Password"]);
  }

  List<OnlinePayment> relatedOnlinePayment = [];
  List<Booking> relatedBooking = [];

  void displayCustomerDetails() {
    // create displayCustomerDetails function
  }

  void updateContactInfo() {
    // create updateContactInfo function
  }

  void changePassword() {
    // create changePassword function
  }

  void updateProfile() {
    // create updateProfile function
  }
}

// class UserModel {
//   String? bAddress;
//   String? hAddress;
//   String? mallAddress;
//   String? name;
//   String? image;

//   LatLng? homeAddress;
//   LatLng? bussinessAddres;
//   LatLng? shoppingAddress;

//   UserModel(
//       {this.name, this.mallAddress, this.hAddress, this.bAddress, this.image});

//   UserModel.fromJson(Map<String, dynamic> json) {
//     bAddress = json['business_address'];
//     hAddress = json['home_address'];
//     mallAddress = json['shopping_address'];
//     name = json['name'];
//     image = json['image'];
//     homeAddress =
//         LatLng(json['home_latlng'].latitude, json['home_latlng'].longitude);
//     bussinessAddres = LatLng(
//         json['business_latlng'].latitude, json['business_latlng'].longitude);
//     shoppingAddress = LatLng(
//         json['shopping_latlng'].latitude, json['shopping_latlng'].longitude);
//   }
// }
