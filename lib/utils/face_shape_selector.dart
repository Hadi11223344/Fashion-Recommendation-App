import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FaceShapeSelector extends StatelessWidget {
  final String detectedFaceShape; // Face shape detected
  static List<String> faceShapes = [
    "oval",
    "round",
    "triangle",
    "oblong",
    "diamond",
    "rectangle"
  ];

  const FaceShapeSelector({super.key, required this.detectedFaceShape});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      top: 50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: faceShapes.map((shape) {
          bool isSelected = shape == detectedFaceShape;
          return Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(25),
              border: isSelected ? Border.all(color: Colors.red, width: 2) : null,
            ),
            child: SvgPicture.asset(
              'assets/faceshapes/$shape.svg',
            ),
          );
        }).toList(),
      ),
    );
  }
}
