
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:path/path.dart';
import 'package:taxi_booking_app/controller/auth_controller.dart';
import 'package:taxi_booking_app/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'dart:ui' as ui;

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String? _mapStyle;
   late LatLng destination;
  late LatLng source;
  
  final Set<Polyline> _polyline = {};
  Set<Marker> markers = Set<Marker>();
  List<String> list = <String>[
    '**** **** **** 8789',
    '**** **** **** 8921',
    '**** **** **** 1233',
    '**** **** **** 4352'
  ];

  AuthController authController = Get.find<AuthController>();
  TextEditingController destinationController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  GoogleMapController? myMapController;

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              buildTextField(),
              
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const HomePage()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 49, 206, 241),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 10)),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              const Text(
                "Settings",
                style: TextStyle(color: Colors.white, fontSize: 54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField() {
    return Positioned(
      top: 170,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 4,
                  blurRadius: 10)
            ],
            borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          controller: destinationController,
          readOnly: true,
          onTap: () async {
            Prediction? p =
                await authController.showGoogleAutoComplete(context as BuildContext);

            String selectedPlace = p!.description!;

            destinationController.text = selectedPlace;

            List<geoCoding.Location> locations =
                await geoCoding.locationFromAddress(selectedPlace);

            destination =
                LatLng(locations.first.latitude, locations.first.longitude);

            markers.add(Marker(
              markerId: MarkerId(selectedPlace),
              infoWindow: InfoWindow(
                title: 'Destination: $selectedPlace',
              ),
              position: destination,
              icon: BitmapDescriptor.fromBytes(markIcons),
            ));

            myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: destination, zoom: 14)
                //17 is new zoom level
                ));

            setState(() {
             // showSourceField = true;
            });
          },
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: 'Search for a destination',
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                Icons.search,
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
