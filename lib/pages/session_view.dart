import 'package:flutter/material.dart';

//Class Definition
class SessionViewPage extends StatelessWidget {
  final Map<String, String> session;

  const SessionViewPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    // Mock Attendess
    //Real data will be fetched from firestore
    List<Map<String, String>> attendees = [
      {"id": "1", "name": "Zach"},
      {"id": "2", "name": "Mark"},
      {"id": "3", "name": "Emmez"},
    ];


//UI Structure (Build Method)
    return Scaffold(
      appBar: AppBar(title: const Text("Session Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //Displaying Session Details
          children: [
            Text("Unit Name: ${session["unitName"]}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Unit Code: ${session["unitCode"]}", style: const TextStyle(fontSize: 16)),
            Text("Date & Time: ${session["dateTime"]}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            //Attendees list view
            const Text("Attendees", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: attendees.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(attendees[index]["name"]!),
                    subtitle: Text("ID: ${attendees[index]["id"]}"),
                  );
                },
              ),
            ),

            //Export and Share button
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement export as PDF and share
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text("Export & Share")

            ),
          ],
        ),
      ),
    );
  }
}
