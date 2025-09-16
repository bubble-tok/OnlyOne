// lib/screens/profile_setup_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import 'chat.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedGender = '남성';

  void _submitProfile() {
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim()) ?? 0;
    final location = _locationController.text.trim();
    final gender = _selectedGender;
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (name.isEmpty || age == 0 || location.isEmpty) return;

    final userProfile = UserProfile(
      id: uid,
      name: name,
      age: age,
      location: location,
      occupation: '',
      personalityTraits: [],
      idealTypeTraits: [],
      avatarUrl: '',
      message: '',
      gender: gender,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          keywords: const [],
          onProfileCompleted: (completedProfile) {
            // Optionally handle after AI matching
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필 설정')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '이름'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: '나이'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: const [
                DropdownMenuItem(value: '남성', child: Text('남성')),
                DropdownMenuItem(value: '여성', child: Text('여성')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _selectedGender = value);
              },
              decoration: const InputDecoration(labelText: '성별'),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: '사는 지역'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submitProfile, child: const Text('다음')),
          ],
        ),
      ),
    );
  }
}
