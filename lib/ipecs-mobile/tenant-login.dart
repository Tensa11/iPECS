import 'package:flutter/material.dart';
import 'package:iPECS/ipecs-mobile/landlord-login.dart';
import 'package:iPECS/ipecs-mobile/tenant-dashboard.dart';
import 'package:iPECS/ipecs-mobile/tenant-rooms.dart';
import 'package:iPECS/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class TenantLogin extends StatefulWidget {
  const TenantLogin({Key? key}) : super(key: key);

  @override
  _TenantLoginState createState() => _TenantLoginState();
}

class _TenantLoginState extends State<TenantLogin> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool _isObscure = true;
  String _errorMessage = '';

  void _signIn() async {
    try {
      final loginUser = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );

      if (loginUser != null) {
        final user = FirebaseAuth.instance.currentUser;
        final userID = user!.uid;

        DatabaseEvent snapshot = await FirebaseDatabase.instance
            .ref()
            .child("Users")
            .child(userID)
            .once();

        final snapshotValue = snapshot.snapshot.value;

        if (snapshotValue != null) {
          if ((snapshotValue as Map)['userRole'] == 'Tenant') {
            // If the user is a Tenant, navigate to TenantRooms
            Navigator.push(context, MaterialPageRoute(builder: (context) => const TenantDashboard()));
          } else if ((snapshotValue as Map)['userRole'] == 'Landlord') {
            // If the user is a Landlord, show an error message
            setState(() {
              _errorMessage = 'Landlords are not allowed to log in here.';
            });
          }
        }
      } else {
        setState(() {
          _errorMessage = 'Login Failed';
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _errorMessage = 'No user found';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          _errorMessage = 'Incorrect password';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 400;
    double sizeAxis = MediaQuery.of(context).size.width / baseWidth;
    double size = sizeAxis * 0.97;// Check if the user is already authenticated and their role

    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding:
              EdgeInsets.fromLTRB(22 * sizeAxis, 150 * sizeAxis, 21 * sizeAxis, 50 * sizeAxis),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xffffffff),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(2 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 30 * sizeAxis),
                    child: Text(
                      'iPECS',
                      textAlign: TextAlign.center,
                      style: SafeGoogleFont(
                        'Urbanist',
                        fontSize: 30 * size,
                        fontWeight: FontWeight.w700,
                        height: 1.2 * size / sizeAxis,
                        color: const Color(0xff231b53),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 23 * sizeAxis, 32 * sizeAxis),
                    constraints: BoxConstraints(
                      maxWidth: 307 * sizeAxis,
                    ),
                    child: Text(
                      'Welcome back Tenant! Glad to see you, Again!',
                      style: SafeGoogleFont(
                        'Urbanist',
                        fontSize: 30 * size,
                        fontWeight: FontWeight.w700,
                        height: 1.3 * size / sizeAxis,
                        letterSpacing: -0.3 * sizeAxis,
                        color: const Color(0xff1e232c),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(1 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 15 * sizeAxis),
                    width: 331 * sizeAxis,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8 * sizeAxis),
                      border: Border.all(color: const Color(0xffe8ecf4)),
                      color: const Color(0xfff7f8f9),
                    ),
                    child: TextFormField(
                      controller: _emailTextController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(
                            18 * sizeAxis, 18 * sizeAxis, 18 * sizeAxis, 19 * sizeAxis),
                        hintText: 'Enter Email',
                        hintStyle: const TextStyle(color: Color(0xff8390a1)),
                      ),
                      style: SafeGoogleFont(
                        'Urbanist',
                        fontSize: 15 * size,
                        fontWeight: FontWeight.w500,
                        height: 1.25 * size / sizeAxis,
                        color: const Color(0xff000000),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(1 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 15 * sizeAxis),
                    width: 331 * sizeAxis,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8 * sizeAxis),
                      border: Border.all(color: const Color(0xffe8ecf4)),
                      color: const Color(0xfff7f8f9),
                    ),
                    child: TextField(
                      controller: _passwordTextController,
                      // Assign the text controller
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(
                            18 * sizeAxis, 18 * sizeAxis, 18 * sizeAxis, 19 * sizeAxis),
                        hintText: 'Enter your Password',
                        hintStyle: const TextStyle(color: Color(0xff8390a1)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
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
                        fontSize: 15 * size,
                        fontWeight: FontWeight.w500,
                        height: 1.25 * size / sizeAxis,
                        color: const Color(0xff000000),
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: _isObscure, // Toggle password visibility
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * sizeAxis, 10 * sizeAxis, 0 * sizeAxis, 150 * sizeAxis),
                    child: TextButton(
                      onPressed: () {
                        _signIn();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        width: 331 * sizeAxis,
                        height: 56 * sizeAxis,
                        decoration: BoxDecoration(
                          color: const Color(0xff231b53),
                          borderRadius: BorderRadius.circular(8 * sizeAxis),
                        ),
                        child: Center(
                          child: Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: SafeGoogleFont(
                              'Urbanist',
                              fontSize: 15 * size,
                              fontWeight: FontWeight.w600,
                              height: 1.2 * size / sizeAxis,
                              color: const Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                    EdgeInsets.fromLTRB(1 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LandlordLogin(),
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
                            fontSize: 15 * size,
                            fontWeight: FontWeight.w600,
                            height: 1.4 * size / sizeAxis,
                            letterSpacing: 0.15 * sizeAxis,
                            color: const Color(0xff1e232c),
                          ),
                          children: [
                            TextSpan(
                              text: 'Not a Tenant? ',
                              style: SafeGoogleFont(
                                'Urbanist',
                                fontSize: 15 * size,
                                fontWeight: FontWeight.w500,
                                height: 1.4 * size / sizeAxis,
                                letterSpacing: 0.15 * sizeAxis,
                                color: const Color(0xff1e232c),
                              ),
                            ),
                            TextSpan(
                              text: 'Landlord',
                              style: SafeGoogleFont(
                                'Urbanist',
                                fontSize: 15 * size,
                                fontWeight: FontWeight.w700,
                                height: 1.4 * size / sizeAxis,
                                letterSpacing: 0.15 * sizeAxis,
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
                      margin: EdgeInsets.fromLTRB(1 * sizeAxis, 10 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis),
                      child: Text(
                        _errorMessage,
                        style: SafeGoogleFont(
                          'Urbanist',
                          fontSize: 15 * size,
                          fontWeight: FontWeight.w500,
                          height: 1.4 * size / sizeAxis,
                          letterSpacing: 0.15 * sizeAxis,
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