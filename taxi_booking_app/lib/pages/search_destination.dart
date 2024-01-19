// ignore_for_file: sort_child_properties_last, avoid_unnecessary_containers

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:taxi_booking_app/controller/auth_controller.dart';
import 'package:taxi_booking_app/controller/polyline_handler.dart';
import 'package:taxi_booking_app/global/global_var.dart';
import 'package:taxi_booking_app/pages/account_page.dart';
import 'package:taxi_booking_app/pages/dashboard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:taxi_booking_app/pages/payment_page.dart';
import 'dart:ui' as ui;

import 'package:taxi_booking_app/widgets/text_widget.dart';

class SearchDestination extends StatefulWidget {
  const SearchDestination({super.key});

  @override
  State<SearchDestination> createState() => _SearchDestinationState();
}

class _SearchDestinationState extends State<SearchDestination> {
  TextEditingController pickupTextEditingController = TextEditingController();
  TextEditingController destinationTextEditingController =
      TextEditingController();
  AuthController authController = Get.find<AuthController>();
  String? _mapStyle;
  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  late LatLng destination;
  late LatLng source;
  bool showSourceField = false;

  final Set<Polyline> _polyline = {};
  Set<Marker> markers = Set<Marker>();
  List<String> list = <String>[
    '**** **** **** 8789',
    '**** **** **** 8921',
    '**** **** **** 1233',
    '**** **** **** 4352'
  ];

  late Uint8List markIcons;

  loadCustomMarker() async {
    markIcons = await loadAsset('assets/dest_marker.png', 100);
  }

  Future<Uint8List> loadAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  
  @override
  void initState() {
    super.initState();

    authController.getUserInfo();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    loadCustomMarker();
  }

  String dropdownValue = '**** **** **** 8789';
  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GoogleMapController? myMapController;

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
              markers: markers,
              polylines: polyline,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                myMapController = controller;

                myMapController!.setMapStyle(_mapStyle);
              },
              initialCameraPosition: _kGooglePlex,

              
              ),
            
          Card(
              elevation: 10,
              child: Container(
                height: 230,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 24, top: 40, right: 24, bottom: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 6,
                      ),

                      //title and icon
                      Stack(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (c) => const Dashboard()));
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              )),
                          const Center(
                            child: Text(
                              "Set Dropoff Location",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // Pickup text field
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/initial.png",
                            height: 40,
                            width: 25,
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: TextFormField(
                                  controller: pickupTextEditingController,
                                  readOnly: true,
                                  onTap: () async {
                                    Prediction? p = await authController
                                        .showGoogleAutoComplete(context);

                                    String selectedPlace = p!.description!;

                                    pickupTextEditingController.text =
                                        selectedPlace;

                                    List<geoCoding.Location> locations =
                                        await geoCoding
                                            .locationFromAddress(selectedPlace);

                                    destination = LatLng(
                                        locations.first.latitude,
                                        locations.first.longitude);

                                    markers.add(Marker(
                                      markerId: MarkerId(selectedPlace),
                                      infoWindow: InfoWindow(
                                        title: 'Destination: $selectedPlace',
                                      ),
                                      position: destination,
                                      icon:
                                          BitmapDescriptor.fromBytes(markIcons),
                                    ));

                                    myMapController!.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                                target: destination, zoom: 14)
                                            //17 is new zoom level
                                            ));

                                    setState(() {
                                      showSourceField = true;
                                    });
                                  },
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: "Pickup Address",
                                    hintStyle: TextStyle(color: Colors.black),
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(
                                      left: 12,
                                      top: 9,
                                      bottom: 9,
                                    ),
                                  ),
                                ),
                              ),

                              // child: TextField(
                              //   controller: pickupTextEditingController,
                              //   decoration: const InputDecoration(
                              //     hintText: "Pickup Address",
                              //     fillColor: Colors.white12,
                              //     filled: true,
                              //     border: InputBorder.none,
                              //     isDense: true,
                              //     contentPadding: EdgeInsets.only(left: 12, top: 9, bottom: 9,),

                              //   ),
                              //   ),
                              // ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // destination text field
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/final.png",
                            height: 40,
                            width: 25,
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: TextFormField(
                                  controller: destinationTextEditingController,
                                  readOnly: true,
                                  onTap: () async {
// Get.back();
              Prediction? p =
                  await authController.showGoogleAutoComplete(context);

              String place = p!.description!;

              destinationTextEditingController.text = place;

              source = await authController.buildLatLngFromAddress(place);

              if (markers.length >= 2) {
                markers.remove(markers.last);
              }
              markers.add(Marker(
                  markerId: MarkerId(place),
                  infoWindow: InfoWindow(
                    title: 'Source: $place',
                  ),
                  position: source));

              await getPolylines(source, destination);

               drawPolyline(place);

              myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: source, zoom: 14)));
              setState(() {});
              buildRideConfirmationSheet();

                                    
                                    // Prediction? p = await authController
                                    //     .showGoogleAutoComplete(context);

                                    // String selectedPlace = p!.description!;

                                    // destinationTextEditingController.text =
                                    //     selectedPlace;

                                    // List<geoCoding.Location> locations =
                                    //     await geoCoding
                                    //         .locationFromAddress(selectedPlace);

                                    // destination = LatLng(
                                    //     locations.first.latitude,
                                    //     locations.first.longitude);

                                    // markers.add(Marker(
                                    //   markerId: MarkerId(selectedPlace),
                                    //   infoWindow: InfoWindow(
                                    //     title: 'Destination: $selectedPlace',
                                    //   ),
                                    //   position: destination,
                                    //   icon:
                                    //       BitmapDescriptor.fromBytes(markIcons),
                                    // ));

                                    // myMapController!.animateCamera(
                                    //     CameraUpdate.newCameraPosition(
                                    //         CameraPosition(
                                    //             target: destination, zoom: 14)
                                    //         //17 is new zoom level
                                    //         ));

                                    // setState(() {
                                    //   showSourceField = true;
                                    // });


                                  },
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: "Dropoff Address",
                                    hintStyle: TextStyle(color: Colors.black),
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(
                                      left: 12,
                                      top: 9,
                                      bottom: 9,
                                    ),
                                  ),
                                ),
                              ),

                              // child: TextField(
                              //   controller: pickupTextEditingController,
                              //   decoration: const InputDecoration(
                              //     hintText: "Pickup Address",
                              //     fillColor: Colors.white12,
                              //     filled: true,
                              //     border: InputBorder.none,
                              //     isDense: true,
                              //     contentPadding: EdgeInsets.only(left: 12, top: 9, bottom: 9,),

                              //   ),
                              // ),
                              // ),
                            ),
                          ),

                          // child: TextField(
                          //   controller: destinationTextEditingController,
                          //   decoration: const InputDecoration(
                          //     hintText: "Dropoff Address",
                          //     fillColor: Colors.white12,
                          //     filled: true,
                          //     border: InputBorder.none,
                          //     isDense: true,
                          //     contentPadding: EdgeInsets.only(left: 12, top: 9, bottom: 9,),

                          //   ),
                          //   ),
                          // ),
                          // ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              )
        ],
      ),
    );
  }



buildDrawerItem(
      {required String title,
      required Function onPressed,
      Color color = Colors.black,
      double fontSize = 20,
      FontWeight fontWeight = FontWeight.w700,
      double height = 45,
      bool isVisible = false}) {
    return SizedBox(
      height: height,
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        // minVerticalPadding: 0,
        dense: true,
        onTap: () => onPressed(),
        title: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: fontWeight, color: color),
            ),
            const SizedBox(
              width: 5,
            ),
            isVisible
                ? CircleAvatar(
                    backgroundColor: const Color(0xff5663ff),
                    radius: 15,
                    child: Text(
                      '1',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => const AccountScreen());
            },
            child: SizedBox(
              height: 150,
              child: DrawerHeader(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: authController.myUser.value.image == null
                            ? const DecorationImage(
                                image: AssetImage('assets/person.png'),
                                fit: BoxFit.fill)
                            : DecorationImage(
                                image: NetworkImage(
                                    authController.myUser.value.image!),
                                fit: BoxFit.fill)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Good Morning, ',
                            style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.28),
                                fontSize: 14)),
                        Text(
                          authController.myUser.value.name == null
                              ? "Mark"
                              : authController.myUser.value.name!,
                          style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )
                      ],
                    ),
                  )
                ],
              )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                buildDrawerItem(title: 'Payment History', onPressed: () => Get.to(()=> const PaymentScreen())),
                buildDrawerItem(
                    title: 'Ride History', onPressed: () {}, isVisible: true),
                buildDrawerItem(title: 'Invite Friends', onPressed: () {}),
                buildDrawerItem(title: 'Promo Codes', onPressed: () {}),
                buildDrawerItem(title: 'Settings', onPressed: () {}),
                buildDrawerItem(title: 'Support', onPressed: () {}),
                buildDrawerItem(title: 'Log Out', onPressed: () {

                  FirebaseAuth.instance.signOut();

                }),
              ],
            ),
          ),
          const Spacer(),
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              children: [
                buildDrawerItem(
                    title: 'Do more',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.15),
                    height: 20),
                const SizedBox(
                  height: 20,
                ),
                buildDrawerItem(
                    title: 'Get food delivery',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.15),
                    height: 20),
                buildDrawerItem(
                    title: 'Make money driving',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.15),
                    height: 20),
                buildDrawerItem(
                  title: 'Rate us on store',
                  onPressed: () {},
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.15),
                  height: 20,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

void drawPolyline(String placeId) {
    _polyline.clear();
    _polyline.add(Polyline(
      polylineId: PolylineId(placeId),
      visible: true,
      points: [source, destination],
      color: const Color(0xff5663ff),
      width: 5,
    ));
  }

void buildSourceSheet() {
    Get.bottomSheet(Container(
      width: Get.width,
      height: Get.height * 0.5,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Select Your Location",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Home Address",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              Get.back();
              source = authController.myUser.value.homeAddress!;
              destinationTextEditingController.text = authController.myUser.value.hAddress!;

              if (markers.length >= 2) {
                markers.remove(markers.last);
              }
              markers.add(Marker(
                  markerId: MarkerId(authController.myUser.value.hAddress!),
                  infoWindow: InfoWindow(
                    title: 'Source: ${authController.myUser.value.hAddress!}',
                  ),
                  position: source));

              await getPolylines(source, destination);

              // drawPolyline(place);

              myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: source, zoom: 14)));
              setState(() {});

              buildRideConfirmationSheet();
            },
            child: Container(
              width: Get.width,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        spreadRadius: 4,
                        blurRadius: 10)
                  ]),
              child: Row(
                children: [
                  Text(
                    authController.myUser.value.hAddress!,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Business Address",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              Get.back();
              source = authController.myUser.value.bussinessAddres!;
              destinationTextEditingController.text = authController.myUser.value.bAddress!;

              if (markers.length >= 2) {
                markers.remove(markers.last);
              }
              markers.add(Marker(
                  markerId: MarkerId(authController.myUser.value.bAddress!),
                  infoWindow: InfoWindow(
                    title: 'Source: ${authController.myUser.value.bAddress!}',
                  ),
                  position: source));

              await getPolylines(source, destination);

              // drawPolyline(place);

              myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: source, zoom: 14)));
              setState(() {});

              buildRideConfirmationSheet();
            },
            child: Container(
              width: Get.width,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        spreadRadius: 4,
                        blurRadius: 10)
                  ]),
              child: Row(
                children: [
                  Text(
                    authController.myUser.value.bAddress!,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () async {
              Get.back();
              Prediction? p =
                  await authController.showGoogleAutoComplete(context);

              String place = p!.description!;

              destinationTextEditingController.text = place;

              source = await authController.buildLatLngFromAddress(place);

              if (markers.length >= 2) {
                markers.remove(markers.last);
              }
              markers.add(Marker(
                  markerId: MarkerId(place),
                  infoWindow: InfoWindow(
                    title: 'Source: $place',
                  ),
                  position: source));

              await getPolylines(source, destination);

               drawPolyline(place);

              myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: source, zoom: 14)));
              setState(() {});
              buildRideConfirmationSheet();
            },
            child: Container(
              width: Get.width,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        spreadRadius: 4,
                        blurRadius: 10)
                  ]),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Search for Address",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

buildPaymentCardWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/visa.png',
            width: 40,
          ),
          const SizedBox(
            width: 10,
          ),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: textWidget(text: value),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

buildRideConfirmationSheet() {
    Get.bottomSheet(Container(
      width: Get.width,
      height: Get.height * 0.4,
      padding: const EdgeInsets.only(left: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12), topLeft: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: Get.width * 0.2,
              height: 8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.grey),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          textWidget(
              text: 'Select an option:',
              fontSize: 18,
              fontWeight: FontWeight.bold),
          const SizedBox(
            height: 20,
          ),
          buildDriversList(),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: buildPaymentCardWidget()),
                MaterialButton(
                  onPressed: () {},
                  child: textWidget(
                    text: 'Confirm',
                    color: Colors.white,
                  ),
                  color: const Color(0xff5663ff),
                  shape: const StadiumBorder(),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }

 int selectedRide = 0;

buildDriversList() {
    return Container(
      height: 90,
      width: Get.width,
      child: StatefulBuilder(builder: (context, set) {
        return ListView.builder(
          itemBuilder: (ctx, i) {
            return InkWell(
              onTap: () {
                set(() {
                  selectedRide = i;
                });
              },
              child: buildDriverCard(selectedRide == i),
            );
          },
          itemCount: 3,
          scrollDirection: Axis.horizontal,
        );
      }),
    );
  }

buildDriverCard(bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
      height: 85,
      width: 165,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: selected
                    ? const Color(0xff5663ff).withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                offset: const Offset(0, 5),
                blurRadius: 5,
                spreadRadius: 1)
          ],
          borderRadius: BorderRadius.circular(12),
          color: selected ? const Color(0xff5663ff) : Colors.grey),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(
                    text: 'Standard',
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
                textWidget(
                    text: '\$9.90',
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
                textWidget(
                    text: '3 MIN',
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.normal,
                    fontSize: 12),
              ],
            ),
          ),
          Positioned(
              right: -20,
              top: 0,
              bottom: 0,
              child: Image.asset('assets/Mask Group 2.png'))
        ],
      ),
    );
  }

}
