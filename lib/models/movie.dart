class Movie {
  final String id;
  final String title;
  final String year;
  final String poster;
  final String type;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.poster,
    required this.type,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['imdbID'], // Mengambil ID IMDb
      title: json['Title'], // Mengambil judul film
      year: json['Year'], // Mengambil tahun rilis
      poster: json['Poster'], // Mengambil URL poster film
      type: json['Type'], // Mengambil jenis film (movie, series, etc.)
    );
  }
}
// 
