import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_strings.dart';
import '../model/message_model.dart';

class ChatApiService {
  Future<String> fetchAssistantReply(List<MessageModel> messages) async {
    print('[Chat] Calling model: ${AppStrings.model}');

    final response = await http
        .post(
      Uri.parse('${AppStrings.baseUrl}/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppStrings.apiKey}',
        'HTTP-Referer': AppStrings.httpReferer,
        'X-Title': AppStrings.appTitle,
      },
      body: jsonEncode({
        'model': AppStrings.model,
        'messages': [
          {'role': 'system', 'content': AppStrings.systemPrompt},
          ...messages.map((m) => m.toApiMap()),
        ],
      }),
    )
        .timeout(const Duration(seconds: 30));

    print('[Chat] Status: ${response.statusCode}');
    print('[Chat] Body: ${response.body.length > 400 ? response.body.substring(0, 400) : response.body}');

    if (response.statusCode != 200) {
      throw Exception('Chat API error ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body);
    return (data['choices'][0]['message']['content'] as String).trim();
  }
}