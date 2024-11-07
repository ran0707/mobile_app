import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Card2Report extends StatefulWidget {

  final int initialVotes;
  final ValueChanged<int> onVote;
  // final List<String> pestNames;

   const Card2Report({super.key,  required this.initialVotes, required this.onVote, });

  @override
  State<Card2Report> createState() => _Card2ReportState();
}

class _Card2ReportState extends State<Card2Report> {

  late int _votes;
  late Map<String, int> _pestVotes;
  late int _yesterdatVotes;
  late int _lastMonthVotes;
  Timer? _timer;

final List<String> _pestNames = [
  'Tea mosquito bug',
  'Tea thrips',
  'Red spider mite',
  'Red slug caterpillar',
  'Aphids',
  'Tea leaf looper',

];


  @override
  void initState(){
    super.initState();

    _votes = widget.initialVotes;
    _yesterdatVotes = 0;
    _lastMonthVotes = 0;
    _pestVotes = {for (var pest in _pestNames) pest: 0};
    _loadVotes();
    _startDailyResetTimer();
    //_fetchReports();
  }

  void _startDailyResetTimer(){
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = midnight.difference(now);
    _timer = Timer(durationUntilMidnight,_resetDailyVotes);
  }

  Future<void> _resetDailyVotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _yesterdatVotes = _votes;
      _votes = 0;
      _pestVotes = { for (var pest in _pestNames) pest: 0 };
    });
    prefs.setInt('yesterdayCount', _yesterdatVotes);
    prefs.setInt('current count', _votes);
    for(var pest in _pestNames){
      prefs.setInt('votes_$pest', 0);
    }
    _startDailyResetTimer();
  }

  Future<void> _loadVotes()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _votes = prefs.getInt('currentVotes') ?? widget.initialVotes;
      _yesterdatVotes = prefs.getInt('yesterdayCount') ?? 0 ;
      _lastMonthVotes = prefs.getInt('lastMonthcount') ?? 0;
      for(var pest in _pestNames){
        _pestVotes[pest] = prefs.getInt('votes_$pest') ?? 0;
      }
    });
  }
  Future<void> _voteForPest( String pest) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _votes++;
      _pestVotes[pest] = (_pestVotes[pest] ?? 0) +1;
    });
    prefs.setInt('currentCount', _votes);
    prefs.setInt('count_$pest', _pestVotes[pest]!);
    widget.onVote(_votes);

    try{
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/reports/report'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'pestName':pest,
          'votes': 1,
          'isIncrease':true,
        })
      );
      if(response.statusCode == 200){
        print('report is saved');
      }else{
        print('failed to save ${response.body}');
      }
    }catch(e){
      print('Error sending report $e');
    }
    
  }

// Future<void> _fetchReports()async{
//     try{
//       final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/reports/allReport'),
//       headers: {'Content-Type': 'application/json'},
//       );
//       if(response.statusCode == 200){
//         List<dynamic> reports = jsonDecode(response.body);
//
//         setState(() {
//           _votes = 0;
//           _pestVotes = {for (var pest in _pestNames) pest: 0};
//           for(var report in reports){
//            int votes = report['votes'] ?? 0;
//             String pestName = report['pestName'];
//             if(_pestVotes.containsKey(pestName)){
//               _pestVotes[pestName] = (_pestVotes[pestName]?? 0) + votes;
//             }
//           }
//         });
//       }else{
//         print('Failed to fetch reports: ${response.body}');
//       }
//     }catch(e){
//       print('Error to fetch the data $e');
//     }
// }
  @override
  void dispose(){
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Recent Reports "),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blueAccent,
            width: double.infinity,
            child: Column(
              children: [
                 Text(
                  'Overall Reports: $_votes',
                  style: const TextStyle(color: Colors.white, fontSize: 22.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0,),
                for(var pest in _pestNames)
                  Text(
                    '$pest : ${_pestVotes[pest]} votes',
                    style: const TextStyle(color: Colors.white, fontSize: 14.0),
                    //textAlign: TextAlign.left,
                  ),
                const SizedBox(height: 16.0,),
                  Row(
                    children: [
                      Text(
                        'Last month report: $_lastMonthVotes',
                        style: const TextStyle(color: Colors.white, fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 10.0,),
                      Text(
                        'Yesterday Report: $_yesterdatVotes',
                        style: const TextStyle(color: Colors.white,fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),


              ],

            ),
          ),
          Expanded(
              child: ListView.builder(
                itemCount: _pestNames.length,
                  itemBuilder: (context, index){
                     final pest = _pestNames[index];
                     return Container(
                       margin: const EdgeInsets.all(8.0) ,
                       // width: 250.0,
                       // height: 250.0,
                       child: Card(
                         child: Padding(
                           padding: const EdgeInsets.all(16.0),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text(
                                 pest, style: const TextStyle(fontSize: 16.0),
                               ),
                               ElevatedButton(
                                onPressed: ()=> _voteForPest(pest),
                               child: const Text('vote') ),
                             ],
                           ),
                         ),
                       ),
                     );
                  }
              )),
        ],

      ),
    );
  }
}
