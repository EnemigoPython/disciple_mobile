import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StreakIndicator extends StatelessWidget {
  final Color flameColor;
  final String streakText;

  const StreakIndicator({super.key, required this.flameColor, required this.streakText});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
        child: Row(
          spacing: 10,
          children: <Widget> [
            SvgPicture.asset(
              'icons/flame.svg',
              colorFilter: ColorFilter.mode(flameColor, BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
            Text('$streakText: 3', style: TextStyle(color: Colors.white, fontSize: 14)),
          ]
        ),
      ),
    );
  }
}
