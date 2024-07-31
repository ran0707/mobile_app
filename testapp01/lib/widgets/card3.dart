import 'package:flutter/material.dart';

class Card3 extends StatelessWidget {
  const Card3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      //color: Color.fromRGBO(179, 229, 252, 0.8),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Eco friendly pesticides',
              style: TextStyle(fontSize: 16.0,),
            ),
          ],
        ),
      ),
    );
  }
}
