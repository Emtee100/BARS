import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

  // Track fingerprint scanning status
  bool _isScanningFingerprint = false;
  bool _fingerprintScanned = false;
  String _fingerprintStatus = '';

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _nameController.dispose();
    _admissionNumberController.dispose();
    super.dispose();
  }

  // Function to handle fingerprint scanning
  void _scanFingerprint() {
    setState(() {
      _isScanningFingerprint = true;
      _fingerprintStatus = 'Please place your finger on the scanner...';
    });

    // Here you would integrate with your hardware fingerprint scanner
    // This is a simulated response after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isScanningFingerprint = false;
        _fingerprintScanned = true;
        _fingerprintStatus = 'Fingerprint successfully scanned!';
      });
    });
  }

  // Function to handle form submission
  void _submitForm() {
    if (_nameController.text.isEmpty ||
        _admissionNumberController.text.isEmpty) {
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Enrollment successful!')));

    // You might want to navigate back or to another screen
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('B.A.R.S'),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
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
            Container(
              width: 175,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',

                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
              ),
            ),
            const SizedBox(height: 20),

            // Admission number input field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: TextField(
                controller: _admissionNumberController,
                decoration: const InputDecoration(
                  labelText: 'Admission Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(height: 30),

            // Fingerprint section
            Container(
              child: Column(
                children: [
                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: _isScanningFingerprint ? null : _scanFingerprint,
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
                              child: CircularProgressIndicator(strokeWidth: 2),
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
            Container(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 125),
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('SUBMIT', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
