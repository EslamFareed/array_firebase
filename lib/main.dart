import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}



//! Firebase => Google 
//! Authentication ( login, create account, login with otp, login with google,....)
//! Cloud Firestore ( Databaase Set,Get,Getlist ) 
//! Realtime database
//! Cloud Storage ( space , files, folder, upload, download )
//! ML KIT ( Machine Learning Kit )
//.............


//! Firebase project ( add app ( android, ios, web, mac ) )