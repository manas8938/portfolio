import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/app_header.dart';
import '../../widgets/neon_background_screen.dart';
import '../models/project.dart';
import '../data/projects_data.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

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
            const AppHeader(selected: NavItem.projects),
            const SizedBox(height: 24),
            // Animated grid
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 16 + bottomInset),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 800;
                    final crossAxisCount = isMobile ? 1 : constraints.maxWidth > 1200 ? 3 : 2;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: isMobile ? 1 : 1,
                      ),
                      itemCount: myProjects.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 250,
                          height: 450,
                          child: ProjectCard(project: myProjects[index])
                              .animate(delay: (100 * index).ms)
                              .fadeIn(duration: 500.ms)
                              .moveY(begin: -20, end: 0, duration: 500.ms),
                        );
                      },
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

class ProjectCard extends StatefulWidget {
  final Project project;
  const ProjectCard({Key? key, required this.project}) : super(key: key);

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final neonColors = const [
      Color(0xFF00FFFF),
      Color(0xFF8A2BE2),
      Color(0xFFFF00FF),
    ];
    final neonGradient = LinearGradient(
      colors: neonColors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final isFypProject = widget.project.title == 'Parcel Delivery System App';

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: _hovering ? neonGradient : null,
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
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 4, // Increased from 3 to 4 for larger image
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      widget.project.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('Image load error: $error');
                        return Container(
                          color: Colors.grey[900],
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  color: Colors.white70,
                                  size: 50,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Image Not Found',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ShaderMask(
                  shaderCallback: (bounds) => neonGradient.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    widget.project.title.isNotEmpty
                        ? widget.project.title
                        : 'No Title',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.project.description.isNotEmpty
                      ? widget.project.description
                      : 'No Description',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                widget.project.techStack.isNotEmpty
                    ? Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children: widget.project.techStack
                      .map((tech) => Chip(
                    label: Text(
                      tech,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.tealAccent,
                      ),
                    ),
                    backgroundColor: Colors.black,
                    side: const BorderSide(
                      color: Color(0xFF00FFFF),
                      width: 1,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                  ))
                      .toList(),
                )
                    : const Text(
                  'No Tech Stack',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                if (isFypProject)
                  ShaderMask(
                    shaderCallback: (bounds) => neonGradient.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      'FYP Project',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  )
                else
                  ShaderMask(
                    shaderCallback: (bounds) => neonGradient.createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    blendMode: BlendMode.srcIn,
                    child: ElevatedButton(
                      onPressed: () async {
                        final url = Uri.parse(widget.project.repoUrl);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Couldn't launch project link")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.white),
                        ),
                      ),
                      child: const Text(
                        'View on GitHub',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}