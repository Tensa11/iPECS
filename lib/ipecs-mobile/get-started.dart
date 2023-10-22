import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:iPECS/ipecs-mobile/tenant-login.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 400;
    double sizeAxis = MediaQuery.of(context).size.width / baseWidth;
    double size = sizeAxis * 0.97;
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.fromLTRB(0*sizeAxis, 520*sizeAxis, 0*sizeAxis, 0*sizeAxis),
        width: double.infinity,
        decoration: const BoxDecoration (
          image: DecorationImage (
            fit: BoxFit.cover,
            image: AssetImage (
              'assets/ipecs-mobile/images/get-started-bg.png',
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16*sizeAxis, 16*sizeAxis, 16*sizeAxis, 16*sizeAxis),
              width: double.infinity,
              decoration: const BoxDecoration (
                gradient: LinearGradient (
                  begin: Alignment(0, -1.186),
                  end: Alignment(0, 1),
                  colors: <Color>[Color(0x000f172a), Color(0xff0f172a)],
                  stops: <double>[0, 1],
                ),
              ),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur (
                    sigmaX: 10*sizeAxis,
                    sigmaY: 10*sizeAxis,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // textDtM (190:483)
                        margin: EdgeInsets.fromLTRB(0*sizeAxis, 0*sizeAxis, 22*sizeAxis, 24*sizeAxis),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // headingMzZ (190:484)
                              margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 8 * sizeAxis),
                              constraints: BoxConstraints(
                                maxWidth: 203 * sizeAxis,
                              ),
                              child: Text(
                                'Powering your life with convenience',
                                style: GoogleFonts.inter(
                                  fontSize: 24 * size,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3333333333 * size / sizeAxis,
                                  letterSpacing: -0.48 * sizeAxis,
                                  color: const Color(0xffffffff),
                                  decoration: TextDecoration.none, // Remove the underline
                                ),
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints (
                                maxWidth: 321*sizeAxis,
                              ),
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.inter(
                                    fontSize: 13*size,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5384615385*size/sizeAxis,
                                    color: const Color(0xffe2e8f0),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'iPECS',
                                      style: GoogleFonts.inter(
                                        fontSize: 13*size,
                                        fontWeight: FontWeight.w700,
                                        height: 1.5384615385*size/sizeAxis,
                                        color: const Color(0xffe2e8f0),
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' is efficient and hassle-free prepaid electricity consumption system in rented apartments. We are dedicated to revolutionize the way electricity is managed and billed in rental properties',
                                      style: GoogleFonts.inter(
                                        fontSize: 13*size,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5384615385*size/sizeAxis,
                                        color: const Color(0xffe2e8f0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const TenantLogin(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50 * sizeAxis,
                          decoration: BoxDecoration(
                            color: const Color(0xffdfb153),
                            borderRadius: BorderRadius.circular(6 * sizeAxis),
                          ),
                          child: Center(
                            child: Text(
                              'Login',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 16 * size,
                                fontWeight: FontWeight.w500,
                                height: 1.5 * size / sizeAxis,
                                color: const Color(0xffffffff),
                                decoration: TextDecoration.none, // Remove the underline
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
            Container(
              width: double.infinity,
              height: 34*sizeAxis,
              decoration: const BoxDecoration (
                color: Color(0xff0f172a),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
