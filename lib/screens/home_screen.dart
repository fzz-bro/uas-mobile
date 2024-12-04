import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/movie.dart';
import 'movie_list_screen.dart'; // Import screen tujuan

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> _moviesFuture;

  final List<Map<String, String>> _categories = [
    {"name": "Action", "icon": "🎬"},
    {"name": "Comedy", "icon": "😂"},
    {"name": "Drama", "icon": "🎭"},
    {"name": "Romance", "icon": "❤️"},
  ];

  @override
  void initState() {
    super.initState();
    _moviesFuture = ApiService().fetchMovies("Action");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE6C9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF002B5B),
        title: const Text(
          "Selamat Datang",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Movie>>(
          future: _moviesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              final movies = snapshot.data!;
              return _buildContent(movies);
            } else {
              return const Center(child: Text("No data available"));
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent(List<Movie> movies) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchBar(),
          const SizedBox(height: 24),
          _buildCategories(),
          const SizedBox(height: 24),
          const Text(
            "Film Populer",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildMovieList(movies),
          const SizedBox(height: 24),
          const Text(
            "Film Terbaru",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildLatestMovies(movies),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Masukkan judul film",
                border: InputBorder.none,
              ),
              onSubmitted: (query) {
                setState(() {
                  _moviesFuture = ApiService().fetchMovies(query);
                });
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _categories.map((category) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieListScreen(
                    category: category["name"]!), // Navigasi ke screen tujuan
              ),
            );
          },
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF002B5B),
                radius: 28,
                child: Text(
                  category["icon"]!,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category["name"]!,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMovieList(List<Movie> movies) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return _movieCard(movie.title, movie.poster);
        },
      ),
    );
  }

  Widget _buildLatestMovies(List<Movie> movies) {
    return Column(
      children: movies.map((movie) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: movie.poster.isNotEmpty
                ? Image.network(movie.poster, width: 50, fit: BoxFit.cover)
                : const Icon(Icons.movie, size: 50),
            title: Text(movie.title, style: const TextStyle(fontSize: 16)),
            subtitle: Text("Tahun: ${movie.year}"),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA726),
              ),
              onPressed: () {},
              child: const Text("Baca Info"),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _movieCard(String title, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: imageUrl.isNotEmpty
                ? NetworkImage(imageUrl)
                : const AssetImage("assets/no_image.png") as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
