import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_booking_app/authentication/login.dart';
import 'package:taxi_booking_app/methods/common_methods.dart';
import 'package:taxi_booking_app/pages/home_page.dart';
import 'package:taxi_booking_app/widgets/loading_dialog.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController phoneNumberTextEditingController =
      TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();
  XFile? imagefile;

  checkIfNetworkAvailabe() {
    cMethods.checkConnectivity(context);
    signUpFormValidation();
  }

  signUpFormValidation() {
    if (userNameTextEditingController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          "Your name Must have 4 or more characters", context);
    } else if (phoneNumberTextEditingController.text.trim().length < 8) {
      cMethods.displaySnackBar(
          "Your phone number must be 8 or more characters", context);
    } else if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("Please enter a valid email address", context);
    } else if (passwordTextEditingController.text.trim().length < 5) {
      cMethods.displaySnackBar(
          "Your password must have 4 or more characters", context);
    } else {
      registerNewUser();
    }
  }

  registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Registering Your account...."),
    );

    final User? userFirebase = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),

    
    )
            // ignore: body_might_complete_normally_catch_error
            .catchError((errorMessage) {
      Navigator.pop(context);
      cMethods.displaySnackBar(errorMessage.toString(), context);
    }))
        .user;

    if (!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);

    Map userDataMap = {
      "name": userNameTextEditingController.text.trim(),
      "email": emailTextEditingController.text.trim(),
      "phone": phoneNumberTextEditingController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no",
    };

    usersRef.set(userDataMap);

    Navigator.push(
        context, MaterialPageRoute(builder: (c) => const HomePage()));
  }

  chooseImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagefile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [

         const SizedBox(
            height: 30,
          ),

          const Text(
            "Create user Account",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 40,
          ),

          imagefile == null?
          const CircleAvatar(
            radius: 90,
            backgroundImage: AssetImage("assets/images/avatarman.png"),
          ):Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: FileImage(
                  File(
                    imagefile!.path,
                  ),
                ))
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          
          GestureDetector(
            onTap: () {
              chooseImageFromGallery();
            },
            child: const Text(
              "choose image",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(
            height: 30,
          ),
         

          //text + button
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                TextField(
                  controller: userNameTextEditingController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "User Name",
                    labelStyle: TextStyle(
                      fontSize: 14,
                    ),
                    hintText: "Enter Your User Name",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.green),
                  ),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                TextField(
                  controller: phoneNumberTextEditingController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    labelStyle: TextStyle(
                      fontSize: 14,
                    ),
                    hintText: "Enter Your Phone Number",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.green),
                  ),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                TextField(
                  controller: emailTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: "Email Address",
                      labelStyle: TextStyle(
                        fontSize: 14,
                      ),
                      hintText: "Enter Your Email Address",
                      hintStyle: TextStyle(
                        fontSize: 14,
                      )),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                TextField(
                  controller: passwordTextEditingController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                      fontSize: 14,
                    ),
                    hintText: "Enter Your password",
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                ElevatedButton(
                  onPressed: () {
                    checkIfNetworkAvailabe();
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
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an Account?",
                style: TextStyle(color: Colors.grey),
              ),

              // text button
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (C) => const LoginScreen()));
                  },
                  child: const Text(
                    "Login here",
                    style: TextStyle(color: Colors.grey),
                  ))
            ],
          )
        ]),
      ),
    ));
  }
}

// // ##############################################################
// // Bottom bar



// class PersistentBottomNavPage extends StatelessWidget {
//   final _tab1navigatorKey = GlobalKey<NavigatorState>();
//   final _tab2navigatorKey = GlobalKey<NavigatorState>();
//   final _tab3navigatorKey = GlobalKey<NavigatorState>();

//   PersistentBottomNavPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return PersistentBottomBarScaffold(
//       items: [
//         PersistentTabItem(
//           tab: const TabPage1(),
//           icon: Icons.home,
//           title: 'Home',
//           navigatorkey: _tab1navigatorKey,
//         ),
//         PersistentTabItem(
//           tab: const TabPage2(),
//           icon: Icons.search,
//           title: 'Search',
//           navigatorkey: _tab2navigatorKey,
//         ),
//         PersistentTabItem(
//           tab: const TabPage3(),
//           icon: Icons.person,
//           title: 'Profile',
//           navigatorkey: _tab3navigatorKey,
//         ),
//       ],
//     );
//   }
// }

// class TabPage1 extends StatelessWidget {
//   const TabPage1({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Tab 1')),
//       body: SizedBox(
//         width: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Tab 1'),
//             ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => const Page1('Tab1')));
//                 },
//                 child: const Text('Go to page1'))
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TabPage2 extends StatelessWidget {
//   const TabPage2({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Tab 2')),
//       body: SizedBox(
//         width: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Tab 2'),
//             ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => const Page2('tab2')));
//                 },
//                 child: const Text('Go to page2'))
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TabPage3 extends StatelessWidget {
//   const TabPage3({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Tab 3')),
//       body: SizedBox(
//         width: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Tab 3'),
//             ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => const Page2('tab3')));
//                 },
//                 child: const Text('Go to page2'))
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Page1 extends StatelessWidget {
//   final String inTab;

//   const Page1(this.inTab, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Page 1')),
//       body: SizedBox(
//         width: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('in $inTab Page 1'),
//             ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => Page2(inTab)));
//                 },
//                 child: const Text('Go to page2'))
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Page2 extends StatelessWidget {
//   final String inTab;

//   const Page2(this.inTab, {Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Page 2')),
//       body: SizedBox(
//         width: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('in $inTab Page 2'),
//             ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => Page3(inTab)));
//                 },
//                 child: const Text('Go to page3'))
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Page3 extends StatelessWidget {
//   final String inTab;

//   const Page3(this.inTab, {Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Page 3')),
//       body: SizedBox(
//         width: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('in $inTab Page 3'),
//             ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Go back'))
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PersistentBottomBarScaffold extends StatefulWidget {
//   /// pass the required items for the tabs and BottomNavigationBar
//   final List<PersistentTabItem> items;

//   const PersistentBottomBarScaffold({Key? key, required this.items})
//       : super(key: key);

//   @override
//   State<PersistentBottomBarScaffold> createState() =>
//       _PersistentBottomBarScaffoldState();
// }

// class _PersistentBottomBarScaffoldState
//     extends State<PersistentBottomBarScaffold> {
//   int _selectedTab = 0;

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         /// Check if curent tab can be popped
//         if (widget.items[_selectedTab].navigatorkey?.currentState?.canPop() ??
//             false) {
//           widget.items[_selectedTab].navigatorkey?.currentState?.pop();
//           return false;
//         } else {
//           // if current tab can't be popped then use the root navigator
//           return true;
//         }
//       },
//       child: Scaffold(
//         /// Using indexedStack to maintain the order of the tabs and the state of the
//         /// previously opened tab
//         body: IndexedStack(
//           index: _selectedTab,
//           children: widget.items
//               .map((page) => Navigator(
//                     /// Each tab is wrapped in a Navigator so that naigation in
//                     /// one tab can be independent of the other tabs
//                     key: page.navigatorkey,
//                     onGenerateInitialRoutes: (navigator, initialRoute) {
//                       return [
//                         MaterialPageRoute(builder: (context) => page.tab)
//                       ];
//                     },
//                   ))
//               .toList(),
//         ),

//         /// Define the persistent bottom bar
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _selectedTab,
//           onTap: (index) {
//             setState(() {
//               _selectedTab = index;
//             });
//           },
//           items: widget.items
//               .map((item) => BottomNavigationBarItem(
//                   icon: Icon(item.icon), label: item.title))
//               .toList(),
//         ),
//       ),
//     );
//   }
// }

// /// Model class that holds the tab info for the [PersistentBottomBarScaffold]
// class PersistentTabItem {
//   final Widget tab;
//   final GlobalKey<NavigatorState>? navigatorkey;
//   final String title;
//   final IconData icon;

//   PersistentTabItem(
//       {required this.tab,
//       this.navigatorkey,
//       required this.title,
//       required this.icon});
// }
