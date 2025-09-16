import 'package:flutter/material.dart';

class SelectIdealTypeScreen extends StatefulWidget {
  final void Function(List<String>) onNext;

  const SelectIdealTypeScreen({super.key, required this.onNext});

  @override
  State<SelectIdealTypeScreen> createState() => _SelectIdealTypeScreenState();
}

class _SelectIdealTypeScreenState extends State<SelectIdealTypeScreen> {
  final List<String> allKeywords = [
    '유머러스한',
    '배려심 있는',
    '책임감 있는',
    '감성적인',
    '리더십 있는',
    '활발한',
    '지적인',
    '창의적인',
    '신앙심 있는',
    '자신감 있는',
    '조용한',
    '애정표현 많은',
  ];

  final Set<String> selectedKeywords = {};

  void _toggleKeyword(String keyword) {
    setState(() {
      if (selectedKeywords.contains(keyword)) {
        selectedKeywords.remove(keyword);
      } else {
        selectedKeywords.add(keyword);
      }
    });
  }

  void _onNextPressed() {
    if (selectedKeywords.isNotEmpty) {
      widget.onNext(selectedKeywords.toList());
    }
  }

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
              '당신이 원하는 이상형의 키워드를 선택하세요.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allKeywords.map((keyword) {
                final isSelected = selectedKeywords.contains(keyword);
                return ChoiceChip(
                  label: Text(keyword),
                  selected: isSelected,
                  onSelected: (_) => _toggleKeyword(keyword),
                  selectedColor: Colors.purple[200],
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onNextPressed,
                child: const Text('다음'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
