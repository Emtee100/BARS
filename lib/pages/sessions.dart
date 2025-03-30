import 'package:bars/pages/mark_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bars/pages/session_view.dart';

// Seesion definition as a stateful widget
class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

//Class Definition
class _SessionsPageState extends State<SessionsPage> {
  List<Map<String, dynamic>> sessions = [];

  //State Variables (Text-Editing controllers for capturing user's data )
  final TextEditingController unitNameController = TextEditingController();
  final TextEditingController unitCodeController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();

  //Date-Time picker library
  Future<void> _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // DateTime format
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        String formattedDateTime = DateFormat(
          'yyyy/MM/dd h:mm a',
        ).format(selectedDateTime);

        setState(() {
          dateTimeController.text = formattedDateTime;
        });
      }
    }
  }

  //Adding session function
  void _addSession() async {
    if (unitNameController.text.isNotEmpty &&
        unitCodeController.text.isNotEmpty &&
        dateTimeController.text.isNotEmpty) {
      String date = dateTimeController.text;
      String unitCode = unitCodeController.text;
      String unitName = unitNameController.text;

      print(dateTimeController.text);
      print(unitCodeController.text);
      print(unitNameController.text);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => MarkRegisterPage(
                dateTime: date,
                unitCode: unitCode,
                unitName: unitName,
              ),
        ),
      );

      // Clear input fields after adding session
      unitNameController.clear();
      unitCodeController.clear();
      dateTimeController.clear();
    }
  }

  void _getSessions() {
    FirebaseFirestore.instance.collection("sessions").get().then((
      QuerySnapshot snapshot,
    ) {
      List<Map<String, dynamic>> loadedSessions =
          snapshot.docs.map((doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList();
      setState(() {
        sessions = loadedSessions;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSessions();
  }

  //Building the page structure (UI)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sessions")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create Session",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            //Input fields for creating a session
            TextField(
              controller: unitNameController,
              decoration: const InputDecoration(labelText: "Unit Name"),
            ),
            TextField(
              controller: unitCodeController,
              decoration: const InputDecoration(labelText: "Unit Code"),
            ),
            TextField(
              controller: dateTimeController,
              decoration: const InputDecoration(
                labelText: "Date & Time",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true, // Prevents manual input
              onTap: _pickDateTime, // Calls the function to pick date & time
            ),
            const SizedBox(height: 10),
            Center(
              //Button for creating a session
              child: ElevatedButton(
                onPressed: _addSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Create Session"),
              ),
            ),

            //Displaying sessions on a drop down
            const SizedBox(height: 20),
            const Text(
              "View Sessions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            sessions.isEmpty
                ? const Text("No sessions available.")
                : DropdownButton(
                  hint: const Text("Select a session"),
                  items:
                      sessions.map((session) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: session,
                          child: Text(
                            "${session["Unit"]} - ${session["Date"]}",
                          ),
                        );
                      }).toList(),
                  onChanged: (selectedSession) {
                    if (selectedSession != null) {
                      //Navigate to session view page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  SessionViewPage(session: selectedSession),
                        ),
                      );
                    }
                  },
                ),
          ],
        ),
      ),
    );
  }
}
