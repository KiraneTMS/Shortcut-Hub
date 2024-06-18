import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF121212),
        appBar: AppBar(title: Text('Latest Games')),
        body: HomeMenu(),
      ),
    );
  }
}

class HomeMenu extends StatefulWidget {
  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('Building HomeMenu...');
    return SingleChildScrollView(
      child: Column(
        children: [
          // ImageWithRatio("assets/images/banner_home.png"),
          HomeSearchBar(
            searchController: searchController,
            onSearchChanged: (query) {
              // You can add custom search handling here if needed
              print('Search query: $query');
              // You can call the filter method of LatestGamesListState from here if needed
            },
          ),
          LatestGamesList(searchController: searchController),
        ],
      ),
    );
  }
}

class HomeSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  HomeSearchBar({required this.searchController, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
      child: TextField(
        controller: searchController,
        style: TextStyle(color: Colors.white54),
        decoration: InputDecoration(
          hintText: "Search here",
          hintStyle: TextStyle(color: Colors.white54),
          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          prefixIcon: Icon(Icons.search, color: Colors.white),
        ),
        onChanged: onSearchChanged,
      ),
    );
  }
}

class ImageWithRatio extends StatelessWidget {
  final String imagePath;

  ImageWithRatio(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
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

  Game({
    required this.name,
    required this.imagePath,
    required this.playedTime,
    required this.filename,
    required this.path,
  });
}

class App {
  final String name;
  final String imagePath;
  final DateTime usedTime;
  final String filename;
  final String path;

  App({
    required this.name,
    required this.imagePath,
    required this.usedTime,
    required this.filename,
    required this.path,
  });
}

class Folder {
  final String name;
  final String imagePath;
  final String description;
  final DateTime usedTime;
  final String path;

  Folder({
    required this.name,
    required this.imagePath,
    required this.description,
    required this.usedTime,
    required this.path,
  });
}


class LatestGamesList extends StatefulWidget {
  final TextEditingController searchController;

  LatestGamesList({required this.searchController});

  @override
  _LatestGamesListState createState() => _LatestGamesListState();
}

class _LatestGamesListState extends State<LatestGamesList> {
  List<Game>? latestGames;
  List<Game>? allGames;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadGames();
    _startTimer();
    widget.searchController.addListener(() {
      filterGames(widget.searchController.text);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.searchController.removeListener(() {});
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
        );
      }).toList();

      games.sort((a, b) => b.playedTime.compareTo(a.playedTime));
      setState(() {
        allGames = games;
        latestGames = games.take(5).toList();
      });
    } catch (e) {
      print('Error loading games: $e');
    }
  }

  void filterGames(String query) {
    if (query.isEmpty) {
      setState(() {
        latestGames = allGames!.take(5).toList();
      });
    } else {
      List<Game> filteredGames = allGames!.where((game) {
        return game.name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        latestGames = filteredGames.take(5).toList();
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
            'Latest Played Games',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: 350,
            enableInfiniteScroll: false,
            enlargeCenterPage: latestGames == null || latestGames!.isEmpty ? true : false,
            initialPage: 0,
            viewportFraction: 0.33,
            padEnds: false, // Align carousel to start
          ),
          items: latestGames == null || latestGames!.isEmpty
              ? [
                  // Display a single item with "No games available" message
                  Center(
                    child: Text(
                      'No games available',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ]
              : latestGames!.map((game) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          // Handle tap event
                          print('Tapped on ${game.name}');
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            width: 250,
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
                                        height: 150,
                                        width: 150,
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
                                            // Handle open button click
                                            print('Open ${game.name}');
                                            runProgram("game", game.path, game.filename, game.name, context);
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
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
        ),
      ],
    );
  }
}

class LatestAppsList extends StatefulWidget {
  final TextEditingController searchController;

  LatestAppsList({required this.searchController});

  @override
  _LatestAppsListState createState() => _LatestAppsListState();
}

class _LatestAppsListState extends State<LatestAppsList> {
  List<App>? latestApps;
  List<App>? allApps;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadApps();
    _startTimer();
    widget.searchController.addListener(() {
      filterApps(widget.searchController.text);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.searchController.removeListener(() {});
    super.dispose();
  }

  Future<void> loadApps() async {
    try {
      String jsonData = await rootBundle.loadString('assets/json/apps.json');
      List<dynamic> appsJson = jsonDecode(jsonData)['apps'];

      List<App> apps = appsJson.map((json) {
        return App(
          name: json['name'] ?? 'Unknown',
          imagePath: json['icon_path'] ?? "assets/images/logo.png",
          usedTime: DateTime.parse(json['usedTime']),
          filename: json['filename'] ?? 'Unknown',
          path: json['path'] ?? 'Unknown',
        );
      }).toList();

      apps.sort((a, b) => b.usedTime.compareTo(a.usedTime));
      setState(() {
        allApps = apps;
        latestApps = apps.take(5).toList();
      });
    } catch (e) {
      print('Error loading apps: $e');
    }
  }

  void filterApps(String query) {
    if (query.isEmpty) {
      setState(() {
        latestApps = allApps!.take(5).toList();
      });
    } else {
      List<App> filteredApps = allApps!.where((app) {
        return app.name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        latestApps = filteredApps.take(5).toList();
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
            'Latest Used Apps',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: 350,
            enableInfiniteScroll: false,
            enlargeCenterPage: latestApps == null || latestApps!.isEmpty ? true : false,
            initialPage: 0,
            viewportFraction: 0.33,
            padEnds: false, // Align carousel to start
          ),
          items: latestApps == null || latestApps!.isEmpty
              ? [
                  // Display a single item with "No apps available" message
                  Center(
                    child: Text(
                      'No apps available',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ]
              : latestApps!.map((app) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          // Handle tap event
                          print('Tapped on ${app.name}');
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            width: 250,
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
                                        File(app.imagePath),
                                        height: 150,
                                        width: 150,
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
                                      app.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      'Last Used:',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '${app.usedTime.day}/${app.usedTime.month}/${app.usedTime.year}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '(${_getElapsedTime(app.usedTime)})',
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
                                            // Handle open button click
                                            print('Open ${app.name}');
                                            runProgram("app" ,app.path, app.filename, app.name, context);
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
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
        ),
      ],
    );
  }
}

class LatestFoldersList extends StatefulWidget {
  final TextEditingController searchController;

  LatestFoldersList({required this.searchController});

  @override
  _LatestFoldersListState createState() => _LatestFoldersListState();
}

class _LatestFoldersListState extends State<LatestFoldersList> {
  List<Folder>? latestFolders;
  List<Folder>? allFolders;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadFolders();
    _startTimer();
    widget.searchController.addListener(() {
      filterFolders(widget.searchController.text);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.searchController.removeListener(() {});
    super.dispose();
  }

  Future<void> loadFolders() async {
    try {
      String jsonData = await rootBundle.loadString('assets/json/folders.json');
      List<dynamic> foldersJson = jsonDecode(jsonData)['folders'];

      List<Folder> folders = foldersJson.map((json) {
        return Folder(
          name: json['name'] ?? 'Unknown',
          imagePath: json['icon_path'] ?? "assets/images/default_folder_icon.png",
          description: json['description'] ?? 'No description available',
          usedTime: DateTime.parse(json['usedTime']),
          path: json['path'] ?? 'Unknown',
        );
      }).toList();

      folders.sort((a, b) => b.usedTime.compareTo(a.usedTime));
      setState(() {
        allFolders = folders;
        latestFolders = folders.take(5).toList();
      });
    } catch (e) {
      print('Error loading folders: $e');
    }
  }

  void filterFolders(String query) {
    if (query.isEmpty) {
      setState(() {
        latestFolders = allFolders!.take(5).toList();
      });
    } else {
      List<Folder> filteredFolders = allFolders!.where((folder) {
        return folder.name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        latestFolders = filteredFolders.take(5).toList();
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
            'Latest Accessed Folders',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: 350,
            enableInfiniteScroll: false,
            enlargeCenterPage: latestFolders == null || latestFolders!.isEmpty ? true : false,
            initialPage: latestFolders == null || latestFolders!.isEmpty ? 1 : 0,
            viewportFraction: 0.33,
            padEnds: false, // Align carousel to start
          ),
          items: latestFolders == null || latestFolders!.isEmpty
              ? [
                  // Display a single item with "No folders available" message
                  Center(
                    child: Text(
                      'No folders available',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ]
              : latestFolders!.map((folder) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          // Handle tap event
                          print('Tapped on ${folder.name}');
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            width: 250,
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
                                    folder.imagePath.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(12.0),
                                            child: Image.file(
                                              File(folder.imagePath),
                                              height: 150,
                                              width: 150,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Icon(
                                            Icons.folder,
                                            color: Colors.white,
                                            size: 150,
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
                                      folder.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      'Description:',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      folder.description,
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
                                            // Handle open button click
                                            print('Open ${folder.name}');
                                            runFolder(folder.path, folder.name, context); // Update the runProgram function to handle folder opening
                                            updateFolderUsedTime(folder.path);
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
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
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

  Future<void> runProgram(String type, String directoryPath, String command, String gameName, BuildContext context) async {
  print('Path: $directoryPath');

    try {
      // Check if the directory exists
      if (!Directory(directoryPath).existsSync()) {
        // Show dialog if directory doesn't exist
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Directory Not Found'),
              content: Text('The specified directory was not found.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }
      // Start the process
      final process = await Process.start(
        command,
        [], // Empty list for arguments
        workingDirectory: directoryPath,
        runInShell: true,
      );

      // Print the actual command being executed for debugging purposes
      print('Launching command: $command in $directoryPath');

      // Handle process output (optional)
      process.stdout.transform(utf8.decoder).listen((data) {
        print('stdout: $data');
      });

      process.stderr.transform(utf8.decoder).listen((data) {
        print('stderr: $data');
      });

      
      // Record the start time
      DateTime startTime = DateTime.now();

      // Handle process exit
      DateTime endTime = DateTime.now(); // Record the end time

      // Calculate the duration
      Duration duration = endTime.difference(startTime);
      print('Directory opened');
      print('Operation took: ${duration.inSeconds} seconds');

      // Update the JSON file
      await updatePlayedTime(gameName, endTime, type);

    } catch (error) {
      print('Error starting process: $error at $directoryPath');
    }
  }

  Future<void> runFolder(String directoryPath, String itemName, BuildContext context) async {
  print('Path: $directoryPath');

  try {
    // Check if the directory exists
    final directory = Directory(directoryPath);
    if (!await directory.exists()) {
      _showPathNotFoundDialog(context, directoryPath);
      return;
    }

    // Create a file URI
    final Uri uri = Uri.file(directoryPath);

    // Open the directory using url_launcher
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }

  } catch (error) {
    print('Error opening directory: $error at $directoryPath');
  }
}

Future<void> updateFolderUsedTime(String directoryPath) async {
  try {
    // Load the JSON file
    String jsonData = await rootBundle.loadString('assets/json/folders.json');
    Map<String, dynamic> data = jsonDecode(jsonData);

    // Find and update the specific folder's usedTime
    for (var folder in data['folders']) {
      if (folder['path'] == directoryPath) {
        folder['usedTime'] = DateTime.now().toIso8601String();
        break;
      }
    }

    // Write the updated JSON data back to the file
    File jsonFile = File('assets/json/folders.json');
    await jsonFile.writeAsString(jsonEncode(data), mode: FileMode.write);
  } catch (e) {
    print('Error updating folder used time: $e');
  }
}

void _showPathNotFoundDialog(BuildContext context, String directoryPath) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF1E1E1E),
        title: Text(
          'Error',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Directory not found: $directoryPath',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            child: Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  Future<void> updatePlayedTime(String name, DateTime playedTime, String type) async {
    try {
      // Determine the correct JSON file based on the type
      String filePath;
      if (type == 'game') {
        filePath = 'assets/json/games.json';
      } else if (type == 'app') {
        filePath = 'assets/json/apps.json';
      } else {
        throw Exception('Invalid type provided');
      }

      // Read the JSON file
      String jsonData = await File(filePath).readAsString();
      Map<String, dynamic> jsonMap = jsonDecode(jsonData);

      // Find and update the playedTime/usedTime
      List<dynamic> items = jsonMap[type == 'game' ? 'games' : 'apps'];
      for (var item in items) {
        if (item['name'] == name) {
          item['usedTime'] = playedTime.toIso8601String();
          break;
        }
      }

      // Write the updated JSON data back to the file
      await File(filePath).writeAsString(jsonEncode(jsonMap));
      print('Updated ${type == 'game' ? 'playedTime' : 'usedTime'} for $name to $playedTime');
    } catch (error) {
      print('Error updating ${type == 'game' ? 'playedTime' : 'usedTime'}: $error');
    }
  }