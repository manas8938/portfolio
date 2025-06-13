import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/app_header.dart';
import '../../widgets/neon_background_screen.dart';

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
            // Shared AppHeader
            const AppHeader(selected: NavItem.contact),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 16 + bottomInset),
                child: Center(
                  child: SizedBox(
                    width: 300,
                    height: 400,
                    child: ContactCard()
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .moveY(begin: -20, end: 0, duration: 500.ms),
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

class _ContactCardState extends State<ContactCard> {
  bool _hovering = false;

  // Contact links with platform-specific icons
  final List<ContactItem> contacts = [
    ContactItem(
      icon: FontAwesomeIcons.whatsapp,
      title: 'WhatsApp',
      url: 'https://wa.me/03029125349', // Replace with your WhatsApp number
    ),
    ContactItem(
      icon: FontAwesomeIcons.github,
      title: 'GitHub',
      url: 'https://github.com/manas8938', // Replace with your GitHub profile
    ),
    ContactItem(
      icon: FontAwesomeIcons.instagram,
      title: 'Instagram',
      url: 'https://www.instagram.com/_ana7x_/', // Replace with your Instagram profile
    ),
    ContactItem(
      icon: FontAwesomeIcons.linkedin,
      title: 'LinkedIn',
      url: 'https://www.linkedin.com/in/muhammad-anas-nawaz-9730a8287/', // Replace with your LinkedIn profile
    ),
  ];

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
            spreadRadius: 1, // Fixed from 'spread-sets'
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
                ShaderMask(
                  shaderCallback: (bounds) => neonGradient.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    'Connect with Me',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Reach out through your preferred platform!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: contacts.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return ElevatedButton(
                        onPressed: () async {
                          final url = Uri.parse(contact.url);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Couldn't launch ${contact.title} link")),
                            );
                          }
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
                            FaIcon(
                              contact.icon,
                              color: Colors.tealAccent,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            ShaderMask(
                              shaderCallback: (bounds) => neonGradient.createShader(
                                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                              ),
                              blendMode: BlendMode.srcIn,
                              child: Text(
                                contact.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
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
  }
}

class ContactItem {
  final IconData icon;
  final String title;
  final String url;

  const ContactItem({
    required this.icon,
    required this.title,
    required this.url,
  });
}