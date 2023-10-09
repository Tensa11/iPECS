import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iPECS/firebase_options.dart';
import 'package:iPECS/ipecs-mobile/get-started.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

Future <void> main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
	runApp(const MyApp());
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
