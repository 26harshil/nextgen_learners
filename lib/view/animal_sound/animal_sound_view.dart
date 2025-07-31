import 'package:nextgen_learners/constant/import_export.dart';

class AnimalSoundView extends StatefulWidget {
  const AnimalSoundView({super.key});

  @override
  _AnimalSoundViewState createState() => _AnimalSoundViewState();
}

class _AnimalSoundViewState extends State<AnimalSoundView>
    with SingleTickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int points = 0;
  bool showHint = false;
  bool showFunFact = false;
  String? selectedAnswer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  final List<Map<String, dynamic>> questions = [
    {
      'question': '🦁 Which animal makes this sound?',
      'sound': 'sounds/lion_roar.mp3',
      'options': ['🦁 Lion', '🐘 Elephant', '🐶 Dog', '🐱 Cat'],
      'answer': '🦁 Lion',
      'hint': 'This animal has a loud roar and a big mane. 🦁',
      'funFact':
          '🦁 Lions roar to talk to their pride and scare other animals. Their roar can be heard 5 miles away!',
    },
    {
      'question': '🐘 Which animal makes this sound?',
      'sound': 'sounds/elephant_trumpet.mp3',
      'options': ['🦒 Giraffe', '🐘 Elephant', '🦓 Zebra', '🐻 Bear'],
      'answer': '🐘 Elephant',
      'hint': 'This animal trumpets with its long trunk. 🐘',
      'funFact':
          '🐘 Elephants trumpet to communicate over long distances. Their trumpets can be heard up to 6 miles away!',
    },
    {
      'question': '🐶 Which animal makes this sound?',
      'sound': 'sounds/dog_bark.mp3',
      'options': ['🐱 Cat', '🐶 Dog', '🦁 Lion', '🦒 Giraffe'],
      'answer': '🐶 Dog',
      'hint': 'This animal barks to alert or play. 🐾',
      'funFact':
          '🐶 Dogs bark to communicate with humans and other dogs, and each bark can mean different things!',
    },
    {
      'question': '🐱 Which animal makes this sound?',
      'sound': 'assets/sounds/cat_meow.mp3',
      'options': ['🐶 Dog', '🐱 Cat', '🐘 Elephant', '🦓 Zebra'],
      'answer': '🐱 Cat',
      'hint': 'This animal meows to get attention. 🐱',
      'funFact':
          '🐱 Cats meow mostly to communicate with humans, not other cats, and each meow has a unique tone!',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void playSound(String soundPath) async {
    try {
      _animationController.forward().then(
            (_) => _animationController.reverse(),
          );
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      showAlertDialog(
        context: context,
        title: 'Oops! 😺',
        message: 'Error playing sound. Try again!',
      );
    }
  }

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
        // Optionally, show a quiz completion screen or reset
        showAlertDialog(
          context: context,
          title: 'Quiz Complete! 🎉',
          message: 'You scored $points points!',
          onPressed: () {
            Navigator.of(context).pop(); // Close the alert
            setState(() {
              currentQuestionIndex = 0;
              points = 0;
              showHint = false;
              showFunFact = false;
              selectedAnswer = null;
            });
          },
        );
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Theme(
      data: ThemeData(
        primaryColor: Colors.green[600],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green[600],
          secondary: Colors.amber[400],
          surface: Colors.white,
        ),
        textTheme: TextTheme(
          headlineMedium: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 24 : 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
          headlineSmall: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 20 : 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          labelLarge: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      child: Scaffold(
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
                    colors: [Colors.green[600]!, Colors.green[400]!],
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
                height: isSmallScreen ? 28 : 32,
                width: isSmallScreen ? 28 : 32,
                fit: BoxFit.contain,
                semanticLabel: 'Animal Sound Quiz Logo',
              ),
              const SizedBox(width: 8),
              Text(
                'Sound Quiz 🐾',
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
                  Colors.green[100]!.withOpacity(0.3),
                  Colors.amber[100]!.withOpacity(0.3),
                ],
              ),
            ),
          ),
          toolbarHeight: isSmallScreen ? 56 : 64,
        
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green[50]!, Colors.amber[50]!, Colors.blue[50]!],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 16.0 : 32.0,
                          vertical: isSmallScreen ? 16.0 : 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Sound icon
                          GestureDetector(
                            onTap: () => playSound(currentQuestion['sound']),
                            child: AnimatedBuilder(
                              animation: _bounceAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _bounceAnimation.value,
                                  child: Container(
                                    padding: EdgeInsets.all(
                                      isSmallScreen ? 16 : 20,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.amber[400]!,
                                          Colors.amber[200]!,
                                        ],
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 8,
                                          color: Colors.black26,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.volume_up,
                                      size: isSmallScreen ? 60 : 80,
                                      color: Colors.white,
                                      semanticLabel: 'Play animal sound',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                          // Title
                          Text(
                            'Guess the Animal Sound! 🐾',
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                            semanticsLabel: 'Guess the Animal Sound Title',
                          ),
                          SizedBox(height: isSmallScreen ? 12 : 15),
                          // Points display
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 20 : 24,
                              vertical: isSmallScreen ? 10 : 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.black12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              'Points: $points 🌟',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.green[800]),
                              semanticsLabel: 'Points: $points',
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 24 : 30),
                          // Question display
                          Container(
                            width: screenWidth * 0.9,
                            constraints: const BoxConstraints(maxWidth: 600),
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 16 : 20,
                              horizontal: isSmallScreen ? 12 : 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.black12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              currentQuestion['question'],
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                              semanticsLabel: currentQuestion['question'],
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                          // Hint display
                          AnimatedOpacity(
                            opacity: showHint ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: showHint
                                ? Container(
                                    width: screenWidth * 0.9,
                                    constraints:
                                        const BoxConstraints(maxWidth: 600),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.amber[100]!.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 6,
                                          color: Colors.black12,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '💡 ${currentQuestion['hint']}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.copyWith(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.brown[700],
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                          // Answer options
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isSmallScreen ? 2 : 4,
                              crossAxisSpacing: isSmallScreen ? 12 : 16,
                              mainAxisSpacing: isSmallScreen ? 12 : 16,
                              childAspectRatio: isSmallScreen ? 2.0 : 2.5,
                            ),
                            itemCount: currentQuestion['options'].length,
                            itemBuilder: (context, index) {
                              final answer = currentQuestion['options'][index];
                              return _buildAnswerButton(
                                context,
                                answer,
                                answer == currentQuestion['answer']
                                    ? Colors.green[600]!
                                    : Colors.blue[400]!,
                                currentQuestion['answer'],
                                isSmallScreen,
                              );
                            },
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                          // Fun fact display
                          AnimatedOpacity(
                            opacity: showFunFact ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: showFunFact
                                ? Container(
                                    width: screenWidth * 0.9,
                                    constraints:
                                        const BoxConstraints(maxWidth: 600),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50]!.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 6,
                                          color: Colors.black12,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '🎉 ${currentQuestion['funFact']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.blue[900]),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          SizedBox(height: isSmallScreen ? 24 : 30),
                          // Progress bar
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                            ),
                            child: LinearProgressIndicator(
                              value: (currentQuestionIndex + 1) /
                                  questions.length,
                              backgroundColor: Colors.green[100],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green[600]!,
                              ),
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                          // Action buttons
                          Wrap(
                            spacing: isSmallScreen ? 12 : 16,
                            runSpacing: isSmallScreen ? 12 : 16,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildActionButton(
                                context,
                                label: showFunFact
                                    ? 'Next Question ➡️'
                                    : 'Submit Answer ✅',
                                color: Colors.blue[600]!,
                                onPressed: showFunFact
                                    ? nextQuestion
                                    : () {
                                        if (selectedAnswer != null) {
                                          selectAnswer(selectedAnswer!);
                                        } else {
                                          showAlertDialog(
                                            context: context,
                                            title: 'Oops! 😺',
                                            message:
                                                'Please select an answer first!',
                                          );
                                        }
                                      },
                                enabled: selectedAnswer != null || showFunFact,
                                isSmallScreen: isSmallScreen,
                              ),
                              _buildActionButton(
                                context,
                                label: showHint ? 'Hide Hint 🙈' : 'Show Hint 💡',
                                color: Colors.amber[600]!,
                                onPressed: toggleHint,
                                isSmallScreen: isSmallScreen,
                              ),
                              _buildActionButton(
                                context,
                                label: 'Play Sound 🔊',
                                color: Colors.orange[600]!,
                                onPressed:
                                    () => playSound(currentQuestion['sound']),
                                isSmallScreen: isSmallScreen,
                              ),
                            ],
                          ),
                          SizedBox(height: isSmallScreen ? 16 : 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
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
    bool isSmallScreen,
  ) {
    bool isSelected = selectedAnswer == answer;
    bool isCorrect = answer == correctAnswer;

    return GestureDetector(
      onTap: showFunFact
          ? null
          : () {
              setState(() {
                selectedAnswer = answer;
              });
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: isSmallScreen ? 60 : 70,
        // The width will be managed by GridView for responsiveness
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isSelected && isCorrect
                  ? Colors.green[500]!
                  : (isSelected && !isCorrect ? Colors.red[400]! : color),
              isSelected && isCorrect
                  ? Colors.green[700]!
                  : (isSelected && !isCorrect
                      ? Colors.red[600]!
                      : color.withOpacity(0.8)),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black12,
              offset: Offset(2, 2),
            ),
          ],
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              answer,
              style: Theme.of(
                context,
              ).textTheme.labelLarge!.copyWith(
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
              textAlign: TextAlign.center,
              semanticsLabel: answer,
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
    required bool isSmallScreen,
  }) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 24 : 32,
          vertical: isSmallScreen ? 12 : 16,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
        shadowColor: Colors.black26,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge!.copyWith(
                fontSize: isSmallScreen ? 14 : 16,
              ),
        ),
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
      final isSmallScreen = MediaQuery.of(ctx).size.width < 600;
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.green[50],
        title: Row(
          children: [
            Icon(
              Icons.pets,
              color: Colors.green[600],
              size: isSmallScreen ? 20 : 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[800],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 14 : 16,
            color: Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: onPressed ?? () => Navigator.of(ctx).pop(),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 14 : 16,
                color: Colors.green[800],
              ),
            ),
          ),
        ],
      );
    },
  );
}