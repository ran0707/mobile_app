import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testapp01/bloc/cultivation//cultivation_page_event.dart';
import 'package:testapp01/bloc/cultivation//cultivation_page_state.dart';
import 'package:testapp01/bloc/cultivation//cultivation_page_bloc.dart';
import 'package:testapp01/screens/cultivation/teaCultivation/tea_cultivation_main.dart';
import 'package:testapp01/screens/cultivation/teaDisease/tea_disease_main.dart';
import 'package:testapp01/screens/cultivation/teaPesticides/tea_pesticides_main.dart';
import 'package:testapp01/screens/cultivation/teaRecipe/tea_recipe_main.dart';


class CultivationMain extends StatefulWidget {
  const CultivationMain({super.key});

  @override
  State<CultivationMain> createState() => _CultivationMainState();
}

class _CultivationMainState extends State<CultivationMain> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CultivationPageBloc()..add(LoadContent()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: !_isSearching
              ? const Text('Green Guard')
              : TextFormField(
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
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                  }
                });
              },
            ),
          ],
        ),
        body: BlocBuilder<CultivationPageBloc, CultivationPageState>(
          builder: (context, state) {
            if (state is ContentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ContentLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children:
                      state.items.asMap().entries.map((entry){
                        int index = entry.key;
                        ContentItem item = entry.value;
                         Color? cardColor = Color(0xffd2e3fc) ;  //0xffd2e3fc
                        return  _buildCard(item, context, cardColor, index);
                      }).toList(),
                ),
              );
            } else if (state is ContentError) {
              return const Center(child: Text('Failed to load content'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}

Widget _buildCard(ContentItem item, context, Color cardColor, int index) {

  return  Card(
    color: cardColor,
      margin: const EdgeInsets.all(10.0),
      child: Container(
        height: 150.0,
        padding: const EdgeInsets.all(16.0),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(50),
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>TeaDiseaseMain()));
          },
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Text(
                    item.content,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              )),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  item.image,
                  width: 120.0,
                  height: 120.0,
                  fit: BoxFit.cover,

                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
            ],
          ),
        ),
      ),
  );
}
