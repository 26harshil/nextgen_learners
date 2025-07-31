import 'package:flutter/material.dart';
import 'package:nextgen_learners/constant/import_export.dart';

class MathViews extends StatefulWidget {
  const MathViews({super.key});

  @override
  State<MathViews> createState() => _MathViewsState();
}

class _MathViewsState extends State<MathViews> with TickerProviderStateMixin {
  // Dummy data for questions
  final List<Map<String, dynamic>> questions = [
    {
      'question': '2 🍎 + 3 🍎 = ?',
      'correctAnswer': '5 🍎',
      'options': ['4 🍎', '5 🍎', '6 🍎', '3 🍎'],
      'hint': 'Count all the apples together!',
      'explanation': 'When you have 2 apples and get 3 more, you have 5 apples in total!',
    },
    {
      'question': '1 ⭐ + 4 ⭐ = ?',
      'correctAnswer': '5 ⭐',
      'options': ['5 ⭐', '3 ⭐', '6 ⭐', '2 ⭐'],
      'hint': 'Add one star to four stars!',
      'explanation': 'One star plus four stars equals five shining stars!',
    },
    {
      'question': '3 🍌 + 2 🍌 = ?',
      'correctAnswer': '5 🍌',
      'options': ['4 🍌', '6 🍌', '5 🍌', '7 🍌'],
      'hint': 'Count all the bananas!',
      'explanation': 'Three bananas plus two bananas makes five delicious bananas!',
    },
  ];

  int currentQuestionIndex = 0;
  int points = 0;
  String? selectedAnswer;
  bool showHint = false;
  bool isAnswerSubmitted = false;
  
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.bounceOut),
    );

    _startAnimations();
  }

  void _startAnimations() {
    _slideController.forward();
    _scaleController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void selectAnswer(String answer) {
    if (isAnswerSubmitted) return;
    
    setState(() {
      selectedAnswer = answer;
    });
  }

  void submitAnswer() {
    if (selectedAnswer == null || isAnswerSubmitted) return;

    setState(() {
      isAnswerSubmitted = true;
    });

    bool isCorrect = selectedAnswer == questions[currentQuestionIndex]['correctAnswer'];
    
    if (isCorrect) {
      setState(() {
        points += 10;
      });
      
      _showEnhancedDialog(
        title: 'Fantastic! 🎉',
        message: questions[currentQuestionIndex]['explanation'],
        isSuccess: true,
        onPressed: _nextQuestion,
      );
    } else {
      _showEnhancedDialog(
        title: 'Almost there! 🤔',
        message: 'That\'s not quite right. The correct answer is ${questions[currentQuestionIndex]['correctAnswer']}',
        isSuccess: false,
        onPressed: _nextQuestion,
      );
    }
  }

  void _nextQuestion() {
    Navigator.of(context).pop();
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        currentQuestionIndex = 0; // Loop back to start
      }
      selectedAnswer = null;
      isAnswerSubmitted = false;
      showHint = false;
    });
    
    // Restart animations for new question
    _slideController.reset();
    _scaleController.reset();
    _startAnimations();
  }

  void toggleHint() {
    setState(() {
      showHint = !showHint;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.purple[700],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          primary: Colors.purple[600],
          secondary: Colors.cyan[400],
          surface: Colors.white,
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _buildEnhancedAppBar(context),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple[100]!,
                Colors.pink[100]!,
                Colors.cyan[50]!,
                Colors.purple[50]!,
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: SafeArea(
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // Animated mascot
                      _buildAnimatedMascot(),
                      
                      const SizedBox(height: 20),
                      
                      // Progress indicator
                      _buildProgressIndicator(),
                      
                      const SizedBox(height: 30),
                      
                      // Points display with animation
                      _buildPointsDisplay(),
                      
                      const SizedBox(height: 30),
                      
                      // Question display
                      _buildQuestionCard(),
                      
                      const SizedBox(height: 20),
                      
                      // Hint display
                      if (showHint) _buildHintCard(),
                      
                      const SizedBox(height: 30),
                      
                      // Answer options
                      _buildAnswerOptions(),
                      
                      const SizedBox(height: 40),
                      
                      // Action buttons
                      _buildActionButtons(),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildEnhancedAppBar(BuildContext context) {
    return AppBar(
      leading: Tooltip(
        message: 'Back to previous screen',
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple[600]!, Colors.purple[400]!],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Get.back(),
              borderRadius: BorderRadius.circular(16),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
              ),
            ),
            child: Image.asset(
              'assets/home_screen/buddy.png',
              height: 28,
              width: 28,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0.8)],
            ).createShader(bounds),
            child: Text(
              'Math Quest',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
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
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Colors.amber[600], size: 16),
              const SizedBox(width: 4),
             
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedMascot() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/home_screen/buddy.png',
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            'Question ${currentQuestionIndex + 1} of ${questions.length}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.purple[800],
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (currentQuestionIndex + 1) / questions.length,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[400]!),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildPointsDisplay() {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: points),
      duration: const Duration(milliseconds: 800),
      builder: (context, value, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber[300]!, Colors.orange[300]!],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                'Points: $value',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white.withOpacity(0.9)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.purple.withOpacity(0.1), width: 2),
      ),
      child: Column(
        children: [
          Icon(
            Icons.psychology,
            color: Colors.purple[400],
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            questions[currentQuestionIndex]['question'],
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.purple[800],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHintCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.yellow[100]!, Colors.amber[50]!],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber[300]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb, color: Colors.amber[700], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              questions[currentQuestionIndex]['hint'],
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.amber[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerOptions() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: questions[currentQuestionIndex]['options'].length,
      itemBuilder: (context, index) {
        String option = questions[currentQuestionIndex]['options'][index];
        bool isSelected = selectedAnswer == option;
        bool isCorrect = option == questions[currentQuestionIndex]['correctAnswer'];
        bool showResult = isAnswerSubmitted;

        Color buttonColor;
        if (showResult) {
          if (isCorrect) {
            buttonColor = Colors.green[400]!;
          } else if (isSelected && !isCorrect) {
            buttonColor = Colors.red[400]!;
          } else {
            buttonColor = Colors.grey[400]!;
          }
        } else {
          buttonColor = isSelected ? Colors.purple[400]! : Colors.blue[400]!;
        }

        return TweenAnimationBuilder(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: GestureDetector(
                onTap: () => selectAnswer(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [buttonColor, buttonColor.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: buttonColor.withOpacity(0.4),
                        blurRadius: isSelected ? 15 : 8,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => selectAnswer(option),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (showResult && isCorrect)
                              Icon(Icons.check_circle, color: Colors.white, size: 24),
                            if (showResult && isSelected && !isCorrect)
                              Icon(Icons.cancel, color: Colors.white, size: 24),
                            const SizedBox(height: 8),
                            Text(
                              option,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
Widget _buildActionButtons() {
  final screenWidth = MediaQuery.of(context).size.width;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Flexible(
        flex: 1,
        child: _buildEnhancedButton(
          label: isAnswerSubmitted ? 'Next Question' : 'Submit Answer',
          icon: isAnswerSubmitted ? Icons.arrow_forward : Icons.send,
          color: Colors.purple[600]!,
          onPressed: isAnswerSubmitted ? _nextQuestion : submitAnswer,
          enabled: selectedAnswer != null,
        ),
      ),
      const SizedBox(width: 16),
      Flexible(
        flex: 1,
        child: _buildEnhancedButton(
          label: showHint ? 'Hide Hint' : 'Show Hint',
          icon: Icons.lightbulb_outline,
          color: Colors.amber[600]!,
          onPressed: toggleHint,
        ),
      ),
    ],
  );
}

Widget _buildEnhancedButton({
  required String label,
  required IconData icon,
  required Color color,
  required VoidCallback onPressed,
  bool enabled = true,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final padding = screenWidth < 400 ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10) : const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      boxShadow: enabled
          ? [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ]
          : null,
    ),
    child: ElevatedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon, size: screenWidth < 400 ? 18 : 20),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: screenWidth < 400 ? 14 : 16,
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? color : Colors.grey[400],
        foregroundColor: Colors.white,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: enabled ? 8 : 2,
      ),
    ),
  );
}
  void _showEnhancedDialog({
    required String title,
    required String message,
    required bool isSuccess,
    required VoidCallback onPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSuccess 
                    ? [Colors.green[50]!, Colors.green[100]!]
                    : [Colors.orange[50]!, Colors.orange[100]!],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSuccess ? Colors.green[400] : Colors.orange[400],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? Icons.celebration : Icons.psychology,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isSuccess ? Colors.green[800] : Colors.orange[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSuccess 
                          ? [Colors.green[400]!, Colors.green[600]!]
                          : [Colors.orange[400]!, Colors.orange[600]!],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: (isSuccess ? Colors.green : Colors.orange).withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}