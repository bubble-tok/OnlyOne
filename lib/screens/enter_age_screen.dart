// lib/screens/enter_age_screen.dart
import 'package:flutter/material.dart';

class EnterAgeScreen extends StatefulWidget {
  final void Function(int) onNext;

  const EnterAgeScreen({super.key, required this.onNext});

  @override
  State<EnterAgeScreen> createState() => _EnterAgeScreenState();
}

class _EnterAgeScreenState extends State<EnterAgeScreen> {
  final TextEditingController _ageController = TextEditingController();

  void _handleNext() {
    final ageText = _ageController.text.trim();
    final age = int.tryParse(ageText);
    if (age != null && age > 0) {
      widget.onNext(age);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('유효한 나이를 입력해주세요.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('나이 입력')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '나이를 입력해주세요',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '예: 25',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleNext,
                child: const Text('다음'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
