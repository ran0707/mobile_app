import 'dart:io';
import 'package:flutter/material.dart';
import 'package:testapp01/models/detected_object.dart';


class ResultPage extends StatelessWidget {
  final File image;
  final List recognitions;
  final List<DetectedObject> detectedObjects;

  const ResultPage({
    super.key,
    required this.image,
    required this.recognitions,
    required this.detectedObjects,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.file(
              image,
              height: 280,
            ),
            const SizedBox(height: 16.0),
            ...detectedObjects.map((obj) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Detected: ${obj.label}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Confidence: ${(obj.confidence * 100).toStringAsFixed(2)}%",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 8.0),
                Text(
                  "Description: This is a ${obj.label}", // Replace with actual description if available
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16.0),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
