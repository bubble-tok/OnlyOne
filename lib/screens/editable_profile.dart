import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class EditableProfileScreen extends StatefulWidget {
  final UserProfile initialProfile;

  const EditableProfileScreen({super.key, required this.initialProfile});

  @override
  State<EditableProfileScreen> createState() => _EditableProfileScreenState();
}

class _EditableProfileScreenState extends State<EditableProfileScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController ageCtrl;
  late TextEditingController locationCtrl;
  late TextEditingController occupationCtrl;
  late TextEditingController traitsCtrl;
  late TextEditingController idealsCtrl;
  late TextEditingController avatarCtrl;
  late TextEditingController messageCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.initialProfile.name);
    ageCtrl = TextEditingController(text: widget.initialProfile.age.toString());
    locationCtrl = TextEditingController(text: widget.initialProfile.location);
    occupationCtrl = TextEditingController(text: widget.initialProfile.occupation);
    traitsCtrl = TextEditingController(text: widget.initialProfile.personalityTraits.join(', '));
    idealsCtrl = TextEditingController(text: widget.initialProfile.idealTypeTraits.join(', '));
    avatarCtrl = TextEditingController(text: widget.initialProfile.avatarUrl);
    messageCtrl = TextEditingController(text: widget.initialProfile.message ?? '');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    locationCtrl.dispose();
    occupationCtrl.dispose();
    traitsCtrl.dispose();
    idealsCtrl.dispose();
    avatarCtrl.dispose();
    messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필 수정')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildField('이름', nameCtrl),
            _buildField('나이', ageCtrl, keyboardType: TextInputType.number),
            _buildField('사는 지역', locationCtrl),
            _buildField('직업', occupationCtrl),
            _buildField('성격 (쉼표로 구분)', traitsCtrl),
            _buildField('이상형 키워드 (쉼표로 구분)', idealsCtrl),
            _buildField('프로필 이미지 URL', avatarCtrl),
            _buildField('한 줄 메시지', messageCtrl, maxLines: 2),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newProfile = UserProfile(
                  id: widget.initialProfile.id,
                  name: nameCtrl.text,
                  age: int.tryParse(ageCtrl.text) ?? 0,
                  location: locationCtrl.text,
                  occupation: occupationCtrl.text,
                  personalityTraits: traitsCtrl.text.split(',').map((e) => e.trim()).toList(),
                  idealTypeTraits: idealsCtrl.text.split(',').map((e) => e.trim()).toList(),
                  avatarUrl: avatarCtrl.text,
                  message: messageCtrl.text,
                );

                Navigator.pop(context, newProfile);
              },
              child: const Text('저장'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, {TextInputType? keyboardType, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
