import 'package:flutter/material.dart';


class TeaDiseaseMain extends StatefulWidget {

  const TeaDiseaseMain({super.key});

  @override
  State<TeaDiseaseMain> createState() => _TeaDiseaseMainState();
}

class _TeaDiseaseMainState extends State<TeaDiseaseMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('item.title'),
      ),

    );
  }
}
