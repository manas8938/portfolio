import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'projects_screen.dart';
import 'service_screen.dart';
import 'contact_screen.dart';

class NeonBackgroundScreen extends StatelessWidget {
  final Widget child;

  const NeonBackgroundScreen({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: child,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NeonBackgroundScreen(
      child: Column(
        children: [
          const SizedBox(height: 30),
          _buildNavBar(context),
          Expanded(
            child: Center(
              child: _buildIntroSection(context),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ['Home', 'Service', 'Projects', 'Contact'].map((item) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
          onTap: () {
          switch (item) {
          case 'Projects':
          Navigator.push(
          context,
          MaterialPageRoute(
          builder: (_) => const ProjectsScreen(),
          ),
          );
          break;
          case 'Service':
          Navigator.push(
          context,
          MaterialPageRoute(
          builder: (_) => const ServiceScreen(),
          ),
          );
          break;
          case 'Contact':
          Navigator.push(
          context,
          MaterialPageRoute(
          builder: (_) => const ContactScreen(),
          ),
          );
          break;
          case 'Home':
          default:
          // Already on Home
          break;
          }
          },
          child: Text(
          item,
          style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          foreground: Paint()
          ..shader = const LinearGradient(
          colors: [
          Color(0xFF00FFFF),
          Color(0xFF8A2BE2),
          Color(0xFFFF00FF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
          ),
          ),
          ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIntroSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: isMobile
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: _buildIntroContent(context, isMobile),
          )
              : Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _buildIntroContent(context, isMobile),
          ),
        );
      },
    );
  }

  List<Widget> _buildIntroContent(BuildContext context, bool isMobile) {
    return [
      Column(
        crossAxisAlignment:
        isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFF00FFFF),
                Color(0xFF8A2BE2),
                Color(0xFFFF00FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            blendMode: BlendMode.srcIn,
            child: Text(
              "Hi, I'm M.Anas Nawaz 👋",
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFF00FFFF),
                Color(0xFF8A2BE2),
                Color(0xFFFF00FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            blendMode: BlendMode.srcIn,
            child: Text(
              "A Mobile Application Developer",
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "I build Full-Stack apps using Flutter, NestJS, and MySQL.\nExplore my Resume below!",
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFF00FFFF),
                Color(0xFF8A2BE2),
                Color(0xFFFF00FF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            blendMode: BlendMode.srcIn,
            child: ElevatedButton.icon(
              onPressed: () async {
                final url = Uri.parse('https://your-resume-link.com/resume.pdf');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Couldn't launch resume link")),
                  );
                }
              },
              icon: const Icon(Icons.download, color: Colors.white),
              label: const Text(
                'Download Resume',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.white),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
      SizedBox(width: isMobile ? 0 : 50, height: isMobile ? 30 : 0),
      Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00FFFF).withOpacity(0.6),
              blurRadius: 10,
              spreadRadius: 5,
            ),
            BoxShadow(
              color: const Color(0xFF8A2BE2).withOpacity(0.4),
              blurRadius: 50,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/anasprofile.jpeg',
            width: 250,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ];
  }
}
