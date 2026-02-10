class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: (json['id'] ?? 0) as int,
      title: (json['title'] ?? '') as String,
      overview: (json['overview'] ?? '') as String,
      posterPath: (json['poster_path'] ?? '') as String,
      voteAverage: ((json['vote_average'] ?? 0) as num).toDouble(),
      releaseDate: (json['release_date'] ?? '') as String,
    );
  }

  String get posterUrl =>
      posterPath.isEmpty ? '' : 'https://image.tmdb.org/t/p/w500$posterPath';
}
