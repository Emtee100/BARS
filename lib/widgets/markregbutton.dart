import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarkReg extends StatelessWidget {
  final onTap;
  bool isMarkRegPressed;

  MarkReg({this.onTap, required this.isMarkRegPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 75),
        height: 80,
        width: 200,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text("Mark Register", style: TextStyle(fontSize: 20)),
            ),
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: Icon(
                CupertinoIcons.pencil,
                size: 58,
                color: isMarkRegPressed ? Colors.green : Colors.greenAccent,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(15),
          boxShadow:
              isMarkRegPressed
                  ? []
                  :
                  //Show no shadow if button is pressed 👆, Otherwise it'll show shadow as coded below 👇
                  [
                    BoxShadow(
                      color: Colors.grey.shade500,
                      offset: Offset(6, 6),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
        ),
      ),
    );
  }
}
