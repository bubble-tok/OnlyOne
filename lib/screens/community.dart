import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('커뮤니티')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          PostCard(author: '민지', content: '좋은 사람을 만나서 기뻐요! 😊'),
          PostCard(author: '지훈', content: '다들 어떤 이상형을 좋아하시나요?'),
          PostCard(author: '수연', content: '처음이라 어색하지만 재밌네요!'),
        ],
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String author;
  final String content;

  const PostCard({super.key, required this.author, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              author,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }
}
