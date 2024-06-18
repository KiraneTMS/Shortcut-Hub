import 'package:flutter/material.dart';
import 'home.dart';
import 'game.dart';
import 'footer.dart';
import 'app.dart';
import 'folder.dart';

// Home Menu
class HomeMenu extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  HomeMenu({required this.searchController, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    print('Building HomeMenu...');
    return SingleChildScrollView(
      child: Column(
        children: [
          ImageWithRatio("assets/images/banner_home.png"),
          const SizedBox(height: 16.0),
          HomeSearchBar(
            searchController: searchController,
            onSearchChanged: onSearchChanged,
          ),
          const SizedBox(height: 50.0),
          LatestGamesList(searchController: searchController),
          const SizedBox(height: 30.0),
          LatestAppsList(searchController: searchController),
          const SizedBox(height: 30.0),
          LatestFoldersList(searchController: searchController),
          const SizedBox(height: 30.0),
          Footer(),
        ],
      ),
    );
  }
}

class AppMenu extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  
  AppMenu({required this.searchController, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ImageWithRatio("assets/images/banner_applications.png"),
          const SizedBox(height: 30.0),
          AppSearchBar(searchController: searchController, onSearchChanged: onSearchChanged),
          const SizedBox(height: 30.0),
          AllAppsList(searchController: searchController),
          const SizedBox(height: 30.0),
          Footer(),
        ],
      ),
    );
  }
}


// Game Menu
class GameMenu extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final Function(String?) onSortChanged;
  final String defaultSortOption; // New parameter for default sorting option

  GameMenu({
    required this.searchController,
    required this.onSearchChanged,
    required this.onSortChanged,
    this.defaultSortOption = 'az', // Default value for sorting option
  });

  @override
  Widget build(BuildContext context) {
    print('Building GameMenu...');
    return SingleChildScrollView(
      child: Column(
        children: [
          ImageWithRatio("assets/images/banner_games.png"),
          const SizedBox(height: 30.0),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              style: TextStyle(color: Colors.white54),
              decoration: InputDecoration(
                hintText: 'Search games...',
                hintStyle: TextStyle(color: Colors.white54),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.white),
              ),
              onChanged: (value) {
                onSearchChanged(value);
              },
            ),
          ),
          const SizedBox(height: 30.0),
          AllGamesList(searchController: searchController),
          const SizedBox(height: 30.0),
          Footer(),
        ],
      ),
    );
  }
}


class MyFolderMenu extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('Building MyFolderMenu...');
    return SingleChildScrollView(
      child: Column(
        children: [
          ImageWithRatio("assets/images/banner_my_folders.png"),
          const SizedBox(height: 16.0),
          FolderSearchBar(
            searchController: searchController,
            onSearchChanged: (query) {
              // The search logic is already handled in AllFoldersList
            },
          ),
          const SizedBox(height: 30.0),
          AllFoldersList(searchController: searchController),
          const SizedBox(height: 30.0),
          Footer(),
        ],
      ),
    );
  }
}

// Settings Menu
class SettingsMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Building SettingsMenu...');
    return Center(
      child: Text("This is the Settings' menu"),
    );
  }
}

// History Menu
class AboutMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Building AboutMenu...');
    return Center(
      child: Text("This is the About's menu"),
    );
  }
}

// History Menu
class HistoryMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Building HistoryMenu...');
    return Center(
      child: Text("This is the History's menu"),
    );
  }
}

// Global Widgets

// Image Banner with Padding
class ImageWithRatio extends StatelessWidget {
  final String imagePath;

  ImageWithRatio(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
      child: AspectRatio(
        aspectRatio: 4 / 1,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}