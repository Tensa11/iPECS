import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iPECS/ipecs-mobile/landlord-drawer.dart';
import 'package:iPECS/ipecs-mobile/landlord-profile.dart';
import 'package:iPECS/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class LandlordRecords extends StatefulWidget {
  const LandlordRecords({Key? key}) : super(key: key);

  @override
  _LandlordRecordsState createState() => _LandlordRecordsState();
}

class _LandlordRecordsState extends State<LandlordRecords> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference().child("PaymentRecord");
  final auth = FirebaseAuth.instance;
  User? currentUser;
  List<Map<String, dynamic>> paymentData = [];

  @override
  void initState() {
    super.initState();
    getPayments();
  }

  @override
  void dispose() {
    // Dispose the listener when the widget is disposed
    _databaseReference.onValue.listen((event) {}).cancel();
    super.dispose();
  }

  Future<void> getPayments() async {
    currentUser = auth.currentUser;
    if (currentUser != null) {
      print("USER ID: ${currentUser?.uid}");
      _databaseReference.onValue.listen((event) {
        final data = event.snapshot.value;
        if (data is Map) {
          setState(() {
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
          });
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


  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double sizeAxis = MediaQuery.of(context).size.width / baseWidth;
    double size = sizeAxis * 0.97;

    return Scaffold(
      endDrawer: const Drawer(
        child: LandlordDrawer(),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.fromLTRB(24 * sizeAxis, 30 * sizeAxis, 24 * sizeAxis, 0 * sizeAxis),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xffffffff),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(8 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis, 32 * sizeAxis),
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
                                builder: (context) => const LandlordProfile(),
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
                                image: AssetImage('assets/ipecs-mobile/images/user2.png'),
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
                // Recent Payments ListView
                Container(
                  margin: EdgeInsets.fromLTRB(0 * sizeAxis, 20 * sizeAxis, 0 * sizeAxis, 13 * sizeAxis),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Records',
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
                      StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: paymentData.map((payment) {
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
                                      SizedBox(height: 5),
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
                          );
                        },
                      ),
                    ],
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
