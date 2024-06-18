import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'game_page.dart';

void main() {
  runApp(GameApp());
}

class GameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF121212),
        appBar: AppBar(title: Text('All Games')),
        body: GameMenu(),
      ),
    );
  }
}

class GameMenu extends StatefulWidget {
  @override
  _GameMenuState createState() => _GameMenuState();
}

class _GameMenuState extends State<GameMenu> {
  TextEditingController searchController = TextEditingController();
  String defaultSortOption = 'az';

  @override
  Widget build(BuildContext context) {
    print('Building GameMenu...');
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search games...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                // Call setState to update UI when search query changes
                setState(() {});
              },
            ),
          ),
          AllGamesList(searchController: searchController),
        ],
      ),
    );
  }
}

class Game {
  final String name;
  final String imagePath;
  final DateTime playedTime;
  final String filename;
  final String path;
  final List<String> genres;
  final String publisher;
  final String developer;
  final String shortDescription;
  final String description;

  Game({
    required this.name,
    required this.imagePath,
    required this.playedTime,
    required this.filename,
    required this.path,
    required this.genres,
    required this.publisher,
    required this.developer,
    required this.shortDescription,
    required this.description,
  });
}

class AllGamesList extends StatefulWidget {
  final TextEditingController searchController;

  AllGamesList({required this.searchController});

  @override
  _AllGamesListState createState() => _AllGamesListState();
}

class _AllGamesListState extends State<AllGamesList> {
  List<Game>? allGames;
  List<Game>? displayedGames;
  List<Game>? searchResults; // List to store search results
  int currentPage = 0;
  int gamesPerPage = 9; // Number of games per page
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchChanged);
    loadGames();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  Future<void> loadGames() async {
    try {
      String jsonData = await rootBundle.loadString('assets/json/games.json');
      List<dynamic> gamesJson = jsonDecode(jsonData)['games'];

      List<Game> games = gamesJson.map((json) {
        return Game(
          name: json['name'] ?? 'Unknown',
          imagePath: json['icon_path'] ?? "assets/images/logo.png",
          playedTime: DateTime.parse(json['playedTime']),
          filename: json['filename'] ?? 'Unknown',
          path: json['path'] ?? 'Unknown',
          genres: List<String>.from(json['genres'] ?? []),
          publisher: json['publisher'] ?? 'Unknown',
          developer: json['developer'] ?? 'Unknown',
          shortDescription: json['short_description'] ?? '',
          description: json['description'] ?? '',
        );
      }).toList();

      // Sort the list by name in A-Z order, ignoring case
      games.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      setState(() {
        allGames = games;
        searchResults = List.from(allGames!); // Initialize search results with all games
        updateDisplayedGames(); // Update displayed games after loading
      });
    } catch (e) {
      print('Error loading games: $e');
    }
  }

  void _onSearchChanged() {
    String query = widget.searchController.text.toLowerCase();
    setState(() {
      searchResults = allGames!.where((game) {
        return game.name.toLowerCase().contains(query);
      }).toList();
      currentPage = 0; // Reset to first page when search query changes
      updateDisplayedGames();
    });
  }

  void updateDisplayedGames() {
    if (searchResults != null) {
      setState(() {
        displayedGames = searchResults!.skip(currentPage * gamesPerPage).take(gamesPerPage).toList();
      });
    }
  }

  void nextPage() {
    if ((currentPage + 1) * gamesPerPage < searchResults!.length) {
      setState(() {
        currentPage++;
        updateDisplayedGames();
      });
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        updateDisplayedGames();
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        // Trigger a rebuild to update the elapsed time
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            'All Games',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        displayedGames == null || displayedGames!.isEmpty
            ? Center(
                child: Text(
                  'No games available',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: displayedGames!.length,
                itemBuilder: (context, index) {
                  Game game = displayedGames![index];
                  return GestureDetector(
                    onTap: () {
                      print('Tapped on ${game.name}');
                    },
                    child: Card(
                      color: Color(0xFF121212),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.white, width: 1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.file(
                                File(game.imagePath),
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Name:',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              game.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Last Played:',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '${game.playedTime.day}/${game.playedTime.month}/${game.playedTime.year}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '(${_getElapsedTime(game.playedTime)})',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => GamePage(game: game)),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Color(0xFF1E1E1E),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: Text('Open'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: previousPage,
                child: Text(
                  'Previous',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: nextPage,
                child: Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


String _getElapsedTime(DateTime playedTime) {
  Duration difference = DateTime.now().difference(playedTime);
  int days = difference.inDays;
  int hours = difference.inHours - days * 24;
  int minutes = difference.inMinutes - (days * 24 * 60 + hours * 60);

  if (days > 0) {
    return '$days days, $hours hours and $minutes minutes ago';
  } else if (hours > 0) {
    return '$hours hours and $minutes minutes ago';
  } else {
    return '$minutes minutes ago';
  }
}

Future<void> updatePlayedTime(String name, DateTime playedTime, String type) async {
  try {
    String filePath;
    if (type == 'game') {
      filePath = 'assets/json/games.json';
    } else if (type == 'app') {
      filePath = 'assets/json/apps.json';
    } else {
      throw Exception('Invalid type provided');
    }

    String jsonData = await File(filePath).readAsString();
    Map<String, dynamic> jsonMap = jsonDecode(jsonData);

    List<dynamic> items = jsonMap[type == 'game' ? 'games' : 'apps'];
    for (var item in items) {
      if (item['name'] == name) {
        item['usedTime'] = playedTime.toIso8601String();
        break;
      }
    }

    await File(filePath).writeAsString(jsonEncode(jsonMap));
    print('Updated ${type == 'game' ? 'playedTime' : 'usedTime'} for $name to $playedTime');
  } catch (error) {
    print('Error updating ${type == 'game' ? 'playedTime' : 'usedTime'}: $error');
  }
}

