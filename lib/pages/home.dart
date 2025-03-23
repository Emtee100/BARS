import 'package:bars/pages/enroll.dart';
import 'package:bars/pages/mark_register.dart';
import 'package:bars/pages/sessions.dart';
import 'package:bars/widgets/sessbutton.dart';
import 'package:bars/widgets/markregbutton.dart';
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

  void MarkRegPressed() {
    setState(() {
      isMarkRegPressed = !isMarkRegPressed;
    });
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const MarkRegisterPage()),
    );
  }

  void buttonPressed() {
    setState(() {
      isButtonPressed = !isButtonPressed;
    });
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EnrollPage()),
    );
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Center(
        child: Column(
          children: [
            const SizedBox(height: 150),
            Sessbutton(onTap: buttonPressed, isButtonPressed: isButtonPressed),
            const SizedBox(height: 20),
            MarkReg(onTap: MarkRegPressed, isMarkRegPressed: isMarkRegPressed),
          ],
        ),
      ),
      const SessionsPage(), // Integrated SessionsPage
      const Center(child: Text("Profile", style: TextStyle(fontSize: 50))),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bolt), label: 'Actions'),
          BottomNavigationBarItem(icon: Icon(Icons.class_rounded), label: 'Sessions'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
