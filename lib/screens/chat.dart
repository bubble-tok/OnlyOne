import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/openai_service.dart';
import '../models/user_profile.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  final List<String> keywords;
  final void Function(UserProfile) onProfileCompleted;

  const ChatScreen({
    super.key,
    required this.keywords,
    required this.onProfileCompleted,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _ctrl = TextEditingController();
  late final OpenAIService _openAi;

  @override
  void initState() {
    super.initState();
    _openAi = OpenAIService();

    final provider = context.read<ChatProvider>();
    final keywordText = widget.keywords.join(', ');

    provider.addSystemMessage('''
      당신은 이상형 매칭 전문가 어시스턴트입니다.
      1) 사용자의 이상형 키워드는 [$keywordText] 입니다. 키워드를 기반으로 대화를 이끌어가세요.
      2) 먼저 사용자 프로필(직업과 성격)을 자연스럽게 물어보세요.
        - 추가로 대화를 하며 정보를 더 얻어도 좋습니다 대화 맥락에 따라 자연스럽게 질문하세요.
      3) 그 다음 이상형 정보(성격, 가치관, 스타일)를 파악하세요.
      4) 모든 정보가 파악되면 아래 형식으로 요약해주세요:

      이름: ㅇㅇㅇ
      나이: 00
      지역: ㅇㅇ
      직업: ㅇㅇ
      성격: ㅇㅇ, ㅇㅇ
      이상형: ㅇㅇ, ㅇㅇ
      추가 의견이 있나요?
      ''');

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _sendInitialBotMessage(),
    );
  }

  Future<void> _sendInitialBotMessage() async {
    final provider = context.read<ChatProvider>();
    final reply = await _openAi.sendMessage(provider.chatHistory);
    provider.addBotMessage(reply);
  }

  Future<void> _onSend(String input) async {
    if (input.trim().isEmpty) return;
    _ctrl.clear();

    final provider = context.read<ChatProvider>();
    provider.addUserMessage(input);

    final reply = await _openAi.sendMessage(provider.chatHistory);
    provider.addBotMessage(reply);

    if (reply.contains('추가 의견') || reply.contains('모든 정보가 정리됐어요')) {
      final profile = _extractProfileFromAIResponse(reply);
      widget.onProfileCompleted(profile);
    }
  }

  UserProfile _extractProfileFromAIResponse(String aiText) {
    String extract(String label) {
      final reg = RegExp('$label[:：]\s*(.+)', caseSensitive: false);
      return reg.firstMatch(aiText)?.group(1)?.trim() ?? '';
    }

    return UserProfile(
      id: 'temp',
      name: extract('이름'),
      age: int.tryParse(extract('나이')) ?? 0,
      location: extract('지역'),
      occupation: extract('직업'),
      personalityTraits: extract('성격').split(',').map((e) => e.trim()).toList(),
      idealTypeTraits: extract('이상형').split(',').map((e) => e.trim()).toList(),
      avatarUrl: 'https://example.com/avatar/default.png',
      message: 'AI가 생성한 프로필입니다.',
    );
  }

  Widget _buildMessage(Map<String, String> message) {
    final isUser = message['sender'] == 'user';
    final timestamp = TimeOfDay.now().format(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isUser)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                  'https://cdn-icons-png.flaticon.com/512/4712/4712109.png',
                ),
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.pink[100] : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: Radius.circular(isUser ? 12 : 0),
                      bottomRight: Radius.circular(isUser ? 0 : 12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message['text']!,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timestamp,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('이상형 찾기'), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 12),
              itemCount: chatProvider.messages.length,
              itemBuilder: (_, i) => _buildMessage(chatProvider.messages[i]),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      maxLines: 1,
                      textInputAction: TextInputAction.send,
                      decoration: const InputDecoration(
                        hintText: '메시지를 입력하세요...',
                      ),
                      onSubmitted: _onSend,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _onSend(_ctrl.text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
