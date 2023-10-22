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
    double sizeAxis = MediaQuery.of(context).size.width / baseWidth;
    double size = sizeAxis * 0.97;
    return Scaffold(
      endDrawer: const Drawer(
        child: TenantDrawer(), // Call your custom drawer widget here
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Container(
            width: double.infinity,
            height: 812 * sizeAxis,
            decoration: const BoxDecoration(
              color: Color(0xffffffff),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 24 * sizeAxis,
                  top: 121 * sizeAxis,
                  child: Container(
                    width: 327 * sizeAxis,
                    height: 268 * sizeAxis,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16 * sizeAxis),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 12 * sizeAxis),
                          child: Text(
                            'Payment Records',
                            style: SafeGoogleFont(
                              'Urbanist',
                              fontSize: 18 * size,
                              fontWeight: FontWeight.w500,
                              height: 1.2 * size / sizeAxis,
                              color: const Color(0xff5c5473),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16 * sizeAxis),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(16 * sizeAxis, 16 * sizeAxis, 16 * sizeAxis, 16 * sizeAxis),
                                width: double.infinity,
                                height: 70 * sizeAxis,
                                decoration: BoxDecoration(
                                  color: const Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(16 * sizeAxis),
                                  border: const Border(),
                                ),
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 20 * sizeAxis,
                                      sigmaY: 20 * sizeAxis,
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 100 * sizeAxis, 0 * sizeAxis),
                                          height: double.infinity,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 16 * sizeAxis, 0 * sizeAxis),
                                                width: 32 * sizeAxis,
                                                height: 32 * sizeAxis,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(16 * sizeAxis),
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
                                                      margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 2 * sizeAxis),
                                                      child: Text(
                                                        '+ ₱300',
                                                        style: SafeGoogleFont(
                                                          'Inter',
                                                          fontSize: 14 * size,
                                                          fontWeight: FontWeight.w700,
                                                          height: 1.2857142857 * size / sizeAxis,
                                                          color: const Color(0xff23426f),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'June 25, 2023',
                                                      style: SafeGoogleFont(
                                                        'Urbanist',
                                                        fontSize: 12 * size,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1 * size / sizeAxis,
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
                                          margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 20 * sizeAxis),
                                          child: Text(
                                            'PENDING',
                                            style: SafeGoogleFont(
                                              'Urbanist',
                                              fontSize: 14 * size,
                                              fontWeight: FontWeight.w700,
                                              height: 1.2857142857 * size / sizeAxis,
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
                                height: 12 * sizeAxis,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(16 * sizeAxis, 16 * sizeAxis, 16 * sizeAxis, 16 * sizeAxis),
                                width: double.infinity,
                                height: 70 * sizeAxis,
                                decoration: BoxDecoration(
                                  color: const Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(16 * sizeAxis),
                                  border: const Border(),
                                ),
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 20 * sizeAxis,
                                      sigmaY: 20 * sizeAxis,
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 130 * sizeAxis, 0 * sizeAxis),
                                          height: double.infinity,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 16 * sizeAxis, 0 * sizeAxis),
                                                width: 32 * sizeAxis,
                                                height: 32 * sizeAxis,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(16 * sizeAxis),
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
                                                      margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 2 * sizeAxis),
                                                      child: Text(
                                                        '+ ₱500',
                                                        style: SafeGoogleFont(
                                                          'Inter',
                                                          fontSize: 14 * size,
                                                          fontWeight: FontWeight.w700,
                                                          height: 1.2857142857 * size / sizeAxis,
                                                          color: const Color(0xff23426f),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      'June 6, 2023',
                                                      style: SafeGoogleFont(
                                                        'Urbanist',
                                                        fontSize: 12 * size,
                                                        fontWeight: FontWeight.w700,
                                                        height: 1 * size / sizeAxis,
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
                                          margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 20 * sizeAxis),
                                          child: Text(
                                            'PAID',
                                            style: SafeGoogleFont(
                                              'Urbanist',
                                              fontSize: 14 * size,
                                              fontWeight: FontWeight.w700,
                                              height: 1.2857142857 * size / sizeAxis,
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
                                height: 12 * sizeAxis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12 * sizeAxis,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 32 * sizeAxis,
                  top: 28 * sizeAxis,
                  child: SizedBox(
                    width: 319 * sizeAxis,
                    height: 780 * sizeAxis,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 641 * sizeAxis),
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
                          margin: EdgeInsets.fromLTRB(32*sizeAxis, 0*sizeAxis, 38*sizeAxis, 0*sizeAxis),
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
                              height: 56*sizeAxis,
                              decoration: BoxDecoration (
                                color: const Color(0xff231b53),
                                borderRadius: BorderRadius.circular(30*sizeAxis),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0x14000000),
                                    offset: Offset(0*sizeAxis, 20*sizeAxis),
                                    blurRadius: 30*sizeAxis,
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
                                      fontSize: 16*size,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5*size/sizeAxis,
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
