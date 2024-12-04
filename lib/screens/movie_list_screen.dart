import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/movie.dart';
import 'movie_detail_screen.dart'; // Import halaman detail

class MovieListScreen extends StatelessWidget {
  final String category;

  const MovieListScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kategori: $category"),
        backgroundColor: const Color(0xFF002B5B),
      ),
      body: FutureBuilder<List<Movie>>(
        future: ApiService().fetchMovies(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final movies = snapshot.data!;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return ListTile(
                  leading: movie.poster.isNotEmpty
                      ? Image.network(movie.poster,
                          width: 50, fit: BoxFit.cover)
                      : const Icon(Icons.movie, size: 50),
                  title: Text(movie.title),
                  subtitle: Text("Tahun: ${movie.year}"),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF002B5B),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MovieDetailScreen(movieId: movie.id),
                        ),
                      );
                    },
                    child: const Text("Detail"),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No movies found"));
          }
        },
      ),
    );
  }
}
