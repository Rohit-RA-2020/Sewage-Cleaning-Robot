import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/neu_button.dart';
import '../widgets/video_stream.dart';

class ControllerPage extends StatefulWidget {
  const ControllerPage({Key? key}) : super(key: key);

  @override
  State<ControllerPage> createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  Timer? timer;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Sewage Robot Controller',
          style: GoogleFonts.robotoMono(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('devicestate')
                .doc('torch')
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Switch(
                  value: snapshot.data!['state'],
                  onChanged: (value) async {
                    firestoreInstance
                        .collection('devicestate')
                        .doc('torch')
                        .update(
                      {'state': value},
                    );
                  },
                );
              }
            },
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            const CustomNeuButton(
              icon: Icons.arrow_circle_up_outlined,
              cmd: 'F',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                CustomNeuButton(
                  icon: Icons.arrow_circle_left_outlined,
                  cmd: 'L',
                ),
                CustomNeuButton(
                  icon: Icons.arrow_circle_right_outlined,
                  cmd: 'R',
                ),
              ],
            ),
            const CustomNeuButton(
              icon: Icons.arrow_circle_down_outlined,
              cmd: 'B',
            ),
            const SizedBox(height: 20),
            const VideoStream(),
            const SizedBox(height: 70),
            // add a emergency stop button
            const EmergencyButton(),
          ],
        ),
      ),
    );
  }
}

class EmergencyButton extends StatelessWidget {
  const EmergencyButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('devicestate')
          .doc('emergencyStop')
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SizedBox(
            height: 60,
            width: 300,
            child: ElevatedButton(
              onPressed: snapshot.data!['state']
                  ? null
                  : () {
                      FirebaseFirestore.instance
                          .collection('devicestate')
                          .doc('emergencyStop')
                          .update(
                        {'state': true},
                      ).whenComplete(
                        () => {
                          Future.delayed(
                            const Duration(seconds: 11),
                            () => FirebaseFirestore.instance
                                .collection('devicestate')
                                .doc('emergencyStop')
                                .update(
                              {'state': false},
                            ),
                          ),
                        },
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Emergency Stop',
                    style: GoogleFonts.robotoMono(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.offline_bolt,
                    size: 30,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
