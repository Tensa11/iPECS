import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iPECS/ipecs-mobile/landlord-manage-user.dart';
import 'package:iPECS/utils.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key,});

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  double baseWidth = 375;
  late double sizeAxis;
  late double size;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;

  List<String> roomNumbers = []; // Update to an empty list
  String selectedRoomNumber = ""; // Set the initial selection to an empty string

  // Function to create a new Tenant user
  Future<void> createUser(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        final userData = {
          'contactNum': _phoneNumberController.text,
          'email': email,
          'userRole': selectedUserRole,
          'userStatus': true,
          'username': _userNameController.text,
        };

        if (selectedRoomNumber != 'None') {
          final roomData = {
            'UserID': user.uid,
          };
          await _database.child('Users').child(user.uid).set(userData);
          await _database.child('Rooms').child(selectedRoomNumber).update(roomData);
        } else {
          // If 'None' is selected, do not save RoomNum in Users and skip updating Rooms
          await _database.child('Users').child(user.uid).set(userData);
        }
      }
    } catch (error) {
      print('Error creating user: $error');
    }
  }

  List<String> userRoles = ['Tenant', 'Landlord']; // Add available user roles
  String selectedUserRole = 'Tenant'; // Set initial selection to 'Tenant'

  @override
  void initState() {
    super.initState();
    fetchAvailableRooms();
  }

  // Fetch available room numbers from Firebase
  void fetchAvailableRooms() {
    final DatabaseReference _roomsReference = FirebaseDatabase.instance.reference().child("Rooms");

    _roomsReference.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        final availableRooms = data.keys.toList().cast<String>(); // Convert to List<String>

        // Sort room numbers before updating state
        availableRooms.sort((a, b) => a.compareTo(b));

        setState(() {
          roomNumbers = availableRooms;
          if (!roomNumbers.contains(selectedRoomNumber) && availableRooms.isNotEmpty) {
            // Update the selected room number only if it is not in the updated room list
            selectedRoomNumber = availableRooms[0];
          }
        });
      }
    }, onError: (error) {
      print("Error fetching available room numbers: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    sizeAxis = MediaQuery.of(context).size.width / baseWidth;
    size = sizeAxis * 0.97;

    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: Scaffold(
        body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
          child: SizedBox(
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.fromLTRB(22 * sizeAxis, 44 * sizeAxis, 21 * sizeAxis, 176 * sizeAxis),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xffffffff),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 3 * sizeAxis, 49 * sizeAxis),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0 * sizeAxis, 12 * sizeAxis, 200 * sizeAxis, 0 * sizeAxis),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: SizedBox(
                              width: 41 * sizeAxis,
                              height: 41 * sizeAxis,
                              child: Image.asset(
                                'assets/ipecs-mobile/images/back.png',
                                width: 41 * sizeAxis,
                                height: 41 * sizeAxis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 173 * sizeAxis, 15 * sizeAxis),
                    child: Text(
                      'Add User',
                      style: GoogleFonts.urbanist(
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
                    child: TextField(
                      controller: _userNameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(18 * sizeAxis, 18 * sizeAxis, 18 * sizeAxis, 19 * sizeAxis),
                        hintText: 'Name',
                        hintStyle: const TextStyle(color: Color(0xff8390a1)),
                      ),
                      style: GoogleFonts.urbanist(
                        fontSize: 15 * size,
                        fontWeight: FontWeight.w500,
                        height: 1.25 * size / sizeAxis,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 1 * sizeAxis, 19 * sizeAxis),
                    width: 331 * sizeAxis,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8 * sizeAxis),
                      border: Border.all(color: const Color(0xffe8ecf4)),
                      color: const Color(0xfff7f7f8),
                    ),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(18 * sizeAxis, 18 * sizeAxis, 18 * sizeAxis, 19 * sizeAxis),
                        hintText: 'Email',
                        hintStyle: const TextStyle(color: Color(0xff8390a1)),
                      ),
                      style: GoogleFonts.urbanist(
                        fontSize: 15 * size,
                        fontWeight: FontWeight.w500,
                        height: 1.25 * size / sizeAxis,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(1 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 15 * sizeAxis),
                    width: 331 * sizeAxis,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8 * sizeAxis),
                      border: Border.all(color: const Color(0xffe8ecf4)),
                      color: const Color(0xfff7f7f8),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedUserRole,
                      items: userRoles.map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedUserRole = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(18 * sizeAxis, 17 * sizeAxis, 16 * sizeAxis, 17 * sizeAxis),
                        hintText: 'User Role',
                        hintStyle: const TextStyle(color: Color(0xff8390a1)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(1 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 15 * sizeAxis),
                    width: 331 * sizeAxis,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8 * sizeAxis),
                      border: Border.all(color: const Color(0xffe8ecf4)),
                      color: const Color(0xfff7f7f8),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedRoomNumber.isNotEmpty && roomNumbers.contains(selectedRoomNumber)
                          ? selectedRoomNumber
                          : roomNumbers.isNotEmpty
                          ? roomNumbers[0]
                          : '',
                      items: roomNumbers.map((String room) {
                        return DropdownMenuItem<String>(
                          value: room,
                          child: Text(room),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRoomNumber = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(18 * sizeAxis, 17 * sizeAxis, 16 * sizeAxis, 17 * sizeAxis),
                        hintText: 'Room Number',
                        hintStyle: const TextStyle(color: Color(0xff8390a1)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(1 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 19 * sizeAxis),
                    width: 331 * sizeAxis,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8 * sizeAxis),
                      border: Border.all(color: const Color(0xffe8ecf4)),
                      color: const Color(0xfff7f7f8),
                    ),
                    child: TextField(
                      maxLength: 11,
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(18 * sizeAxis, 13 * sizeAxis, 18 * sizeAxis, 19 * sizeAxis),
                        hintText: 'Phone Number',
                        hintStyle: const TextStyle(color: Color(0xff8390a1)),
                      ),
                      style: GoogleFonts.urbanist(
                        fontSize: 14 * size,
                        fontWeight: FontWeight.w500,
                        height: 1.7142857143 * size / sizeAxis,
                        letterSpacing: -0.28 * sizeAxis,
                        color: const Color(0xff000000),
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
                    child: TextField(
                      controller: _passwordController,
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
                    margin: EdgeInsets.fromLTRB(37 * sizeAxis, 0 * sizeAxis, 38 * sizeAxis, 0 * sizeAxis),
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context){
                              return Center(child: CircularProgressIndicator(
                                color: Color(0xffdfb153),
                              ));
                            }
                        );
                        createUser(_emailController.text, _passwordController.text);// Call the createUser function on button press
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 56 * sizeAxis,
                        decoration: BoxDecoration(
                          color: const Color(0xff231b53),
                          borderRadius: BorderRadius.circular(30 * sizeAxis),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x14000000),
                              offset: Offset(0 * sizeAxis, 20 * sizeAxis),
                              blurRadius: 30 * sizeAxis,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Submit',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              fontSize: 16 * size,
                              fontWeight: FontWeight.w600,
                              height: 1.5 * size / sizeAxis,
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