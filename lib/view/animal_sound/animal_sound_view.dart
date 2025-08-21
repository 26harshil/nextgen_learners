import 'package:nextgen_learners/constant/import_export.dart';

class AnimalSoundView extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final String quizId;
  const AnimalSoundView({super.key, required this.questions, required this.quizId});

  @override
  _AnimalSoundViewState createState() => _AnimalSoundViewState();
}

class _AnimalSoundViewState extends State<AnimalSoundView>
    with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int points = 0;
  bool showHint = false;
  bool showFunFact = false;
  String? selectedAnswer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Enhanced animation controllers
  late AnimationController _bounceController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _confettiController;

  late Animation<double> _bounceAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _confettiAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadProgress();
  }

  void _initializeAnimations() {
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _confettiAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _confettiController, curve: Curves.easeOut),
    );

    // Start initial animations
    _slideController.forward();
    _startPulseAnimation();
  }

  void _startPulseAnimation() {
    _pulseController.repeat(reverse: true);
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt('progress_${widget.quizId}') ?? 0;
    final savedPoints = prefs.getInt('points_${widget.quizId}') ?? 0;
    if (!mounted) return;
    setState(() {
      final maxIndex = widget.questions.isEmpty ? 0 : (widget.questions.length - 1);
      currentQuestionIndex = savedIndex.clamp(0, maxIndex);
      points = savedPoints;
    });
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('progress_${widget.quizId}', currentQuestionIndex);
    await prefs.setInt('points_${widget.quizId}', points);
  }

  Future<void> _markCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('completed_${widget.quizId}', true);
    await prefs.remove('progress_${widget.quizId}');
    await prefs.remove('points_${widget.quizId}');
    final badges = prefs.getStringList('badges') ?? [];
    if (!badges.contains(widget.quizId)) {
      badges.add(widget.quizId);
      await prefs.setStringList('badges', badges);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void playSound(String soundPath) async {
    try {
      _bounceController.forward().then((_) => _bounceController.reverse());
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      _showEnhancedAlert(
        title: 'Oops! 😺',
        message: 'Error playing sound. Try again!',
        icon: Icons.error_outline,
        color: Colors.red,
      );
    }
  }

  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      showFunFact = true;
      final correct = (widget.questions[currentQuestionIndex]['answer'] as String?) ?? '';
      if (answer == correct) {
        points += 10;
        _saveProgress();
        _confettiController.forward().then((_) => _confettiController.reset());
      }
      // Show quiz completion dialog only after the last question
      if (currentQuestionIndex == widget.questions.length - 1) {
        _showQuizComplete();
      }
    });
  }

  void _nextQuestion() async {
    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        showFunFact = false;
        showHint = false;
        _slideController.reset();
        _slideController.forward();
      });
      _saveProgress();
    } else {
      await _markCompleted();
      // Quiz complete, navigate to DashboardScreen
      Get.off(() => Dashboard(totalPoints: points));
    }
  }

  void _showQuizComplete() {
    final percentage = (points / (widget.questions.length * 10)) * 100;
    String message = '';
    String emoji = '';

    if (percentage >= 80) {
      message = 'Amazing! You\'re an animal sound expert! 🌟';
      emoji = '🎉';
    } else if (percentage >= 60) {
      message = 'Great job! You know your animal sounds well! 👏';
      emoji = '😊';
    } else {
      message = 'Good try! Keep learning about animal sounds! 💪';
      emoji = '🤗';
    }

    _showEnhancedAlert(
      title: 'Quiz Complete! $emoji',
      message:
          '$message\n\nFinal Score: $points/${widget.questions.length * 10} points\n(${percentage.toStringAsFixed(0)}%)',
      icon: Icons.celebration,
      color: Colors.green,
      onPressed: _nextQuestion,
    );
  }

  void _resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      points = 0;
      showHint = false;
      showFunFact = false;
      selectedAnswer = null;
    });
    _slideController.reset();
    _slideController.forward();
  }

  void toggleHint() {
    setState(() {
      showHint = !showHint;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sound Quiz')),
        body: const Center(child: Text('No questions available')),
      );
    }
    final currentQuestion = widget.questions[currentQuestionIndex];
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final currentColor = (currentQuestion['color'] as Color?) ?? Colors.blue;

    return Theme(
      data: _buildTheme(currentColor, isSmallScreen),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _buildEnhancedAppBar(context, isSmallScreen, currentColor),
        body: Container(
          decoration: _buildGradientBackground(currentColor),
          child: SafeArea(
            child: Stack(
              children: [
                _buildFloatingShapes(currentColor),
                _buildMainContent(
                  context,
                  currentQuestion,
                  screenWidth,
                  isSmallScreen,
                  currentColor,
                ),
                if (showFunFact && selectedAnswer == (currentQuestion['answer'] as String? ?? ''))
                  _buildConfettiOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ThemeData _buildTheme(Color currentColor, bool isSmallScreen) {
    return ThemeData(
      primaryColor: currentColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: currentColor,
        brightness: Brightness.light,
      ),
      textTheme: TextTheme(
        headlineMedium: GoogleFonts.poppins(
          fontSize: isSmallScreen ? 26 : 32,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 1.5,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: isSmallScreen ? 18 : 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: isSmallScreen ? 20 : 24,
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
    );
  }

  PreferredSizeWidget _buildEnhancedAppBar(
    BuildContext context,
    bool isSmallScreen,
    Color currentColor,
  ) {
    return AppBar(
      leading: _buildBackButton(),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              'assets/home_screen/buddy.png',
              height: isSmallScreen ? 28 : 32,
              width: isSmallScreen ? 28 : 32,
              fit: BoxFit.contain,
              semanticLabel: 'Animal Sound Quiz Logo',
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sound Quiz 🐾',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: isSmallScreen ? 16 : 18,
                ),
              ),
              Text(
                '${(widget.questions.isEmpty ? 0 : currentQuestionIndex + 1)}/${widget.questions.isEmpty ? 0 : widget.questions.length}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
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
              currentColor.withOpacity(0.9),
              currentColor.withOpacity(0.7),
            ],
          ),
        ),
      ),
      toolbarHeight: isSmallScreen ? 70 : 80,
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildGradientBackground(Color currentColor) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          currentColor.withOpacity(0.1),
          Colors.white,
          currentColor.withOpacity(0.05),
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }

  Widget _buildFloatingShapes(Color currentColor) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: FloatingShapesPainter(
              animation: _pulseAnimation.value,
              color: currentColor,
            ),
            child: Container(),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    Map<String, dynamic> currentQuestion,
    double screenWidth,
    bool isSmallScreen,
    Color currentColor,
  ) {
    return SlideTransition(
      position: _slideAnimation,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 20.0 : 40.0,
            vertical: isSmallScreen ? 20.0 : 40.0,
          ),
          child: Column(
            children: [
              _buildEnhancedProgressBar(isSmallScreen, currentColor),
              SizedBox(height: isSmallScreen ? 15 : 20),
              SizedBox(height: isSmallScreen ? 20 : 40),
              _buildEnhancedSoundButton(
                currentQuestion,
                isSmallScreen,
                currentColor,
              ),
              SizedBox(height: isSmallScreen ? 24 : 30),
              _buildAnimatedTitle(context),
              SizedBox(height: isSmallScreen ? 16 : 20),
              _buildEnhancedPointsDisplay(context, isSmallScreen, currentColor),
              SizedBox(height: isSmallScreen ? 30 : 40),
              _buildQuestionCard(
                context,
                currentQuestion,
                screenWidth,
                isSmallScreen,
                currentColor,
              ),
              SizedBox(height: isSmallScreen ? 15 : 20),
              _buildAnimatedHint(
                context,
                currentQuestion,
                screenWidth,
                isSmallScreen,
              ),
              SizedBox(height: isSmallScreen ? 25 : 30),
              _buildEnhancedAnswerGrid(
                context,
                currentQuestion,
                isSmallScreen,
                currentColor,
              ),
              SizedBox(height: isSmallScreen ? 20 : 25),
              _buildAnimatedFunFact(
                context,
                currentQuestion,
                screenWidth,
                isSmallScreen,
              ),
              SizedBox(height: isSmallScreen ? 30 : 40),

              _buildActionButtonsRow(
                context,
                currentQuestion,
                isSmallScreen,
                currentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedSoundButton(
    Map<String, dynamic> currentQuestion,
    bool isSmallScreen,
    Color currentColor,
  ) {
    return GestureDetector(
      onTap: () {
        final sp = currentQuestion['sound'] as String?;
        if (sp == null || sp.isEmpty) {
          _showEnhancedAlert(
            title: 'No sound',
            message: 'Sound unavailable for this question.',
            icon: Icons.volume_off,
            color: Colors.red,
          );
        } else {
          playSound(sp);
        }
      },
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimation.value,
            child: Container(
              width: isSmallScreen ? 120 : 140,
              height: isSmallScreen ? 120 : 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    currentColor.withOpacity(0.8),
                    currentColor.withOpacity(0.6),
                    currentColor.withOpacity(0.4),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: currentColor.withOpacity(0.3),
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    blurRadius: 40,
                    color: currentColor.withOpacity(0.1),
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.volume_up,
                    size: isSmallScreen ? 50 : 60,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedTitle(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1000),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                'Guess the Animal Sound! 🐾',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  background: Paint()..color = Colors.transparent,
                  foreground:
                      Paint()
                        ..shader = LinearGradient(
                          colors: [Colors.purple[600]!, Colors.blue[600]!],
                        ).createShader(
                          const Rect.fromLTWH(0.0, 0.0, 300.0, 70.0),
                        ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedPointsDisplay(
    BuildContext context,
    bool isSmallScreen,
    Color currentColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 24 : 32,
        vertical: isSmallScreen ? 16 : 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [currentColor.withOpacity(0.1), Colors.white],
        ),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: currentColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: currentColor.withOpacity(0.2),
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: Colors.amber[600],
            size: isSmallScreen ? 24 : 28,
          ),
          const SizedBox(width: 8),
          Text(
            'Points: $points',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: currentColor.withOpacity(0.8),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.star,
            color: Colors.amber[600],
            size: isSmallScreen ? 24 : 28,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    Map<String, dynamic> currentQuestion,
    double screenWidth,
    bool isSmallScreen,
    Color currentColor,
  ) {
    return Container(
      width: screenWidth * 0.9,
      constraints: const BoxConstraints(maxWidth: 600),
      padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, currentColor.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: currentColor.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: currentColor.withOpacity(0.1),
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            (currentQuestion['question'] as String? ?? 'Which animal makes this sound?'),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedHint(
    BuildContext context,
    Map<String, dynamic> currentQuestion,
    double screenWidth,
    bool isSmallScreen,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: showHint ? null : 0,
      child: AnimatedOpacity(
        opacity: showHint ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child:
            showHint
                ? Container(
                  width: screenWidth * 0.9,
                  constraints: const BoxConstraints(maxWidth: 600),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber[100]!, Colors.amber[50]!],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber[300]!, width: 2),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.amber.withOpacity(0.2),
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.amber[700], size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          (currentQuestion['hint'] as String? ?? 'Listen carefully for clues.'),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.brown[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildEnhancedAnswerGrid(
    BuildContext context,
    Map<String, dynamic> currentQuestion,
    bool isSmallScreen,
    Color currentColor,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: isSmallScreen ? 16 : 20,
        mainAxisSpacing: isSmallScreen ? 16 : 20,
        childAspectRatio: isSmallScreen ? 1.8 : 2.2,
      ),
      itemCount: ((currentQuestion['options'] as List?) ?? const []).length,
      itemBuilder: (context, index) {
        final opts = (currentQuestion['options'] as List?) ?? const [];
        final answer = opts[index].toString();
        return _buildEnhancedAnswerButton(
          context,
          answer,
          (currentQuestion['answer'] as String?) ?? '',
          isSmallScreen,
          currentColor,
          index,
        );
      },
    );
  }

  Widget _buildEnhancedAnswerButton(
    BuildContext context,
    String answer,
    String correctAnswer,
    bool isSmallScreen,
    Color currentColor,
    int index,
  ) {
    bool isSelected = selectedAnswer == answer;
    bool isCorrect = answer == correctAnswer;
    bool showResult = showFunFact;

    Color buttonColor;
    if (showResult) {
      if (isCorrect) {
        buttonColor = Colors.green;
      } else if (isSelected) {
        buttonColor = Colors.red;
      } else {
        buttonColor = Colors.grey;
      }
    } else {
      buttonColor = isSelected ? currentColor : Colors.blue[400]!;
    }

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 100)),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: GestureDetector(
            onTap:
                showFunFact
                    ? null
                    : () {
                      setState(() {
                        selectedAnswer = answer;
                      });
                    },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    buttonColor.withOpacity(0.8),
                    buttonColor.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isSelected ? Colors.white : buttonColor.withOpacity(0.3),
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: isSelected ? 15 : 8,
                    color: buttonColor.withOpacity(0.3),
                    offset: Offset(0, isSelected ? 6 : 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  answer,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedFunFact(
    BuildContext context,
    Map<String, dynamic> currentQuestion,
    double screenWidth,
    bool isSmallScreen,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: showFunFact ? null : 0,
      child: AnimatedOpacity(
        opacity: showFunFact ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child:
            showFunFact
                ? Container(
                  width: screenWidth * 0.9,
                  constraints: const BoxConstraints(maxWidth: 600),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[50]!, Colors.cyan[50]!],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue[200]!, width: 2),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        color: Colors.blue.withOpacity(0.1),
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.psychology, color: Colors.blue[600], size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          (currentQuestion['funFact'] as String? ?? ''),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.blue[900], height: 1.4),
                        ),
                      ),
                    ],
                  ),
                )
                : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildEnhancedProgressBar(bool isSmallScreen, Color currentColor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 20 : 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: currentColor,
                ),
              ),
              Text(
                '${(widget.questions.isEmpty ? 0 : currentQuestionIndex + 1)}/${widget.questions.isEmpty ? 0 : widget.questions.length}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: currentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 12,
            decoration: BoxDecoration(
              color: currentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: widget.questions.isEmpty ? 0 : (currentQuestionIndex + 1) / widget.questions.length,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(currentColor),
                minHeight: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsRow(
    BuildContext context,
    Map<String, dynamic> currentQuestion,
    bool isSmallScreen,
    Color currentColor,
  ) {
    return Wrap(
      spacing: isSmallScreen ? 12 : 16,
      runSpacing: isSmallScreen ? 12 : 16,
      alignment: WrapAlignment.center,
      children: [
        _buildEnhancedActionButton(
          context,
          label: showFunFact ? 'Next Question ➡️' : 'Submit Answer ✅',
          icon: showFunFact ? Icons.arrow_forward : Icons.check,
          color: Colors.blue[600]!,
          onPressed:
              showFunFact
                  ? () {
                    if (currentQuestionIndex < widget.questions.length - 1) {
                      _nextQuestion();
                    } else {
                      _showQuizComplete();
                    }
                  }
                  : () {
                    if (selectedAnswer != null) {
                      selectAnswer(selectedAnswer!);
                    } else {
                      _showEnhancedAlert(
                        title: 'Oops! 😺',
                        message: 'Please select an answer first!',
                        icon: Icons.warning,
                        color: Colors.orange,
                      );
                    }
                  },
          enabled: selectedAnswer != null || showFunFact,
          isSmallScreen: isSmallScreen,
        ),
        _buildEnhancedActionButton(
          context,
          label: showHint ? 'Hide Hint 🙈' : 'Show Hint 💡',
          icon: showHint ? Icons.visibility_off : Icons.lightbulb,
          color: Colors.amber[600]!,
          onPressed: toggleHint,
          isSmallScreen: isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildEnhancedActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    bool enabled = true,
    required bool isSmallScreen,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: Icon(icon, size: isSmallScreen ? 18 : 20),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[400],
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 20 : 28,
            vertical: isSmallScreen ? 14 : 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: enabled ? 8 : 2,
          shadowColor: color.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget _buildConfettiOverlay() {
    return AnimatedBuilder(
      animation: _confettiAnimation,
      builder: (context, child) {
        return Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: ConfettiPainter(animation: _confettiAnimation.value),
            ),
          ),
        );
      },
    );
  }

  void _showEnhancedAlert({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        final isSmallScreen = MediaQuery.of(ctx).size.width < 600;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: Colors.white,
          title: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.1), Colors.white],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: isSmallScreen ? 24 : 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 16 : 18,
                color: Colors.black87,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton(
                  onPressed: onPressed ?? () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 32 : 40,
                      vertical: isSmallScreen ? 12 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 6,
                  ),
                  child: Text(
                    'OK',
                    style: GoogleFonts.poppins(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Custom painter for floating shapes background
class FloatingShapesPainter extends CustomPainter {
  final double animation;
  final Color color;

  FloatingShapesPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color.withOpacity(0.05)
          ..style = PaintingStyle.fill;

    // Draw floating circles
    for (int i = 0; i < 8; i++) {
      final x = (size.width * 0.1) + (i * size.width * 0.15);
      final y =
          (size.height * 0.1) + (sin((animation * 2 * pi) + (i * 0.5)) * 20);

      canvas.drawCircle(
        Offset(x, y),
        10 + (sin(animation * pi + i) * 5),
        paint,
      );
    }

    // Draw floating triangles
    for (int i = 0; i < 5; i++) {
      final x = size.width * 0.8;
      final y =
          (size.height * 0.2) +
          (i * size.height * 0.15) +
          (cos((animation * 2 * pi) + (i * 0.7)) * 15);

      final path = Path();
      path.moveTo(x, y);
      path.lineTo(x + 15, y + 20);
      path.lineTo(x - 15, y + 20);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom painter for confetti effect
class ConfettiPainter extends CustomPainter {
  final double animation;

  ConfettiPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];

    for (int i = 0; i < 50; i++) {
      final paint =
          Paint()
            ..color = colors[i % colors.length].withOpacity(
              1.0 - (animation * 0.7),
            );

      final x =
          (size.width * (i % 10) * 0.1) + (sin(animation * pi * 2 + i) * 20);
      final y = (animation * size.height * 1.5) - (i * 10);

      if (y > 0 && y < size.height) {
        canvas.drawCircle(Offset(x, y), 4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
