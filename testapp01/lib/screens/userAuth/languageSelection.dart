import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp01/bloc/language_selection/language_state.dart';
import 'package:testapp01/screens/userAuth/phoneVerify.dart';
import 'package:testapp01/screens/userAuth/userverify.dart';
import '../../bloc/language_selection/language_bloc.dart';
import '../../bloc/language_selection/language_event.dart';
import '../../localization/app_localizations.dart';


class LanguageSelection extends StatefulWidget {

  const LanguageSelection({super.key});

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  final List<Map<String, String>> languages = [
    {'name': 'தமிழ்', 'image': 'Images/tamil.png'},
    {'name': 'English', 'image': 'Images/english.png'},
    {'name': 'हिंदी', 'image': 'Images/hindi.png'},
    {'name': 'অসমীয়া', 'image': 'Images/assameses.png'},
    {'name': 'తెలుగు', 'image': 'Images/Telugu.png'},
    {'name': 'ಕನ್ನಡ', 'image': 'Images/Kannada.png'},
    {'name': 'മലയാളം', 'image': 'Images/malayalam.png'},
    {'name': 'ਪੰਜਾਬੀ', 'image': 'Images/punjabi.png'},
  ];


  // String? selectedLanguage;
  //
  // void selectLanguage(String language) async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('selectedLanguage', language);
  //   context.read<LanguageBloc>().add(SelectLanguage(language));
  //
  //   setState(() {
  //     selectedLanguage = language;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Select Your Language'),
        // actions: const [Icon(Icons.more_vert_outlined)],
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),

        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,  //number of column
              childAspectRatio: 5 / 3, // aspect ration for each card
              crossAxisSpacing: 15, // hor space
              mainAxisSpacing: 15, //ver space
            ),
            itemCount: languages.length,
            itemBuilder: (context, index){
              final language = languages[index]['name']!;
              final image = languages[index]['image']!;
              return BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
                final isSelected = state is LanguageSelected && state.selectedLanguage == language;
                return LanguageCard(
                  language: language,
                  image: image,
                  isSelected: isSelected,
                  onSelect:(selectedLanguage){
                    context.read<LanguageBloc>().add(SelectLanguage(selectedLanguage));
                   Navigator.of(context).push(MaterialPageRoute(builder: (context) => PhoneVerification()));
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserVerification()));
                  }
                );
              });
            }
        ),
      ),
    );
  }


}



class LanguageCard extends StatelessWidget {

  final String language;
  final String image;
  final bool isSelected;
  final Function(String) onSelect;




  const LanguageCard({
    super.key,
    required this.language,
    required this.image,
    required this.isSelected,
    required this.onSelect
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xffdfe5fa) ,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: isSelected ? Colors.black : Colors.transparent,
          width: .80,
        ),
      ),
      child: InkWell(
        onTap: () {
          onSelect(language);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$language selected')),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(image, width: 30, height: 30,),
                const SizedBox(height: 14.0,),
          
                Text(
                  language,
                  style: TextStyle(fontSize: 16.0,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
