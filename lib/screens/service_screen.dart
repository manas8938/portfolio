import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../widgets/app_header.dart';
import '../../widgets/neon_background_screen.dart';

/// Services screen with shared AppHeader and animated cards
class ServiceScreen extends StatelessWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  static const List<ServiceItem> services = [
    ServiceItem(
      icon: Icons.android,
      title: 'Android App Development',
      subtitle: 'Let\'s build your next Flutter app!',
      skills: ['Flutter'],
    ),
    ServiceItem(
      icon: Icons.apple,
      title: 'iOS App Development',
      subtitle: 'Native experiences on Apple devices.',
      skills: ['Flutter'],
    ),
    ServiceItem(
      icon: Icons.storage,
      title: 'Back-End Development',
      subtitle: 'Scalable server-side solutions.',
      skills: ['Nest.JS', 'Docker', 'MySQL', 'Swagger'],
    ),
    ServiceItem(
      icon: Icons.design_services,
      title: 'UI/UX Design',
      subtitle: 'Intuitive, user-centric interfaces.',
      skills: ['Figma'],
    ),
    ServiceItem(
      icon: Icons.web,
      title: 'Web Development',
      subtitle: 'Responsive websites & PWAs.',
      skills: ['React', 'Flutter Web'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return NeonBackgroundScreen(
      child: SafeArea(
        bottom: true,
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Shared AppHeader
            const AppHeader(selected: NavItem.service),
            const SizedBox(height: 24),

            // Animated grid: 3 cards on top row, 2 on bottom
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 16 + bottomInset),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Center(
                      child: Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        alignment: WrapAlignment.center,
                        children: List.generate(services.length, (index) {
                          return SizedBox(
                            width: 260,
                            height: 260,
                            child: ServiceCard(item: services[index])
                                .animate(delay: (100 * index).ms)
                                .fadeIn(duration: 500.ms)
                                .moveY(begin: -20, end: 0, duration: 500.ms),
                          );
                        }),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data model for services
class ServiceItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> skills;

  const ServiceItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.skills,
  });
}

/// Card representation with neon shadow and hover effect
class ServiceCard extends StatefulWidget {
  final ServiceItem item;
  const ServiceCard({Key? key, required this.item}) : super(key: key);

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final neonColors = const [
      Color(0xFF00FFFF),
      Color(0xFF8A2BE2),
      Color(0xFFFF00FF),
    ];

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: _hovering ? LinearGradient(colors: neonColors) : null,
          boxShadow: neonColors
              .map((color) => BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 2,
            spreadRadius: 1,
            offset: const Offset(0, 0),
          ))
              .toList(),
        ),
        child: Card(
          color: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(widget.item.icon, size: 48, color: Colors.tealAccent),
                const SizedBox(height: 12),
                Text(
                  widget.item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.item.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const Spacer(),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children: widget.item.skills
                      .map((s) => Chip(
                    label: Text(
                      s,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.tealAccent,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    backgroundColor: Colors.black,
                    side: const BorderSide(color: Color(0xFF00FFFF), width: 1),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}