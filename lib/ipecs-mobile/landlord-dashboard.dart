import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iPECS/ipecs-mobile/landlord-drawer.dart';
import 'package:iPECS/ipecs-mobile/landlord-payment-management.dart';
import 'package:iPECS/ipecs-mobile/landlord-profile.dart';
import 'package:iPECS/ipecs-mobile/tenant-profile.dart';
import 'dart:ui';
import 'package:iPECS/utils.dart';

class LandlordDashboard extends StatefulWidget {
  const LandlordDashboard({Key? key}) : super(key: key);

  @override
  _LandlordDashboardState createState() => _LandlordDashboardState();
}

class _LandlordDashboardState extends State<LandlordDashboard> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double sizeAxis = MediaQuery.of(context).size.width / baseWidth;
    double size = sizeAxis * 0.97;

    return Scaffold(
      endDrawer: const Drawer(
        child: LandlordDrawer(), // Call your custom drawer widget here
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.fromLTRB(24 * sizeAxis, 30 * sizeAxis, 24 * sizeAxis, 0 * sizeAxis),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xffffffff),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(8 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 32 * sizeAxis),
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 200 * sizeAxis, 0 * sizeAxis),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LandlordProfile(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Container(
                            width: 48 * sizeAxis,
                            height: 48 * sizeAxis,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24 * sizeAxis),
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('assets/ipecs-mobile/images/user2.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10 * sizeAxis, 20 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis),
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset(
                              'assets/ipecs-mobile/images/drawer.png',
                              width: 25 * sizeAxis,
                              height: 18 * sizeAxis,
                            ),
                            onPressed: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis),
                  child: Text(
                    'Total Payment Received',
                    textAlign: TextAlign.center,
                    style: SafeGoogleFont(
                      'Urbanist',
                      fontSize: 14 * size,
                      fontWeight: FontWeight.w700,
                      height: 1.4285714286 * size / sizeAxis,
                      color: const Color(0xff23426f),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 13 * sizeAxis),
                  child: Text(
                    '₱1000',
                    style: SafeGoogleFont(
                      'Inter',
                      fontSize: 48 * size,
                      fontWeight: FontWeight.w400,
                      height: 1.2 * size / sizeAxis,
                      color: const Color(0xff1f375b),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                // Recent Payments ListView
                Container(
                  margin: EdgeInsets.fromLTRB(0 * sizeAxis, 20 * sizeAxis, 0 * sizeAxis, 13 * sizeAxis),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Record History',
                        style: SafeGoogleFont(
                          'Urbanist',
                          fontSize: 18 * size,
                          fontWeight: FontWeight.w500,
                          height: 1.2 * size / sizeAxis,
                          color: const Color(0xff5c5473),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      // ListView for Recent Payments
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          // Add your ListTile widgets here
                          Card(
                            elevation: 3, // Add elevation for drop shadow
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage('assets/ipecs-mobile/images/user1.png'),
                              ),
                              title: Text(
                                'Credit Balance Added!',
                                style: TextStyle( // Replace SafeGoogleFont with TextStyle
                                  fontFamily: 'Inter', // Specify the font family
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff1f375b),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              subtitle: Text(
                                'June 9, 2023',
                                style: TextStyle( // Replace SafeGoogleFont with TextStyle
                                  fontFamily: 'Urbanist', // Specify the font family
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff9ba7b1),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              trailing: Text(
                                '+ ₱300',
                                style: TextStyle(
                                  fontFamily: 'Inter', // Specify the font family
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff1f375b),
                                  decoration: TextDecoration.none, // Remove underline here
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 15),

                          Card(
                            elevation: 3, // Add elevation for drop shadow
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage('assets/ipecs-mobile/images/user3.png'),
                              ),
                              title: Text(
                                'Credit Balance Added!',
                                style: TextStyle( // Replace SafeGoogleFont with TextStyle
                                  fontFamily: 'Inter', // Specify the font family
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff1f375b),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              subtitle: Text(
                                'June 9, 2023',
                                style: TextStyle( // Replace SafeGoogleFont with TextStyle
                                  fontFamily: 'Urbanist', // Specify the font family
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff9ba7b1),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              trailing: Text(
                                '+ ₱300',
                                style: TextStyle(
                                  fontFamily: 'Inter', // Specify the font family
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff1f375b),
                                  decoration: TextDecoration.none, // Remove underline here
                                ),
                              ),
                            ),
                          ),
                          // Add more ListTiles as needed
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  margin: EdgeInsets.fromLTRB(0 * sizeAxis, 20 * sizeAxis, 0 * sizeAxis, 13 * sizeAxis),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Credit Balance',
                        style: SafeGoogleFont(
                          'Urbanist',
                          fontSize: 18 * size,
                          fontWeight: FontWeight.w500,
                          height: 1.2 * size / sizeAxis,
                          color: const Color(0xff5c5473),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      // ListView for Recent Payments
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          // Add your ListTile widgets here
                          Card(
                            elevation: 3, // Add elevation for drop shadow
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage('assets/ipecs-mobile/images/user1.png'),
                              ),
                              title: Text(
                                'User 1',
                                style: TextStyle( // Replace SafeGoogleFont with TextStyle
                                  fontFamily: 'Inter', // Specify the font family
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff1f375b),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              subtitle: Text(
                                'Room 1',
                                style: TextStyle( // Replace SafeGoogleFont with TextStyle
                                  fontFamily: 'Urbanist', // Specify the font family
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff9ba7b1),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              trailing: Text(
                                '₱500',
                                style: TextStyle(
                                  fontFamily: 'Inter', // Specify the font family
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff1f375b),
                                  decoration: TextDecoration.none, // Remove underline here
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 15),

                          Card(
                            elevation: 3, // Add elevation for drop shadow
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage('assets/ipecs-mobile/images/user3.png'),
                              ),
                              title: Text(
                                'User 2',
                                style: TextStyle( // Replace SafeGoogleFont with TextStyle
                                  fontFamily: 'Inter', // Specify the font family
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff1f375b),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              subtitle: Text(
                                'Room 2',
                                style: TextStyle( // Replace SafeGoogleFont with TextStyle
                                  fontFamily: 'Urbanist', // Specify the font family
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff9ba7b1),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              trailing: Text(
                                '₱500',
                                style: TextStyle(
                                  fontFamily: 'Inter', // Specify the font family
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff1f375b),
                                  decoration: TextDecoration.none, // Remove underline here
                                ),
                              ),
                            ),
                          ),
                          // Add more ListTiles as needed
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
