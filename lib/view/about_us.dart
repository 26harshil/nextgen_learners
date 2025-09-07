import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple[400]!.withOpacity(0.9),
                Colors.cyan[300]!.withOpacity(0.9),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple[50]!,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/home_screen/buddy.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'NextGen Learners',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.purple[800],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'A playful and engaging learning app for kids! Explore quizzes across animals, colors, fruits, math, and more — complete challenges, earn badges, and learn with fun facts, hints, and sounds.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber[700]),
                            const SizedBox(width: 8),
                            Text(
                              'What we offer',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.purple[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _bullet('Fun and interactive MCQ quizzes'),
                        _bullet('Beautiful visuals and sounds for kids'),
                        _bullet('Hints, facts, and progress tracking'),
                        _bullet('Badges and achievements to motivate learning'),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Made with ❤️ to inspire little minds.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.purple[700],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18)),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
