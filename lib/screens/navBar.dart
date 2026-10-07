import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitmaker/BLoC/theme/themeCubit.dart';
import 'package:habitmaker/screens/createHabit.dart';
import 'package:habitmaker/screens/currentActivites.dart';
import 'package:habitmaker/screens/history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;
  bool darkIcon = false;
  String date = "";
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final List<Widget> _screens = [
    const CurrentActivitiesScreen(),
    const HistoryScreen(),
  ];

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      darkIcon = prefs.getBool('dark') ?? false;
      date = prefs.getString('date') ?? "";
    });
    DateTime now = DateTime.now();
    prefs.setString('date', now.day.toString());
  }

  void changeTheme() {
    context.read<Themecubit>().toggleTheme();
    setState(() {
      darkIcon = !darkIcon;
    });
  }

  @override
  Widget build(BuildContext context) {
    const bottomGradientColor = Color.fromARGB(255, 52, 41, 83);
    const navBarBarColor = Color.fromARGB(255, 28, 22, 48);
    const activeCircleColor = Color(0xFF6750A4);

    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 6,
        backgroundColor: activeCircleColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 30),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatehabitScreen()),
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: const Text(
          "Habit Maker",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: changeTheme,
            icon: Icon(
              !darkIcon ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: Colors.amberAccent,
            ),
          )
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        key: _bottomNavigationKey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: bottomGradientColor,
        color: navBarBarColor,
        buttonBackgroundColor: activeCircleColor,
        height: 60,
        items: <Widget>[
          Icon(
            Icons.local_fire_department_rounded,
            color: _currentIndex == 0 ? Colors.orangeAccent : Colors.white60,
            size: 30,
          ),
          Icon(
            Icons.archive_rounded,
            color: _currentIndex == 1 ? Colors.purpleAccent : Colors.white60,
            size: 30,
          ),
        ],
      ),
    );
  }
}