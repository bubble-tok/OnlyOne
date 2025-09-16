import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('관리자 대시보드')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '안녕하세요, 관리자님 👋',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('여기서 사용자 활동을 관리하고, 신고 내역을 확인할 수 있습니다.'),
            // 향후 관리자 기능 버튼들 추가 예정
          ],
        ),
      ),
    );
  }
}
