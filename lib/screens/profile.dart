import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onEdit;

  const ProfileScreen({super.key, required this.profile, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 프로필'),
        actions: [
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            icon: const Icon(Icons.logout),
            tooltip: '로그아웃',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoTile('이름', profile.name),
            _infoTile('나이', '${profile.age}'),
            _infoTile('사는 지역', profile.location),
            _infoTile('직업', profile.occupation),
            _infoTile('성격', profile.personalityTraits.join(', ')),
            _infoTile('이상형 키워드', profile.idealTypeTraits.join(', ')),
            _infoTile('메시지', profile.message ?? ''),
            const SizedBox(height: 16),
            if (profile.avatarUrl.isNotEmpty)
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(profile.avatarUrl),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(content)),
        ],
      ),
    );
  }
}
