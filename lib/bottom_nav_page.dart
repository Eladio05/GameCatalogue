import 'package:flutter/material.dart';
import '../GamePage/game_list_page.dart';
import '../AddGamePage/add_game_page.dart';
import '../AddGamePage/add_wishlist_page.dart';
import 'WishListPage/wishlist_page.dart';


class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  _BottomNavPageState createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final GlobalKey<GameCollectionPageState> _gameCollectionPageKey = GlobalKey<GameCollectionPageState>();
  final GlobalKey<WishlistPageState> _wishlistPageKey = GlobalKey<WishlistPageState>();

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

  void _onAddButtonPressed() async {
    if (_selectedIndex == 0) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddGamePage()),
      );
      if (result == true) {
        _gameCollectionPageKey.currentState?.fetchGames();
      }
    }
    else {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddWishlistPage()),
      );
      if (result == true) {
        _wishlistPageKey.currentState?.fetchWishlist();
      }
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
                  primaryColor: const Color.fromARGB(255, 26, 26, 29),
                  scaffoldBackgroundColor: const Color.fromARGB(255, 26, 26, 29),
                  colorScheme: ColorScheme.dark(
                    primary: const Color.fromARGB(255, 26, 26, 29),
                    secondary: const Color.fromARGB(255, 255, 0, 0),
                  ),
                  textTheme: const TextTheme(
                    bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    bodyMedium: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    bodySmall: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                  ),
                ),
                child: GameCollectionPage(key: _gameCollectionPageKey),
              ),
              Theme(
                data: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: const Color.fromARGB(255, 26, 26, 29),
                  scaffoldBackgroundColor: const Color.fromARGB(255, 26, 26, 29),
                  colorScheme: ColorScheme.dark(
                    primary: const Color.fromARGB(255, 26, 26, 29),
                    secondary: const Color.fromARGB(255, 138, 43, 226),
                  ),
                  textTheme: const TextTheme(
                    bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    bodyMedium: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    bodySmall: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                  ),
                ),
                child: WishlistPage(key: _wishlistPageKey),
              ),
            ],
          ),
          Positioned(
            right: 16.0,
            bottom: 16.0,
            child: FloatingActionButton(
              backgroundColor: _selectedIndex == 0 ? const Color.fromARGB(255, 255, 0, 0) : const Color.fromARGB(255, 138, 43, 226),
              onPressed: _onAddButtonPressed,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 40, 40, 40),
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
        selectedItemColor: _selectedIndex == 0 ? const Color.fromARGB(255, 255, 0, 0) : const Color.fromARGB(255, 138, 43, 226),
        unselectedItemColor: Colors.white70,
        onTap: _onItemTapped,
      ),
    );
  }
}
