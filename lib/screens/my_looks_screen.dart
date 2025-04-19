import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:fashion_app/utils/face_painter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../utils/facial_measurements.dart';
import '../utils/hairstyle_selection.dart';
import '../utils/face_shape_selector.dart';

class MyLooksScreen extends StatefulWidget {
  const MyLooksScreen({super.key});

  @override
  State<MyLooksScreen> createState() => _MyLooksScreenState();
}

class _MyLooksScreenState extends State<MyLooksScreen> {
  CameraController? _cameraController;
  late FaceDetector _faceDetector;
  String _detectedFaceShape = "Detecting...";
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  List<Face> _detectedFaces = [];

  Map<String, List<String>> faceShapePngs = {
    "oval": [
      "assets/hairstyles/oval/straight.png",
      "assets/hairstyles/oval/wavy.png",
      "assets/hairstyles/oval/curly.png"
    ],
    "round": [
      "assets/hairstyles/round/straight.png",
      "assets/hairstyles/round/wavy.png",
      "assets/hairstyles/round/curly.png"
    ],
    "triangle": [
      "assets/hairstyles/triangle/straight.png",
      "assets/hairstyles/triangle/wavy.png",
      "assets/hairstyles/triangle/curly.png"
    ],
    "diamond": [
      "assets/hairstyles/diamond/straight.png",
      "assets/hairstyles/diamond/wavy.png",
      "assets/hairstyles/diamond/curly.png"
    ],
    "rectangle": [
      "assets/hairstyles/rectangle/straight.png",
      "assets/hairstyles/rectangle/wavy.png",
      "assets/hairstyles/rectangle/curly.png"
    ],
    "oblong": [
      "assets/hairstyles/oblong/straight.png",
      "assets/hairstyles/oblong/wavy.png",
      "assets/hairstyles/oblong/curly.png"
    ],
  };

  @override
  void initState() {
    super.initState();
    _initializeFaceDetection();
  }

  void _initializeFaceDetection() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception('No cameras found');

      final frontCamera = cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      _faceDetector = FaceDetector(
        options: FaceDetectorOptions(

            performanceMode: FaceDetectorMode.accurate,
            enableContours: true,
            enableClassification: false,
            enableLandmarks: true
        ),
      );

      if (mounted) {
        setState(() => _isCameraInitialized = true);
        _startFaceDetection();
      }
    } catch (e) {
      print("Initialization Error: $e");
    }
  }

  void _startFaceDetection() {
    if (!_isCameraInitialized || _cameraController == null) return;

    _cameraController!.startImageStream((image) async {
      if (_isProcessing) return;
      _isProcessing = true;
      await _processImage(image);
      _isProcessing = false;
    });
  }


  Future<void> _processImage(CameraImage image) async {
    try {
      final inputImage = await _convertCameraImage(image);
      if (inputImage == null) return;

      final faces = await _faceDetector.processImage(inputImage);
      if (faces.isEmpty || !mounted) return;

      final face = faces.first;
      final faceContour = face.contours[FaceContourType.face];
      if (faceContour == null || faceContour.points.isEmpty) return;

      final faceMetrics = _calculateFaceMetrics(faceContour.points);
      final shape = _classifyFaceShape(
        face,
      ).toLowerCase();

      setState(() {
        _detectedFaceShape = shape;
        _detectedFaces = faces;
      });
    } catch (e) {
      print("Processing Error: $e");
    }
  }

  Map<String, double> _calculateFaceMetrics(List<Point> points) {
    double minX = double.infinity,
        maxX = -double.infinity;
    double minY = double.infinity,
        maxY = -double.infinity;

    for (final point in points) {
      minX = min(minX, point.x.toDouble());
      maxX = max(maxX, point.x.toDouble());
      minY = min(minY, point.y.toDouble());
      maxY = max(maxY, point.y.toDouble());
    }

    final width = maxX - minX;
    final height = maxY - minY;
    return {
      'width': width,
      'height': height,
      'ratio': height / width,
    };
  }

  String _classifyFaceShape(Face face) {
    final faceContour = face.contours[FaceContourType.face];
    if (faceContour == null || faceContour.points.isEmpty) return "Unknown";

    final points = faceContour.points;
    final width = face.boundingBox.width;
    final height = face.boundingBox.height;
    final faceRatio = height / width;
    final measurements = _getFacialMeasurements(points);

    if (faceRatio < 1.1) {
      if (measurements.jawWidth >= width * 0.95) {
        return "Square";
      }
      if (measurements.cheekWidth > measurements.foreheadWidth * 1.2) {
        return "Diamond";
      }
      return "Round";
    }

    if (faceRatio > 1.4) {
      if (measurements.foreheadWidth > measurements.jawWidth * 1.3) {
        return "Heart";
      }
      return "Oblong";
    }

    if (measurements.cheekWidth > measurements.foreheadWidth &&
        measurements.cheekWidth > measurements.jawWidth) {
      return "Diamond";
    }

    return "Oval";
  }

  FacialMeasurements _getFacialMeasurements(List<Point> points) {
    final yCoords = points.map((p) => p.y).toList();
    final minY = yCoords.reduce(min);
    final maxY = yCoords.reduce(max);
    final faceHeight = maxY - minY;

    final foreheadPoints = points.where((p) => p.y < minY + faceHeight * 0.25);
    final cheekPoints = points.where((p) =>
    p.y >= minY + faceHeight * 0.25 && p.y <= minY + faceHeight * 0.75);
    final jawPoints = points.where((p) => p.y > minY + faceHeight * 0.75);

    return FacialMeasurements(
      _calculateWidth(foreheadPoints),
      _calculateWidth(cheekPoints),
      _calculateWidth(jawPoints),
    );
  }

  double _calculateWidth(Iterable<Point> points) {
    if (points.isEmpty) return 0.0;
    final xCoords = points.map((p) => p.x).toList();
    return (xCoords.reduce(max) - xCoords.reduce(min)).toDouble();
  }

  Future<InputImage?> _convertCameraImage(CameraImage image) async {
    try {
      final format = defaultTargetPlatform == TargetPlatform.android
          ? InputImageFormat.nv21
          : InputImageFormat.bgra8888;

      final inputImage = InputImage.fromBytes(
        bytes: _getImageBytes(image),
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: _getRotation(),
          format: format,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );
      return inputImage;
    } catch (e) {
      print("Image Conversion Error: $e");
      return null;
    }
  }

  Uint8List _getImageBytes(CameraImage image) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return _yuv420toNV21(image);
    }
    return image.planes[0].bytes;
  }

  Uint8List _yuv420toNV21(CameraImage image) {
    final yPlane = image.planes[0].bytes;
    final uvPlane = Uint8List(
        image.planes[1].bytes.length + image.planes[2].bytes.length);

    // Interleave U and V planes (V first for NV21)
    for (int i = 0; i < image.planes[2].bytes.length; i++) {
      uvPlane[2 * i] = image.planes[2].bytes[i];
      uvPlane[2 * i + 1] = image.planes[1].bytes[i];
    }

    return Uint8List.fromList([...yPlane, ...uvPlane]);
  }

  InputImageRotation _getRotation() {
    final sensorOrientation = _cameraController?.description
        .sensorOrientation ?? 0;
    switch (sensorOrientation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    final detectedFaceShape = _detectedFaceShape.isNotEmpty
        ? _detectedFaceShape
        : "Unknown";

    return Scaffold(
      body: Stack(
        children: [
          // Camera Preview
          if (_cameraController != null &&
              _cameraController!.value.isInitialized)
            ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              child: SizedBox.expand(
                child: CameraPreview(_cameraController!),
              ),
            )
          else
            Center(child: CircularProgressIndicator()),

          // Face Detection Overlay
          if (_detectedFaces.isNotEmpty)
            LayoutBuilder(
              builder: (context, constraints) {
                final previewSize = _cameraController!.value.previewSize!;
                final face = _detectedFaces.first; // First detected face
                final faceBox = face.boundingBox;

                final double scaleX = constraints.maxWidth / previewSize.height;
                final double scaleY = constraints.maxHeight / previewSize.width;

                final double faceTop = faceBox.top * scaleY;
                final double faceLeft = faceBox.left * scaleX;
                final double faceWidth = faceBox.width * scaleX;
                final double faceHeight = faceBox.height * scaleY;

                return Stack(
                  children: [
                    CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      painter: FacePainter(
                        detectedShapes: detectedFaceShape,
                        isFrontCamera: true,
                        faces: _detectedFaces,
                        previewSize: Size(
                            previewSize.height, previewSize.width),
                        screenSize: Size(
                            constraints.maxWidth, constraints.maxHeight),
                      ),
                    ),

                    // Face Shape Label
                    Positioned(
                      top: faceTop - 30, // Position above the face
                      left: faceLeft + (faceWidth / 4),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${detectedFaceShape.toUpperCase()} FACE",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

          // Close Button (Top-Left Corner)
          Positioned(
            top: 5,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.cancel, size: 30, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Face Shape Selector (Left Side, 20% from Top)
          Positioned(
            left: 10,
            top: screenSize.height * 0.2,
            child: FaceShapeSelector(detectedFaceShape: detectedFaceShape),
          ),

          // Hairstyle Selection (Bottom, with Padding)
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: HairstyleSelection(
              detectedFaceShape: detectedFaceShape,
              faceShapePngs: faceShapePngs,
            ),
          ),
        ],
      ),
    );
  }
}