import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  final String apiKey = "89887852";
  final String baseUrl = "http://www.omdbapi.com/";

  // Fetch movies by category
  Future<List<Movie>> fetchMovies(String category) async {
    final url = Uri.parse("$baseUrl?s=$category&apikey=$apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Movie> movies = [];
      if (data['Search'] != null) {
        for (var movieJson in data['Search']) {
          movies.add(Movie.fromJson(movieJson));
        }
      }
      return movies;
    } else {
      throw Exception("Failed to load movies");
    }
  }

  // Fetch movie details by ID
  Future<Map<String, dynamic>> fetchMovieDetail(String id) async {
    final url = Uri.parse("$baseUrl?i=$id&apikey=$apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load movie details");
    }
  }
}
