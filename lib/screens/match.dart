import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class MatchScreen extends StatefulWidget {
  final UserProfile currentUser;

  const MatchScreen({super.key, required this.currentUser});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  late Future<List<UserProfile>> _matchedProfilesFuture;

  @override
  void initState() {
    super.initState();
    _matchedProfilesFuture = fetchMatchedProfiles();
  }

  Future<List<UserProfile>> fetchMatchedProfiles() async {
    await Future.delayed(const Duration(seconds: 2)); // 👈 시뮬레이션용 지연
    // TODO: 여기를 Firestore에서 유저들 불러오도록 교체
    return [
      UserProfile(
        id: 'user2',
        name: '민수',
        age: 28,
        location: '부산',
        occupation: '디자이너',
        personalityTraits: ['감성적', '사교적'],
        idealTypeTraits: ['유머러스한', '이해심 많은'],
        avatarUrl: '',
        message: '안녕하세요!',
      ),
      UserProfile(
        id: 'user3',
        name: '지연',
        age: 27,
        location: '대구',
        occupation: '마케터',
        personalityTraits: ['논리적', '차분한'],
        idealTypeTraits: ['책임감 있는', '밝은 성격'],
        avatarUrl: '',
        message: '반가워요!',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('매칭된 사용자')),
      body: FutureBuilder<List<UserProfile>>(
        future: _matchedProfilesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('매칭 정보를 불러오는 데 실패했습니다.'));
          }

          final profiles = snapshot.data!;
          return ListView.builder(
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final user = profiles[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.avatarUrl.isNotEmpty
                      ? NetworkImage(user.avatarUrl)
                      : null,
                  child: user.avatarUrl.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(user.name),
                subtitle: Text(user.message ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}
