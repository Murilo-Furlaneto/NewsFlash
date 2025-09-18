import 'package:flutter/material.dart';
import 'package:news_flash/cubit/news/news_cubit.dart';
import 'package:news_flash/data/getIt/init_get_it.dart';
import 'package:news_flash/view/explore/explore_screen.dart';
import 'package:news_flash/view/home/home_screen.dart';
import 'package:news_flash/view/news/favorite_news_page.dart';
import 'package:news_flash/view/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedBottomNavIndex = 0;
  final PageController _pageController = PageController();

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedBottomNavIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedBottomNavIndex = index;
          });
        },
        children: [
          HomeScreen(),
          ExploreScreen(),
          FavoriteNewsPage(cubit: getIt<NewsCubit>(),),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onBottomNavTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
