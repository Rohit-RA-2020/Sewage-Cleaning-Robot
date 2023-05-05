import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/services.dart';

class CustomNeuButton extends StatefulWidget {
  const CustomNeuButton({
    super.key,
    required this.icon,
    required this.cmd,
  });

  final IconData icon;
  final String cmd;

  @override
  State<CustomNeuButton> createState() => _CustomNeuButtonState();
}

class _CustomNeuButtonState extends State<CustomNeuButton> {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  void sendCommand(String command) {
    firestoreInstance.collection('commands').doc('list').update(
      {
        'cmd': command,
        'time': DateTime.now().microsecondsSinceEpoch,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: NeumorphicButton(
        onPressed: () {
          sendCommand(widget.cmd);
          HapticFeedback.lightImpact();
          SystemSound.play(SystemSoundType.click);
        },
        style: const NeumorphicStyle(
          shape: NeumorphicShape.convex,
          depth: 2,
          boxShape: NeumorphicBoxShape.circle(),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Icon(widget.icon, size: 80),
      ),
    );
  }
}
