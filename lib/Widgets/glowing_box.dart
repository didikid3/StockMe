import 'package:flutter/material.dart';

class GlowingBox extends StatelessWidget{
  final Color glowColor;
  final double heightPercentage;
  final Widget bodyText;
  const GlowingBox({super.key, required this.glowColor, required this.heightPercentage, required this.bodyText});

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * heightPercentage,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 3,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * heightPercentage,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(24),

            ),
            child: bodyText,
          ),
        ]
    );
  }

}