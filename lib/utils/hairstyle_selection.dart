import 'package:flutter/material.dart';

class HairstyleSelection extends StatelessWidget {
  final String detectedFaceShape;
  final Map<String, List<String>> faceShapePngs;

  const HairstyleSelection({
    required this.detectedFaceShape,
    required this.faceShapePngs,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> hairstyles = faceShapePngs[detectedFaceShape] ?? [];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: hairstyles.map((imagePath) {
            String hairstyleName = _extractHairstyleName(imagePath);

            return Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(5.39),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8.98),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    hairstyleName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 93.10,
                    height: 120.93,
                    child: Image.asset(imagePath, fit: BoxFit.cover,)
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Extracts a clean hairstyle name from PNG path
  String _extractHairstyleName(String svgPath) {
    return svgPath.split('/').last.split('.').first.replaceAll('_', ' ');
  }
}
