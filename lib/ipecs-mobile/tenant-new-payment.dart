import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iPECS/ipecs-mobile/tenant-drawer.dart';
import 'package:iPECS/ipecs-mobile/tenant-login.dart';
import 'package:iPECS/ipecs-mobile/tenant-profile.dart';

class NewPayment extends StatefulWidget {
  const NewPayment({super.key});

  @override
  _NewPaymentState createState() => _NewPaymentState();
}

class _NewPaymentState extends State<NewPayment> {
  double baseWidth = 375;
  double fem = 1.0;
  double ffem = 1.0;

  @override
  Widget build(BuildContext context) {
    fem = MediaQuery.of(context).size.width / baseWidth;
    ffem = fem * 0.97;
    return Scaffold(
      endDrawer: const Drawer(
        child: TenantDrawer(), // Call your custom drawer widget here
      ),
      body: SingleChildScrollView( // Wrap your content with a SingleChildScrollView
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.fromLTRB(22 * fem, 28 * fem, 21 * fem, 180 * fem),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xffffffff),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10 * fem, 0 * fem, 3 * fem, 70 * fem),
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
                                builder: (context) => const TenantProfile(),
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
                  margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 100 * fem, 4 * fem),
                  child: Text(
                    'Payment Details',
                    style: GoogleFonts.urbanist(
                      fontSize: 30 * ffem,
                      fontWeight: FontWeight.w700,
                      height: 1.3 * ffem / fem,
                      letterSpacing: -0.3 * fem,
                      color: const Color(0xff1e232c),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 149 * fem, 15 * fem),
                  constraints: BoxConstraints(
                    maxWidth: 181 * fem,
                  ),
                  child: Text(
                    'Fill up the needed details and attach the proof of payment',
                    style: GoogleFonts.inter(
                      fontSize: 13 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 1.5384615385 * ffem / fem,
                      color: const Color(0xff1e232c),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(1 * fem, 0 * fem, 0 * fem, 15 * fem),
                  width: 331 * fem,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8 * fem),
                    border: Border.all(color: const Color(0xffe8ecf4)),
                    color: const Color(0xfff7f8f9),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(18 * fem, 18 * fem, 18 * fem, 19 * fem),
                      hintText: 'Reference Number',
                      hintStyle: const TextStyle(color: Color(0xff8390a1)),
                    ),
                    style: GoogleFonts.urbanist(
                      fontSize: 15 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.25 * ffem / fem,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(1 * fem, 0 * fem, 0 * fem, 15 * fem),
                  width: double.infinity,
                  height: 56 * fem,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffe8ecf4)),
                    color: const Color(0xfff7f7f8),
                    borderRadius: BorderRadius.circular(8 * fem),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(18 * fem, 17 * fem, 16 * fem, 17 * fem),
                      hintText: 'Name',
                      hintStyle: const TextStyle(color: Color(0xff8390a1)),
                    ),
                    style: GoogleFonts.urbanist(
                      fontSize: 15 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.25 * ffem / fem,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 1 * fem, 19 * fem),
                  width: 331 * fem,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8 * fem),
                    border: Border.all(color: const Color(0xffe8ecf4)),
                    color: const Color(0xfff7f7f8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(18 * fem, 17 * fem, 16 * fem, 17 * fem),
                      hintText: 'Room Number',
                      hintStyle: const TextStyle(color: Color(0xff8390a1)),
                    ),
                    style: GoogleFonts.urbanist(
                      fontSize: 15 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.25 * ffem / fem,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(1 * fem, 0 * fem, 0 * fem, 59 * fem),
                  width: double.infinity,
                  height: 56 * fem,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffe8ecf4)),
                    color: const Color(0xfff7f7f8),
                    borderRadius: BorderRadius.circular(8 * fem),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(18 * fem, 17 * fem, 16 * fem, 17 * fem),
                      hintText: 'Proof of Payment',
                      hintStyle: const TextStyle(color: Color(0xff8390a1)),
                    ),
                    style: GoogleFonts.urbanist(
                      fontSize: 15 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.25 * ffem / fem,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(39 * fem, 0 * fem, 36 * fem, 0 * fem),
                  child: TextButton(
                    onPressed: () {
                      // Submit
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 56 * fem,
                      decoration: BoxDecoration(
                        color: const Color(0xff231b53),
                        borderRadius: BorderRadius.circular(30 * fem),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x14000000),
                            offset: Offset(0 * fem, 20 * fem),
                            blurRadius: 30 * fem,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Submit',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                            fontSize: 16 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.5 * ffem / fem,
                            color: const Color(0xffffffff),
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
