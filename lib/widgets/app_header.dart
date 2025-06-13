import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/home_screen.dart';
import '../screens/service_screen.dart';
import '../screens/projects_screen.dart';
import '../screens/contact_screen.dart';

enum NavItem { home, service, projects, contact }

/// Shared top navigation bar with uniform background
class AppHeader extends StatelessWidget {
  final NavItem selected;
  const AppHeader({Key? key, required this.selected}) : super(key: key);

  // Labels for each nav item
  static const _labels = {
    NavItem.home: 'Home',
    NavItem.service: 'Service',
    NavItem.projects: 'Projects',
    NavItem.contact: 'Contact',
  };

  // Define consistent colors
  static const Color _bgColor = Colors.transparent; // removed background color
  static const Color _selectedColor = Color(0xFFFF00FF); // updated button color
  static const Color _unselectedColor = Color(0xFFFF00FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: NavItem.values.map((item) {
          final isSelected = item == selected;
          return GestureDetector(
            onTap: () {
              if (item == selected) return;
              Widget dest;
              switch (item) {
                case NavItem.service:
                  dest = const ServiceScreen();
                  break;
                case NavItem.projects:
                  dest = const ProjectsScreen();
                  break;
                case NavItem.contact:
                  dest = const ContactScreen();
                  break;
                case NavItem.home:
                default:
                  dest = const HomeScreen();
                  break;
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => dest),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _labels[item]!,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? _selectedColor : _unselectedColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
