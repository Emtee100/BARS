import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
import 'package:rive/rive.dart';

//Mark Register widget
class MarkRegisterPage extends StatefulWidget {
  const MarkRegisterPage({
    Key? key,
    required this.unitCode,
    required this.dateTime,
    required this.unitName,
  }) : super(key: key);

  final String unitName;
  final String unitCode;
  final String dateTime;

  @override
  State<MarkRegisterPage> createState() => _MarkRegisterPageState();
}

// State management
class _MarkRegisterPageState extends State<MarkRegisterPage> {
  late IOWebSocketChannel channel;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
   late RiveAnimation anim;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createDoc(); // Create Firestore document
    _connectWebSocket(); // Connect WebSocket immediately
    _sendRecognizeCommand(); // Send recognize command


    anim = RiveAnimation.asset(
      "assets/fingerprint.riv",
      artboard: "fingerprint-loop",
      fit: BoxFit.cover,
      //controllers: [stateMachineController],
    );
  }

  Future<void> _sendRecognizeCommand() async {
    final url = Uri.parse('http://192.168.39.227/data');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: 'command=${Uri.encodeComponent("recognize")}',
      );
      if (response.statusCode != 200) {
        if (mounted) {
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text(
                'Failed to send command. Status code: ${response.statusCode}',
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('HTTP request error: $e');
      if (mounted) {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('HTTP request error: $e')),
        );
      }
    }
  }

  void _connectWebSocket() {
    try {
      channel = IOWebSocketChannel.connect('ws://192.168.39.227:90');
      _setupWebSocketListener();
    } catch (e) {
      print('WebSocket connection error: $e');
      if (mounted) {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(content: Text('WebSocket connection error: $e')),
        );
      }
    }
  }

  final docRef = FirebaseFirestore.instance.collection("sessions").doc();

  void _createDoc() {
    docRef
        .set({
          "Code": widget.unitCode,
          "Unit": widget.unitName,
          "Date": widget.dateTime,
          "fids": [], // Initialize empty array for fingerprints
        })
        .then((_) {
          print('Document created successfully');
        })
        .catchError((error) {
          print('Firestore error: $error');
          if (mounted) {
            _scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBar(content: Text('Firestore error: $error')),
            );
          }
        });
  }

  void _setupWebSocketListener() {
    print("Setting up socket");
    channel.stream.listen(
      (message) {
        print('Received WebSocket message: $message');

        int receivedId = int.parse(message);
        print(receivedId);
        docRef.update({
              "fids": FieldValue.arrayUnion([receivedId]), // Append ID to Firestore array
            })
            .then((_) {
              print('Added $receivedId to Firestore');
             
            })
            .catchError((error) {
              print('Firestore error: $error');
              if (mounted) {
                _scaffoldMessengerKey.currentState?.showSnackBar(
                  SnackBar(content: Text('Firestore error: $error')),
                );
              }
            });

        
      },
      onError: (error) {
        print('WebSocket error: $error');
        if (mounted) {
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(content: Text('WebSocket error: $error')),
          );
        }
      },
      onDone: () {
        print('WebSocket connection closed');
        if (mounted) {
          _scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(content: Text('WebSocket connection closed')),
          );
        }
      },
      cancelOnError: true,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    channel.sink.close();
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        title: const Text('B.A.R.S'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Center(
        child: Column(
          children: [
           ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200, maxHeight: 200),
            child: anim,
          ),
            Text("Enroll students fingerprints to capture their attendance"),
          ],
        )
      ),

      // Column(
      //   children: [
      //     Center(

      //     )
      //   ],
      // )
    );
  }
}
