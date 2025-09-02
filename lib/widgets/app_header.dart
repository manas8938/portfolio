import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/home_screen.dart';
import '../screens/service_screen.dart';
import '../screens/projects_screen.dart';
import '../screens/contact_screen.dart';

enum NavItem { home, service, projects, contact }

class AppHeader extends StatelessWidget {
  final NavItem selected;
  const AppHeader({Key? key, required this.selected}) : super(key: key);

  static const _labels = {
    NavItem.home: 'Home',
    NavItem.service: 'Service',
    NavItem.projects: 'Work',
    NavItem.contact: 'Contact',
  };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // breakpoint at 600px for mobile
      final isMobile = constraints.maxWidth < 600;
      final horizontalPadding = isMobile ? 16.0 : 40.0;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
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
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16),
                child: Text(
                  _labels[item]!,
                  style: GoogleFonts.poppins(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? const Color(0xFFFF00FF) : Colors.white,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}
