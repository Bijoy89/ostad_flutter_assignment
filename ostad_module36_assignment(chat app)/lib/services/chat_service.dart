import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message.dart';

class ChatService {
  static const String _baseUrl = 'https://api.durjoyai.com';
  static const String _model = 'durjoy-kotha-1';
  static const String _apiKey = 'sk-LvqSBOf80jxFCYNvf6vPpQ';

  Future<String> sendMessage(List<Message> messages) async {
    try {
      final response = await http
          .post(
        Uri.parse('$_baseUrl/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages.map((m) => m.toJson()).toList(),
        }),
      )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on http.ClientException {
      throw Exception('No internet connection. Please check your network.');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timed out. Please try again.');
      }
      rethrow;
    }
  }
}