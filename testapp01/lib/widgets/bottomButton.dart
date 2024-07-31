import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



class BottomButton extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final Function onCameraPressed;

  const BottomButton({ Key?key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.onCameraPressed,
  }) : super (key: key);

  @override
  State<BottomButton> createState() => _BottomButtonState();
}

class _BottomButtonState extends State<BottomButton> {



  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:<Widget> [
              _buildBottomNavigationItem(Icons.home, "Home", 0),
              _buildBottomNavigationItem(CupertinoIcons.tree, "Cultivation", 1),
              SizedBox(width: 40.0,),
              _buildBottomNavigationItem(CupertinoIcons.group_solid, "community", 2),
              _buildBottomNavigationItem(CupertinoIcons.shopping_cart, "vendors", 3),
            ],
          ),
        ),
        //color: Colors.green[200],
    );
  }
  Widget _buildBottomNavigationItem(IconData icon, String label, int index){
     return GestureDetector(
       onTap:()=> widget.onItemTapped(index),
       child: Column(
         mainAxisSize: MainAxisSize.min,
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           Icon(icon, color: widget.selectedIndex == index ? Colors.green : Colors.black,),
           Text(
             label,
             style: TextStyle(color: widget.selectedIndex == index ? Colors.green : Colors.black, fontSize: 12.0),
           ),
         ],
       ),
     );
  }
}

