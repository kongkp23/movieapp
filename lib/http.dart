import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'movie.dart';

class HttpHelper {
  final String _apiKey = '25e18605587b94c24b7c8549122821b8';
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _language = 'en-US';

  Future<List<Movie>> getUpcoming() async {
    final uri = Uri.parse('$_baseUrl/movie/upcoming?api_key=$_apiKey&language=$_language');
    final res = await http.get(uri);

    if (res.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(res.body) as Map<String, dynamic>;
      final results = (jsonResponse['results'] as List<dynamic>);
      return results.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<Movie>> findMovies(String title) async {
    final uri = Uri.parse('$_baseUrl/search/movie?api_key=$_apiKey&query=$title&language=$_language');
    final res = await http.get(uri);

    if (res.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(res.body) as Map<String, dynamic>;
      final results = (jsonResponse['results'] as List<dynamic>);
      return results.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
