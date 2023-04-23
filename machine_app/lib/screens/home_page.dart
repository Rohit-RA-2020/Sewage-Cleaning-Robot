import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../providers/providers.dart';
import 'meeting_page.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final firestoreInstance = FirebaseFirestore.instance;
  bool res = false;

  static Future<bool> getPermissions() async {
    if (Platform.isIOS) return true;
    await Permission.camera.request();
    await Permission.microphone.request();
    await Permission.bluetoothConnect.request();

    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }
    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
    }
    while ((await Permission.bluetoothConnect.isDenied)) {
      await Permission.bluetoothConnect.request();
    }
    return true;
  }

  void getHostId() {
    firestoreInstance.collection('devicestate');
    // get a document value
    firestoreInstance.collection('devicestate').doc('agoraID').get().then(
      (value) {
        var id = value.data();
        ref.read(hostIdProvider.notifier).state = id!['host'];
      },
    );
  }

  @override
  void initState() {
    getHostId();
    super.initState();
  }

  var state = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.robotoMono(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('devicestate')
            .doc('state')
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            state = snapshot.data!.get('state');
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Device current state is',
                  style: GoogleFonts.robotoMono(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.pinkAccent,
                  ),
                ),
                Text(
                  state ? "'ON'" : "'OFF'",
                  style: GoogleFonts.robotoMono(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: state ? Colors.green : Colors.red,
                  ),
                ),
                Lottie.asset(
                  state ? 'assets/poweron.json' : 'assets/poweroff.json',
                ),
                Text(
                  state
                      ? ".....Please continue...."
                      : ".......Please wait......",
                  style: GoogleFonts.robotoMono(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.pinkAccent,
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: state
                        ? () async => {
                              res = await getPermissions(),
                              if (res)
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => const MeetingPage(),
                                  ),
                                )
                            }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Text(
                        'Connect',
                        style: GoogleFonts.robotoMono(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
