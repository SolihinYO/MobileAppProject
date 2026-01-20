import 'package:flutter/material.dart';
import 'booking_screen.dart';
import 'live_location_screen.dart';
import 'register_child_screen.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  int _selectedIndex = 0;

  // Senarai skrin yang dipanggil
  final List<Widget> _pages = [
    const BookingScreen(),
    const LiveLocationScreen(),
    const RegisterChildScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.blue.shade800,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.directions_bus), label: 'Booking'),
          BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Live Location'),
          BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Register Child'),
        ],
      ),
    );
  }
}