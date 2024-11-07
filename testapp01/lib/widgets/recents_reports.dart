import 'package:flutter/material.dart';

class RecentReports extends StatelessWidget {
  final int votes;
  final bool isIncrease;
  //final VoidCallback onVote;

  const RecentReports({super.key, required this.votes, required this.isIncrease, });


  @override
  Widget build(BuildContext context) {

    return Card(
      color: const Color(0xffb0e1aa),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent reports',
              style: TextStyle(fontSize: 18.0,),
            ),
            const SizedBox(height: 8.0,),
            Row(
              children: [
                const SizedBox(width: 40.0,),
                Text(
                  '$votes',
                  style:const  TextStyle(fontSize: 20.0, ),
                ),
                const SizedBox(width: 20.0,),
                Icon(
                  isIncrease ? Icons.arrow_upward : Icons.arrow_downward_sharp,
                  color: isIncrease ? Colors.green[600] : Colors.red,
                ),


              ],

            )
          ],
        ),
      ),
    );
  }
}
