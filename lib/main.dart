import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iPECS/firebase-messaging/notify.dart';
import 'package:iPECS/firebase_options.dart';
import 'package:iPECS/ipecs-mobile/TestTest.dart';
import 'package:iPECS/ipecs-mobile/get-started.dart';
import 'package:iPECS/ipecs-mobile/tenant-dashboard.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future <void> main() async {
	WidgetsFlutterBinding.ensureInitialized();
	flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

	await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
	// await FirebaseNotify().initNotification();
	FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
	runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
	await Firebase.initializeApp();
	print('Handling a background message ${message.messageId}');
}



class MyApp extends StatelessWidget {
	const MyApp({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		SystemChrome.setSystemUIOverlayStyle(
				const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
		return const MaterialApp(
			debugShowCheckedModeBanner: false,
			title: 'iPECS',
			home: SplashScreen(),
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
