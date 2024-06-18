import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'game.dart';
import 'footer.dart';

class GamePage extends StatelessWidget {
  final Game game;

  GamePage({required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 28, 28, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56, 56, 56, 1),
        title: Text(
          game.name,
          style: TextStyle(
            color: Colors.white, // Set text color to white
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 16,
            top: 0,
            left: 16,
            right: 16
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 25), // Add bottom margin
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0), // Not rounded at top left
                      topRight: Radius.circular(0), // Not rounded at top right
                      bottomLeft: Radius.circular(150), // Rounded at bottom left
                      bottomRight: Radius.circular(150), // Rounded at bottom right
                    ),
                    border: Border(
                      bottom: BorderSide(color: Colors.white), // Border color at the bottom
                      right: BorderSide(color: Colors.white),
                      left: BorderSide(color: Colors.white),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color.fromRGBO(92, 92, 92, 1), // hsla(0, 0%, 36%, 1)
                        Color.fromRGBO(56, 56, 56, 1),    // hsla(0, 0%, 1%, 1)
                      ],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0), // Not rounded at top left
                      topRight: Radius.circular(0), // Not rounded at top right
                      bottomLeft: Radius.circular(20), // Rounded at bottom left
                      bottomRight: Radius.circular(20), // Rounded at bottom right
                    ),
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 50
                            ),
                            child: SizedBox(
                              width: 200, // Width for the image section (adjust as needed)
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20), // Not rounded at top left
                                  topRight: Radius.circular(20), // Not rounded at top right
                                  bottomLeft: Radius.circular(20), // Rounded at bottom left
                                  bottomRight: Radius.circular(20), // Rounded at bottom right
                                ),
                                child: Image.file(
                                  File(game.imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    game.name,
                                    style: TextStyle(
                                      fontSize: 24, 
                                      fontWeight: FontWeight.bold, 
                                      color: Color.fromARGB(223, 255, 230, 5),
                                      ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Genres:', // List of genres
                                    style: TextStyle(
                                      fontSize: 16, 
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[300]
                                      ),
                                  ),
                                  SizedBox(height: 4),
                                  // Displaying genres as chips
                                  Wrap(
                                    spacing: 8.0,
                                    children: game.genres.map((genre) {
                                      return Chip(label: Text(genre));
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Developer: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white, // Set text color to white
                                  ),
                                ),
                                TextSpan(
                                  text: game.developer, // Developer name
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.yellow[600], // Set developer name color to gold
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8), // Add spacing between Developer and Publisher
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Publisher: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white, // Set text color to white
                                  ),
                                ),
                                TextSpan(
                                  text: game.publisher, // Publisher name
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.yellow[600], // Set publisher name color to gold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    SizedBox(
                      height: 50, // Set the height of the button (adjust as needed)
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(179, 179, 179, 1),
                              Color.fromRGBO(217, 217, 217, 1),
                              Color.fromRGBO(179, 179, 179, 1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                          onPressed: () {
                            // Handle play button tap
                            runProgram("game", game.path, game.filename, game.name, context);
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.amber,
                            textStyle: TextStyle(fontSize: 20), // Set font size for the text
                          ),
                          child: Text(
                            'Play Game',
                            style: TextStyle(
                              color: Colors.black, // Set text color if needed
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.only(
                    top: 25,
                    bottom: 100
                  ), // Add top margin
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.9, // 70% of the max width
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border(
                          bottom: BorderSide(color: Colors.white10),
                          top: BorderSide(color: Colors.white10),
                          right: BorderSide(color: Colors.white10),
                          left: BorderSide(color: Colors.white10),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0xFF252525),
                            Color.fromRGBO(28, 28, 28, 1),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 25),
                        child: Text(
                          'Description: ${game.description}', // Description text
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Footer()
            ],
          ),
        ),
      ),
    );
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