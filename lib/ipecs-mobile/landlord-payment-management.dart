import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iPECS/ipecs-mobile/landlord-drawer.dart';
import 'package:iPECS/ipecs-mobile/landlord-manual-payment.dart';
import 'package:iPECS/ipecs-mobile/landlord-profile.dart';
import 'package:iPECS/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PaymentManage extends StatefulWidget {
  const PaymentManage({Key? key}) : super(key: key);

  @override
  _PaymentManageState createState() => _PaymentManageState();
}

class _PaymentManageState extends State<PaymentManage> {
  final DatabaseReference _paymentManageReference = FirebaseDatabase.instance.reference().child("PaymentManage");
  final DatabaseReference _paymentRecordReference = FirebaseDatabase.instance.reference().child("PaymentRecord");
  final auth = FirebaseAuth.instance;
  User? currentUser;
  List<Map<String, dynamic>> paymentData = [];
  List<Map<String, dynamic>> roomData = [];

  @override
  void initState() {
    super.initState();
    getPayments();
    getRooms();
  }

  Future<void> getPayments() async {
    currentUser = auth.currentUser;
    if (currentUser != null) {
      print("USER ID: ${currentUser?.uid}");
      _paymentManageReference.onValue.listen((event) {
        final data = event.snapshot.value;
        if (data is Map) {
          paymentData = data.entries.map<Map<String, dynamic>>((entry) {
            final payment = entry.value;
            return {
              'ref': entry.key,
              'date': payment['Date'],
              'paidBy': payment['PaidBy'],
              'paymentAmount': payment['PaymentAmount'],
              'proofImage': payment['ProofImage'],
              'roomNum': payment['RoomNum'],
            };
          }).toList();
          setState(() {});
        } else {
          print("Data is not in the expected format");
        }
      });
    } else {
      print("No User");
    }
  }

  // Inside the class _PaymentManageState

  Future<void> getRooms() async {
    final DatabaseReference _roomsRef = FirebaseDatabase.instance.reference().child("Rooms");
    final DatabaseReference _usersRef = FirebaseDatabase.instance.reference().child("Users");
    DataSnapshot snapshot = await _roomsRef.get();
    DataSnapshot userSnapshot = await _usersRef.get();
    if (snapshot.value != null && userSnapshot.value != null) {
      Map<dynamic, dynamic> roomValues = snapshot.value as Map<dynamic, dynamic>;
      Map<dynamic, dynamic> userValues = userSnapshot.value as Map<dynamic, dynamic>;
      roomData.clear(); // Clear the roomData list before adding new data
      roomValues.forEach((key, value) {
        String tenantName = userValues[value['UserID']]['username'] ?? 'No Name';
        roomData.add({
          'name': key,
          'currentcredit': value['CurrentCredit'],
          'creditcriticallevel': value['CreditCriticalLevel'],
          'electricityprice': value['ElectricityPrice'],
          'userid': value['UserID'],
          'tenantName': tenantName
        });
      });
      roomData.sort((a, b) => a['name'].compareTo(b['name']));
      setState(() {});
    }
  }

  void handleCheckButtonPress(Map<String, dynamic> payment) {
    double sizeAxis = 1.0;
    double size = 1.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Payment Confirmed',
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
            'The Payment has been accepted and reviewed',
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

    String refNumber = payment['ref'];
    String roomNum = payment['roomNum'];
    int paymentAmount = payment['paymentAmount'] as int; // Parse paymentAmount to int

    DatabaseReference roomRef = FirebaseDatabase.instance.reference().child("Rooms").child(roomNum);

    roomRef.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic> roomData = snapshot.value as Map<dynamic, dynamic>;
        double currentCredit = roomData['CurrentCredit'] ?? 0;
        double newCredit = currentCredit + paymentAmount;

        roomRef.update({'CurrentCredit': newCredit}).then((_) {
          // Copy data from PaymentManage to PaymentRecord and set PaymentStatus to true
          _paymentRecordReference.child(refNumber).set({
            'Date': payment['date'],
            'PaidBy': payment['paidBy'],
            'PaymentAmount': paymentAmount, // Save paymentAmount as int
            'ProofImage': payment['proofImage'],
            'RoomNum': payment['roomNum'],
            'PaymentStatus': true,
          }).then((_) {
            // Remove the payment record from PaymentManage
            _paymentManageReference.child(refNumber).remove().then((_) {
              // Remove the payment record from paymentData list
              setState(() {
                paymentData.removeWhere((element) => element['ref'] == refNumber);
              });
            }).catchError((error) {
              print("Failed to remove payment record: $error");
            });
          }).catchError((error) {
            print("Failed to copy data to PaymentRecord: $error");
          });
        }).catchError((error) {
          print("Failed to update CurrentCredit in the Room: $error");
        });
      } else {
        print("Room $roomNum not found");
      }
    }).catchError((error) {
      print("Error retrieving room data: $error");
    });
  }


  void handleCloseButtonPress(Map<String, dynamic> payment) {
    double sizeAxis = 1.0;
    double size = 1.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Payment Confirmed',
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
            'The Payment has been rejected and reviewed',
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
    // Use the same reference number from PaymentManage
    String refNumber = payment['ref'];

    // Copy data from PaymentManage to PaymentRecord and set PaymentStatus to false
    _paymentRecordReference.child(refNumber).set({
      'Date': payment['date'],
      'PaidBy': payment['paidBy'],
      'PaymentAmount': payment['paymentAmount'],
      'ProofImage': payment['proofImage'],
      'RoomNum': payment['roomNum'],
      'PaymentStatus': false,
    });

    // Remove the payment record from PaymentManage
    _paymentManageReference.child(refNumber).remove();

    // Refresh the payment data
    getPayments();
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
                        margin: EdgeInsets.fromLTRB(10 * sizeAxis, 20 * sizeAxis, 0 * sizeAxis, 0 * sizeAxis),
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
                        'Payment Management',
                        style: SafeGoogleFont(
                          'Urbanist',
                          fontSize: 18 * size,
                          fontWeight: FontWeight.w500,
                          height: 1.2 * size / sizeAxis,
                          color: const Color(0xff5c5473),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      // Payment Data ListView
                      ListView(
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
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green),
                                    onPressed: () {
                                      handleCheckButtonPress(payment);
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      handleCloseButtonPress(payment);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ManualPayment(),
            ),
          );
        },
        child: Icon(Icons.payment),
        backgroundColor: Color(0xffdfb153),
      ),
    );
  }
}