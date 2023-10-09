import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key});

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  double baseWidth = 375;
  late double fem;
  late double ffem;

  @override
  Widget build(BuildContext context) {
    fem = MediaQuery.of(context).size.width / baseWidth;
    ffem = fem * 0.97;

    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: Scaffold(
        body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.fromLTRB(22 * fem, 44 * fem, 21 * fem, 176 * fem),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xffffffff),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 3 * fem, 49 * fem),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * fem, 12 * fem, 200 * fem, 0 * fem),
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
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 173 * fem, 15 * fem),
                    child: Text(
                      'Add User',
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
                        contentPadding: EdgeInsets.fromLTRB(18 * fem, 18 * fem, 18 * fem, 19 * fem),
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
                        contentPadding: EdgeInsets.fromLTRB(18 * fem, 18 * fem, 18 * fem, 19 * fem),
                        hintText: 'Email',
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
                    margin: EdgeInsets.fromLTRB(1 * fem, 0 * fem, 0 * fem, 19 * fem),
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
                        contentPadding: EdgeInsets.fromLTRB(18 * fem, 13 * fem, 18 * fem, 19 * fem),
                        hintText: 'Phone Number',
                        hintStyle: const TextStyle(color: Color(0xff8390a1)),
                      ),
                      style: GoogleFonts.urbanist(
                        fontSize: 14 * ffem,
                        fontWeight: FontWeight.w500,
                        height: 1.7142857143 * ffem / fem,
                        letterSpacing: -0.28 * fem,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 1 * fem, 32 * fem),
                    width: 331 * fem,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8 * fem),
                      border: Border.all(color: const Color(0xffe8ecf4)),
                      color: const Color(0xfff7f7f8),
                    ),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(18 * fem, 13 * fem, 18 * fem, 19 * fem),
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Color(0xff8390a1)),
                      ),
                      style: GoogleFonts.urbanist(
                        fontSize: 14 * ffem,
                        fontWeight: FontWeight.w500,
                        height: 1.7142857143 * ffem / fem,
                        letterSpacing: -0.28 * fem,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(37 * fem, 0 * fem, 38 * fem, 0 * fem),
                    child: TextButton(
                      onPressed: () {},
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
      ),
    );
  }
}