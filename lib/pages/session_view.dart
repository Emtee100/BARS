import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Class Definition
class SessionViewPage extends StatefulWidget {
  final Map<String, dynamic> session;

  const SessionViewPage({super.key, required this.session});

  @override
  State<SessionViewPage> createState() => _SessionViewPageState();
}

class _SessionViewPageState extends State<SessionViewPage> {
  final db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> returnStudents() async {
  final List<Map<String, dynamic>> presentStudents = [];

  final List<int> fids = List<int>.from(widget.session["fids"] ?? []);

  List<Future<void>> futures = fids.map((fid) async {
    print(fids);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("students")
        .where("fid", isEqualTo: fid)
        .get();

    for (var doc in snapshot.docs) {
      presentStudents.add(doc.data() as Map<String, dynamic>);
      print(presentStudents);
    }
  }).toList();

  await Future.wait(futures); // Wait for all queries to complete
  return presentStudents; // Return collected students
}



  @override
  Widget build(BuildContext context) {
    // Mock Attendess
    //Real data will be fetched from firestore
   

    //UI Structure (Build Method)
    return Scaffold(
      appBar: AppBar(title: const Text("Session Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //Displaying Session Details
          children: [
            Text(
              "Unit Name: ${widget.session["Unit"]}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Unit Code: ${widget.session["Code"]}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Date & Time: ${widget.session["Date"]}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            //Attendees list view
            const Text(
              "Attendees",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FutureBuilder(
                future: returnStudents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text("Error");
                  } else {
                    final data = snapshot.data;
                    return Center(
                      child: ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(data[index]["fullName"]!),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Admission Number: ${data[index]["AdmNo"]}"),
                                Text("ID: ${data[index]["fid"]}"),
                              ],
                            )
                          );
                        },
                      ),
                    );
                  }
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
              child: const Text("Export & Share"),
            ),
          ],
        ),
      ),
    );
  }
}
