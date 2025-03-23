import 'package:bars/pages/enroll.dart';
import 'package:bars/widgets/markregbutton.dart';
import 'package:bars/widgets/sessbutton.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isMarkRegPressed = false;
  void MarkRegPressed() {
    setState(() {
      if (isMarkRegPressed == false) {
        isMarkRegPressed = true;
      } else if (isMarkRegPressed == true) {
        isMarkRegPressed = false;
      }
    });
  }

  bool isButtonPressed = false;
  void buttonPressed() {
    setState(() {
      if (isButtonPressed == false) {
        isButtonPressed = true;
      } else if (isButtonPressed == true) {
        isButtonPressed = false;
      }
    });

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (Context) => const EnrollPage()));
  }

  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void initState() {
    super.initState();
  }

  List<Widget> get _pages => [
    Center(
      child: Column(
        children: [
          SizedBox(height: 150),
          Sessbutton(onTap: buttonPressed, isButtonPressed: isButtonPressed),
          SizedBox(height: 20),
          MarkReg(onTap: MarkRegPressed, isMarkRegPressed: isMarkRegPressed),
        ],
      ),
    ),

    Center(child: Text("Session", style: TextStyle(fontSize: 50))),

    Center(child: Text("Profile", style: TextStyle(fontSize: 50))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'Actions'),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_rounded),
            label: 'Sessions',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
