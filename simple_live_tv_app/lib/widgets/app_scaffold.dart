import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  const AppScaffold({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  // //linear-gradient(135deg,#152331,#000000)
                  // Color.fromARGB(255, 29, 50, 70),
                  // Color.fromARGB(255, 14, 21, 29),
                  // Color.fromARGB(255, 29, 50, 70),
                  // linear-gradient(135deg,#141e30,#243b55)
                  Color(0xFF000000),
                  Color(0xFF1C1C1E),
                  Color(0xFF000000),
                ],
              ),
            ),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}
