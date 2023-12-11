import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iPECS/ipecs-mobile/landlord-login.dart';
import 'package:iPECS/utils.dart';
import 'package:intl/intl.dart';

class LandlordProfile extends StatefulWidget {
  const LandlordProfile({Key? key}) : super(key: key);

  @override
  _LandlordProfileState createState() => _LandlordProfileState();
}

class _LandlordProfileState extends State<LandlordProfile> {
  final double coverHeight = 280;
  final double profileHeight = 144;

  double baseWidth = 375;
  late double sizeAxis;
  late double size;

  final auth = FirebaseAuth.instance;
  User? currentUser;
  List<Map<String, dynamic>> paymentData = [];


  @override
  void initState() {
    super.initState();
    getPayments();
  }

  Future<void> getPayments() async {
    final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference().child("PaymentRecord");
    currentUser = auth.currentUser;
    if (currentUser != null) {
      print("USER ID: ${currentUser?.uid}");
      _databaseReference.onValue.listen((event) {
        final data = event.snapshot.value;
        if (data is Map) {
          paymentData = data.entries.map<Map<String, dynamic>>((entry) {
            final payment = entry.value;
            return {
              'ref': entry.key,
              'date': payment['Date'],
              'paidBy': payment['PaidBy'],
              'paymentAmount': payment['PaymentAmount'],
              'paymentStatus': payment['PaymentStatus'],
              'proofImage': payment['ProofImage'],
              'roomNum': payment['RoomNum'],
            };
          }).toList();
          // Sort paymentData by date in descending order
          paymentData.sort((a, b) {
            var format = DateFormat("MM-dd-yyyy");
            var dateA = format.parse(a['date']);
            var dateB = format.parse(b['date']);
            return dateB.compareTo(dateA);
          });
          paymentData = paymentData.take(4).toList();
          setState(() {});
        } else {
          print("Data is not in the expected format");
        }
      });
    } else {
      print("No User");
    }
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;

  void showImageDialog(String imageName) async {
    showDialog(
        context: context,
        builder: (context){
          return Center(child: CircularProgressIndicator(
            color: Color(0xffdfb153),
          ));
        }
    );
    final String imagePath = 'PaymentProof/$imageName.png'; // Update with your folder path
    try {
      final ref = _storage.ref().child(imagePath);
      final String imageUrl = await ref.getDownloadURL();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(imageName, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Image.network(imageUrl), // Display the image from Firebase Storage
              ],
            ),
          );
        },
      );
    } catch (e) {
      print('Error fetching image: $e');
    }
  }

  void handleImageTap(String imageName) {
    Fluttertoast.showToast(
      msg: 'Image Name: $imageName',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
    );
    showImageDialog(imageName);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference().child('Users');

  Future<Map<String, dynamic>> getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseEvent event = await _dbRef.child(user.uid).once();
      if (event.snapshot.value != null) {
        if (event.snapshot.value is Map) {
          return Map<String, dynamic>.from(event.snapshot.value as Map);
        }
      }
    }
    return {};
  }

  final DatabaseReference _roomsDataReference = FirebaseDatabase.instance.ref().child("Rooms");

  Future<List<dynamic>> getAllRooms() async {
    List<dynamic> roomNumbers = [];
    final roomSnapshot = await _roomsDataReference.once();
    final roomData = roomSnapshot.snapshot.value as Map<dynamic, dynamic>?;
    if (roomData != null && roomData.isNotEmpty) {
      roomNumbers = roomData.keys.toList();
    }
    return roomNumbers;
  }

  @override
  Widget build(BuildContext context) {
    sizeAxis = MediaQuery.of(context).size.width / baseWidth;
    size = sizeAxis * 0.97;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(),
          buildContent(),
          Container(
            margin: EdgeInsets.fromLTRB(30 * sizeAxis, 20 * sizeAxis, 30 * sizeAxis, 0 * sizeAxis),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recent Payments of Tenant's",
                  style: SafeGoogleFont(
                    'Urbanist',
                    fontSize: 18 * size,
                    fontWeight: FontWeight.w500,
                    height: 1.2 * size / sizeAxis,
                    color: const Color(0xff5c5473),
                    decoration: TextDecoration.none,
                  ),
                ),
                // Replace this ListView with the one from your first code snippet
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: paymentData.take(3).map((payment) {
                    return Card(
                      elevation: 3,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: AssetImage('assets/ipecs-mobile/images/userCartoon.png'),
                        ),
                        onTap: () {
                          handleImageTap(payment['ref']);
                        },
                        title: Text(
                          '${payment['paidBy']}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${payment['ref']}',
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff9ba7b1),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              '${payment['roomNum']}',
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff9ba7b1),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              '${payment['date']}',
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff9ba7b1),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              '₱${payment['paymentAmount']}',
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff9ba7b1),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          payment['paymentStatus'] ? Icons.check_circle : Icons.cancel,
                          color: payment['paymentStatus'] ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // "Logout" button
          Container(
            margin: EdgeInsets.fromLTRB(38 * sizeAxis, 30 * sizeAxis, 38 * sizeAxis, 0 * sizeAxis),
            child: TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(  // Use pushReplacement to prevent going back to the previous screen
                    MaterialPageRoute(
                      builder: (context) => const LandlordLogin(),
                    ),
                  );
                } catch (e) {
                  print('Error logging out: $e');
                }
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
                    'Logout',
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
    );
  }

  Widget buildContent() {
    return FutureBuilder<Map<String, dynamic>>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loader while data is fetched
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No user data available');
        } else {
          final userData = snapshot.data!;
          final username = userData['username'];
          final userRole = userData['userRole'];
          final userId = userData['userId']; // Assuming you have a 'userId' field in your user data structure

          return Column(
            children: [
              SizedBox(height: 30),
              Text(
                username ?? 'Username',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 5),
              Text(
                userRole ?? 'Role',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              Divider(),
              SizedBox(height: 16),
              FutureBuilder<List<dynamic>>(
                future: getAllRooms(), // Fetch all rooms
                builder: (context, roomSnapshot) {
                  if (roomSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show a loader while room data is fetched
                  } else if (roomSnapshot.hasError) {
                    return Text('Error fetching room data: ${roomSnapshot.error}');
                  } else {
                    final roomNumbers = roomSnapshot.data ?? [];
                    final totalRooms = roomNumbers.length;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              '$totalRooms',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xff23426f)),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Total\n Rooms', // Show total rooms available
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: 25),
              Divider(),
              // Other parts of your UI
              // ...
            ],
          );
        }
      },
    );
  }

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
        top: 12 * sizeAxis,
        left: 12 * sizeAxis,
        child: Container(
          margin: EdgeInsets.fromLTRB(10 * sizeAxis, 12 * sizeAxis, 200 * sizeAxis, 0 * sizeAxis),
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
      ),
    ],
  );

  Widget buildProfileImage() => CircleAvatar(
    radius: profileHeight / 2,
    backgroundColor: Colors.white,
    child: const ClipOval(
      child: Image(
        image: AssetImage('assets/ipecs-mobile/images/user2.png'),
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
