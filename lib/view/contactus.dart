import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ContactUsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ContactUsPage extends StatelessWidget {
  final String youtubeUrl = "https://www.youtube.com/@sehr7754";
  final String facebookUrl =
      "https://www.facebook.com/profile.php?id=100082066110985";
  final String phoneNumber = "0515421151";
  final String websiteUrl = "https://sehr.pk";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        centerTitle: true,
        backgroundColor: Color(0xFF15BE77), // Set the app bar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ContactCard(
              title: 'YouTube',
              subtitle: 'Visit our YouTube Channel (@sehr7754)',
              icon: Icons.youtube_searched_for,
              color: Color(0xFF15BE77), // Set the card color
              onTap: () => _launchUrl(youtubeUrl),
            ),
            SizedBox(height: 16),
            ContactCard(
              title: 'Facebook',
              subtitle: 'Visit our Facebook Page (Sehr)',
              icon: Icons.facebook,
              color: Color(0xFF15BE77), // Set the card color
              onTap: () => _launchUrl(facebookUrl),
            ),
            SizedBox(height: 16),
            ContactCard(
              title: 'Call Us',
              subtitle: 'Click to Call (0515421151)',
              icon: Icons.phone,
              color: Color(0xFF15BE77), // Set the card color
              onTap: () => UrlLauncher.launch("tel://$phoneNumber"),
            ),
            SizedBox(height: 16),
            ContactCard(
              title: 'Website',
              subtitle: 'Visit our Website (https://sehr.pk)',
              icon: Icons.web,
              color: Color(0xFF15BE77), // Set the card color
              onTap: () => _launchUrl(websiteUrl),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchPhoneCall(String phoneNumber) async {
    final phoneUrl = 'tel://$phoneNumber';
    if (await canLaunchUrl(Uri.parse(phoneUrl))) {
      await launchUrl(Uri.parse(phoneUrl));
    } else {
      throw 'Could not launch $phoneUrl';
    }
  }
}

class ContactCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  ContactCard(
      {required this.title,
      required this.subtitle,
      required this.icon,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: color, // Set the card color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 40, color: Colors.white), // Set the icon color
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white), // Set the title text color
              ),
              SizedBox(height: 8),
              Text(subtitle,
                  style: TextStyle(
                      color: Colors.white)), // Set the subtitle text color
            ],
          ),
        ),
      ),
    );
  }
}
