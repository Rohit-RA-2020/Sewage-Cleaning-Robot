import 'package:client_app/providers/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';
import 'pages/controller_page.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomeWidget(),
    );
  }
}

class MyHomeWidget extends ConsumerStatefulWidget {
  const MyHomeWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomeWidgetState();
}

class _MyHomeWidgetState extends ConsumerState<MyHomeWidget> {
  // create a firestore reference
  final firestoreInstance = FirebaseFirestore.instance;

  bool res = false;

  static Future<bool> getPermissions() async {
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

  void getClientId() {
    firestoreInstance.collection('devicestate');
    // get a document value
    firestoreInstance.collection('devicestate').doc('agoraID').get().then(
      (value) {
        var id = value.data();
        ref.read(clientIdProvider.notifier).state = id!['client'];
      },
    );
  }

  @override
  void initState() {
    getClientId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome to Waste-Wizard',
          style: GoogleFonts.robotoMono(
            fontSize: 20,
            fontWeight: FontWeight.w800,
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Device Current State',
                        style: GoogleFonts.robotoMono(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Switch(
                        value: snapshot.data!.get('state'),
                        onChanged: (value) {
                          setState(
                            () {
                              firestoreInstance
                                  .collection('devicestate')
                                  .doc('state')
                                  .update(
                                {'state': value},
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Lottie.asset(
                    'assets/machine.json',
                  ),
                  SizedBox(
                    height: 60,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: snapshot.data!.get('state')
                          ? () async => {
                                res = await getPermissions(),
                                if (res)
                                  {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (_) => const ControllerPage(),
                                      ),
                                    )
                                  }
                              }
                          : null,
                      child: Text(
                        'Continue',
                        style: GoogleFonts.robotoMono(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
