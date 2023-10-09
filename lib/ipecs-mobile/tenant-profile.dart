import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iPECS/ipecs-mobile/tenant-login.dart';

class TenantProfile extends StatefulWidget {
  const TenantProfile({Key? key}) : super(key: key);

  @override
  _TenantProfileState createState() => _TenantProfileState();
}

class _TenantProfileState extends State<TenantProfile> {
  final double coverHeight = 280;
  final double profileHeight = 144;

  double baseWidth = 375;
  late double fem;
  late double ffem;

  @override
  Widget build(BuildContext context) {
    fem = MediaQuery.of(context).size.width / baseWidth;
    ffem = fem * 0.97;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(),
          buildContent(),
          Container(
            margin: EdgeInsets.fromLTRB(38 * fem, 160 * fem, 38 * fem, 0 * fem),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TenantLogin(),
                  ),
                );
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
                    'Logout',
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
    );
  }

  Widget buildContent() => const Column(
    children: [
      SizedBox(height: 30),
      Text(
        'Ana Croft',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      ),
      SizedBox(height: 5),
      Text(
        'Tenant: Room 1',
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
      SizedBox(height: 16),
      SizedBox(height: 16),
      Divider(),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                '₱500', // Replace with the actual value
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xff23426f)),
                textAlign: TextAlign.center,
              ),
              Text(
                'Credit\nBalance',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(width: 20), // Add spacing between the pairs of text
          Column(
            children: [
              Text(
                '120 kWh', // Replace with the actual value
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xff23426f)),
                textAlign: TextAlign.center,
              ),
              Text(
                'Electricity\nConsumption',
                style: TextStyle(fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 25),
      Divider(),
    ],
  );

  Widget buildTop() {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 3;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        buildCoverImage(),
        Positioned(
          top: top,
          child: buildProfileImage(),
        ),
      ],
    );
  }

  Widget buildCoverImage() => Stack( // Merged code
    children: [
      Container(
        color: Colors.white,
        child: Image(
          image: const AssetImage('assets/ipecs-mobile/images/get-started-bg.png'),
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        top: 12 * fem,
        left: 12 * fem,
        child: Container(
          margin: EdgeInsets.fromLTRB(10 * fem, 12 * fem, 200 * fem, 0 * fem),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            child: SizedBox(
              width: 41 * fem,
              height: 41 * fem,
              child: Image.asset(
                'assets/ipecs-mobile/images/back.png',
                width: 41 * fem,
                height: 41 * fem,
              ),
            ),
          ),
        ),
      ),
    ],
  );

  Widget buildProfileImage() => CircleAvatar(
    radius: profileHeight / 2,
    backgroundColor: Colors.white,
    child: const ClipOval(
      child: Image(
        image: AssetImage('assets/ipecs-mobile/images/user1.png'),
        fit: BoxFit.cover,
        width: 130,
        height: 130,
      ),
    ),
  );

  Widget buildSocialIcon(IconData icon) => CircleAvatar(
    radius: 25,
    child: Center(child: Icon(icon, size: 32)),
  );
}
