import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/services.dart';

class CustomNeuButton extends StatelessWidget {
  const CustomNeuButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: NeumorphicButton(
        onPressed: () {
          //onPressed;
          HapticFeedback.lightImpact();
          SystemSound.play(SystemSoundType.click);
        },
        style: const NeumorphicStyle(
          shape: NeumorphicShape.convex,
          depth: 2,
          boxShape: NeumorphicBoxShape.circle(),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Icon(icon, size: 80),
      ),
    );
  }
}
