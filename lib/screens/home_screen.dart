import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html; // For Flutter Web file download
import '../widgets/app_header.dart';
import '../widgets/neon_background_screen.dart';

class AnimatedTitleText extends StatefulWidget {
  final bool isMobile;
  const AnimatedTitleText({super.key, required this.isMobile});

  @override
  State<AnimatedTitleText> createState() => _AnimatedTitleTextState();
}

class _AnimatedTitleTextState extends State<AnimatedTitleText>
    with SingleTickerProviderStateMixin {
  final List<String> _titles = [
    'A Mobile Application Developer',
    'A Web Developer',
    'A UI/UX Designer',
  ];
  int _currentIndex = 0;
  String _displayText = '';
  bool _isTyping = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    Future.delayed(Duration.zero, () {
      _startTypingAnimation();
    });
  }

  void _startTypingAnimation() async {
    final currentTitle = _titles[_currentIndex];
    _isTyping = true;
    _fadeController.forward();

    for (int i = 0; i <= currentTitle.length; i++) {
      if (!mounted) return;
      setState(() {
        _displayText = currentTitle.substring(0, i);
      });
      await Future.delayed(const Duration(milliseconds: 100));
    }

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      await _fadeController.reverse();
    }

    if (mounted) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _titles.length;
        _displayText = '';
      });
      _startTypingAnimation();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [Colors.tealAccent, Colors.tealAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
        blendMode: BlendMode.srcIn,
        child: Text(
          _displayText,
          textAlign: widget.isMobile ? TextAlign.center : TextAlign.left,
          style: GoogleFonts.poppins(
            fontSize: widget.isMobile ? 20 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NeonBackgroundScreen(
      child: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              children: [
                const SizedBox(height: 30),
                const AppHeader(selected: NavItem.home),
                const SizedBox(height: 40),
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
                  child: isMobile
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _buildIntroContent(context, isMobile),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildIntroContent(context, isMobile),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          );
        }),
      ),
    );
  }

  List<Widget> _buildIntroContent(BuildContext context, bool isMobile) {
    final textBlock = Flexible(
      flex: 1,
      child: Column(
        crossAxisAlignment:
        isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          _gradientText("Hi, I'm M.Anas Nawaz 👋", isMobile ? 28 : 30, isMobile),
          const SizedBox(height: 10),
          AnimatedTitleText(isMobile: isMobile),
          const SizedBox(height: 20),
          Text(
            "I am capable of creating Full-Stack Mobile App and Website.\nExplore my Resume below!",
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
          ),
          const SizedBox(height: 30),
          _downloadButton(context),
        ],
      ),
    );

    final double imageSize = isMobile ? 180.0 : 250.0;
    final profileImage = Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SizedBox(
        width: imageSize,
        height: imageSize,
        child: DecoratedBox(
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
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );

    if (isMobile) {
      return [
        profileImage,
        const SizedBox(height: 30),
        textBlock,
      ];
    } else {
      return [
        textBlock,
        const SizedBox(width: 50),
        profileImage,
      ];
    }
  }

  Widget _gradientText(String text, double size, bool isMobile) {
    return ShaderMask(
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
        text,
        textAlign: isMobile ? TextAlign.center : TextAlign.left,
        style: GoogleFonts.poppins(fontSize: size, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _downloadButton(BuildContext context) {
    return ShaderMask(
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
        onPressed: () {
          final resumePath = 'assets/anas_resume.pdf';
          final anchor = html.AnchorElement(href: resumePath)
            ..target = 'blank'
            ..download = 'Muhammad_Anas_Resume.pdf'
            ..click();
        },
        icon: const Icon(Icons.download, color: Colors.white),
        label: const Text('Download Resume', style: TextStyle(color: Colors.white)),
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
    );
  }
}
