import 'package:flutter/material.dart';
import 'question_screen.dart'; // ✅ 질문 화면 import

class AIChatScreen extends StatelessWidget {
  const AIChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const QuestionScreen(); // ✅ 질문 흐름 시작
  }
}
