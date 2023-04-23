import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_app/screens/home_page.dart';
import 'firebase_options.dart';

import 'package:audioplayers/audioplayers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AudioPlayer audioPlayer = AudioPlayer();
  AssetSource src = AssetSource('emergency.mp3');

  void playEmergencySound() {
    audioPlayer.play(src);
    audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void stopEmergencySound() {
    audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('devicestate')
            .doc('emergencyStop')
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.get('state')) {
              playEmergencySound();
            } else {
              stopEmergencySound();
            }
          }
          return const MyHomePage(title: 'Host Application');
        },
      ),
    );
  }
}
