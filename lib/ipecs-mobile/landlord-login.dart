import 'package:flutter/material.dart';
import 'package:iPECS/ipecs-mobile/landlord-dashboard.dart';
import 'package:iPECS/ipecs-mobile/landlord-login.dart';
import 'package:iPECS/ipecs-mobile/tenant-dashboard.dart';
import 'package:iPECS/ipecs-mobile/tenant-login.dart';
import 'package:iPECS/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class LandlordLogin extends StatefulWidget {
  const LandlordLogin({Key? key}) : super(key: key);

  @override
  _LanlordLoginState createState() => _LanlordLoginState();
}

class _LanlordLoginState extends State<LandlordLogin> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool _isObscure = true;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    double baseWidth = 400;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  22 * fem, 60 * fem, 21 * fem, 50 * fem),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xffffffff),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 291 * fem, 82 * fem),
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
                          'assets/ipecs-mobile/images/back-Bj7.png',
                          width: 41 * fem,
                          height: 41 * fem,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        2 * fem, 0 * fem, 0 * fem, 30 * fem),
                    child: Text(
                      'iPECS',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Urbanist',
                        fontSize: 30 * ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.2 * ffem / fem,
                        color: const Color(0xff231b53),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 23 * fem, 32 * fem),
                    constraints: BoxConstraints(
                      maxWidth: 307 * fem,
                    ),
                    child: Text(
                      'Welcome back Landlord! Glad to see you, Again!',
                      style: SafeGoogleFont(
                        'Urbanist',
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
                      controller: _emailTextController, // Assign the text controller
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding:
                        EdgeInsets.fromLTRB(18 * fem, 18 * fem, 18 * fem, 19 * fem),
                        hintText: 'Enter Email',
                        hintStyle: const TextStyle(color: Color(0xff8390a1)),
                      ),
                      style: SafeGoogleFont(
                        'Urbanist',
                        fontSize: 15 * ffem,
                        fontWeight: FontWeight.w500,
                        height: 1.25 * ffem / fem,
                        color: const Color(0xff000000),
                      ),
                      keyboardType: TextInputType.emailAddress,
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
                      controller: _passwordTextController, // Assign the text controller
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding:
                        EdgeInsets.fromLTRB(18 * fem, 18 * fem, 18 * fem, 19 * fem),
                        hintText: 'Enter your Password',
                        hintStyle: const TextStyle(color: Color(0xff8390a1)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                      style: SafeGoogleFont(
                        'Urbanist',
                        fontSize: 15 * ffem,
                        fontWeight: FontWeight.w500,
                        height: 1.25 * ffem / fem,
                        color: const Color(0xff000000),
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: _isObscure, // Toggle password visibility
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        1 * fem, 0 * fem, 0 * fem, 150 * fem),
                    child: TextButton(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LandlordDashboard(),
                            ),
                          );
                        } catch (error) {
                          print("Error: $error");
                          // Handle the error here, you can show an error message to the user.
                          setState(() {
                            _errorMessage =
                            "An error occurred. Please check your email and password.";
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        width: 331 * fem,
                        height: 56 * fem,
                        decoration: BoxDecoration(
                          color: const Color(0xff231b53),
                          borderRadius: BorderRadius.circular(8 * fem),
                        ),
                        child: Center(
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Urbanist',
                              fontSize: 15 * ffem,
                              fontWeight: FontWeight.w600,
                              height: 1.2 * ffem / fem,
                              color: const Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        1 * fem, 0 * fem, 0 * fem, 0 * fem),
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
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 15 * ffem,
                            fontWeight: FontWeight.w600,
                            height: 1.4 * ffem / fem,
                            letterSpacing: 0.15 * fem,
                            color: const Color(0xff1e232c),
                          ),
                          children: [
                            TextSpan(
                              text: 'Not a Landlord? ',
                              style: SafeGoogleFont(
                                'Urbanist',
                                fontSize: 15 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.4 * ffem / fem,
                                letterSpacing: 0.15 * fem,
                                color: const Color(0xff1e232c),
                              ),
                            ),
                            TextSpan(
                              text: 'Tenant',
                              style: SafeGoogleFont(
                                'Urbanist',
                                fontSize: 15 * ffem,
                                fontWeight: FontWeight.w700,
                                height: 1.4 * ffem / fem,
                                letterSpacing: 0.15 * fem,
                                color: const Color(0xffdfb153),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_errorMessage.isNotEmpty)
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          1 * fem, 10 * fem, 0 * fem, 0 * fem),
                      child: Text(
                        _errorMessage,
                        style: SafeGoogleFont(
                          'Urbanist',
                          fontSize: 15 * ffem,
                          fontWeight: FontWeight.w500,
                          height: 1.4 * ffem / fem,
                          letterSpacing: 0.15 * fem,
                          color: const Color(0xffe74c3c),
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
