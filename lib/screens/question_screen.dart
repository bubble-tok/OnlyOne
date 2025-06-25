import 'package:flutter/material.dart';

class QuestionScreen extends StatelessWidget {
  final String question = "Do you enjoy outdoor activities?";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Personality Test")),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              question,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // TODO: handle answer
              },
              child: Text("Yes"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: handle answer
              },
              child: Text("No"),
            ),
          ],
        ),
      ),
    );
  }
}
