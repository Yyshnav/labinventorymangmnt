import 'package:flutter/material.dart';
import 'package:lab/login.dart';

class IpScreen extends StatelessWidget {
  final TextEditingController ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Server IP")),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: ipController,
              // keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: "Server IP",
                hintText: "e.g., 192.168.1.10",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (ipController.text.isNotEmpty) {
                  baseurl = "http://${ipController.text.trim()}";
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a valid IP address")),
                  );
                }
              },
              child: Text("Connect"),
            ),
          ],
        ),
      ),
    );
  }
}
