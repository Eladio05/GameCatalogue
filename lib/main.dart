import 'package:flutter/material.dart';
import 'GamePage/game_list_page.dart';
import 'WishlistPage/wishlist_page.dart';
import 'AddGamePage/add_game_page.dart';
import 'AddGamePage/add_wishlist_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de Bibliothèque de Jeux',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF1A1A1D),
        scaffoldBackgroundColor: const Color(0xFF1A1A1D),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF1A1A1D),
          secondary: const Color(0xFFAD1457),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
          bodyMedium: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
          bodySmall: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
        ),
        useMaterial3: true,
      ),
      home: const BottomNavPage(),
    );
  }
}

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  _BottomNavPageState createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAddButtonPressed() {
    if (_selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddGamePage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddWishlistPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              Theme(
                data: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: const Color(0xFF1A1A1D),
                  scaffoldBackgroundColor: const Color(0xFF1A1A1D),
                  colorScheme: ColorScheme.dark(
                    primary: const Color(0xFF1A1A1D),
                    secondary: const Color(0xFFFF0000),
                  ),
                  textTheme: const TextTheme(
                    bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    bodyMedium: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    bodySmall: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                  ),
                ),
                child: const GameCollectionPage(),
              ),
              Theme(
                data: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: const Color(0xFF1A1A1D),
                  scaffoldBackgroundColor: const Color(0xFF1A1A1D),
                  colorScheme: ColorScheme.dark(
                    primary: const Color(0xFF1A1A1D),
                    secondary: const Color(0xFF8A2BE2),
                  ),
                  textTheme: const TextTheme(
                    bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    bodyMedium: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    bodySmall: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                  ),
                ),
                child: const WishlistPage(),
              ),
            ],
          ),
          Positioned(
            right: 16.0,
            bottom: 16.0,
            child: FloatingActionButton(
              backgroundColor: _selectedIndex == 0 ? const Color(0xFFFF0000) : const Color(0xFF8A2BE2),
              onPressed: _onAddButtonPressed,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF282828),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.videogame_asset),
            label: 'Jeux',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _selectedIndex == 0 ? const Color(0xFFFF0000) : const Color(0xFF8A2BE2),
        unselectedItemColor: Colors.white70,
        onTap: _onItemTapped,
      ),
    );
  }
}
