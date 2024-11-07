
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testapp01/screens/dashboard/pest_season_main.dart';

class DateSeasonCard extends StatefulWidget {
  const DateSeasonCard({super.key});

  @override
  State<DateSeasonCard> createState() => _DateSeasonCardState();
}

class _DateSeasonCardState extends State<DateSeasonCard> {
  String? _pestName;

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('dd MMM').format(DateTime.now());
    String currentMonth = DateFormat('MMM').format(DateTime.now());

    return InkWell(
      onTap: () async {
        print('Navigation to pestseasonMain ');
        final result = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => const PestSeasonMain()));
        print('Navigation returned result: $result');
        if (result != null && result is String) {
          print("Returned pest name: $result");
          setState(() {
            _pestName = result;
          });
        }else{
          print('No valid pest name received');
        }
      },
      child: Card(
        color: const Color(0xfffad9bf),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'today, $currentDate',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 8.0,
              ),
              if (_pestName != null)
                SizedBox(
                  height: 45.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _pestName!.split(', ').length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: Card(
                          //color: Color(0xfffbee52),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, ),
                            child: Text(
                              _pestName!.split(', ')[index],

                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                Container(
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Tap to see pest details',
                      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
