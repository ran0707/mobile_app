import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class PestSeasonMain extends StatefulWidget {
  const PestSeasonMain({super.key});

  @override
  State<PestSeasonMain> createState() => _PestSeasonMainState();
}

class _PestSeasonMainState extends State<PestSeasonMain> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isCalendarVisible = false;

  List<Map<String, dynamic>> cardDetails = [];

  @override
  void initState() {
    super.initState();
    fetchPestData();
  }

  Future<void> fetchPestData() async {
    try {
      final res = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/pests'),
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body);
        print('Fetched Data: $data');
        setState(() {
          cardDetails = data
              .map((item) {
                try {
                  final month = item['month'];
                  return {
                    'id': item['_id'],
                    'month': month,
                    'pestName': item['pestName'],
                    'images': item['images'] ?? [],
                  };
                } catch (e) {
                  print('Error parsing month for item: $item - $e');
                  return null;
                }
              })
              .where((item) => item != null)
              .cast<Map<String, dynamic>>()
              .toList();
        });
      } else {
        print('Failed to load pest data: ${res.statusCode} ${res.body}');
        throw Exception(
            'Failed to load pest data: ${res.statusCode} ${res.body}');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to load pest data: $e');
    }
  }

  Future<Uint8List> fetchImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  void _toggleCalendarVisible() {
    setState(() {
      _isCalendarVisible = !_isCalendarVisible;
    });
  }

  void _selectPestName(String pestName) {
    print('Selected pest Name: $pestName');
    Navigator.pop(context, pestName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pests Season'),
        actions: [
          IconButton(
            onPressed: _toggleCalendarVisible,
            icon: Icon(Icons.calendar_month_sharp),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isCalendarVisible)
            Container(
              height: MediaQuery.of(context).size.height / 2.2,
              child: TableCalendar(
                firstDay: DateTime.utc(2001, 4, 22),
                lastDay: DateTime.utc(2030, 2, 13),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // Adjust the cross axis count as needed
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.50, // Adjust the aspect ratio as needed
                ),
                itemCount: cardDetails.length,
                itemBuilder: (context, index) {
                  final card = cardDetails[index];
                  final images = card['images'] as List<dynamic>;

                  return GestureDetector(
                    onTap: () => {
                      print('Tapped on: ${card['pestName']}'),
                      _selectPestName(card['pestName']),
                    },
                    child: Card(
                      color: Color(0xffbcd7ed),
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              '${card['month']} - ${card['pestName']}',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w800),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length,
                              itemBuilder: (context, imgIndex) {
                                final imageId = images[imgIndex]['_id'];
                                final imageUrl =
                                    'http://10.0.2.2:5000/api/pests/${card['id']}/image/$imageId';
                                print('imageURlL: $imageUrl');

                                return FutureBuilder<Uint8List>(
                                    future: fetchImage(imageUrl),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: Text('Loading...'),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Icon(
                                          Icons.broken_image_outlined,
                                          size: 100.0,
                                        );
                                      } else {
                                        return Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              child: Image.memory(
                                                snapshot.data!,
                                                height: 80.0,
                                                width: 240.0,
                                                fit: BoxFit.cover,
                                              ),
                                            ));
                                      }
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
