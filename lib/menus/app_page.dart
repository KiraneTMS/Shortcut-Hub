import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'app.dart';
import 'footer.dart';

class AppPage extends StatelessWidget {
  final App app;
  var backgroundStartColor = Color(0xFF252525);
  var backgroundEndColor = Color(0xFF121212);

  AppPage({required this.app});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 28, 28, 1),
      appBar: AppBar(
        title: Text(app.name),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Icon
                Center(
                  child: app.imagePath.isNotEmpty
                      ? Image.file(
                          File(app.imagePath),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.apps,
                          size: 100,
                          color: Colors.grey,
                        ),
                ),
                const SizedBox(height: 16.0),

                // App Name
                Center(
                  child: Text(
                    app.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Publisher, Developer, and Open Button in a Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Publisher: ${app.publisher}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Developer: ${app.developer}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16.0),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color.fromRGBO(92, 92, 92, 1),
                            Color.fromRGBO(56, 56, 56, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.white, width: 0.1),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Add your open functionality here
                          runProgram("app", app.path, app.filename, app.name, context);
                        },
                        borderRadius: BorderRadius.circular(8.0),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                          child: Text(
                            'Open ${app.name}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16.0),

                // Short Description
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF252525),
                        Color.fromRGBO(28, 28, 28, 1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    app.shortDescription,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),

                // Full Description
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xFF252525),
                        Color.fromRGBO(28, 28, 28, 1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    app.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Last Used Time
                Text(
                  'Last Used: ${app.usedTime.day}/${app.usedTime.month}/${app.usedTime.year} (${_getElapsedTime(app.usedTime)})',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                  ),
                ),

                const SizedBox(height: 16.0),

                Footer()
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getElapsedTime(DateTime usedTime) {
    Duration difference = DateTime.now().difference(usedTime);
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