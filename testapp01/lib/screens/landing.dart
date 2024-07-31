import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp01/screens/userAuth/languageSelection.dart';
import 'package:testapp01/screens/userAuth/phoneVerify.dart';
import 'package:testapp01/screens/objectdetection/resultPage.dart';
import 'package:testapp01/screens/userAuth/userverify.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  void _navigateToPhoneVerify(BuildContext context) async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.setBool('isFirstTime', false);
   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LanguageSelection()));
   //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Userverification()));
   //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ResultPage()));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('Images/landingPage.jpg'),
            const SizedBox(height: 20.0,),
            const Text('Green Camellia', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),),
            const SizedBox(height: 100.0,),
            OutlinedButton(onPressed: () => _navigateToPhoneVerify(context),
                child: const Text('Get Started')),
          ],
        ),
      ),
    );
  }
}
