import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iPECS/ipecs-mobile/landlord-dashboard.dart';
import 'package:iPECS/ipecs-mobile/landlord-drawer.dart';
import 'package:iPECS/ipecs-mobile/tenant-profile.dart';
import 'package:iPECS/utils.dart';
class ManualPayment extends StatefulWidget {
  const ManualPayment({super.key});

  @override
  _ManualPaymentState createState() => _ManualPaymentState();
}

class _ManualPaymentState extends State<ManualPayment> {
  double baseWidth = 375;
  double sizeAxis = 1.0;
  double size = 1.0;


  List<String> roomNumbers = []; // Update to an empty list
  String selectedRoomNumber = ""; // Set the initial selection to an empty string
  final user = FirebaseAuth.instance.currentUser!;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  TextEditingController amountController = TextEditingController();

  void submitPayment() async {
    if (amountController.text.isEmpty || selectedRoomNumber.isEmpty) {
      // Show an alert or message to ensure both fields are filled
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: SafeGoogleFont(
                'Urbanist',
                fontSize: 18 * size,
                fontWeight: FontWeight.w500,
                height: 1.2 * size / sizeAxis,
                color: const Color(0xff5c5473),
                decoration: TextDecoration.none,
              ),
            ),
            content: Text(
              'Please enter the amount and select the room number',
              style: SafeGoogleFont(
                'Urbanist',
                fontSize: 15 * size,
                fontWeight: FontWeight.w500,
                height: 1.2 * size / sizeAxis,
                color: const Color(0xff5c5473),
                decoration: TextDecoration.none,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Ok',
                  style: SafeGoogleFont(
                    'Urbanist',
                    fontSize: 15 * size,
                    fontWeight: FontWeight.w500,
                    height: 1.2 * size / sizeAxis,
                    color: const Color(0xff5c5473),
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    // Show a confirmation dialog before submitting the payment
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Confirm Submission',
            style: SafeGoogleFont(
              'Urbanist',
              fontSize: 18 * size,
              fontWeight: FontWeight.w500,
              height: 1.2 * size / sizeAxis,
              color: const Color(0xff5c5473),
              decoration: TextDecoration.none,
            ),
          ),
          content: Text(
            'Are you sure you want to submit the manual payment?',
            style: SafeGoogleFont(
              'Urbanist',
              fontSize: 15 * size,
              fontWeight: FontWeight.w500,
              height: 1.2 * size / sizeAxis,
              color: const Color(0xff5c5473),
              decoration: TextDecoration.none,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LandlordDashboard(),
                  ),
                );

                double enteredAmount = double.parse(amountController.text);

                // Fetch the current 'CurrentCredit' value of the selected room from Firebase
                DatabaseReference roomRef = _database.child('Rooms').child(selectedRoomNumber);

                try {
                  DataSnapshot snapshot = await roomRef.once().then((event) => event.snapshot);
                  if (snapshot.value != null) {
                    Map<dynamic, dynamic> roomData = snapshot.value as Map<dynamic, dynamic>;
                    var currentCredit = roomData['CurrentCredit'];

                    if (currentCredit is int || currentCredit is double) {
                      var numericEnteredAmount = enteredAmount; // Keep enteredAmount as double

                      // Convert currentCredit to double if it's an int
                      var currentCreditValue = currentCredit is int ? currentCredit.toDouble() : currentCredit;

                      var updatedCredit = currentCreditValue + numericEnteredAmount;

                      // Ensure updatedCredit is stored as a double in Firebase
                      await roomRef.update({'CurrentCredit': updatedCredit.toDouble()}).then((_) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LandlordDashboard(),
                          ),
                        );
                      }).catchError((error) {
                        print('Failed to update payment: $error');
                        // Show error message if the update fails
                      });
                    } else {
                      print('Current credit value is null.');
                      // Handle the scenario where the current credit value is null
                    }
                  } else {
                    print('Room data not found.');
                    // Handle the scenario where room data is not found
                  }
                } catch (error) {
                  print('Error fetching room data: $error');
                  // Show error message if fetching room data fails
                }
              },
              child: Text(
                'Submit',
                style: SafeGoogleFont(
                  'Urbanist',
                  fontSize: 15 * size,
                  fontWeight: FontWeight.w500,
                  height: 1.2 * size / sizeAxis,
                  color: const Color(0xff5c5473),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: SafeGoogleFont(
                  'Urbanist',
                  fontSize: 15 * size,
                  fontWeight: FontWeight.w500,
                  height: 1.2 * size / sizeAxis,
                  color: const Color(0xff5c5473),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
    return Scaffold(
      endDrawer: const Drawer(
        child: LandlordDrawer(), // Call your custom drawer widget here
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.fromLTRB(22 * sizeAxis, 28 * sizeAxis, 21 * sizeAxis, 180 * sizeAxis),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xffffffff),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10 * sizeAxis, 0 * sizeAxis, 3 * sizeAxis, 70 * sizeAxis),
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
                                builder: (context) => const TenantProfile(),
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
                                  'assets/ipecs-mobile/images/user2.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0 * sizeAxis, 20 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis),
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
                  margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 90 * sizeAxis, 4 * sizeAxis),
                  child: Text(
                    'Manual Payment',
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
                  margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 149 * sizeAxis, 15 * sizeAxis),
                  constraints: BoxConstraints(
                    maxWidth: 181 * sizeAxis,
                  ),
                  child: Text(
                    'Fill up the amount and select the room',
                    style: GoogleFonts.inter(
                      fontSize: 13 * size,
                      fontWeight: FontWeight.w400,
                      height: 1.5384615385 * size / sizeAxis,
                      color: const Color(0xff1e232c),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(1 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 15 * sizeAxis),
                  width: double.infinity,
                  height: 56 * sizeAxis,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffe8ecf4)),
                    color: const Color(0xfff7f7f8),
                    borderRadius: BorderRadius.circular(8 * sizeAxis),
                  ),
                  child: TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(18 * sizeAxis, 17 * sizeAxis, 16 * sizeAxis, 17 * sizeAxis),
                      hintText: 'Amount',
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
                    value: selectedRoomNumber,
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
                  margin: EdgeInsets.fromLTRB(39 * sizeAxis, 0 * sizeAxis, 36 * sizeAxis, 0 * sizeAxis),
                  child: TextButton(
                    onPressed: submitPayment,
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
    );
  }
}
