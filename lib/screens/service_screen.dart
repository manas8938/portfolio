import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/neon_background_screen.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  static const List<ServiceItem> services = [
    ServiceItem(Icons.android, 'Android App Development',
        'Let\'s build your next Flutter app!', ['Flutter']),
    ServiceItem(Icons.apple, 'iOS App Development',
        'Native on Apple devices.', ['Flutter']),
    ServiceItem(Icons.storage, 'Back-End Development',
        'Scalable server-side solutions.', ['NestJS', 'Docker', 'MySQL', 'Swagger']),
    ServiceItem(Icons.design_services, 'UI/UX Design',
        'Intuitive interfaces.', ['Figma']),
    ServiceItem(Icons.web, 'Web Development',
        'Responsive websites & PWAs.', ['Html', 'CSS', 'React', 'Flutter Web']),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return NeonBackgroundScreen(
      child: SafeArea(
        bottom: true,
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            final bool isMobile = constraints.maxWidth < 600;
            return Column(
              children: [
                const SizedBox(height: 30),
                const AppHeader(selected: NavItem.service),
                const SizedBox(height: 24),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: bottomInset + 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Text section with fade-in
                          FadeInText(),
                          const SizedBox(height: 24),
                          // Cards based on layout
                          if (!isMobile)
                            SizedBox(
                              height: 260,
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: ServiceScreen.services.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 24),
                                itemBuilder: (ctx, i) {
                                  final double cardW = 260.0;
                                  return SizedBox(
                                    width: cardW,
                                    child: ServiceCard(
                                      item: ServiceScreen.services[i],
                                      index: i,
                                    ),
                                  );
                                },
                              ),
                            )
                          else
                            Column(
                              children: ServiceScreen.services.asMap().entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: ServiceCard(
                                    item: entry.value,
                                    index: entry.key,
                                  ),
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Fade-in animation for text section
class FadeInText extends StatefulWidget {
  @override
  _FadeInTextState createState() => _FadeInTextState();
}

class _FadeInTextState extends State<FadeInText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Column(
        children: [
          Text(
            'What I can do?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Skilled in full-stack App & Web development: React, Flutter, NestJS, REST APIs, MySQL, Docker, and responsive UI design.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class ServiceItem {
  final IconData icon;
  final String title, subtitle;
  final List<String> skills;
  const ServiceItem(this.icon, this.title, this.subtitle, this.skills);
}

class ServiceCard extends StatefulWidget {
  final ServiceItem item;
  final int index;
  const ServiceCard({Key? key, required this.item, required this.index}) : super(key: key);

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> with SingleTickerProviderStateMixin {
  bool _hovering = false;
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _rotation;
  late Animation<double> _opacity;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _rotation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _glow = Tween<double>(begin: 0.2, end: 0.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    // Staggered entrance based on index
    Future.delayed(Duration(milliseconds: widget.index * 200), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final neonCols = [
      const Color(0xFF00FFFF),
      const Color(0xFF8A2BE2),
      const Color(0xFFFF00FF),
    ];
    final Gradient neonGrad = LinearGradient(
      colors: neonCols,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..scale(_hovering ? 1.05 : _scale.value)
              ..rotateZ(_hovering ? 0.02 : _rotation.value),
            alignment: Alignment.center,
            child: Opacity(
              opacity: _opacity.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: _hovering ? neonGrad : null,
                  boxShadow: neonCols
                      .map((c) => BoxShadow(
                    color: c.withOpacity(_hovering ? 0.6 : _glow.value),
                    blurRadius: _hovering ? 12 : 6,
                    spreadRadius: _hovering ? 4 : 2,
                  ))
                      .toList(),
                ),
                child: Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(widget.item.icon, size: 48, color: Colors.tealAccent),
                        const SizedBox(height: 12),
                        Text(
                          widget.item.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
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
                            label: Text(s,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.tealAccent)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            backgroundColor: Colors.black,
                            side: const BorderSide(color: Color(0xFF00FFFF)),
                          ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}