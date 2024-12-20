import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: const Color(0xFF343141),
        ),
        Container(
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                   Color.fromRGBO(250, 27, 255, 0.2),
                   Color.fromRGBO(67, 77, 203, 0.2),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color:  Color(0x801F1D28),
                  offset:  Offset(0, 24.92),
                  blurRadius: 80,
                ),
              ],
            ),
          ),
        child,
      ],
    );
  }
}
