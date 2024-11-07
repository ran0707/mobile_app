import 'package:flutter/material.dart';

class TeaCultivationMain extends StatefulWidget {

  const TeaCultivationMain({super.key});

  @override
  State<TeaCultivationMain> createState() => _TeaCultivationMainState();
}

class _TeaCultivationMainState extends State<TeaCultivationMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('item.title'),
      ),
    );
  }
}
