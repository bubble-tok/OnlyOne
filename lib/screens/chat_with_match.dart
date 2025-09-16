import 'package:flutter/material.dart';
import '../service/openai_service.dart';
import '../service/match_service.dart';
import 'editable_profile_screen.dart';

class ChatWithMatchScreen extends StatefulWidget {
  const ChatWithMatchScreen({super.key});

  @override
  State<ChatWithMatchScreen> createState() => _ChatWithMatchScreenState();
}

class _ChatWithMatchScreenState extends State<ChatWithMatchScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();

  Future<void> _sendMessage() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': input});
    });
    _controller.clear();

    final openAI = OpenAIService();
    final aiResponse = await openAI.sendMessage([
      {'role': 'user', 'content': input},
    ]);

    setState(() {
      _messages.add({'sender': 'ai', 'text': aiResponse});
    });

    if (MatchService.isMatchingComplete(_messages)) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const EditableProfileScreen(),
          ),
        );
      });
    }
  }

  Widget _buildMessage(Map<String, String> message) {
    final isUser = message['sender'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message['text'] ?? '',
          style: TextStyle(color: isUser ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat with AI')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessage(_messages[index]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
