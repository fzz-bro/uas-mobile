import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MovieDetailScreen extends StatelessWidget {
  final String movieId;

  const MovieDetailScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Film"),
        backgroundColor: const Color(0xFF002B5B),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService().fetchMovieDetail(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final movieDetail = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  movieDetail["Poster"] != null &&
                          movieDetail["Poster"] != "N/A"
                      ? Center(
                          child: Image.network(movieDetail["Poster"],
                              height: 300, fit: BoxFit.cover),
                        )
                      : const Center(child: Icon(Icons.movie, size: 150)),
                  const SizedBox(height: 16),
                  Text(
                    movieDetail["Title"] ?? "Judul tidak tersedia",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tahun: ${movieDetail["Year"] ?? "N/A"}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Genre: ${movieDetail["Genre"] ?? "N/A"}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sutradara: ${movieDetail["Director"] ?? "N/A"}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Deskripsi:",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movieDetail["Plot"] ?? "Tidak ada deskripsi.",
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("Data tidak ditemukan"));
          }
        },
      ),
    );
  }
}
