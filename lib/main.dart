import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'menus/menus_manager.dart';

var appName = 'Shortcut Hub';
void main(){
  ThemeManager.initialise();
  runApp(MyApp());
  doWhenWindowReady(() {
    const initialSize = Size(1000, 700);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = appName;
    appWindow.show();
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Menu currentMenu = Menu.home;

  void changeMenu(Menu newMenu) {
    setState(() {
      currentMenu = newMenu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: WindowBorder(
          width: 1,
          color: Colors.white38,
          child: Row(
            children: [
              LeftSide(
                onMenuChanged: changeMenu,
              ),
              Expanded(
                child: RightSide(
                  currentMenu: currentMenu,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

var sideBarColor = Color(0xFF121212);

class LeftSide extends StatelessWidget {
  final Function(Menu) onMenuChanged;

  LeftSide({required this.onMenuChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: sideBarColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WindowTitleBarBox(
            child: WindowTitleBar(
              title: appName,
              imagePath: "assets/images/logo.png",
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => onMenuChanged(Menu.home),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10.0),
              children: [
                MenuItem(
                  title: "Game",
                  onTap: () => onMenuChanged(Menu.game),
                ),
                MenuItem(
                  title: "App",
                  onTap: () => onMenuChanged(Menu.app),
                ),
                MenuItem(
                  title: "My Folder",
                  onTap: () => onMenuChanged(Menu.myFolder),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MenuItem(
                  title: "About Me",
                  onTap: () => onMenuChanged(Menu.about),
                ),
                // MenuItem(
                //   title: "Settings",
                //   onTap: () => onMenuChanged(Menu.setting),
                // ),
                // MenuItem(
                //   title: "History",
                //   onTap: () => onMenuChanged(Menu.history),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const MenuItem({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isHovered = false;
        });
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

var backgroundStartColor = Color(0xFF252525);
var backgroundEndColor = Color(0xFF121212);

enum Menu { home, app, myFolder, game, about, setting, history }

class RightSide extends StatelessWidget {
  final Menu currentMenu;

  RightSide({required this.currentMenu});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [backgroundStartColor, backgroundEndColor], // Example gradient colors
          stops: [0.0, 1.0],
        ),
      ),
      child: Column(
        children: [
          WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(child: MoveWindow()),
                WindowButtons(),
              ],
            ),
          ),
          Expanded(
            child: getMenuContent(currentMenu),
          ),
        ],
      ),
    );
  }

  Widget getMenuContent(Menu menu) {
    switch (menu) {
      case Menu.home:
        return HomeMenu(
            searchController: TextEditingController(), // Provide an instance of TextEditingController
            onSearchChanged: (String value) {},
          );

      case Menu.app:
        return AppMenu(
            searchController: TextEditingController(), // Provide an instance of TextEditingController
            onSearchChanged: (String value) {},
            );
      case Menu.game:
        return GameMenu(
            searchController: TextEditingController(), // Provide an instance of TextEditingController
            onSearchChanged: (String value) {},
            onSortChanged: (String? value) {},
            );
      case Menu.myFolder:
        return MyFolderMenu();
      case Menu.about:
        return AboutMenu();
      // case Menu.setting:
      //   return SettingsMenu();
      // case Menu.history:
      //   return HistoryMenu();
      default:
        return Center(child: Text("Unknown menu"));
    }
  }
}

var windowTitleBarButtonColors = WindowButtonColors(
  iconNormal: Colors.amber[400],
  mouseOver: Colors.white38,
  mouseDown: Colors.amber[400],
  iconMouseDown: Colors.amber[400],
  iconMouseOver: Colors.grey[300]
);
var closeWindowTitleBarButtonColors = WindowButtonColors(
  iconNormal: Colors.red[700],
  mouseOver: Colors.red,
  mouseDown: Colors.red,
  iconMouseDown: Colors.red,
  iconMouseOver: Colors.grey[300]
);

class WindowButtons extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        MinimizeWindowButton(colors: windowTitleBarButtonColors,),
        MaximizeWindowButton(colors: windowTitleBarButtonColors,),
        CloseWindowButton(colors: closeWindowTitleBarButtonColors,),
      ],
    );
  }
}
class WindowTitleBar extends StatelessWidget {
  final String title;
  final String imagePath;

  WindowTitleBar({required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40, // Adjust height as needed
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          if (imagePath != null) // Conditionally render image
            Image.asset(
              imagePath,
              width: 24.0, // Adjust width as needed
              height: 24.0, // Adjust height as needed
            ),
          const SizedBox(width: 10.0),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: title,
                style: TextStyle(color: Colors.amber[400]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}