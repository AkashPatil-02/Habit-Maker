import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habitmaker/BLoC/theme/themeCubit.dart';
import 'package:habitmaker/screens/createHabit.dart';
import 'package:habitmaker/screens/currentActivites.dart';
import 'package:habitmaker/screens/history.dart';
import 'package:habitmaker/themes/appTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;
  bool darkIcon=false;
  String date="";
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final List<Widget> _screens = [
    CurrentActivitiesScreen(),
    HistoryScreen()
  ];

  @override
  void initState() {
    initialize();
    super.initState();
  }
  Future<void> initialize()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    darkIcon = prefs.getBool('dark')!;
    date = prefs.getString('date')!;
    DateTime now = DateTime.now();
    prefs.setString('date',now.day.toString());
    //TODO: check whether the day has passed or not

  }
  
  void changeTheme(){
    context.read<Themecubit>().toggleTheme();
    setState(() {
      darkIcon=!darkIcon;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 0,                
        child: Icon(Icons.create_rounded),
        onPressed: (){   
        Navigator.push(context,MaterialPageRoute(builder: (context)=>CreatehabitScreen()));
      }),
      appBar: AppBar(
        title: const Text("Habit Maker"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            changeTheme();
          }, icon:Icon(!darkIcon ? Icons.light_mode_rounded:Icons.dark_mode_rounded ))
        ],      
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        // currentIndex: _currentIndex,
        index: _currentIndex,
        key: _bottomNavigationKey,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Theme.of(context).colorScheme.primary,
        color: AppTheme.primaryColor,
        items: <Widget>[
      Icon(Icons.local_fire_department_rounded,color: Colors.orange, size: 30),
      Icon(Icons.archive_rounded,color: Colors.white, size: 30),
    ],
    ),
    );
  }
}