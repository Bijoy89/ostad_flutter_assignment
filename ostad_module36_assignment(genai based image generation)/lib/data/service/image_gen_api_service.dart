import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_strings.dart';
import '../../domain/entities/image_message_entity.dart';

class ImageGenApiService {
  Future<ImageMessage> generateImage(String prompt) async {
    print('[ImageGen] Calling model: ${AppStrings.imageGenModel}');

    final response = await http
        .post(
      Uri.parse('${AppStrings.imageGenBaseUrl}/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppStrings.imageGenApiKey}',
        'HTTP-Referer': AppStrings.httpReferer,
        'X-Title': AppStrings.appTitle,
      },
      body: jsonEncode({
        'model': AppStrings.imageGenModel,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text': prompt,
              }
            ],
          }
        ],
      }),
    )
        .timeout(const Duration(seconds: 120));

    print('[ImageGen] Status: ${response.statusCode}');
    print('[ImageGen] Body: ${response.body.length > 600 ? response.body.substring(0, 600) : response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to generate image: ${response.statusCode}\n${response.body}');
    }

    final decoded = jsonDecode(response.body);
    final message = decoded['choices']?[0]?['message'];

    if (message == null) {
      throw Exception('Invalid response structure from API.');
    }

    final content = message['content'];
    final images = message['images'];

    print('[ImageGen] content type: ${content.runtimeType}');
    print('[ImageGen] content preview: ${content.toString().length > 300 ? content.toString().substring(0, 300) : content}');
    print('[ImageGen] images: ${images == null ? 'null' : (images is List ? 'List(${images.length})' : images)}');

    if (images is List && images.isNotEmpty) {
      final img = images[0];
      final url = img['url'] as String? ?? img['image_url']?['url'] as String?;
      if (url != null) {
        return ImageMessage(
          role: 'assistant',
          prompt: prompt,
          imageUrl: url,
          textContent: content is String && content.trim().isNotEmpty ? content.trim() : null,
          time: DateTime.now(),
        );
      }
    }

    if (content is List) {
      String? imageUrl;
      String? textContent;
      for (final block in content) {
        final type = block['type'];
        if (type == 'image_url') {
          imageUrl = block['image_url']?['url'] as String?;
        } else if (type == 'text') {
          final t = block['text'] as String?;
          if (t != null && t.trim().isNotEmpty) textContent = t.trim();
        }
      }
      if (imageUrl != null) {
        return ImageMessage(
          role: 'assistant',
          prompt: prompt,
          imageUrl: imageUrl,
          textContent: textContent,
          time: DateTime.now(),
        );
      }
    }

    if (content is String && content.isNotEmpty) {
      final dataUriRegex = RegExp(r'data:image/[^;]+;base64,[A-Za-z0-9+/=]+');
      final dataMatch = dataUriRegex.firstMatch(content);
      if (dataMatch != null) {
        return ImageMessage(
          role: 'assistant',
          prompt: prompt,
          imageUrl: dataMatch.group(0)!,
          textContent: content.replaceAll(RegExp(r'!\[.*?\]\(data:image[^)]+\)'), '').trim(),
          time: DateTime.now(),
        );
      }

      final httpImageRegex = RegExp(r'!\[.*?\]\((https://[^)]+)\)');
      final httpMatch = httpImageRegex.firstMatch(content);
      if (httpMatch != null) {
        return ImageMessage(
          role: 'assistant',
          prompt: prompt,
          imageUrl: httpMatch.group(1)!,
          textContent: content.replaceAll(RegExp(r'!\[.*?\]\(https://[^)]+\)'), '').trim(),
          time: DateTime.now(),
        );
      }
    }

    throw Exception('No image was returned. Try a more descriptive prompt.');
  }
}