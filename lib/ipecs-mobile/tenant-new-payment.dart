import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iPECS/ipecs-mobile/tenant-drawer.dart';
import 'package:iPECS/ipecs-mobile/tenant-payments-history.dart';
import 'package:iPECS/ipecs-mobile/tenant-profile.dart';
import 'package:iPECS/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class NewPayment extends StatefulWidget {
  const NewPayment({super.key});

  @override
  _NewPaymentState createState() => _NewPaymentState();
}

class _NewPaymentState extends State<NewPayment> {
  double baseWidth = 375;
  double sizeAxis = 1.0;
  double size = 1.0;


  List<String> roomNumbers = []; // Update to an empty list
  String selectedRoomNumber = ""; // Set the initial selection to an empty string
  XFile? imagePath; // Store the path to the uploaded image
  final user = FirebaseAuth.instance.currentUser!;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  TextEditingController referenceController = TextEditingController(); // Add a TextEditingController for the reference input
  TextEditingController paidByController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  // Function to save the image to Firebase Storage
  Future<void> saveImageToFirebaseStorage() async {
    if (imagePath != null) {
      final String referenceNumber = 'Ref-${referenceController.text.padLeft(9, '0')}'; // Format reference number as 'Ref-123456789'
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('PaymentProof/$referenceNumber.png'); // Use .png as the format
      final UploadTask uploadTask = storageReference.putFile(File(imagePath!.path));
      await uploadTask.whenComplete(() {
        print('Image uploaded to Firebase Storage');
      }).catchError((error) {
        print('Error uploading image to Firebase Storage: $error');
      });
    }
  }

  final referenceNumberFormatter = FilteringTextInputFormatter.allow(RegExp(r'\d{0,9}'));

  // Updated submitPayment function to include image upload
  void submitPayment() async {
    if (amountController.text.isEmpty ||
        selectedRoomNumber.isEmpty ||
        imagePath == null ||
        referenceController.text.isEmpty ||
        paidByController.text.isEmpty) {
      // Show an alert or message to ensure all fields are filled
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
              'Please enter all the fields',
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

    // Show confirmation dialog before submitting the payment
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Confirmation',
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
            'Are you sure you want to submit this payment?',
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
                showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0xffdfb153),
                      ),
                    );
                  },
                );
                if (imagePath != null) {
                  final String referenceNumber = 'Ref-${referenceController.text.padLeft(9, '0')}';
                  final String currentDate = DateFormat('MM-dd-yyyy').format(DateTime.now());
                  final String userName = paidByController.text;

                  await saveImageToFirebaseStorage();

                  final NumberFormat formatter = NumberFormat.currency(symbol: '', decimalDigits: 2);
                  final double paymentAmount = double.parse(amountController.text); // Convert entered amount to a double

                  final Map<String, dynamic> paymentData = {
                    'Date': currentDate,
                    'PaidBy': userName,
                    'PaymentAmount': paymentAmount, // Store the payment amount as a number
                    'ProofImage': 'PaymentProof/$referenceNumber.png',
                    'RoomNum': selectedRoomNumber,
                  };

                  _database.child('PaymentManage').child(referenceNumber).set(paymentData).then((_) {
                    print('Payment data saved to Firebase: $paymentData');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PaymentHistory(),
                      ),
                    );
                  }).catchError((error) {
                    print('Error saving payment data: $error');
                  });
                }
              },
              child: Text(
                'Yes',
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
                Navigator.pop(context); // Close the confirmation dialog
              },
              child: Text(
                'No',
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
    fetchUsername(); // Call the method to fetch the username
  }

  // Method to fetch the current user's username
  void fetchUsername() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final DatabaseReference userReference = FirebaseDatabase.instance.reference().child("Users").child(uid);

    userReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final userData = event.snapshot.value as Map<dynamic, dynamic>;
        final username = userData['username'] as String;

        // Set the fetched username to the controller
        setState(() {
          paidByController.text = username;
        });
      }
    }, onError: (error) {
      print("Error fetching username: $error");
    });
  }



  // Fetch available room numbers from Firebase
  void fetchAvailableRooms() {
    final DatabaseReference _roomsReference = FirebaseDatabase.instance.reference().child("Rooms");

    _roomsReference.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        final List<String> ownedRoomNumbers = [];

        data.forEach((key, value) {
          // Check if the room's UserID matches the current user's ID
          if (value['UserID'] == user.uid) {
            ownedRoomNumbers.add(key);
          }
        });

        // Sort room numbers before updating state
        ownedRoomNumbers.sort((a, b) => a.compareTo(b));

        setState(() {
          roomNumbers = ownedRoomNumbers;
          if (!roomNumbers.contains(selectedRoomNumber) && ownedRoomNumbers.isNotEmpty) {
            // Update the selected room number only if it is not in the updated room list
            selectedRoomNumber = ownedRoomNumbers[0];
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
        child: TenantDrawer(), // Call your custom drawer widget here
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
                                  'assets/ipecs-mobile/images/userCartoon.png',
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
                  margin: EdgeInsets.fromLTRB(0 * sizeAxis, 0 * sizeAxis, 100 * sizeAxis, 4 * sizeAxis),
                  child: Text(
                    'Payment Details',
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
                    'Fill up the needed details and attach the proof of payment',
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
                  width: 331 * sizeAxis,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8 * sizeAxis),
                    border: Border.all(color: const Color(0xffe8ecf4)),
                    color: const Color(0xfff7f8f9),
                  ),
                  child: TextField(
                    controller: referenceController, // Use the referenceController to capture user input
                    inputFormatters: [referenceNumberFormatter], // Set input formatter for the reference number
                    maxLength: 9,
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(18 * sizeAxis, 18 * sizeAxis, 18 * sizeAxis, 19 * sizeAxis),
                      hintText: 'Reference Number',
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
                  width: double.infinity,
                  height: 56 * sizeAxis,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffe8ecf4)),
                    color: const Color(0xfff7f7f8),
                    borderRadius: BorderRadius.circular(8 * sizeAxis),
                  ),
                  child: TextField(
                    controller: paidByController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(18 * sizeAxis, 17 * sizeAxis, 16 * sizeAxis, 17 * sizeAxis),
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
                    margin: EdgeInsets.fromLTRB(1 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 59 * sizeAxis),
                    width: double.infinity,
                    height: 56 * sizeAxis,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffe8ecf4)),
                      color: const Color(0xfff7f7f8),
                      borderRadius: BorderRadius.circular(8 * sizeAxis),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                        if (pickedImage != null) {
                          setState(() {
                            imagePath = pickedImage;
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              imagePath == null ? 'Proof of Payment' : imagePath!.name, // Use the image name if it's not null
                              style: GoogleFonts.urbanist(
                                fontSize: 15 * size,
                                fontWeight: FontWeight.w500,
                                height: 1.25 * size / sizeAxis,
                                color: imagePath == null ? const Color(0xff8390a1) : const Color(0xff000000),
                              ),
                            ),
                          ),
                          const Icon(Icons.upload, color: Color(0xff8390a1)),
                        ],
                      ),
                    )
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