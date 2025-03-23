import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class EnrollPage extends StatefulWidget {
  const EnrollPage({Key? key}) : super(key: key);

  @override
  State<EnrollPage> createState() => _EnrollPageState();
}

class _EnrollPageState extends State<EnrollPage> {
  // Text controllers for the input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _admissionNumberController =
      TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();

  // Track fingerprint scanning status
  bool _isScanningFingerprint = false;
  bool _fingerprintScanned = false;
  String _fingerprintStatus = '';

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _nameController.dispose();
    _admissionNumberController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  // Function to handle fingerprint scanning
  void _scanFingerprint() {
    // setState(() {
    //   _isScanningFingerprint = true;
    //   _fingerprintStatus = 'Please place your finger on the scanner...';
    // });

    enrollFingerprint(int.parse(_idNumberController.text.trim()));

    // Here you would integrate with your hardware fingerprint scanner
    // This is a simulated response after 3 seconds
    // Future.delayed(const Duration(seconds: 3), () {
    //   setState(() {
    //     _isScanningFingerprint = false;
    //     _fingerprintScanned = true;
    //     _fingerprintStatus = 'Fingerprint successfully scanned!';
    //   });
    // });
  }

  Future<void> enrollFingerprint(int id) async {
    // trigger the onboarding animation

    setState(() {
      _isScanningFingerprint = true;
      _fingerprintStatus = 'Please place your finger on the scanner...';
    });

    final url = Uri.parse('http://192.168.88.115/data');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        }, // Correct header
        body:
            'command=${Uri.encodeComponent("enroll")}&id=${Uri.encodeComponent(id.toString())}', // URL-encoded body
      );
      if (response.statusCode == 200) {
        print('ESP32 Response: ${response.body}');
        // FirebaseFirestore.instance.collection("students").add({
        //   "AdmNo": _admNoController.text.trim(),
        //   "fullName": _nameController.text.trim(),
        //   "fid": int.parse(response.body),
        // });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Enrolled fingerprint ${response.body}'),
        //     margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        //   ),
        // );
        // _admNoController.clear();
        // _nameController.clear();
        // _idController.clear();

        // stop the onboarding animation
        setState(() {
          _isScanningFingerprint = false;
          _fingerprintScanned = true;
          _fingerprintStatus = 'Fingerprint successfully scanned!';
        });
      } else {
        print(
          'Failed to send data. Status code: ${response.statusCode}, ${response.body}',
        );
      }
    } catch (e) {
      print('Error sending data: $e');
    }
  }

  // Function to handle form submission
  void _submitForm() {
    if (_nameController.text.isEmpty ||
        _admissionNumberController.text.isEmpty ||
        _idNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (!_fingerprintScanned) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please scan your fingerprint')),
      );
      return;
    }

    // Here you would handle the enrollment data
    // For example, sending it to a database

    FirebaseFirestore.instance.collection("students").add({
      "AdmNo": _admissionNumberController.text.trim(),
      "fullName": _nameController.text.trim(),
      "fid": _idNumberController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        content: Text('Enrollment successful!'),
      ),
    );

    // You might want to navigate back or to another screen
    // Navigator.of(context).pop();
  }

  // Future<void> recognize() async {
  //   // create an empty lisd to hold fingerprint IDs for present students
  //   List<int> fids = [];

  //   // pop the bottom sheet
  //   Navigator.pop(context);

  //   // go to the recognize page
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => RecognizePage()),
  //   );

  //   // send recognize command to the ESP32
  //   final url = Uri.parse('http://192.168.88.120/data');
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //       }, // Correct header
  //       body:
  //           'command=${Uri.encodeComponent("recognize")}}', // URL-encoded body
  //     );

  //     if (response.statusCode == 200) {
  //       print('ESP32 Response: ${response.body}');
  //       fids.add(int.parse(response.body));
  //       FirebaseFirestore.instance.collection("sessions").add({
  //         "unit": _unitController.text.trim(),
  //         "code": _codeController.text.trim(),
  //         "time": Timestamp.now(),
  //         "fids": fids,
  //       });

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Enrolled fingerprint ${response.body}'),
  //           margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error sending data: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('B.A.R.S'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Student Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Name input field
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',

                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
              ),

              const SizedBox(height: 20),

              // Admission number input field
              TextField(
                controller: _admissionNumberController,
                decoration: const InputDecoration(
                  labelText: 'Admission Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.text,
              ),

              const SizedBox(height: 30),

              TextField(
                controller: _idNumberController,
                decoration: const InputDecoration(
                  labelText: 'Finger ID',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
              ),

              // Fingerprint section
              Container(
                child: Column(
                  children: [
                    const SizedBox(height: 15),

                    ElevatedButton(
                      onPressed:
                          _isScanningFingerprint ? null : _scanFingerprint,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor:
                            _fingerprintScanned ? Colors.green : Colors.blue,
                        padding: const EdgeInsets.all(15),
                        shape: const CircleBorder(),
                        elevation: 2,
                      ),
                      child:
                          _isScanningFingerprint
                              ? const SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : Icon(
                                Icons.fingerprint,
                                size: 60,
                                color:
                                    _fingerprintScanned
                                        ? Colors.grey
                                        : Colors.green,
                              ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _fingerprintStatus.isEmpty
                          ? 'Tap to scan your fingerprint'
                          : _fingerprintStatus,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _fingerprintScanned ? Colors.green : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Submit', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
