import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MarkRegisterPage extends StatefulWidget {
  const MarkRegisterPage({Key? key}) : super(key: key);

  @override
  State<MarkRegisterPage> createState() => _MarkRegisterPageState();
}

class _MarkRegisterPageState extends State<MarkRegisterPage> {
  // Track fingerprint scanning status
  bool _isScanningFingerprint = false;
  bool _fingerprintScanned = false;
  String _fingerprintStatus = '';

  // Function to handle fingerprint scanning
  void _scanFingerprint() {
    setState(() {
      _isScanningFingerprint = true;
      _fingerprintStatus = 'Please place your finger on the scanner...';
    });

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
    if (!_fingerprintScanned) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please scan your fingerprint')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Attendance marked successfully!')),
    );
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
              'Place your finger for scanning',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),

            // Fingerprint section
            Column(
              children: [
                ElevatedButton(
                  onPressed: _isScanningFingerprint ? null : _scanFingerprint,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _fingerprintScanned ? Colors.green : Colors.blue,
                    padding: const EdgeInsets.all(15),
                    shape: const CircleBorder(),
                    elevation: 2,
                  ),
                  child: _isScanningFingerprint
                      ? const SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Icon(
                    Icons.fingerprint,
                    size: 60,
                    color: _fingerprintScanned ? Colors.grey : Colors.green,
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
                const SizedBox(height: 30),
              ],
            ),

            // Submit button
            Container(
              padding: EdgeInsets.symmetric(horizontal: 125),
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
