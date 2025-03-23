import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bars/pages/session_view.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  final List<Map<String, String>> sessions = [];

  final TextEditingController unitNameController = TextEditingController();
  final TextEditingController unitCodeController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();

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

        String formattedDateTime =
        DateFormat('yyyy/MM/dd h:mm a').format(selectedDateTime);


        setState(() {
          dateTimeController.text = formattedDateTime;
        });
      }
    }
  }

  void _addSession() {
    if (unitNameController.text.isNotEmpty &&
        unitCodeController.text.isNotEmpty &&
        dateTimeController.text.isNotEmpty) {
      setState(() {
        sessions.add({
          "unitName": unitNameController.text,
          "unitCode": unitCodeController.text,
          "dateTime": dateTimeController.text,
        });
      });

      // Clear input fields after adding session
      unitNameController.clear();
      unitCodeController.clear();
      dateTimeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sessions")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Create Session",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
                controller: unitNameController,
                decoration: const InputDecoration(labelText: "Unit Name")),
            TextField(
                controller: unitCodeController,
                decoration: const InputDecoration(labelText: "Unit Code")),
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
              child: ElevatedButton(
                onPressed: _addSession,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white),
                child: const Text("Create Session"),
              ),
            ),
            const SizedBox(height: 20),
            const Text("View Sessions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            sessions.isEmpty
                ? const Text("No sessions available.")
                : DropdownButton<Map<String, String>>(
              hint: const Text("Select a session"),
              items: sessions.map((session) {
                return DropdownMenuItem<Map<String, String>>(
                  value: session,
                  child: Text(
                      "${session["unitName"]} - ${session["dateTime"]}"),
                );
              }).toList(),
              onChanged: (selectedSession) {
                if (selectedSession != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
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
