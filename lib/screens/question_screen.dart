import 'package:flutter/material.dart';
import 'chat.dart'; // ChatScreen import

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final List<String> _allKeywords = [
    '유머러스한',
    '책임감 있는',
    '차분한',
    '창의적인',
    '낙천적인',
    '감성적인',
    '지적인',
    '외향적인',
    '내향적인',
  ];

  final Set<String> _selectedKeywords = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('이상형 키워드 선택')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '당신의 이상형을 나타내는 키워드를 3개 이상 선택해주세요.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _allKeywords.map((keyword) {
                final isSelected = _selectedKeywords.contains(keyword);
                return ChoiceChip(
                  label: Text(keyword),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      if (isSelected) {
                        _selectedKeywords.remove(keyword);
                      } else {
                        _selectedKeywords.add(keyword);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _selectedKeywords.length >= 3
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            keywords: _selectedKeywords.toList(),
                            onProfileCompleted: (userProfile) {
                              print("완성된 프로필: ${userProfile.name}");
                            },
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text('완료'),
            ),
          ],
        ),
      ),
    );
  }
}
