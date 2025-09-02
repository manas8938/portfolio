import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_header.dart';
import '../widgets/neon_background_screen.dart';
import '../models/project.dart';
import '../data/projects_data.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  final int index;
  const ProjectCard({Key? key, required this.project, required this.index}) : super(key: key);

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> with SingleTickerProviderStateMixin {
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
    final neonGrad = LinearGradient(
      colors: neonCols,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final isFyp = widget.project.title.contains('Parcel Delivery');

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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Expanded(
                          flex: isFyp ? 4 : 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: widget.project.imagePath.isNotEmpty
                                ? Image.asset(widget.project.imagePath, fit: BoxFit.cover)
                                : Container(
                              color: Colors.grey[900],
                              child: const Center(
                                child: Icon(Icons.broken_image,
                                    color: Colors.white70, size: 50),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ShaderMask(
                          shaderCallback: (bounds) => neonGrad.createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                          blendMode: BlendMode.srcIn,
                          child: Text(
                            widget.project.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.project.description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.white70),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          alignment: WrapAlignment.center,
                          children: widget.project.techStack
                              .map((t) => Chip(
                            label: Text(t,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.tealAccent)),
                            backgroundColor: Colors.black,
                            side: const BorderSide(color: Color(0xFF00FFFF)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                          ))
                              .toList(),
                        ),
                        const SizedBox(height: 12),
                        if (isFyp)
                          ShaderMask(
                            shaderCallback: (bounds) => neonGrad.createShader(
                                Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                            blendMode: BlendMode.srcIn,
                            child: Text('FYP Project',
                                style: GoogleFonts.poppins(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                          )
                        else
                          ElevatedButton(
                            onPressed: () async {
                              final url = Uri.parse(widget.project.repoUrl);
                              if (await canLaunchUrl(url)) await launchUrl(url);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(color: Colors.white)),
                            ),
                            child: ShaderMask(
                              shaderCallback: (bounds) => neonGrad.createShader(
                                  Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                              blendMode: BlendMode.srcIn,
                              child: const Text('View on GitHub',
                                  style: TextStyle(color: Colors.white)),
                            ),
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

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToDirection({required bool isLeft}) {
    final double cardWidth = MediaQuery.of(context).size.width < 800
        ? MediaQuery.of(context).size.width * 0.7
        : 360.0;
    final double scrollOffset = _scrollController.offset + (isLeft ? -cardWidth : cardWidth);
    _scrollController.animateTo(
      scrollOffset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    // Sort projects to place FYP project first
    final sortedProjects = List<Project>.from(myProjects)
      ..sort((a, b) {
        if (a.title.contains('Parcel Delivery')) return -1;
        if (b.title.contains('Parcel Delivery')) return 1;
        return 0;
      });

    return NeonBackgroundScreen(
      child: SafeArea(
        bottom: true,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInHeader(),
                Expanded(
                  child: LayoutBuilder(
                    builder: (ctx, constraints) {
                      final isMobile = constraints.maxWidth < 800;
                      final cardWidth = isMobile
                          ? (constraints.maxWidth * 0.7).toDouble()
                          : 360.0;

                      return ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 64),
                        physics: const BouncingScrollPhysics(),
                        itemCount: sortedProjects.length,
                        itemBuilder: (context, index) {
                          final project = sortedProjects[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 24),
                            child: SizedBox(
                              width: cardWidth,
                              child: ProjectCard(project: project, index: index),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: bottomInset + 16),
              ],
            ),
            // Scroll Buttons
            Positioned(
              left: 16,
              top: 150,
              child: _ScrollButton(
                icon: Icons.arrow_left,
                onPressed: () => _scrollToDirection(isLeft: true),
              ),
            ),
            Positioned(
              right: 16,
              top: 150,
              child: _ScrollButton(
                icon: Icons.arrow_right,
                onPressed: () => _scrollToDirection(isLeft: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Fade-in animation for header
class FadeInHeader extends StatefulWidget {
  @override
  _FadeInHeaderState createState() => _FadeInHeaderState();
}

class _FadeInHeaderState extends State<FadeInHeader> with SingleTickerProviderStateMixin {
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
          const SizedBox(height: 30),
          const AppHeader(selected: NavItem.projects),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// Scroll Button Widget
class _ScrollButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ScrollButton({required this.icon, required this.onPressed});

  @override
  __ScrollButtonState createState() => __ScrollButtonState();
}

class __ScrollButtonState extends State<_ScrollButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final neonCols = [
      const Color(0xFF00FFFF),
      const Color(0xFF8A2BE2),
      const Color(0xFFFF00FF),
    ];
    final neonGrad = LinearGradient(
      colors: neonCols,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: _hovering ? neonGrad : null,
          boxShadow: neonCols
              .map((c) => BoxShadow(
            color: c.withOpacity(_hovering ? 0.6 : 0.3),
            blurRadius: _hovering ? 10 : 5,
            spreadRadius: _hovering ? 3 : 1,
          ))
              .toList(),
        ),
        child: IconButton(
          onPressed: widget.onPressed,
          icon: Icon(
            widget.icon,
            size: 40,
            color: Colors.tealAccent,
          ),
          style: IconButton.styleFrom(
            backgroundColor: Colors.black,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
          ),
        ),
      ),
    );
  }
}