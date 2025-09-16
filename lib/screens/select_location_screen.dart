import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/user_profile.dart';
import 'chat.dart';
import 'main_navigation.dart';

class SelectLocationScreen extends StatefulWidget {
  final UserProfile initialProfile;

  const SelectLocationScreen({super.key, required this.initialProfile});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  String? _location;
  bool _loading = false;

  Future<void> _getLocation() async {
    setState(() => _loading = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _loading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _loading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _loading = false);
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    final locationString = '위도 ${position.latitude}, 경도 ${position.longitude}';
    final completedProfile = widget.initialProfile.copyWith(
      location: locationString,
    );

    setState(() {
      _location = locationString;
      _loading = false;
    });

    // ✅ AI ChatScreen으로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          keywords: completedProfile.idealTypeTraits,
          onProfileCompleted: (finalizedProfile) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    MainNavigation(initialUserProfile: finalizedProfile),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('사는 지역 설정')),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_location != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('위치: $_location'),
                    ),
                  ElevatedButton(
                    onPressed: _getLocation,
                    child: const Text('위치 권한 허용 후 위치 설정'),
                  ),
                ],
              ),
      ),
    );
  }
}
