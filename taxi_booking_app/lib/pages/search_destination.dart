import 'package:flutter/material.dart';
import 'package:taxi_booking_app/pages/dashboard.dart';


class SearchDestination extends StatefulWidget {
  const SearchDestination({super.key});

  @override
  State<SearchDestination> createState() => _SearchDestinationState();
}

class _SearchDestinationState extends State<SearchDestination> {
  TextEditingController pickupTextEditingController = TextEditingController();
  TextEditingController destinationTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
                elevation: 10,
                child: Container(
                  height: 230,
                  decoration: const BoxDecoration(
                    color: Colors.black12,
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
            context, MaterialPageRoute(builder: (c) => const Dashboard()));
                                },
                               child:  const Icon(
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
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child:  Padding(
                                    padding: const EdgeInsets.all(3),
                                  
                                  child: TextField(
                                    controller: pickupTextEditingController,
                                    decoration: const InputDecoration(
                                      hintText: "Pickup Address",
                                      fillColor: Colors.white12,
                                      filled: true,
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(left: 12, top: 9, bottom: 9,),

                                    ),
                                    ),
                                  ),
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
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child:  Padding(
                                    padding: const EdgeInsets.all(3),
                                  
                                  child: TextField(
                                    controller: destinationTextEditingController,
                                    decoration: const InputDecoration(
                                      hintText: "Dropoff Address",
                                      fillColor: Colors.white12,
                                      filled: true,
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(left: 12, top: 9, bottom: 9,),

                                    ),
                                    ),
                                  ),
                                  ),
                            ),
                          ],
                        ),
                     
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
