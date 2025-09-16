// lib/service/openai_service.dart

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  // .env에서 읽어온 API 키 (없으면 빈 문자열)
  final String _apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

  OpenAIService() {
    // 키가 제대로 로드됐는지 확인
    assert(_apiKey.isNotEmpty, '❗️OPENAI_API_KEY가 설정되지 않았습니다!');
    debugPrint('🔑 OPENAI_API_KEY loaded: ${_apiKey.isNotEmpty}');
  }

  /// chatHistory: [
  ///   {"role":"system"|"user"|"assistant", "content":"..."},
  ///   ...
  /// ]
  Future<String> sendMessage(List<Map<String, String>> chatHistory) async {
    try {
      final response = await http
          .post(
            Uri.parse('https://api.openai.com/v1/chat/completions'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $_apiKey',
            },
            body: jsonEncode({
              'model': 'gpt-4o',
              'messages': chatHistory,
              'max_tokens': 300,
              'temperature': 0.8,
              'top_p': 0.9,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        final data = jsonDecode(utf8Body);
        final content = data['choices'][0]['message']['content'] as String;
        return content.trim();
      } else {
        debugPrint('⛔ OpenAI error ${response.statusCode}: ${response.body}');
        return '죄송해요, 응답을 받을 수 없었어요.';
      }
    } on TimeoutException {
      debugPrint('⏱️ OpenAI request timed out');
      return '서버 응답이 지연되고 있어요. 잠시 후 다시 시도해주세요.';
    } on http.ClientException catch (e) {
      debugPrint('⚠️ HTTP exception: $e');
      return '네트워크 문제로 응답을 받을 수 없었어요.';
    } catch (e, st) {
      debugPrint('❗ Unexpected error: $e\n$st');
      return '예기치 못한 오류가 발생했어요.';
    }
  }
}
