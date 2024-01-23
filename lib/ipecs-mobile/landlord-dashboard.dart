import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iPECS/ipecs-mobile/landlord-drawer.dart';
import 'package:iPECS/ipecs-mobile/landlord-profile.dart';
import 'package:iPECS/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class LandlordDashboard extends StatefulWidget {
  const LandlordDashboard({Key? key}) : super(key: key);

  @override
  _LandlordDashboardState createState() => _LandlordDashboardState();
}

class _LandlordDashboardState extends State<LandlordDashboard> {
  final auth = FirebaseAuth.instance;
  User? currentUser;
  List<Map<String, dynamic>> roomData = [];
  List<Map<String, dynamic>> paymentData = [];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    getRooms();
    getPayments();
  }

  @override
  void dispose() {
    // Dispose of the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  Future<void> getRooms() async {
    final DatabaseReference _roomsRef = FirebaseDatabase.instance.reference().child("Rooms");
    final DatabaseReference _usersRef = FirebaseDatabase.instance.reference().child("Users");
    DataSnapshot snapshot = await _roomsRef.get();
    DataSnapshot userSnapshot = await _usersRef.get();

    if (snapshot.value is Map && userSnapshot.value is Map) {
      Map<dynamic, dynamic> roomValues = Map<dynamic, dynamic>.from(snapshot.value as Map);
      Map<dynamic, dynamic> userValues = Map<dynamic, dynamic>.from(userSnapshot.value as Map);

      roomValues.forEach((key, value) {
        String tenantName = userValues[value['UserID']]['username'] ?? 'No Name';
        List<double> consumptionValues = (value['PowerConsumption'] as Map<dynamic, dynamic>)
            .values
            .map<double>((e) => e as double)
            .toList();
        double totalPowerConsumption = consumptionValues.isNotEmpty ? consumptionValues.reduce((a, b) => a + b) : 0.0;

        roomData.add({
          'name': key,
          'currentcredit': value['CurrentCredit'],
          'creditcriticallevel': value['CreditCriticalLevel'],
          'electricityprice': value['ElectricityPrice'],
          'userid': value['UserID'],
          'tenantName': tenantName,
          'totalPowerConsumption': totalPowerConsumption,
        });
      });

      roomData.sort((a, b) => a['name'].compareTo(b['name']));
      setState(() {});
    }

    // Set up the listener for future changes
    _roomsRef.onChildChanged.listen((event) {
      // Update roomData when a child is changed
      DataSnapshot snapshot = event.snapshot;
      String key = snapshot.key ?? '';
      Map<dynamic, dynamic> roomValue = Map<dynamic, dynamic>.from(snapshot.value as Map);
      Map<dynamic, dynamic> userValues = Map<dynamic, dynamic>.from(userSnapshot.value as Map);

      String tenantName = userValues[roomValue['UserID']]['username'] ?? 'No Name';
      List<double> consumptionValues = (roomValue['PowerConsumption'] as Map<dynamic, dynamic>)
          .values
          .map<double>((e) => e as double)
          .toList();
      double totalPowerConsumption = consumptionValues.isNotEmpty ? consumptionValues.reduce((a, b) => a + b) : 0.0;

      setState(() {
        int existingIndex = roomData.indexWhere((element) => element['name'] == key);
        if (existingIndex != -1) {
          // Update existing data
          roomData[existingIndex]['currentcredit'] = roomValue['CurrentCredit'];
          roomData[existingIndex]['creditcriticallevel'] = roomValue['CreditCriticalLevel'];
          roomData[existingIndex]['electricityprice'] = roomValue['ElectricityPrice'];
          roomData[existingIndex]['userid'] = roomValue['UserID'];
          roomData[existingIndex]['tenantName'] = tenantName;
          roomData[existingIndex]['totalPowerConsumption'] = totalPowerConsumption;
        } else {
          // Add new data if not present
          roomData.add({
            'name': key,
            'currentcredit': roomValue['CurrentCredit'],
            'creditcriticallevel': roomValue['CreditCriticalLevel'],
            'electricityprice': roomValue['ElectricityPrice'],
            'userid': roomValue['UserID'],
            'tenantName': tenantName,
            'totalPowerConsumption': totalPowerConsumption,
          });
        }
        roomData.sort((a, b) => a['name'].compareTo(b['name']));
      });
    });
  }

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference().child("PaymentRecord");

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
                'timestamp': payment['Timestamp'], // Add the 'timestamp' field
              };
            }).toList();

            // Sort paymentData by timestamp in descending order
            paymentData.sort((a, b) {
              var format = DateFormat("MM-dd-yyyy HH:mm:ss");
              var dateA = format.parse(a['timestamp']);
              var dateB = format.parse(b['timestamp']);
              return dateB.compareTo(dateA);
            });
            paymentData = paymentData.take(4).toList();
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
    // showDialog(
    //     context: context,
    //     builder: (context){
    //       return Center(child: CircularProgressIndicator(
    //         color: Color(0xffdfb153),
    //       ));
    //     }
    // );
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

  void _roomHistory(int selectedIndex) {
    if (selectedIndex >= 0 && selectedIndex < roomData.length) {
      // Create a reference to the Firebase node for RoomHistory
      DatabaseReference _roomHistoryRef = FirebaseDatabase.instance.reference().child("RoomHistory");

      // Get the selected room data
      Map<String, dynamic> selectedRoom = roomData[selectedIndex];

      // Create a unique key for the selected entry in RoomHistory
      String newKey = _roomHistoryRef.push().key ?? '';

      // Copy the data from the selected room to RoomHistory using the new key
      _roomHistoryRef.child(newKey).set({
        'name': selectedRoom['name'],
        'tenantName': selectedRoom['tenantName'],
        'currentcredit': selectedRoom['currentcredit'],
        'creditcriticallevel': selectedRoom['creditcriticallevel'],
        'electricityprice': selectedRoom['electricityprice'],
        'userid': selectedRoom['userid'],
        'totalPowerConsumption': selectedRoom['totalPowerConsumption'],
        'timestamp': DateTime.now().toString(), // You can add a timestamp if needed
      }).then((_) {
        print("Selected room data copied to RoomHistory successfully");
        _updateCurrentCreditToZero(selectedRoom['name']); // Pass the room key to update only that room's credit
      }).catchError((error) {
        print("Failed to copy selected room data: $error");
      });
    } else {
      print("Invalid index or no room selected");
    }
  }

  void _updateCurrentCreditToZero(String roomKey) {
    DatabaseReference _roomsRef = FirebaseDatabase.instance.reference().child("Rooms");

    _roomsRef.child(roomKey).update({'CurrentCredit': 0}).then((_) {
      print("CurrentCredit updated to 0 for room: $roomKey");
    }).catchError((error) {
      print("Error updating CurrentCredit for room $roomKey: $error");
    });
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
                Container(
                  margin: EdgeInsets.fromLTRB(0 * sizeAxis, 20 * sizeAxis, 0 * sizeAxis, 13 * sizeAxis),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tenant Balance',
                        style: SafeGoogleFont(
                          'Urbanist',
                          fontSize: 18 * size,
                          fontWeight: FontWeight.w500,
                          height: 1.2 * size / sizeAxis,
                          color: const Color(0xff5c5473),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      // ListView for Recent Payments
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: roomData.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, dynamic> room = entry.value;
                          return Card(
                            elevation: 3,
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundImage: AssetImage('assets/ipecs-mobile/images/userCartoon.png'),
                              ),
                              title: Text(
                                '${room['name']} - ${room['tenantName']}',
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
                                    'Room Credit: ₱${(room['currentcredit'] ?? 0).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    'Electricity Price: ₱${room['electricityprice']}',
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  Text(
                                    '⚡: ${(room['totalPowerConsumption'] ?? 0).toStringAsFixed(7)} KWh',
                                    style: TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none,
                                      color: Color(0xffdfb153),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  _roomHistory(index);
                                },
                                icon: Icon(
                                  Icons.remove_circle_outlined, // Replace with your desired icon
                                  color: Colors.red, // Replace with your desired icon color
                                  size: 30, // Replace with your desired icon size
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.fromLTRB(0 * sizeAxis, 20 * sizeAxis, 0 * sizeAxis, 13 * sizeAxis),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Payments',
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
          _showEditCreditCriticalLevelDialog();
        },
        child: Icon(Icons.electric_bolt),
        backgroundColor: Color(0xffdfb153),
      ),
    );
  }
  void _showEditCreditCriticalLevelDialog() {
    double baseWidth = 375;
    double sizeAxis = MediaQuery.of(context).size.width / baseWidth;
    double size = sizeAxis * 0.97;

    TextEditingController elecPriceController = TextEditingController();
    bool isSaveButtonEnabled = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Edit The Desired Electricity Price',
                style: SafeGoogleFont(
                  'Urbanist',
                  fontSize: 18 * size,
                  fontWeight: FontWeight.w500,
                  height: 1.2 * size / sizeAxis,
                  color: const Color(0xff5c5473),
                  decoration: TextDecoration.none,
                ),
              ),
              content: Container(
                padding: EdgeInsets.all(16.0 * size),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ensure the AlertDialog is vertically centered
                  children: [
                    TextField(
                      controller: elecPriceController,
                      decoration: InputDecoration(labelText: 'New Electricity Price!'),
                      style: GoogleFonts.urbanist(
                        fontSize: 15 * size,
                        fontWeight: FontWeight.w500,
                        height: 1.25 * size / sizeAxis,
                        color: const Color(0xff000000),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          isSaveButtonEnabled = double.tryParse(value) != null;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: SafeGoogleFont(
                      'Urbanist',
                      fontSize: 18 * size,
                      fontWeight: FontWeight.w500,
                      height: 1.2 * size / sizeAxis,
                      color: const Color(0xff5c5473),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: isSaveButtonEnabled
                      ? () {
                    _saveElectricityPrice(elecPriceController.text);
                    Navigator.pop(context);
                  } : null,
                  child: Text(
                    'Save',
                    style: SafeGoogleFont(
                      'Urbanist',
                      fontSize: 18 * size,
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
      },
    );
  }

  void _saveElectricityPrice(String newElectricityPrice) {
    DatabaseReference _roomsRef = FirebaseDatabase.instance.reference().child("Rooms");

    _roomsRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? rooms = event.snapshot.value as Map<dynamic, dynamic>?;

        if (rooms != null) {
          rooms.forEach((key, room) {
            _roomsRef.child(key).update({'ElectricityPrice': int.parse(newElectricityPrice)});
          });
        }
      }
    }).catchError((error) {
      print("Error: $error");
    });
  }
}

