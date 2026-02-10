class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: (json['id'] ?? 0) as int,
      title: (json['title'] ?? '') as String,
      overview: (json['overview'] ?? '') as String,
      posterPath: (json['poster_path'] ?? '') as String,
    );
  }

  String get posterUrl => posterPath.isEmpty
      ? ''
      : 'https://image.tmdb.org/t/p/w500$posterPath';
}
