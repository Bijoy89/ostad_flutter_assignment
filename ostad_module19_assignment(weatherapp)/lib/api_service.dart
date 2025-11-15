import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static Future<({String? city, double? lat, double? lon})> geoLocation(
    String city,
  ) async {
    try {
      final url = Uri.parse(
        "https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1&format=json",
      );
      final res = await http.get(url);
      print("response: ${res.body}");
      if (res.statusCode != 200)
        throw Exception("Geocoding failed ${res.statusCode}");
      final deData = jsonDecode(res.body) as Map<String, dynamic>;
      final result = (deData['results'] as List?) ?? [];
      if (result.isEmpty) throw Exception("City Not Found");
      final m = result.first as Map<String, dynamic>;
      final lat = (m['latitude'] as num).toDouble();
      final lon = (m['longitude'] as num).toDouble();
      final name = "${m['name']}, ${m['country']}";
      print("lat: $lat, lon: $lon, name: $name");
      return (city: name, lat: lat, lon: lon);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
