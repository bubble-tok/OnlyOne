import 'package:flutter/material.dart';

class SelectGenderScreen extends StatefulWidget {
  final int age;
  final Function(String gender) onNext;

  const SelectGenderScreen({
    super.key,
    required this.age,
    required this.onNext,
  });

  @override
  State<SelectGenderScreen> createState() => _SelectGenderScreenState();
}

class _SelectGenderScreenState extends State<SelectGenderScreen> {
  String? _selectedGender;

  void _onNextPressed() {
    if (_selectedGender != null) {
      widget.onNext(_selectedGender!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final genderOptions = ['남성', '여성', '말하고 싶지 않음'];

    return Scaffold(
      appBar: AppBar(title: const Text('성별 선택')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '성별을 선택해주세요.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...genderOptions.map(
              (gender) => RadioListTile<String>(
                title: Text(gender),
                value: gender,
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedGender != null ? _onNextPressed : null,
                child: const Text('다음'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
