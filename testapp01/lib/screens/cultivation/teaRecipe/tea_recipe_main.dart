import 'package:flutter/material.dart';

class TeaRecipeMain extends StatefulWidget {

  const TeaRecipeMain({super.key});

  @override
  State<TeaRecipeMain> createState() => _TeaRecipeMainState();
}

class _TeaRecipeMainState extends State<TeaRecipeMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('item.title'),
      ),
    );
  }
}
