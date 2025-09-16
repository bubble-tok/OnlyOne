// match_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class MatchService {
  // Firestore에서 모든 사용자 불러오기 (본인 제외)
  static Future<List<UserProfile>> getAllUsers(UserProfile currentUser) async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    return snapshot.docs.where((doc) => doc.id != currentUser.id).map((doc) {
      final data = doc.data();
      return UserProfile(
        id: doc.id,
        name: data['name'] ?? '',
        age: data['age'] ?? 0,
        location: data['location'] ?? '',
        occupation: data['occupation'] ?? '',
        personalityTraits: List<String>.from(data['personalityTraits'] ?? []),
        idealTypeTraits: List<String>.from(data['idealTypeTraits'] ?? []),
        avatarUrl: data['avatarUrl'] ?? '',
        message: data['message'] ?? '',
      );
    }).toList();
  }

  // 매칭 점수를 계산하는 함수
  static double calculateMatchScore(UserProfile user, UserProfile otherUser) {
    final traits1 = user.idealTypeTraits;
    final traits2 = otherUser.personalityTraits;

    if (traits1.isEmpty || traits2.isEmpty) return 0.0;

    final common = traits1.where((t) => traits2.contains(t)).length;
    return common / traits1.length;
  }

  // 이상형과 일치하는 상대 리스트 정렬 반환
  static List<UserProfile> sortByMatchScore(
    UserProfile user,
    List<UserProfile> allUsers,
  ) {
    final others = allUsers.where((u) => u.id != user.id).toList();

    others.sort((a, b) {
      final scoreA = calculateMatchScore(user, a);
      final scoreB = calculateMatchScore(user, b);
      return scoreB.compareTo(scoreA); // 점수 높은 순
    });

    return others;
  }

  // 모든 정보를 입력했는지 확인하는 간단한 기준
  static bool isMatchingComplete(List<Map<String, String>> messages) {
    final summaryKeys = ['이름', '나이', '지역', '직업', '성격', '이상형'];
    return messages.any((m) {
      final content = m['text'] ?? '';
      return summaryKeys.every((key) => content.contains(key));
    });
  }
}
