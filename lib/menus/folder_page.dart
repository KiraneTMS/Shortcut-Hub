import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'folder.dart';
import 'footer.dart';

class FolderPage extends StatelessWidget {
  final Folder folder;
  var backgroundStartColor = Color(0xFF252525);
  var backgroundEndColor = Color(0xFF121212);

  FolderPage({required this.folder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(28, 28, 28, 1),
      appBar: AppBar(
        title: Text(folder.name),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Folder Icon (Placeholder)
                Center(
                  child: Icon(
                    Icons.folder,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16.0),

                // Folder Name
                Center(
                  child: Text(
                    folder.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Folder Path and Open Folder Button in a Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Path: ${folder.path}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[400],
                        ),
                      ),
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
                          print('Opening folder: ${folder.path}');
                          runFolder(folder.path, folder.name, context);
                        },
                        borderRadius: BorderRadius.circular(8.0),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                          child: Text(
                            'Access ${folder.name}',
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

                // Folder Description
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
                    folder.description,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),

                // Last Used Time
                Text(
                  'Last Used: ${folder.usedTime.day}/${folder.usedTime.month}/${folder.usedTime.year} (${_getElapsedTime(folder.usedTime)})',
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
