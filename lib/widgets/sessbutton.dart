import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Sessbutton extends StatelessWidget {
  final onTap;
  bool isButtonPressed;

  Sessbutton({this.onTap, required this.isButtonPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 75),
        height: 80,
        width: 200,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(15),
          boxShadow:
              isButtonPressed
                  ? []
                  : [
                    BoxShadow(
                      color: Colors.grey.shade500,
                      offset: Offset(6, 6),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 30),
              child: Text("Enroll", style: TextStyle(fontSize: 20)),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30),
              child: Icon(
                Icons.book,
                size: 40,
                color: isButtonPressed ? Colors.green : Colors.greenAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
