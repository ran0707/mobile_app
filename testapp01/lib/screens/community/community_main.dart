import 'package:flutter/material.dart';

class CommunityMain extends StatefulWidget {
  const CommunityMain({super.key});

  @override
  State<CommunityMain> createState() => _CommunityMainState();
}

class _CommunityMainState extends State<CommunityMain> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: !_isSearching
        ? const Text('Green Communtiy')
            : TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search..',
            fillColor: Color(0xffe0e0e0),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 40.0),
            prefixIcon: Icon(Icons.search, color: Color(0xff8e8e8e),),
          ),
          style: const TextStyle(color: Colors.black, fontSize: 16.0),
        ),
        actions: <Widget>[
          IconButton(
              icon:Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: (){
            setState(() {
              _isSearching = !_isSearching;
              if(!_isSearching){
                _searchController.clear();
              }
            });
          },
          ),
        ],
      ),
      body: ListView(
        children: [
          // Banner for announcements or promotions
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blueGrey[100],
            child: const Row(
              children: [
                Icon(Icons.announcement),
                SizedBox(width: 10.0),
                Text(
                  'Join our Discord server for live discussions!',
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),

          // Section for popular topics
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Popular Topics',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              Chip(
                label: const Text('State Management'),
                backgroundColor: Colors.blue[100],
              ),
              Chip(
                label: const Text('Animations'),
                backgroundColor: Colors.blue[100],
              ),
              Chip(
                label: const Text('Networking'),
                backgroundColor: Colors.blue[100],
              ),
              // Add more chips as needed
            ],
          ),

          // Section for community members
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Community Members',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          const ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://placeimg.com/64/64/people'),
            ),
            title: Text('John Doe'),
            subtitle: Text('Flutter enthusiast'),
          ),
          const ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://placeimg.com/64/64/tech'),
            ),
            title: Text('Jane Smith'),
            subtitle: Text('Mobile developer'),
          ),
          // Add more list tiles as needed
        ],
      ),
    );
  }
}
