import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../screens/chat.dart';
import '../screens/match.dart';
import '../screens/chat_with_match.dart';
import '../screens/community.dart';
import '../screens/profile.dart';
import '../screens/editable_profile.dart';
import '../service/match_service.dart';

class MainNavigation extends StatefulWidget {
  final UserProfile initialUserProfile;

  const MainNavigation({super.key, required this.initialUserProfile});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late UserProfile _currentUser;
  List<UserProfile> _matchedProfiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.initialUserProfile;
    _loadMatchedProfiles();
  }

  Future<void> _loadMatchedProfiles() async {
    final allUsers = await MatchService.getAllUsers(_currentUser);
    final sortedMatches = MatchService.sortByMatchScore(_currentUser, allUsers);
    setState(() {
      _matchedProfiles = sortedMatches;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<Widget> tabs = [
      ChatScreen(
        keywords: _currentUser.idealTypeTraits,
        onProfileCompleted: (profile) {
          setState(() {
            _currentUser = profile;
            _loadMatchedProfiles(); // 다시 매칭 불러오기
          });
        },
      ),
      MatchScreen(currentUser: _currentUser), // 내부에서 매칭 데이터 불러옴
      const ChatWithMatchScreen(),
      const CommunityScreen(),
      ProfileScreen(
        profile: _currentUser,
        onEdit: () async {
          final updated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  EditableProfileScreen(initialProfile: _currentUser),
            ),
          );
          if (updated != null && updated is UserProfile) {
            setState(() {
              _currentUser = updated;
              _loadMatchedProfiles(); // 다시 매칭 불러오기
            });
          }
        },
      ),
    ];

    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.psychology), label: 'AI 채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '매칭'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: '상대와 채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: '커뮤니티'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        ],
      ),
    );
  }
}
