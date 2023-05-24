import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      child: GestureDetector(
        onTap: () {
          sendCommand(widget.cmd);
          HapticFeedback.lightImpact();
          SystemSound.play(SystemSoundType.click);
        },
        child: Center(
          child: Icon(widget.icon, size: 80),
        ),
      ),
    );
  }
}
