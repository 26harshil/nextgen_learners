// import 'dart:math';
// import 'package:confetti/confetti.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:haptic_feedback/haptic_feedback.dart';
// import 'package:nextgen_learners/constant/question.dart';

// class MathViews extends StatefulWidget {
//   const MathViews({super.key});

//   @override
//   _MathViewsState createState() => _MathViewsState();
// }

// class _MathViewsState extends State<MathViews> {

//   final List<String> messages = [
//     'You\'re a math star! 😊',
//     'Wow, keep shining! 🚀',
//     'You\'re unstoppable! 🌟'
//   ];

//   int currentQuestion = 0;
//   int score = 0;
//   int points = 0;
//   bool showConfetti = false;
//   bool showBadge = false;
//   bool wrongAnswer = false;
//   bool narrationOn = true;
//   late ConfettiController _confettiController;
//   late FlutterTts flutterTts;
//   double mascotScale = 1.0;
//   final List<bool> buttonTapped = [false, false, false, false];

//   @override
//   void initState() {
//     super.initState();
//     _confettiController = ConfettiController(duration: const Duration(seconds: 3));
//     flutterTts = FlutterTts();
//     _setupTts();
//     _speakQuestion();
//   }

//   void _setupTts() async {
//     await flutterTts.setLanguage('en-US');
//     await flutterTts.setPitch(1.2);
//     await flutterTts.setSpeechRate(0.5);
//   }

//   void _speakQuestion() async {
//     if (narrationOn) {
//       await flutterTts.speak(questions[currentQuestion]['question']);
//     }
//   }

//   @override
//   void dispose() {
//     _confettiController.dispose();
//     flutterTts.stop();
//     super.dispose();
//   }

//   void handleAnswer(String answer, int index) async {
//     await Haptics.vibrate(HapticsType.light);
//     setState(() {
//       buttonTapped[index] = true;
//       if (answer == questions[currentQuestion]['correct']) {
//         score++;
//         points += 10;
//         showConfetti = true;
//         _confettiController.play();
//         wrongAnswer = false;
//         mascotScale = 1.2;
//         messages.shuffle();
//         Future.delayed(const Duration(milliseconds: 500), () {
//           setState(() {
//             mascotScale = 1.0;
//             buttonTapped[index] = false;
//           });
//         });
//         Future.delayed(const Duration(seconds: 3), () {
//           setState(() {
//             showConfetti = false;
//             _confettiController.stop();
//           });
//         });
//       } else {
//         wrongAnswer = true;
//         messages.shuffle();
//         Future.delayed(const Duration(milliseconds: 500), () {
//           setState(() => buttonTapped[index] = false);
//         });
//       }

//       if (currentQuestion < questions.length - 1) {
//         currentQuestion++;
//         _speakQuestion();
//       } else {
//         showBadge = true;
//       }
//     });
//   }

//   void toggleNarration() async {
//     await Haptics.vibrate(HapticsType.light);
//     setState(() {
//       narrationOn = !narrationOn;
//       if (narrationOn) {
//         _speakQuestion();
//       } else {
//         flutterTts.stop();
//       }
//     });
//   }

//   void showHint() async {
//     await Haptics.vibrate(HapticsType.light);
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Text('Hint', style: GoogleFonts.nunito(color: Colors.orange[700], fontSize: 24, fontWeight: FontWeight.bold)),
//         content: Text(questions[currentQuestion]['hint'], style: GoogleFonts.nunito(fontSize: 18, color: Colors.grey[800])),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('OK', style: GoogleFonts.nunito(color: Colors.blue, fontSize: 18)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMascotAndTitle() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           AnimatedScale(
//             scale: mascotScale,
//             duration: const Duration(milliseconds: 300),
//             child: Image.asset(
//               'assets/home_screen/buddy.png',
//               width: 100,
//               height: 100,
//             ),
//           ),
//           Text(
//             'Math Adventure!',
//             style: GoogleFonts.nunito(
//               fontSize: 40,
//               fontWeight: FontWeight.bold,
//               color: Colors.orange[700],
//               shadows: [Shadow(blurRadius: 6, color: Colors.black.withOpacity(0.3), offset: const Offset(2, 2))],
//             ),
//           ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             margin: const EdgeInsets.only(top: 12),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(colors: [Colors.purple[600]!, Colors.purple[400]!]),
//               borderRadius: BorderRadius.circular(25),
//               boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26, offset: Offset(2, 2))],
//             ),
//             child: Text(
//               'Points: $points',
//               style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuestionCard() {
//     return Expanded(
//       child: Center(
//         child: Container(
//           width: double.infinity,
//           margin: const EdgeInsets.symmetric(horizontal: 24),
//           padding: const EdgeInsets.all(28),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(colors: [Colors.white, Colors.grey[100]!]),
//             borderRadius: BorderRadius.circular(30),
//             border: Border.all(color: Colors.blue[300]!, width: 3),
//             boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black26, offset: Offset(0, 6))],
//           ),
//           child: Text(
//             questions[currentQuestion]['question'],
//             style: GoogleFonts.nunito(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.indigo[800]),
//             textAlign: TextAlign.center,
//           ),
//         ).animate().rotate(begin: -0.02, end: 0.02, duration: 300.ms).then().rotate(begin: 0.02, end: -0.02, duration: 300.ms),
//       ),
//     );
//   }

//   Widget _buildAnswerButtons() {
//     final List<LinearGradient> buttonGradients = [
//       LinearGradient(colors: [Colors.red[600]!, Colors.red[400]!]),
//       LinearGradient(colors: [Colors.blue[600]!, Colors.blue[400]!]),
//       LinearGradient(colors: [Colors.green[600]!, Colors.green[400]!]),
//       LinearGradient(colors: [Colors.yellow[600]!, Colors.yellow[400]!]),
//     ];

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//       child: GridView.count(
//         shrinkWrap: true,
//         crossAxisCount: 2,
//         crossAxisSpacing: 20,
//         mainAxisSpacing: 20,
//         childAspectRatio: 1.2,
//         children: List.generate(4, (index) => GestureDetector(
//           onTap: () => handleAnswer(questions[currentQuestion]['answers'][index], index),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             transform: Matrix4.identity()..scale(buttonTapped[index] ? 0.95 : 1.0),
//             decoration: BoxDecoration(
//               gradient: buttonGradients[index],
//               borderRadius: BorderRadius.circular(30),
//               boxShadow: [
//                 BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.2), offset: const Offset(2, 2)),
//                 if (buttonTapped[index]) BoxShadow(blurRadius: 12, color: buttonGradients[index].colors[0].withOpacity(0.5)),
//               ],
//             ),
//             child: Center(
//               child: Text(
//                 questions[currentQuestion]['answers'][index],
//                 style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//             ),
//           ).animate().shake(duration: 300.ms, hz: 4, curve: Curves.easeInOut)
//         )),
//       ),
//     );
//   }

//   Widget _buildProgressBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               Container(
//                 height: 14,
//                 decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(7)),
//               ),
//               Container(
//                 height: 14,
//                 width: MediaQuery.of(context).size.width * ((currentQuestion + 1) / questions.length),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(colors: [Colors.blue[400]!, Colors.cyan[400]!]),
//                   borderRadius: BorderRadius.circular(7),
//                 ),
//               ).animate().slideX(begin: -1, duration: 500.ms),
//               Positioned(
//                 right: 0,
//                 child: Icon(Icons.star, size: 20, color: Colors.yellow[700]),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Text(
//             '${currentQuestion + 1}/${questions.length} Questions',
//             style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMotivationalMessage() {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.1))],
//         ),
//         child: Text(
//           wrongAnswer ? 'Oops, try again! 😄' : messages[0],
//           style: GoogleFonts.nunito(
//             fontSize: 26,
//             fontWeight: FontWeight.bold,
//             color: wrongAnswer ? Colors.red[600] : Colors.pink[600],
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8)),
//     );
//   }

//   Widget _buildNarrationToggle() {
//     return Positioned(
//       top: 20,
//       left: 20,
//       child: GestureDetector(
//         onTap: toggleNarration,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: narrationOn ? Colors.cyan[400] : Colors.grey[400],
//             boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.2))],
//           ),
//           child: Icon(
//             narrationOn ? Icons.mic : Icons.mic_off,
//             size: 30,
//             color: Colors.white,
//           ),
//         ).animate()
//       ),
//     );
//   }

//   Widget _buildHintButton() {
//     return Positioned(
//       bottom: 100,
//       right: 20,
//       child: ElevatedButton(
//         onPressed: showHint,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.yellow[400],
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//           elevation: 8,
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.lightbulb, color: Colors.white, size: 28),
//             const SizedBox(width: 10),
//             Text(
//               'Hint',
//               style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ],
//         ),
//       ).animate().scale(duration: 200.ms, curve: Curves.easeInOut),
//     );
//   }

//   Widget _buildBadgePopup() {
//     return Container(
//       color: Colors.black54,
//       child: Center(
//         child: Container(
//           padding: const EdgeInsets.all(28),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(30),
//             boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black26)],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.network(
//                 'https://via.placeholder.com/100?text=Star',
//                 width: 100,
//                 height: 100,
//                 color: Colors.yellow[700],
//               ).animate().rotate(duration: 1000.ms, curve: Curves.easeInOut),
//               Text(
//                 'Math Star Badge Earned!',
//                 style: GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.purple[600]),
//                 textAlign: TextAlign.center,
//               ).animate().fadeIn(duration: 600.ms),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => setState(() => showBadge = false),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue[600],
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                 ),
//                 child: Text(
//                   'Awesome!',
//                   style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextButton(
//                 onPressed: () {}, // Placeholder for share functionality
//                 child: Text(
//                   'Share Achievement',
//                   style: GoogleFonts.nunito(fontSize: 18, color: Colors.blue[600], fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.8, 0.8));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFFCE93D8), Color(0xFFF06292), Color(0xFF4DD0E1)],
//           ),
//         ),
//         child: Stack(
//           children: [
//             // Twinkling stars
//             ...List.generate(30, (index) => Positioned(
//               left: Random().nextDouble() * MediaQuery.of(context).size.width,
//               top: Random().nextDouble() * MediaQuery.of(context).size.height,
//               child: AnimatedContainer(
//                 duration: Duration(seconds: 1 + Random().nextInt(2)),
//                 width: 4 + Random().nextDouble() * 4,
//                 height: 4 + Random().nextDouble() * 4,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                   boxShadow: [BoxShadow(blurRadius: 4, color: Colors.white.withOpacity(0.3))],
//                 ),
//                 child: Opacity(opacity: (Random().nextDouble() * 0.5) + 0.4),
//               ).animate().fade(duration: 1500.ms, curve: Curves.easeInOut),
//             )),
//             // Floating clouds
//             Positioned(
//               top: 40,
//               right: 40,
//               child: Image.network(
//                 'https://via.placeholder.com/80x50?text=Cloud',
//                 width: 80,
//                 height: 50,
//                 color: Colors.white.withOpacity(0.8),
//               ).animate().moveX(begin: -20, end: 20, duration: 4000.ms, curve: Curves.easeInOut).then().moveX(begin: 20, end: -20),
//             ),
//             // Main content
//             SafeArea(
//               child: Column(
//                 children: [
//                   _buildMascotAndTitle(),
//                   _buildQuestionCard(),
//                   _buildAnswerButtons(),
//                   _buildProgressBar(),
//                   _buildMotivationalMessage(),
//                 ],
//               ),
//             ),
//             _buildNarrationToggle(),
//             _buildHintButton(),
//             Align(
//               alignment: Alignment.topCenter,
//               child: ConfettiWidget(
//                 confettiController: _confettiController,
//                 blastDirectionality: BlastDirectionality.explosive,
//                 particleDrag: 0.05,
//                 emissionFrequency: 0.05,
//                 numberOfParticles: 60,
//                 gravity: 0.05,
//                 colors: const [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.pink, Colors.purple],
//               ),
//             ),
//             if (showBadge) _buildBadgePopup(),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class MathViews extends StatelessWidget {
  const MathViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFCE93D8), Color(0xFFF06292), Color(0xFF4DD0E1)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo/icon
                Image.asset(
                  'assets/home_screen/buddy.png',
                  height: 120,
                  width: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),

                // Title
                const Text(
                  'Math Adventure Quest',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // Points display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black26,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'Points: 0',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Question display
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '1 + 2 = ?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Answer options
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        _buildAnswerButton(context, '3', Colors.purple),
                        const SizedBox(height: 20),
                        _buildAnswerButton(context, '1', Colors.red),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        _buildAnswerButton(context, '2', Colors.purple),
                        const SizedBox(height: 20),
                        _buildAnswerButton(context, '4', Colors.red),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      context,
                      label: 'Submit Answer',
                      color: Colors.blue[700]!,
                      onPressed: () {
                        // Add submit logic here
                      },
                    ),
                    const SizedBox(width: 20),
                    _buildActionButton(
                      context,
                      label: 'Hint',
                      color: Colors.green[600]!,
                      onPressed: () {
                        // Add hint logic here
                        showAlertDialog(
                          context: context,
                          title: "Hint",
                          message: "Here's a hint!",
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerButton(BuildContext context, String answer, Color color) {
    return GestureDetector(
      onTap: () {
        // Add answer selection logic here
      },
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withOpacity(0.7)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black26,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            answer,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}

void showAlertDialog({
  required BuildContext context,
  required String title,
  required String message,
  VoidCallback? onPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.purple[100],
        title: Row(
          children: [
            Icon(Icons.emoji_emotions, color: Colors.purple[600]),
            SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message, style: TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: onPressed ?? () => Navigator.of(ctx).pop(),
            child: Text("OK", style: TextStyle(color: Colors.purple[800])),
          ),
        ],
      );
    },
  );
}
