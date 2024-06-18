import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'folder_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class FolderSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  FolderSearchBar({required this.searchController, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.white),
          hintText: 'Search folders...',
          hintStyle: TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Color(0xFF121212),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class Folder {
  final String name;
  final String path;
  final String iconPath;
  final String description;
  final DateTime usedTime;

  Folder({
    required this.name,
    required this.path,
    required this.iconPath,
    required this.description,
    required this.usedTime,
  });
}


class AllFoldersList extends StatefulWidget {
  final TextEditingController searchController;

  AllFoldersList({required this.searchController});

  @override
  _AllFoldersListState createState() => _AllFoldersListState();
}

class _AllFoldersListState extends State<AllFoldersList> {
  List<Folder>? allFolders;
  List<Folder>? displayedFolders;
  List<Folder>? searchResults;
  int currentPage = 0;
  int foldersPerPage = 9;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchChanged);
    loadFolders();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  Future<void> loadFolders() async {
    try {
      String jsonData = await rootBundle.loadString('assets/json/folders.json');
      List<dynamic> foldersJson = jsonDecode(jsonData)['folders'];

      List<Folder> folders = foldersJson.map((json) {
        return Folder(
          name: json['name'] ?? 'Unknown',
          path: json['path'] ?? 'Unknown',
          iconPath: json['icon_path'] ?? "assets/images/default_folder_icon.png",
          description: json['description'] ?? '',
          usedTime: DateTime.parse(json['usedTime']),
        );
      }).toList();

      // Sort the list by name in A-Z order, ignoring case
      folders.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      setState(() {
        allFolders = folders;
        searchResults = List.from(allFolders!); // Initialize search results with all folders
        updateDisplayedFolders(); // Update displayed folders after loading
      });
    } catch (e) {
      print('Error loading folders: $e');
    }
  }

  void _onSearchChanged() {
    String query = widget.searchController.text.toLowerCase();
    setState(() {
      searchResults = allFolders!.where((folder) {
        return folder.name.toLowerCase().contains(query);
      }).toList();
      currentPage = 0; // Reset to first page when search query changes
      updateDisplayedFolders();
    });
  }

  void updateDisplayedFolders() {
    if (searchResults != null) {
      setState(() {
        displayedFolders = searchResults!.skip(currentPage * foldersPerPage).take(foldersPerPage).toList();
      });
    }
  }

  void nextPage() {
    if ((currentPage + 1) * foldersPerPage < searchResults!.length) {
      setState(() {
        currentPage++;
        updateDisplayedFolders();
      });
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        updateDisplayedFolders();
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
            'My Folders',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        displayedFolders == null || displayedFolders!.isEmpty
            ? Center(
                child: Text(
                  'No folders available',
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
                itemCount: displayedFolders!.length,
                itemBuilder: (context, index) {
                  Folder folder = displayedFolders![index];
                  return GestureDetector(
                    onTap: () {
                      print('Tapped on ${folder.name}');
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
                            folder.iconPath.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.file(
                                      File(folder.iconPath),
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    Icons.folder,
                                    size: 100,
                                    color: Colors.white,
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
                              'Last Used:',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '${folder.usedTime.day}/${folder.usedTime.month}/${folder.usedTime.year}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '(${_getElapsedTime(folder.usedTime)})',
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
                                    // Handle folder open action
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => FolderPage(folder: folder)),
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

  String _getElapsedTime(DateTime lastUsedTime) {
    Duration diff = DateTime.now().difference(lastUsedTime);
    if (diff.inDays > 0) {
      return '${diff.inDays} days ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
