import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:iPECS/ipecs-mobile/landlord-drawer.dart';
import 'package:iPECS/ipecs-mobile/landlord-payment-management.dart';
import 'package:iPECS/ipecs-mobile/landlord-profile.dart';
import 'dart:ui';
import 'package:iPECS/utils.dart';

class LandlordDashboard extends StatefulWidget {
  const LandlordDashboard({Key? key}) : super(key: key);

  @override
  _LandlordDashboardState createState() => _LandlordDashboardState();
}

class _LandlordDashboardState extends State<LandlordDashboard> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      endDrawer: const Drawer(
        child: LandlordDrawer(), // Call your custom drawer widget here
      ),
      body: SingleChildScrollView(
        child: SizedBox(
        width: double.infinity,
        child: Container(
          padding: EdgeInsets.fromLTRB(24*fem, 30*fem, 24*fem, 0*fem),
          width: double.infinity,
          decoration: const BoxDecoration (
            color: Color(0xffffffff),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(8*fem, 0*fem, 0*fem, 32*fem),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // Avatar Icon
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 200*fem, 0*fem),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LandlordProfile(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom (
                          padding: EdgeInsets.zero,
                        ),
                        child: Container(
                          width: 48*fem,
                          height: 48*fem,
                          decoration: BoxDecoration (
                            borderRadius: BorderRadius.circular(24*fem),
                            image: const DecorationImage (
                              fit: BoxFit.cover,
                              image: AssetImage (
                                'assets/ipecs-mobile/images/user2.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // This is for the Drawer!
                      margin: EdgeInsets.fromLTRB(10 * fem, 20 * fem, 0 * fem, 0 * fem),
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: Image.asset(
                            'assets/ipecs-mobile/images/drawer.png',
                            width: 25 * fem,
                            height: 18 * fem,
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
                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                child: Text(
                  'Total Payments Received',
                  textAlign: TextAlign.center,
                  style: SafeGoogleFont (
                    'Urbanist',
                    fontSize: 14*ffem,
                    fontWeight: FontWeight.w700,
                    height: 1.4285714286*ffem/fem,
                    color: const Color(0xff23426f),
                    decoration: TextDecoration.none, // Remove underline here
                  ),
                ),
              ),
              Container(
                // nSM (192:5684)
                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 13*fem),
                child: Text(
                  '₱1000',
                  style: SafeGoogleFont (
                    'Inter',
                    fontSize: 48*ffem,
                    fontWeight: FontWeight.w400,
                    height: 1.2*ffem/fem,
                    color: const Color(0xff1f375b),
                    decoration: TextDecoration.none, // Remove underline here
                  ),
                ),
              ),
              Container(
                // Record History
                margin: EdgeInsets.fromLTRB(0*fem, 10*fem, 0*fem, 13*fem),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 12*fem),
                      child: Text(
                        'Record History',
                        style: SafeGoogleFont (
                          'Urbanist',
                          fontSize: 18*ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.2*ffem/fem,
                          color: const Color(0xff5c5473),
                          decoration: TextDecoration.none, // Remove underline here
                        ),
                      ),
                    ),
                    SizedBox(
                      // group115wyT (192:5784)
                      width: double.infinity,
                      height: 210*fem,
                      child: Stack(
                        children: [
                          Positioned(
                            // frame80Vzy (192:5792)
                            left: 0*fem,
                            top: 92*fem,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(16*fem, 64*fem, 15*fem, 16*fem),
                              width: 327*fem,
                              height: 118*fem,
                              decoration: BoxDecoration (
                                color: const Color(0xffffffff),
                                border: const Border (
                                ),
                                borderRadius: BorderRadius.only (
                                  bottomRight: Radius.circular(16*fem),
                                  bottomLeft: Radius.circular(16*fem),
                                ),
                              ),
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur (
                                    sigmaX: 20*fem,
                                    sigmaY: 20*fem,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 91*fem, 0*fem),
                                        height: double.infinity,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                                              width: 32*fem,
                                              height: 32*fem,
                                              decoration: BoxDecoration (
                                                borderRadius: BorderRadius.circular(16*fem),
                                                image: const DecorationImage (
                                                  fit: BoxFit.cover,
                                                  image: AssetImage (
                                                    'assets/ipecs-mobile/images/user3.png',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              // group90nsb (192:5795)
                                              height: double.infinity,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    //  (192:5796)
                                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                                                    child: Text(
                                                      'New Balance!',
                                                      style: SafeGoogleFont (
                                                        'Urbanist',
                                                        fontSize: 12*ffem,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.5*ffem/fem,
                                                        color: const Color(0xff1f375b),
                                                        decoration: TextDecoration.none, // Remove underline here
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'June 9, 2023',
                                                    style: SafeGoogleFont (
                                                      'Urbanist',
                                                      fontSize: 12*ffem,
                                                      fontWeight: FontWeight.w700,
                                                      height: 1.5*ffem/fem,
                                                      color: const Color(0xff9ba7b1),
                                                      decoration: TextDecoration.none,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 20*fem),
                                        child: Text(
                                          '₱250',
                                          style: SafeGoogleFont (
                                            'Inter',
                                            fontSize: 14*ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.2857142857*ffem/fem,
                                            color: const Color(0xff23426f),
                                            decoration: TextDecoration.none, // Remove underline here
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // frame7984H (192:5799)
                            left: 0*fem,
                            top: 22*fem,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(16*fem, 64*fem, 14*fem, 16*fem),
                              width: 327*fem,
                              height: 118*fem,
                              decoration: BoxDecoration (
                                color: const Color(0xffffffff),
                                border: const Border (
                                ),
                                borderRadius: BorderRadius.only (
                                  bottomRight: Radius.circular(16*fem),
                                  bottomLeft: Radius.circular(16*fem),
                                ),
                              ),
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur (
                                    sigmaX: 20*fem,
                                    sigmaY: 20*fem,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 92*fem, 0*fem),
                                        height: double.infinity,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                                              width: 32*fem,
                                              height: 32*fem,
                                              decoration: BoxDecoration (
                                                borderRadius: BorderRadius.circular(16*fem),
                                                image: const DecorationImage (
                                                  fit: BoxFit.cover,
                                                  image: AssetImage (
                                                    'assets/ipecs-mobile/images/user4.png',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: double.infinity,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                                                    child: Text(
                                                      'New Balance!',
                                                      style: SafeGoogleFont (
                                                        'Urbanist',
                                                        fontSize: 12*ffem,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.5*ffem/fem,
                                                        color: const Color(0xff1f375b),
                                                        decoration: TextDecoration.none, // Remove underline here
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'June 14, 2023',
                                                    style: SafeGoogleFont (
                                                      'Urbanist',
                                                      fontSize: 12*ffem,
                                                      fontWeight: FontWeight.w700,
                                                      height: 1.5*ffem/fem,
                                                      color: const Color(0xff9ba7b1),
                                                      decoration: TextDecoration.none, // Remove underline here
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        // eaM (192:5805)
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 20*fem),
                                        child: Text(
                                          '₱300',
                                          style: SafeGoogleFont (
                                            'Inter',
                                            fontSize: 14*ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.2857142857*ffem/fem,
                                            color: const Color(0xff23426f),
                                            decoration: TextDecoration.none, // Remove underline here
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // frame78mey (192:5806)
                            left: 0*fem,
                            top: 0*fem,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(16*fem, 16*fem, 14*fem, 16*fem),
                              width: 327*fem,
                              height: 70*fem,
                              decoration: BoxDecoration (
                                color: const Color(0xffffffff),
                                borderRadius: BorderRadius.circular(16*fem),
                                border: const Border (
                                ),
                              ),
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur (
                                    sigmaX: 20*fem,
                                    sigmaY: 20*fem,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        // group92T21 (192:5807)
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 92*fem, 0*fem),
                                        height: double.infinity,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                                              width: 32*fem,
                                              height: 32*fem,
                                              decoration: BoxDecoration (
                                                borderRadius: BorderRadius.circular(16*fem),
                                                image: const DecorationImage (
                                                  fit: BoxFit.cover,
                                                  image: AssetImage (
                                                    'assets/ipecs-mobile/images/user1.png',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: double.infinity,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                                                    child: Text(
                                                      'New Balance!',
                                                      style: SafeGoogleFont (
                                                        'Urbanist',
                                                        fontSize: 12*ffem,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.5*ffem/fem,
                                                        color: const Color(0xff1f375b),
                                                        decoration: TextDecoration.none, // Remove underline here
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'June 20, 2023',
                                                    style: SafeGoogleFont (
                                                      'Urbanist',
                                                      fontSize: 12*ffem,
                                                      fontWeight: FontWeight.w700,
                                                      height: 1.5*ffem/fem,
                                                      color: const Color(0xff9ba7b1),
                                                      decoration: TextDecoration.none, // Remove underline here

                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        // vph (192:5812)
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 20*fem),
                                        child: Text(
                                          '₱300',
                                          style: SafeGoogleFont (
                                            'Inter',
                                            fontSize: 14*ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.2857142857*ffem/fem,
                                            color: const Color(0xff23426f),
                                            decoration: TextDecoration.none, // Remove underline here
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // Credit Balance
                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 12*fem),
                      child: Text(
                        'Credit Balance',
                        style: SafeGoogleFont (
                          'Urbanist',
                          fontSize: 18*ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.2*ffem/fem,
                          color: const Color(0xff5c5473),
                          decoration: TextDecoration.none, // Remove underline here
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 210*fem,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0*fem,
                            top: 92*fem,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(16*fem, 64*fem, 14*fem, 16*fem),
                              width: 327*fem,
                              height: 118*fem,
                              decoration: BoxDecoration (
                                color: const Color(0xffffffff),
                                border: const Border (
                                ),
                                borderRadius: BorderRadius.only (
                                  bottomRight: Radius.circular(16*fem),
                                  bottomLeft: Radius.circular(16*fem),
                                ),
                              ),
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur (
                                    sigmaX: 20*fem,
                                    sigmaY: 20*fem,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // frame79wfF (192:5702)
                            left: 0*fem,
                            top: 22*fem,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(16*fem, 64*fem, 15*fem, 16*fem),
                              width: 327*fem,
                              height: 118*fem,
                              decoration: BoxDecoration (
                                color: const Color(0xffffffff),
                                border: const Border (
                                ),
                                borderRadius: BorderRadius.only (
                                  bottomRight: Radius.circular(16*fem),
                                  bottomLeft: Radius.circular(16*fem),
                                ),
                              ),
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur (
                                    sigmaX: 20*fem,
                                    sigmaY: 20*fem,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        // group92ztR (192:5703)
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 160*fem, 0*fem),
                                        height: double.infinity,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                                              width: 32*fem,
                                              height: 32*fem,
                                              decoration: BoxDecoration (
                                                borderRadius: BorderRadius.circular(16*fem),
                                                image: const DecorationImage (
                                                  fit: BoxFit.cover,
                                                  image: AssetImage (
                                                    'assets/ipecs-mobile/images/user3.png',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              // group90fDs (192:5705)
                                              height: double.infinity,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                                                    child: Text(
                                                      'Ana',
                                                      style: SafeGoogleFont (
                                                        'Urbanist',
                                                        fontSize: 12*ffem,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.5*ffem/fem,
                                                        color: const Color(0xff1f375b),
                                                        decoration: TextDecoration.none, // Remove underline here
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Room 2',
                                                    style: SafeGoogleFont (
                                                      'Urbanist',
                                                      fontSize: 12*ffem,
                                                      fontWeight: FontWeight.w700,
                                                      height: 1.5*ffem/fem,
                                                      color: const Color(0xff9ba7b1),
                                                      decoration: TextDecoration.none, // Remove underline here
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        // hgM (192:5708)
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 20*fem),
                                        child: Text(
                                          '₱500',
                                          style: SafeGoogleFont (
                                            'Inter',
                                            fontSize: 14*ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.2857142857*ffem/fem,
                                            color: const Color(0xff23426f),
                                            decoration: TextDecoration.none, // Remove underline here
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            // frame78d4D (192:5709)
                            left: 0*fem,
                            top: 0*fem,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(16*fem, 16*fem, 15*fem, 16*fem),
                              width: 327*fem,
                              height: 70*fem,
                              decoration: BoxDecoration (
                                color: const Color(0xffffffff),
                                borderRadius: BorderRadius.circular(16*fem),
                                border: const Border (
                                ),
                              ),
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur (
                                    sigmaX: 20*fem,
                                    sigmaY: 20*fem,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 151*fem, 0*fem),
                                        height: double.infinity,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 16*fem, 0*fem),
                                              width: 32*fem,
                                              height: 32*fem,
                                              decoration: BoxDecoration (
                                                borderRadius: BorderRadius.circular(16*fem),
                                                image: const DecorationImage (
                                                  fit: BoxFit.cover,
                                                  image: AssetImage (
                                                    'assets/ipecs-mobile/images/user1.png',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              // group90aNm (192:5712)
                                              height: double.infinity,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                                                    child: Text(
                                                      'Yors',
                                                      style: SafeGoogleFont (
                                                        'Urbanist',
                                                        fontSize: 12*ffem,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.5*ffem/fem,
                                                        color: const Color(0xff1f375b),
                                                        decoration: TextDecoration.none, // Remove underline here
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Room 1',
                                                    style: SafeGoogleFont (
                                                      'Urbanist',
                                                      fontSize: 12*ffem,
                                                      fontWeight: FontWeight.w700,
                                                      height: 1.5*ffem/fem,
                                                      color: const Color(0xff9ba7b1),
                                                      decoration: TextDecoration.none, // Remove underline here
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 20*fem),
                                        child: Text(
                                          '₱500',
                                          style: SafeGoogleFont (
                                            'Inter',
                                            fontSize: 14*ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.2857142857*ffem/fem,
                                            color: const Color(0xff23426f),
                                            decoration: TextDecoration.none, // Remove underline here
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // Button Payment Management
                margin: EdgeInsets.fromLTRB(32*fem, 0*fem, 32*fem, 0*fem),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PaymentManage(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom (
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 56*fem,
                    decoration: BoxDecoration (
                      color: const Color(0xff231b53),
                      borderRadius: BorderRadius.circular(30*fem),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x14000000),
                          offset: Offset(0*fem, 20*fem),
                          blurRadius: 30*fem,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Center(
                        child: Text(
                          'Payment Management',
                          textAlign: TextAlign.center,
                          style: SafeGoogleFont (
                            'Urbanist',
                            fontSize: 16*ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.5*ffem/fem,
                            color: const Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                    ),
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