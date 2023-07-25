import 'package:flutter/material.dart';

class BottomLightWidget extends StatelessWidget {
  final bool error;
  const BottomLightWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        // width: ,
        height: 45,
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/Ellipse 6.png',
                scale: 2,
              ),
            ),
            Center(
              child: Image.asset(
                'assets/Ellipse 7.png',
                scale: 2,
                color: error ? Colors.red : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
