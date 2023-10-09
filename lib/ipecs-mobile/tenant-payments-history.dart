import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:iPECS/ipecs-mobile/landlord-profile.dart';
import 'package:iPECS/ipecs-mobile/tenant-drawer.dart';
import 'package:iPECS/ipecs-mobile/tenant-new-payment.dart';
import 'package:iPECS/utils.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({Key? key}) : super(key: key);

  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      endDrawer: const Drawer(
        child: TenantDrawer(), // Call your custom drawer widget here
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Container(
            width: double.infinity,
            height: 812 * fem,
            decoration: const BoxDecoration(
              color: Color(0xffffffff),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 24 * fem,
                  top: 121 * fem,
                  child: Container(
                    width: 327 * fem,
                    height: 268 * fem,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16 * fem),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 12 * fem),
                          child: Text(
                            'Payment Records',
                            style: SafeGoogleFont(
                              'Urbanist',
                              fontSize: 18 * ffem,
                              fontWeight: FontWeight.w500,
                              height: 1.2 * ffem / fem,
                              color: const Color(0xff5c5473),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16 * fem),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(16 * fem, 16 * fem, 16 * fem, 16 * fem),
                                width: double.infinity,
                                height: 70 * fem,
                                decoration: BoxDecoration(
                                  color: const Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(16 * fem),
                                  border: const Border(),
                                ),
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 20 * fem,
                                      sigmaY: 20 * fem,
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 100 * fem, 0 * fem),
                                          height: double.infinity,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 16 * fem, 0 * fem),
                                                width: 32 * fem,
                                                height: 32 * fem,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(16 * fem),
                                                  image: const DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
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
                                                      margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 2 * fem),
                                                      child: Text(
                                                        '+ ₱300',
                                                        style: SafeGoogleFont(
                                                          'Inter',
                                                          fontSize: 14 * ffem,
                                                          fontWeight: FontWeight.w700,
                                                          height: 1.2857142857 * ffem / fem,
                                                          color: const Color(0xff23426f),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'June 25, 2023',
                                                      style: SafeGoogleFont(
                                                        'Urbanist',
                                                        fontSize: 12 * ffem,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1 * ffem / fem,
                                                        color: const Color(0xff9ba7b1),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 20 * fem),
                                          child: Text(
                                            'PENDING',
                                            style: SafeGoogleFont(
                                              'Urbanist',
                                              fontSize: 14 * ffem,
                                              fontWeight: FontWeight.w700,
                                              height: 1.2857142857 * ffem / fem,
                                              color: const Color(0xffdfb153),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12 * fem,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(16 * fem, 16 * fem, 16 * fem, 16 * fem),
                                width: double.infinity,
                                height: 70 * fem,
                                decoration: BoxDecoration(
                                  color: const Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(16 * fem),
                                  border: const Border(),
                                ),
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 20 * fem,
                                      sigmaY: 20 * fem,
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 130 * fem, 0 * fem),
                                          height: double.infinity,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 16 * fem, 0 * fem),
                                                width: 32 * fem,
                                                height: 32 * fem,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(16 * fem),
                                                  image: const DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
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
                                                      margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 2 * fem),
                                                      child: Text(
                                                        '+ ₱500',
                                                        style: SafeGoogleFont(
                                                          'Inter',
                                                          fontSize: 14 * ffem,
                                                          fontWeight: FontWeight.w700,
                                                          height: 1.2857142857 * ffem / fem,
                                                          color: const Color(0xff23426f),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'June 6, 2023',
                                                      style: SafeGoogleFont(
                                                        'Urbanist',
                                                        fontSize: 12 * ffem,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1 * ffem / fem,
                                                        color: const Color(0xff9ba7b1),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 20 * fem),
                                          child: Text(
                                            'PAID',
                                            style: SafeGoogleFont(
                                              'Urbanist',
                                              fontSize: 14 * ffem,
                                              fontWeight: FontWeight.w700,
                                              height: 1.2857142857 * ffem / fem,
                                              color: const Color(0xff05cd99),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12 * fem,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12 * fem,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 32 * fem,
                  top: 28 * fem,
                  child: SizedBox(
                    width: 319 * fem,
                    height: 780 * fem,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 0 * fem, 641 * fem),
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
                                          'assets/ipecs-mobile/images/user1.png',
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
                          margin: EdgeInsets.fromLTRB(32*fem, 0*fem, 38*fem, 0*fem),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const NewPayment(),
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
                                    'New Payment',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
