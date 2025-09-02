import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_header.dart';
import '../widgets/neon_background_screen.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return NeonBackgroundScreen(
      child: SafeArea(
        bottom: true,
        child: Column(
          children: [
            const SizedBox(height: 30),
            const AppHeader(selected: NavItem.contact),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 16 + bottomInset),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width < 600 ? 280 : 300,
                    height: 400,
                    child: ContactCard()
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .moveX(begin: -30, end: 0, duration: 500.ms),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactCard extends StatefulWidget {
  const ContactCard({Key? key}) : super(key: key);

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> with SingleTickerProviderStateMixin {
  bool _hovering = false;

  final contacts = [
    ContactItem(FontAwesomeIcons.whatsapp, 'WhatsApp', 'https://wa.me/03029125349'),
    ContactItem(FontAwesomeIcons.github, 'GitHub', 'https://github.com/manas8938'),
    ContactItem(FontAwesomeIcons.instagram, 'Instagram', 'https://instagram.com/_ana7x_/'),
    ContactItem(FontAwesomeIcons.linkedin, 'LinkedIn',
        'https://linkedin.com/in/muhammad-anas-nawaz-9730a8287'),
  ];

  late AnimationController _cardController;
  late Animation<double> _cardScale;
  late Animation<double> _cardGlow;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _cardScale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );
    _cardGlow = Tween<double>(begin: 0.4, end: 0.6).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final neonCols = [
      const Color(0xFF00FFFF),
      const Color(0xFF8A2BE2),
      const Color(0xFFFF00FF),
    ];
    final neonGrad = LinearGradient(colors: neonCols, begin: Alignment.topLeft, end: Alignment.bottomRight);

    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovering = true);
        _cardController.forward();
      },
      onExit: (_) {
        setState(() => _hovering = false);
        _cardController.reverse();
      },
      child: AnimatedBuilder(
        animation: _cardController,
        builder: (context, child) {
          return Transform.scale(
            scale: _hovering ? _cardScale.value : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: _hovering ? neonGrad : null,
                boxShadow: neonCols
                    .map((c) => BoxShadow(
                  color: c.withOpacity(_hovering ? _cardGlow.value : 0.4),
                  blurRadius: _hovering ? 10 : 2,
                  spreadRadius: _hovering ? 6 : 1,
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
                      FadeInText(
                        child: ShaderMask(
                          shaderCallback: (b) => neonGrad.createShader(Rect.fromLTWH(0, 0, b.width, b.height)),
                          blendMode: BlendMode.srcIn,
                          child: Text(
                            'Connect with Me',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeInText(
                        delay: 200.ms,
                        child: Text(
                          'Reach out through your preferred platform!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: ListView.separated(
                          itemCount: contacts.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (ctx, i) {
                            final cItem = contacts[i];
                            return AnimatedContactButton(
                              index: i,
                              contact: cItem,
                              neonGrad: neonGrad,
                            );
                          },
                        ),
                      ),
                    ],
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

// Fade-in animation for text
class FadeInText extends StatefulWidget {
  final Widget child;
  final Duration? delay;

  const FadeInText({Key? key, required this.child, this.delay}) : super(key: key);

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
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    Future.delayed(widget.delay ?? Duration.zero, () {
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
    return FadeTransition(
      opacity: _opacity,
      child: widget.child,
    );
  }
}

// Animated contact button
class AnimatedContactButton extends StatefulWidget {
  final int index;
  final ContactItem contact;
  final Gradient neonGrad;

  const AnimatedContactButton({
    Key? key,
    required this.index,
    required this.contact,
    required this.neonGrad,
  }) : super(key: key);

  @override
  _AnimatedContactButtonState createState() => _AnimatedContactButtonState();
}

class _AnimatedContactButtonState extends State<AnimatedContactButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _translateY;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _translateY = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(0, _translateY.value),
            child: child,
          ),
        );
      },
      child: ElevatedButton(
        onPressed: () async {
          final url = Uri.parse(widget.contact.url);
          if (await canLaunchUrl(url)) await launchUrl(url);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.white),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(widget.contact.icon, color: Colors.tealAccent, size: 24),
            const SizedBox(width: 12),
            ShaderMask(
              shaderCallback: (b) =>
                  widget.neonGrad.createShader(Rect.fromLTWH(0, 0, b.width, b.height)),
              blendMode: BlendMode.srcIn,
              child: Text(
                widget.contact.title,
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactItem {
  final IconData icon;
  final String title, url;
  const ContactItem(this.icon, this.title, this.url);
}