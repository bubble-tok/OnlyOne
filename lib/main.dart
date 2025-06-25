import 'package:flutter/material.dart';
import 'screens/chat.dart';

void main() => runApp(const OnlyOneApp());

class OnlyOneApp extends StatelessWidget {
  const OnlyOneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OnlyOne',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const ChatScreen(), // 반드시 const ChatScreen()
    );
  }
}
