import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testapp01/screens/userAuth/languageSelection.dart';
import 'package:testapp01/screens/userAuth/userverify.dart';
import '../userAuth/phoneVerify.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final String avatar = 'Images/avatar.png';
  final String userName = 'username';
  final String email = 'sampleEmail@gmail.com';


Future<void> _logout() async{
  await Future.delayed(Duration(seconds: 2));
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>  LanguageSelection()));
}

  void _handleLocationTap(){

    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserVerification()));
  }

  void _handleDroneServiceTap(){}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('profile'),
          actions: [
            IconButton(
                icon: CircleAvatar(
                    backgroundColor: Color(0xfef35158),
                    child:Icon(CupertinoIcons.power, color: Color(0xfeffffff),)
                ),
              onPressed: (){
               _logout();
              },

            )
          ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffe4e4e4)),
                borderRadius:BorderRadius.circular(50.0),

              ),
              child: Row(
                children: [
                  Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Color(0xffeaddff),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('Images/english.png'),
                        fit: BoxFit.cover,
                      )
                    ),
                  ),

                  const SizedBox(width: 16.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 18.0,
                          //fontWeight: FontWeight.w100,
                        ),
                      ),
                      const SizedBox(height: 8.0,),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                ],
              ),
            ),
            const SizedBox(height: 20.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text('General', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
               const SizedBox(height: 18.0,),
                Container(
                  height: 60.0,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffe4e4e4)),
                    borderRadius:BorderRadius.circular(5.0),
                    //color: Color(0xffe4e4e4)
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: _handleLocationTap,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Location', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10.0,),
                Container(
                  height: 60.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffe4e4e4)),
                    borderRadius:BorderRadius.circular(5.0),
                    //color: Color(0xffe4e4e4)
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: _handleLocationTap,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Drone service', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),
                Container(
                  height: 60.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffe4e4e4)),
                    borderRadius:BorderRadius.circular(5.0),
                    //color: Color(0xffe4e4e4)
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: _handleLocationTap,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Language', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),
                Container(
                  height: 60.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffe4e4e4)),
                    borderRadius:BorderRadius.circular(5.0),
                    //color: Color(0xffe4e4e4)
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: _handleLocationTap,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('My Activity', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('support', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                const SizedBox(height: 18.0,),
                Container(
                  height: 60.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffe4e4e4)),
                    borderRadius:BorderRadius.circular(5.0),
                    //color: Color(0xffe4e4e4)
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: _handleLocationTap,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Support', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),
                Container(
                  height: 60.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffe4e4e4)),
                    borderRadius:BorderRadius.circular(5.0),
                    //color: Color(0xffe4e4e4)
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: _handleLocationTap,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('About', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],


        ),
  

      ),

    );
  }
}
