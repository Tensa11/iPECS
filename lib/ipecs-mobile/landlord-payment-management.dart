import 'package:flutter/material.dart';
import 'package:iPECS/ipecs-mobile/landlord-drawer.dart';
import 'package:iPECS/ipecs-mobile/landlord-profile.dart';
import 'dart:ui';
import 'package:iPECS/utils.dart';

class PaymentManage extends StatefulWidget {
  const PaymentManage({Key? key}) : super(key: key);

  @override
  _PaymentManageState createState() => _PaymentManageState();
}
class _PaymentManageState extends State<PaymentManage> {
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
        child: Container(
          padding: EdgeInsets.fromLTRB(22 * fem, 44 * fem, 24 * fem, 34 * fem),
          decoration: const BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 25*fem),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 200 * fem, 0 * fem),
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
                          width: 48 * fem,
                          height: 48 * fem,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24 * fem),
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
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
                margin: EdgeInsets.fromLTRB(2*fem, 0*fem, 0*fem, 24*fem),
                width: 327*fem,
                decoration: BoxDecoration (
                  borderRadius: BorderRadius.circular(16*fem),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 15*fem),
                      child: Text(
                        'Payment Management',
                        style: SafeGoogleFont (
                          'Urbanist',
                          fontSize: 18*ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.2*ffem/fem,
                          color: const Color(0xff5c5473),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 17*fem),
                      width: double.infinity,
                      height: 110*fem,
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
                          child: Stack(
                            children: [
                              Positioned(
                                left: 16*fem,
                                top: 16*fem,
                                child: SizedBox(
                                  width: 294*fem,
                                  height: 104*fem,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 147*fem, 0*fem),
                                        width: double.infinity,
                                        height: 42*fem,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0*fem, 2*fem, 10*fem, 0*fem),
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
                                                      'Ana Croft',
                                                      style: SafeGoogleFont (
                                                        'Urbanist',
                                                        fontSize: 20*ffem,
                                                        fontWeight: FontWeight.w700,
                                                        height: 0.9*ffem/fem,
                                                        color: const Color(0xff23426f),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                                                    child: Text(
                                                      'Room 1',
                                                      style: SafeGoogleFont (
                                                        'Urbanist',
                                                        fontSize: 12*ffem,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.5*ffem/fem,
                                                        color: const Color(0xff9ba7b1),
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
                                        margin: EdgeInsets.fromLTRB(42*fem, 0*fem, 0*fem, 0*fem),
                                        child: Text(
                                          '₱300',
                                          style: SafeGoogleFont (
                                            'Inter',
                                            fontSize: 12*ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.5*ffem/fem,
                                            color: const Color(0xff9ba7b1),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                                        width: double.infinity,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(175*fem, 0*fem, 0*fem, 0*fem),
                                              child: TextButton(
                                                onPressed: () {},
                                                style: TextButton.styleFrom (
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: Text(
                                                  'Accept',
                                                  style: SafeGoogleFont (
                                                    'Urbanist',
                                                    fontSize: 12*ffem,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.2857142857*ffem/fem,
                                                    color: const Color(0xff47e83d),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                                              child: TextButton(
                                                onPressed: () {},
                                                style: TextButton.styleFrom (
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: Text(
                                                  'Reject',
                                                  style: SafeGoogleFont (
                                                    'Urbanist',
                                                    fontSize: 12*ffem,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.2857142857*ffem/fem,
                                                    color: const Color(0xffea3b2f),
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
                              ),
                              Positioned(
                                left: 286 * fem,
                                child: IconButton(
                                  onPressed: () {
                                    // Handle Proof of Payment
                                  },
                                  icon: Icon(
                                    Icons.image, // You can use any edit icon you prefer
                                    size: 25 * fem, // Adjust the size as needed
                                    color: const Color(0xff231b53), // Customize the color
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // 2nd User
                    Container(
                      margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 17*fem),
                      width: double.infinity,
                      height: 110*fem,
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
                          child: Stack(
                            children: [
                              Positioned(
                                left: 16*fem,
                                top: 16*fem,
                                child: SizedBox(
                                  width: 294*fem,
                                  height: 104*fem,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 147*fem, 0*fem),
                                        width: double.infinity,
                                        height: 42*fem,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0*fem, 2*fem, 10*fem, 0*fem),
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
                                              height: double.infinity,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                                                    child: Text(
                                                      'Mr. 11',
                                                      style: SafeGoogleFont (
                                                        'Urbanist',
                                                        fontSize: 20*ffem,
                                                        fontWeight: FontWeight.w700,
                                                        height: 0.9*ffem/fem,
                                                        color: const Color(0xff23426f),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                                                    child: Text(
                                                      'Room 2',
                                                      style: SafeGoogleFont (
                                                        'Urbanist',
                                                        fontSize: 12*ffem,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1.5*ffem/fem,
                                                        color: const Color(0xff9ba7b1),
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
                                        margin: EdgeInsets.fromLTRB(42*fem, 0*fem, 0*fem, 0*fem),
                                        child: Text(
                                          '₱400',
                                          style: SafeGoogleFont (
                                            'Inter',
                                            fontSize: 12*ffem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.5*ffem/fem,
                                            color: const Color(0xff9ba7b1),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                                        width: double.infinity,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(175*fem, 0*fem, 0*fem, 0*fem),
                                              child: TextButton(
                                                onPressed: () {},
                                                style: TextButton.styleFrom (
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: Text(
                                                  'Accept',
                                                  style: SafeGoogleFont (
                                                    'Urbanist',
                                                    fontSize: 12*ffem,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.2857142857*ffem/fem,
                                                    color: const Color(0xff47e83d),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 0*fem, 0*fem),
                                              child: TextButton(
                                                onPressed: () {},
                                                style: TextButton.styleFrom (
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: Text(
                                                  'Reject',
                                                  style: SafeGoogleFont (
                                                    'Urbanist',
                                                    fontSize: 12*ffem,
                                                    fontWeight: FontWeight.w700,
                                                    height: 1.2857142857*ffem/fem,
                                                    color: const Color(0xffea3b2f),
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
                              ),
                              Positioned(
                                left: 286 * fem,
                                child: IconButton(
                                  onPressed: () {
                                    // Proof of Payment
                                  },
                                  icon: Icon(
                                    Icons.image, // You can use any edit icon you prefer
                                    size: 25 * fem, // Adjust the size as needed
                                    color: const Color(0xff231b53), // Customize the color
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0*fem, 0*fem, 2*fem, 133*fem),
                width: 327*fem,
                height: 130*fem,
                decoration: BoxDecoration (
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(16*fem),
                  border: const Border (
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
