import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FacePainter extends CustomPainter {
  final List<Face> faces;
  final Size previewSize;
  final Size screenSize;
  final bool isFrontCamera;
  final String detectedShapes;

  FacePainter({
    required this.faces,
    required this.previewSize,
    required this.screenSize,
    required this.isFrontCamera,
    required this.detectedShapes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = screenSize.width / previewSize.width;
    final double scaleY = screenSize.height / previewSize.height;

    for (int i = 0; i < faces.length; i++) {
      final face = faces[i];
      final contour = face.contours[FaceContourType.face];
      if (contour == null || contour.points.isEmpty) continue;

      final Paint paint = Paint()
        ..color = Colors.white
        ..strokeWidth = max(2.0, face.boundingBox.width * 0.03)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..filterQuality = FilterQuality.high;

      final Path path = Path();

      for (int j = 0; j < contour.points.length; j++) {
        double x = contour.points[j].x * scaleX;
        double y = contour.points[j].y * scaleY;

        if (isFrontCamera) {
          x = screenSize.width - x;
        }

        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant FacePainter oldDelegate) => true;
}

class FaceShapeOverlay extends StatelessWidget {
  final String detectedFaceShape;

  const FaceShapeOverlay({required this.detectedFaceShape, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            detectedFaceShape,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

