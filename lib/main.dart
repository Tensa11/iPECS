import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iPECS/firebase_options.dart';
import 'package:iPECS/ipecs-mobile/get-started.dart';
import 'package:iPECS/ipecs-mobile/landlord-dashboard.dart';
import 'package:iPECS/ipecs-mobile/tenant-dashboard.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';

Future <void> main() async {
	WidgetsFlutterBinding.ensureInitialized();
	// flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
	await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
	// final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
	// final initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
	// final initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
	// await flutterLocalNotificationsPlugin.initialize(initializationSettings);
	runApp(const MyApp());
}


class MyApp extends StatelessWidget {
	const MyApp({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		SystemChrome.setSystemUIOverlayStyle(
				const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			title: 'iPECS',
			// home: SplashScreen(),
			home: StreamBuilder<User?>(
				stream: FirebaseAuth.instance.authStateChanges(),
				builder: (BuildContext context, snapshot) {
					if (snapshot.hasData) {
						final user = snapshot.data;
						if (user != null) {
							// Fetch user role from Firebase Realtime Database
							return StreamBuilder<DatabaseEvent>(
								stream: FirebaseDatabase.instance.reference().child('Users').child(user.uid).onValue,
								builder: (BuildContext context, snapshot) {
									if (snapshot.hasData) {
										final userRole = (snapshot.data!.snapshot.value as Map).cast<String, dynamic>()?['userRole'];
										if (userRole == 'Tenant') {
											return const SplashScreenTenant();
										} else if (userRole == 'Landlord') {
											return const SplashScreenLandlord();
										}
									}
									return const SplashScreen();
								},
							);
						}
					}
					return const SplashScreen();
				},
			),
		);
	}
}

class SplashScreen extends StatelessWidget {
	const SplashScreen({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return AnimatedSplashScreen(
			splash: Lottie.asset('assets/lottie/LottieAnimationIntro.json'),
			// splash: Lottie.network('https://lottiefiles.com/animations/light-bulb-rrtnthBH0O'),
			nextScreen: const GetStarted(),
			splashIconSize: 900,
			duration: 2000,
			splashTransition: SplashTransition.fadeTransition,
		);
	}
}

class SplashScreenTenant extends StatelessWidget {
	const SplashScreenTenant({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return AnimatedSplashScreen(
			splash: Lottie.asset('assets/lottie/LottieAnimationIntro.json'),
			// splash: Lottie.network('https://lottiefiles.com/animations/light-bulb-rrtnthBH0O'),
			nextScreen: const TenantDashboard(),
			splashIconSize: 900,
			duration: 2000,
			splashTransition: SplashTransition.fadeTransition,
		);
	}
}

class SplashScreenLandlord extends StatelessWidget {
	const SplashScreenLandlord({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return AnimatedSplashScreen(
			splash: Lottie.asset('assets/lottie/LottieAnimationIntro.json'),
			// splash: Lottie.network('https://lottiefiles.com/animations/light-bulb-rrtnthBH0O'),
			nextScreen: const LandlordDashboard(),
			splashIconSize: 900,
			duration: 2000,
			splashTransition: SplashTransition.fadeTransition,
		);
	}
}