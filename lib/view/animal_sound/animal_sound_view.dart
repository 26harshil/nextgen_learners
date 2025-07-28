import 'package:flutter/material.dart';

class AnimalSoundView extends StatelessWidget {
  const AnimalSoundView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for the current question
    const String question = 'Which animal makes this sound?';
    const List<String> options = ['Lion', 'Elephant', 'Dog', 'Cat'];
    const String hint = 'This animal has a loud roar and a big mane.';
    const String funFact = '🦁 Lions roar to talk to their pride and scare other animals. Their roar can be heard 5 miles away!';
    const bool showHint = false; // Toggle to true to show hint
    const bool showFunFact = false; // Toggle to true to show fun fact
    const String selectedAnswer = 'Lion'; // Dummy selected answer
    const String correctAnswer = 'Lion'; // Dummy correct answer
    const int points = 0; // Dummy points

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4CAF50),
              Color(0xFF2196F3),
              Color(0xFFFF9800),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Sound icon
                GestureDetector(
                  onTap: () {}, // Placeholder for sound playback
                  child: const Icon(
                    Icons.volume_up,
                    size: 120,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                const Text(
                  'Guess the Animal Sound!',
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
                    'Points: $points',
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
                      question,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Hint display
                if (showHint)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.yellow[100],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 6,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Hint: $hint',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.brown[700],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // Answer options
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        _buildAnswerButton(
                          context,
                          options[0],
                          Colors.green,
                          selectedAnswer,
                          correctAnswer,
                        ),
                        const SizedBox(height: 20),
                        _buildAnswerButton(
                          context,
                          options[1],
                          Colors.blue,
                          selectedAnswer,
                          correctAnswer,
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        _buildAnswerButton(
                          context,
                          options[2],
                          Colors.green,
                          selectedAnswer,
                          correctAnswer,
                        ),
                        const SizedBox(height: 20),
                        _buildAnswerButton(
                          context,
                          options[3],
                          Colors.blue,
                          selectedAnswer,
                          correctAnswer,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Fun fact display
                if (showFunFact)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 6,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      funFact,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                const SizedBox(height: 30),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    _buildActionButton(
                      context,
                      label: 'Submit Answer', // Placeholder: change to 'Next Question' after submission
                      color: Colors.blue[700]!,
                      onPressed: () {}, // Placeholder for submit/next logic
                      enabled: true, // Adjust based on your logic
                    ),
                   
                    _buildActionButton(
                      context,
                      label: 'Show Hint', // Placeholder: toggle to 'Hide Hint'
                      color: Colors.green[600]!,
                      onPressed: () {}, // Placeholder for hint toggle
                    ),
                    
                    _buildActionButton(
                      context,
                      label: 'Play Sound',
                      color: Colors.orange[600]!,
                      onPressed: () {}, // Placeholder for sound playback
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

  Widget _buildAnswerButton(
    BuildContext context,
    String answer,
    Color color,
    String selectedAnswer,
    String correctAnswer,
  ) {
    bool isSelected = selectedAnswer == answer;
    bool isCorrect = answer == correctAnswer;

    return GestureDetector(
      onTap: () {}, // Placeholder for answer selection
      child: Container(
        height: 60,
        width: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isSelected && isCorrect ? Colors.green[400]! : color,
              isSelected && !isCorrect ? Colors.red[400]! : color.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black26,
              offset: Offset(2, 2),
            ),
          ],
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Center(
          child: Text(
            answer,
            style: const TextStyle(
              fontSize: 18,
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
    bool enabled = true,
  }) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}