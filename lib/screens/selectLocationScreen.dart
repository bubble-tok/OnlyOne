import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SelectLocationScreen extends StatefulWidget {
  final void Function(String location) onNext;

  const SelectLocationScreen({super.key, required this.onNext});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  String? _location;
  bool _isLoading = false;

  Future<void> _getLocation() async {
    setState(() => _isLoading = true);

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      setState(() {
        _location = '위치 권한이 거부되었습니다';
        _isLoading = false;
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _location =
            '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _location = '위치 정보를 불러오는 데 실패했습니다';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('지역 설정')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('현재 위치를 자동으로 불러오는 중...', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (!_isLoading && _location != null) ...[
              Text(
                _location!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => widget.onNext(_location!),
                child: const Text('다음'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
