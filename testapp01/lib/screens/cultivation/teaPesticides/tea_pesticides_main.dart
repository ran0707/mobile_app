import 'package:flutter/material.dart';

class TeaPesticidesMain extends StatefulWidget {

  const TeaPesticidesMain({super.key});

  @override
  State<TeaPesticidesMain> createState() => _TeaPesticidesMainState();
}

class _TeaPesticidesMainState extends State<TeaPesticidesMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('item.title'),
      ),
    );
  }
}
