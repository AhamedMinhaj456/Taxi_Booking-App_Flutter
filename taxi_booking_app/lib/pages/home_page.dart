import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_booking_app/Models/Payment.dart';
import 'package:taxi_booking_app/authentication/login.dart';
import 'package:taxi_booking_app/global/global_var.dart';
import 'package:taxi_booking_app/methods/common_methods.dart';
import 'package:taxi_booking_app/pages/account_page.dart';
import 'package:taxi_booking_app/pages/add_payment_card_page.dart';
import 'package:taxi_booking_app/pages/login_window/login_screen.dart';
import 'package:taxi_booking_app/pages/payment_page.dart';
import 'package:taxi_booking_app/pages/search_destination.dart';
import 'package:taxi_booking_app/pages/support_page.dart';
import 'package:taxi_booking_app/view/home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPositionofuser;
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  CommonMethods cMethods = CommonMethods();
  double searchContainerHeight = 220;

  void updateMapTheme(GoogleMapController controller) {
    getJsonFileFromThemes("themes/dark_style.json")
        .then((value) => setGoogleMapStyle(value, controller));
  }

  Future<String> getJsonFileFromThemes(String mapStylePath) async {
    ByteData byteData = await rootBundle.load(mapStylePath);
    var list = byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    return utf8.decode(list);
  }

  setGoogleMapStyle(String googleMapStyle, GoogleMapController controller) {
    controller.setMapStyle(googleMapStyle);
  }

  getCurrentLiveLocationOfUser() async {
    Position positionOfUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPositionofuser = positionOfUser;

    LatLng positionOfUserinLating = LatLng(
        currentPositionofuser!.latitude, currentPositionofuser!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: positionOfUserinLating, zoom: 15);
    controllerGoogleMap!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    //await getUserInfoAndCheckLockStatus();
  }

  // App crashing with this Admin Lock function

  // getUserInfoAndCheckLockStatus() async {
  //   DatabaseReference usersRef = FirebaseDatabase.instance
  //       .ref()
  //       .child("users")
  //       .child(FirebaseAuth.instance.currentUser!.uid);

  //   await usersRef.once().then((snap) {
  //     if (snap.snapshot.value != null) {
  //       if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
  //         setState(() {
  //           userName = (snap.snapshot.value as Map)["name"];
  //         });
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (c) => const Dashboard()));
  //       } else {
  //         FirebaseAuth.instance.signOut();
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (c) => const LoginScreen()));
  //         cMethods.displaySnackBar(
  //             "Your Account has been blocked. \n Contact RuhunaRide", context);
  //       }
  //     } else {
  //       FirebaseAuth.instance.signOut();
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (c) => const LoginScreen()));
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 250,
        color: Colors.black,
        child: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            children: [
              // header
              Container(
                color: Colors.black,
                height: 260,
                child: DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: Row(children: [
                   
                   
                    Image.asset(
                      "assets/images/avatarman.png",
                      width: 60,
                      height: 60,
                    ),

                    // const Icon(
                    //   Icons.person,
                    //   size: 60,
                    // ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Text(
                          "Profile",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ]),
                ),
              ),

              const Divider(
                height: 1,
                color: Colors.blueAccent,
                thickness: 1,
              ),

              //body
              GestureDetector(
                onTap: () {Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const PaymentScreen()));},
                child: ListTile(
                  leading: IconButton(
                    onPressed: () { },
                    icon: const Icon(
                      Icons.payment,
                      color: Colors.grey,
                    ),
                  ),
                  title: const Text(
                    "Payment History",
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:13),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {},
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.motorcycle,
                      color: Colors.grey,
                    ),
                  ),
                  title: const Text(
                    "Ride History",
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:13),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {},
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.handshake,
                      color: Colors.grey,
                    ),
                  ),
                  title: const Text(
                    "Invite Friends",
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:13),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {},
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.code,
                      color: Colors.grey,
                    ),
                  ),
                  title: const Text(
                    "Promo Code",
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:13),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const AddPaymentCardScreen()));
                },
                child: ListTile(
                  leading: IconButton(
                    onPressed: () { },
                    icon: const Icon(
                      Icons.credit_card,
                      color: Colors.grey,
                    ),
                  ),
                  title: const Text(
                    "Add Card",
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:13),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const AccountScreen()));},
                child: ListTile(
                  leading: IconButton(
                    onPressed: () { },
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.grey,
                    ),
                  ),
                  title: const Text(
                    "Settings",
                 style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:13),
                  ),
                ),
              ),

             GestureDetector(
                onTap: () {Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const HelpPage()));},
                child: ListTile(
                  leading: IconButton(
                    onPressed: () { },
                    icon: const Icon(
                      Icons.help,
                      color: Colors.grey,
                    ),
                  ),
                  title: const Text(
                    "Get Support",
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:13),
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {},
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.info,
                      color: Colors.grey,
                    ),
                  ),
                  title: const Text(
                    "About Us",
                     style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:13),
                  ),
                ),
              ),

              

              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const LoginScreenLast()));
                },
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.grey,
                    ),
                  ),
                  title: const Text(
                    "Log Out",
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: const EdgeInsets.only(top: 35, bottom: 10),
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController mapController) {
              controllerGoogleMap = mapController;
              // updateMapTheme(controllerGoogleMap!);
              googleMapCompleterController.complete(controllerGoogleMap);
              getCurrentLiveLocationOfUser();
            },
          ),

          // Drawer button
          Positioned(
              top: 42,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  sKey.currentState!.openDrawer();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7))
                      ]),
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                  ),
                ),
              )),

          Positioned(
            left: 10,
            // right: 40,
            //top: 60,
            // ignore: sized_box_for_whitespace
            child: Container(
              height: searchContainerHeight,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const HomeScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(5)),
                      child: const Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 30,
                      ),
                    ),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
