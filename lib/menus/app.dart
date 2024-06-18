import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'app_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  AppSearchBar({required this.searchController, required this.onSearchChanged});

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
          hintText: 'Search apps...',
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

class App {
  final String name;
  final String path;
  final String imagePath;
  final String publisher;
  final String developer;
  final String shortDescription;
  final String description;
  final String filename;
  final DateTime usedTime;

  App({
    required this.name,
    required this.path,
    required this.imagePath,
    required this.publisher,
    required this.developer,
    required this.shortDescription,
    required this.description,
    required this.filename,
    required this.usedTime,
  });
}


class AllAppsList extends StatefulWidget {
  final TextEditingController searchController;

  AllAppsList({required this.searchController});

  @override
  _AllAppsListState createState() => _AllAppsListState();
}

class _AllAppsListState extends State<AllAppsList> {
  List<App>? allApps;
  List<App>? displayedApps;
  List<App>? searchResults;
  int currentPage = 0;
  int appsPerPage = 9;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchChanged);
    loadApps();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  Future<void> loadApps() async {
    try {
      String jsonData = await rootBundle.loadString('assets/json/apps.json');
      List<dynamic> appsJson = jsonDecode(jsonData)['apps'];

      List<App> apps = appsJson.map((json) {
        return App(
          name: json['name'] ?? 'Unknown',
          path: json['path'] ?? 'Unknown',
          imagePath: json['icon_path'] ?? "assets/images/logo.png",
          publisher: json['publisher'] ?? 'Unknown',
          developer: json['developer'] ?? 'Unknown',
          shortDescription: json['short_description'] ?? '',
          description: json['description'] ?? '',
          filename: json['filename'] ?? 'Unknown',
          usedTime: DateTime.parse(json['usedTime']),
        );
      }).toList();

      // Sort the list by name in A-Z order, ignoring case
      apps.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      setState(() {
        allApps = apps;
        searchResults = List.from(allApps!); // Initialize search results with all apps
        updateDisplayedApps(); // Update displayed apps after loading
      });
    } catch (e) {
      print('Error loading apps: $e');
    }
  }

  void _onSearchChanged() {
    String query = widget.searchController.text.toLowerCase();
    setState(() {
      searchResults = allApps!.where((app) {
        return app.name.toLowerCase().contains(query);
      }).toList();
      currentPage = 0; // Reset to first page when search query changes
      updateDisplayedApps();
    });
  }

  void updateDisplayedApps() {
    if (searchResults != null) {
      setState(() {
        displayedApps = searchResults!.skip(currentPage * appsPerPage).take(appsPerPage).toList();
      });
    }
  }

  void nextPage() {
    if ((currentPage + 1) * appsPerPage < searchResults!.length) {
      setState(() {
        currentPage++;
        updateDisplayedApps();
      });
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
        updateDisplayedApps();
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
            'All Apps',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        displayedApps == null || displayedApps!.isEmpty
            ? Center(
                child: Text(
                  'No apps available',
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
                itemCount: displayedApps!.length,
                itemBuilder: (context, index) {
                  App app = displayedApps![index];
                  return GestureDetector(
                    onTap: () {
                      print('Tapped on ${app.name}');
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
                                File(app.imagePath),
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
                                    // Navigate to app page or handle app open action
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AppPage(app: app)),
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
