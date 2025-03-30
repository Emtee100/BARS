import 'package:bars/pages/enroll.dart';
import 'package:bars/pages/sessions.dart';
import 'package:bars/widgets/sessbutton.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isMarkRegPressed = false;
  bool isButtonPressed = false;
  int _selectedIndex = 0;

  //Mark register button function
  // void MarkRegPressed() {
  //   setState(() {
  //     isMarkRegPressed = !isMarkRegPressed;
  //   });
  //   Navigator.of(context).push(
  //     MaterialPageRoute(builder: (context) => const MarkRegisterPage(
  //       dateTime: ,
  //       unitCode: ,
  //       unitName: ,
  //     )),
  //   );
  // }
//Enroll button function
  void buttonPressed() {
    setState(() {
      isButtonPressed = !isButtonPressed;
    });
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EnrollPage()),
    );
  }
//Handling navigation between pages
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  // the two buttons Enrol and Mark register
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Center(
        child: Column(
          children: [
            const SizedBox(height: 150),
            Sessbutton(onTap: buttonPressed, isButtonPressed: isButtonPressed),
            const SizedBox(height: 20),
            //MarkReg(onTap: MarkRegPressed, isMarkRegPressed: isMarkRegPressed),
          ],
        ),
      ),
      const SessionsPage(), // Integrated SessionsPage
      const Center(child: Text("Profile", style: TextStyle(fontSize: 50))),
    ];

    //Displays the content of the selected page
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: Colors.deepPurple),
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt), label: 'Actions'),
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
