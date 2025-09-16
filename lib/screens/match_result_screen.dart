import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class MatchResultScreen extends StatelessWidget {
  final UserProfile match;

  const MatchResultScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 매칭 결과')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (match.avatarUrl.isNotEmpty)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(match.avatarUrl),
              ),
            const SizedBox(height: 16),
            Text(match.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('${match.age}세 · ${match.occupation}'),
            Text(match.location),
            const SizedBox(height: 16),
            if (match.message?.isNotEmpty == true)
              Text('"${match.message}"', style: const TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
            Text('성격: ${match.personalityTraits.join(', ')}'),
            Text('이상형: ${match.idealTypeTraits.join(', ')}'),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context); // 다시 질문부터 시작 가능
              },
              icon: const Icon(Icons.refresh),
              label: const Text('다시 매칭받기'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            )
          ],
        ),
      ),
    );
  }
}
