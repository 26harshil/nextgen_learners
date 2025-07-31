import 'package:nextgen_learners/constant/import_export.dart';

class AnimalNameView extends StatefulWidget {
  const AnimalNameView({super.key});

  @override
  _AnimalQuizState createState() => _AnimalQuizState();
}

class _AnimalQuizState extends State<AnimalNameView> {
  int currentQuestionIndex = 0;
  int points = 0;
  bool showHint = false;
  bool showFunFact = false;
  String? selectedAnswer;

  final List<Map<String, dynamic>> questions = [
    {
      'image':
          'https://tse1.mm.bing.net/th/id/OIP.PtoTy3zxmq89LA_fx2_rbAHaHq?rs=1&pid=ImgDetMain&o=7&rm=3',
      'question': 'Which animal is known as the King of the Jungle?',
      'options': ['Elephant', 'Tiger', 'Lion', 'Bear'],
      'answer': 'Lion',
      'hint': 'This animal is a big cat with a majestic mane.',
      'funFact':
          '🦁 Lions are called the King of the Jungle because of their strength, leadership, and majestic appearance. They live in groups called prides.',
    },
    {
      'image':
          'https://tse3.mm.bing.net/th/id/OIP.TGg5wMD-jRwcZyz1IxXH6gHaIN?w=1154&h=1280&rs=1&pid=ImgDetMain&o=7&rm=3',
      'question': 'Which animal has black and white stripes?',
      'options': ['Leopard', 'Giraffe', 'Zebra', 'Cow'],
      'answer': 'Zebra',
      'hint': 'This animal’s pattern is unique like a fingerprint.',
      'funFact':
          '🦓 Each zebra has a unique stripe pattern, which helps them blend into the grasslands and confuse predators.',
    },
    {
      'image':
          'https://img.freepik.com/premium-vector/cute-elephant-cartoon_160606-195.jpg?w=2000',
      'question': 'Which animal is the largest land mammal?',
      'options': ['Hippo', 'Elephant', 'Rhino', 'Buffalo'],
      'answer': 'Elephant',
      'hint': 'This animal has a long trunk and large ears.',
      'funFact':
          '🐘 Elephants can weigh up to 6,000 kg. They have long trunks used for drinking water, grabbing food, and social interactions.',
    },
    // Add more questions as needed, following the same structure
    // For brevity, only 3 questions are included here; extend the list to include all 50 questions similarly
  ];

  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      showFunFact = true;
      if (answer == questions[currentQuestionIndex]['answer']) {
        points += 10;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        currentQuestionIndex = 0; // Loop back to start
      }
      showHint = false;
      showFunFact = false;
      selectedAnswer = null;
    });
  }

  void toggleHint() {
    setState(() {
      showHint = !showHint;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        leading: Tooltip(
          message: 'Back to previous screen',
          child: InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple[600]!, Colors.purple[400]!],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 6,
                    color: Colors.black26,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
                semanticLabel: 'Back',
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/home_screen/buddy.png',
              height: 32,
              width: 32,
              fit: BoxFit.contain,
              semanticLabel: 'Math Adventure Quest Logo',
            ),
            const SizedBox(width: 8),
            Text(
              'Math Quest',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0.1),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple[100]!.withOpacity(0.3),
                Colors.pink[100]!.withOpacity(0.3),
              ],
            ),
          ),
        ),
        toolbarHeight: 64,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4CAF50), Color(0xFF2196F3), Color(0xFFFF9800)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo/icon
                Image.network(
                  currentQuestion['image'],
                  height: 120,
                  width: 120,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (context, error, stackTrace) => const Icon(
                        Icons.pets,
                        size: 120,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 20),

                // Title
                const Text(
                  'Guess the Animal!',
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
                  child: Center(
                    child: Text(
                      currentQuestion['question'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
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
                      'Hint: ${currentQuestion['hint']}',
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
                          currentQuestion['options'][0],
                          Colors.green,
                          currentQuestion['answer'],
                        ),
                        const SizedBox(height: 20),
                        _buildAnswerButton(
                          context,
                          currentQuestion['options'][1],
                          Colors.blue,
                          currentQuestion['answer'],
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        _buildAnswerButton(
                          context,
                          currentQuestion['options'][2],
                          Colors.green,
                          currentQuestion['answer'],
                        ),
                        const SizedBox(height: 20),
                        _buildAnswerButton(
                          context,
                          currentQuestion['options'][3],
                          Colors.blue,
                          currentQuestion['answer'],
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
                      currentQuestion['funFact'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.blue[900]),
                    ),
                  ),
                const SizedBox(height: 30),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      context,
                      label: showFunFact ? 'Next Question' : 'Submit Answer',
                      color: Colors.blue[700]!,
                      onPressed:
                          showFunFact
                              ? nextQuestion
                              : () {
                                if (selectedAnswer != null) {
                                  selectAnswer(selectedAnswer!);
                                }
                              },
                      enabled: selectedAnswer != null || showFunFact,
                    ),
                    const SizedBox(width: 20),
                    _buildActionButton(
                      context,
                      label: showHint ? 'Hide Hint' : 'Show Hint',
                      color: Colors.green[600]!,
                      onPressed: toggleHint,
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
    String correctAnswer,
  ) {
    bool isSelected = selectedAnswer == answer;
    bool isCorrect = answer == correctAnswer;

    return GestureDetector(
      onTap:
          showFunFact
              ? null
              : () {
                setState(() {
                  selectedAnswer = answer;
                });
              },
      child: Container(
        height: 60,
        width: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isSelected && isCorrect ? Colors.green[400]! : color,
              isSelected && !isCorrect
                  ? Colors.red[400]!
                  : color.withOpacity(0.7),
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
