import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class EditableProfileScreen extends StatefulWidget {
  final UserProfile? initialProfile;

  const EditableProfileScreen({super.key, this.initialProfile});

  @override
  State<EditableProfileScreen> createState() => _EditableProfileScreenState();
}

class _EditableProfileScreenState extends State<EditableProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _occupationCtrl = TextEditingController();
  final _personalityCtrl = TextEditingController();
  final _idealTypeCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final p = widget.initialProfile;
    if (p != null) {
      _nameCtrl.text = p.name;
      _ageCtrl.text = p.age.toString();
      _locationCtrl.text = p.location;
      _occupationCtrl.text = p.occupation;
      _personalityCtrl.text = p.personalityTraits.join(', ');
      _idealTypeCtrl.text = p.idealTypeTraits.join(', ');
      _messageCtrl.text = p.message ?? '';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _locationCtrl.dispose();
    _occupationCtrl.dispose();
    _personalityCtrl.dispose();
    _idealTypeCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    final profile = UserProfile(
      id: widget.initialProfile?.id ?? 'temp',
      name: _nameCtrl.text.trim(),
      age: int.tryParse(_ageCtrl.text.trim()) ?? 0,
      location: _locationCtrl.text.trim(),
      occupation: _occupationCtrl.text.trim(),
      personalityTraits: _personalityCtrl.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      idealTypeTraits: _idealTypeCtrl.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      avatarUrl: 'https://example.com/avatar/default.png',
      message: _messageCtrl.text.trim(),
    );

    Navigator.pop(context, profile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필 수정')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('이름', _nameCtrl),
              _buildTextField('나이', _ageCtrl, isNumber: true),
              _buildTextField('지역', _locationCtrl),
              _buildTextField('직업', _occupationCtrl),
              _buildTextField('성격 (쉼표로 구분)', _personalityCtrl),
              _buildTextField('이상형 키워드 (쉼표로 구분)', _idealTypeCtrl),
              _buildTextField('소개 메시지', _messageCtrl),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveProfile, child: const Text('저장')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController ctrl, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.trim().isEmpty ? '필수 항목입니다.' : null,
      ),
    );
  }
}
