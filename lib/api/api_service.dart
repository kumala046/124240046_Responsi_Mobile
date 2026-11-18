import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://www.freetogame.com/api';

  static Future<List<dynamic>> getGames() async {
    final response = await http.get(Uri.parse('$baseUrl/games'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load games');
    }
  }

  static Future<Map<String, dynamic>> getGameDetail(int gameId) async {
    final response = await http.get(Uri.parse('$baseUrl/game?id=$gameId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load game details');
    }
  }
}
