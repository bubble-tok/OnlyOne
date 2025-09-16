// lib/screens/select_avatar_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectAvatarScreen extends StatefulWidget {
  final void Function(File imageFile) onNext;

  const SelectAvatarScreen({super.key, required this.onNext});

  @override
  State<SelectAvatarScreen> createState() => _SelectAvatarScreenState();
}

class _SelectAvatarScreenState extends State<SelectAvatarScreen> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필 사진 설정')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _imageFile != null
                ? CircleAvatar(
                    radius: 80,
                    backgroundImage: FileImage(_imageFile!),
                  )
                : const CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 60),
                  ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('사진 선택'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _imageFile != null
                  ? () => widget.onNext(_imageFile!)
                  : null,
              child: const Text('다음'),
            ),
          ],
        ),
      ),
    );
  }
}
