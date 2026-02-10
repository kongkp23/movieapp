import 'package:flutter/material.dart';
import 'http.dart';
import 'movie.dart';

void main() => runApp(const MyMovies());

class MyMovies extends StatelessWidget {
  const MyMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Movies',
      // ใช้โทนดำ-น้ำเงิน ให้ดูพรีเมียม
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF0D1B2A),
        scaffoldBackgroundColor: const Color(0xFF0B1622),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D1B2A),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: Color(0xFF1B3A5C),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          iconTheme: IconThemeData(color: Color(0xFF5DADE2)),
        ),
        cardColor: const Color(0xFF1A2A3A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1B3A5C),
          secondary: Color(0xFF5DADE2),
          surface: Color(0xFF1A2A3A),
        ),
      ),
      home: const MovieList(),
    );
  }
}

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  late HttpHelper helper;
  List<Movie>? movies;
  int moviesCount = 0;

  // ตัวแปรสำหรับจัดการการค้นหาใน AppBar
  Icon visibleIcon = const Icon(Icons.search, color: Color(0xFF5DADE2));
  Widget searchBar = const Text(
    'Movies',
    style: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    ),
  );

  @override
  void initState() {
    helper = HttpHelper();
    initialize(); // เรียกดึงข้อมูลหนัง Upcoming ทันทีที่เปิดแอป
    super.initState();
  }

  Future initialize() async {
    movies = await helper.getUpcoming();
    setState(() {
      moviesCount = movies?.length ?? 0;
      movies = movies;
    });
  }

  Future search(String title) async {
    movies = await helper.findMovies(title);
    setState(() {
      moviesCount = movies?.length ?? 0;
      movies = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D1B2A), Color(0xFF1B3A5C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: searchBar,
        actions: [
          IconButton(
            icon: visibleIcon,
            onPressed: () {
              setState(() {
                if (visibleIcon.icon == Icons.search) {
                  visibleIcon = const Icon(
                    Icons.cancel,
                    color: Color(0xFF5DADE2),
                  );
                  // เปลี่ยน Title เป็นช่องกรอกข้อความเมื่อกดค้นหา
                  searchBar = TextField(
                    textInputAction: TextInputAction.search,
                    style: const TextStyle(color: Colors.white, fontSize: 20.0),
                    cursorColor: const Color(0xFF5DADE2),
                    decoration: const InputDecoration(
                      hintText: 'Search movies...',
                      hintStyle: TextStyle(color: Color(0xFF7F8C8D)),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (String text) {
                      search(text);
                    },
                  );
                } else {
                  visibleIcon = const Icon(
                    Icons.search,
                    color: Color(0xFF5DADE2),
                  );
                  searchBar = const Text(
                    'Movies',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  );
                  initialize();
                }
              });
            },
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: moviesCount,
        itemBuilder: (context, position) {
          final movie = movies![position];
          return Card(
            color: const Color(0xFF1A2A3A),
            elevation: 3.0,
            shadowColor: const Color(0xFF1B3A5C).withOpacity(0.5),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF1B3A5C),
                backgroundImage: (movie.posterPath.isNotEmpty)
                    ? NetworkImage(movie.posterUrl)
                    : const NetworkImage(
                            'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg',
                          )
                          as ImageProvider,
              ),
              title: Text(
                movie.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Released: ${movie.releaseDate}',
                      style: const TextStyle(
                        color: Color(0xFF5DADE2),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          final starValue = (index + 1) * 2;
                          if (movie.voteAverage >= starValue) {
                            return const Icon(
                              Icons.star,
                              color: Color(0xFFFFD700),
                              size: 16,
                            );
                          } else if (movie.voteAverage >= starValue - 1) {
                            return const Icon(
                              Icons.star_half,
                              color: Color(0xFFFFD700),
                              size: 16,
                            );
                          } else {
                            return const Icon(
                              Icons.star_border,
                              color: Color(0xFFFFD700),
                              size: 16,
                            );
                          }
                        }),
                        const SizedBox(width: 6),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Color(0xFFFFD700),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MovieDetail(movie)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// คลาสหน้าแสดงรายละเอียดหนัง (ย้ายมาไว้ในไฟล์เดียวกัน)
class MovieDetail extends StatelessWidget {
  final Movie movie;
  const MovieDetail(this.movie, {super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D1B2A), Color(0xFF1B3A5C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      // ใช้ SingleChildScrollView เพื่อให้เลื่อนดูเรื่องย่อที่ยาวได้
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                height: height / 1.5,
                child: Image.network(
                  (movie.posterPath.isNotEmpty)
                      ? movie.posterUrl
                      : 'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg',
                ),
              ),
              // Rating display
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(5, (index) {
                      final starValue = (index + 1) * 2;
                      if (movie.voteAverage >= starValue) {
                        return const Icon(
                          Icons.star,
                          color: Color(0xFFFFD700),
                          size: 28,
                        );
                      } else if (movie.voteAverage >= starValue - 1) {
                        return const Icon(
                          Icons.star_half,
                          color: Color(0xFFFFD700),
                          size: 28,
                        );
                      } else {
                        return const Icon(
                          Icons.star_border,
                          color: Color(0xFFFFD700),
                          size: 28,
                        );
                      }
                    }),
                    const SizedBox(width: 10),
                    Text(
                      '${movie.voteAverage.toStringAsFixed(1)} / 10',
                      style: const TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  movie.overview,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
