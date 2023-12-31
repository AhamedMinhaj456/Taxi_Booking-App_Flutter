import 'package:flutter/material.dart';
import 'package:taxi_booking_app/Models/Login.dart';
import 'package:taxi_booking_app/authentication/login.dart';
import 'package:taxi_booking_app/methods/common_methods.dart';

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

  checkIfNetworkAvailabe() {
    cMethods.checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Image.asset("assets/images/logo.png"),
          const Text(
            "Create user Account",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
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
                  controller: emailTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "User Name",
                    labelStyle: TextStyle(
                      fontSize: 14,
                    ),
                    hintText: "Enter Your User Name",
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
