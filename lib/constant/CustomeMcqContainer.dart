import 'package:nextgen_learners/constant/import_export.dart' hide AudioPlayer;

class CustomMCQWidget extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final String quizTitle;
  final String quizId;

  const CustomMCQWidget({
    super.key,
    required this.questions,
    required this.quizTitle,
    required this.quizId,
  });

  @override
  State<CustomMCQWidget> createState() => _CustomMCQWidgetState();
}

class _CustomMCQWidgetState extends State<CustomMCQWidget>
    with TickerProviderStateMixin {
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
    _loadProgress();
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
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );
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

    final correctAnswer =
        widget.questions[currentQuestionIndex]['answer'] as String? ??
        widget.questions[currentQuestionIndex]['correctAnswer'] as String;
    bool isCorrect = selectedAnswer == correctAnswer;

    if (isCorrect) {
      setState(() {
        points += 10;
      });
      _saveProgress();
      _showEnhancedDialog(
        title: 'Fantastic! 🎉',
        message:
            widget.questions[currentQuestionIndex]['funFact'] as String? ??
            widget.questions[currentQuestionIndex]['explanation'] as String,
        isSuccess: true,
        onPressed: _nextQuestion,
      );
    } else {
      _showEnhancedDialog(
        title: 'Almost there! 🤔',
        message:
            'That\'s not quite right. The correct answer is $correctAnswer. ${widget.questions[currentQuestionIndex]['funFact'] as String? ?? widget.questions[currentQuestionIndex]['explanation'] as String}',
        isSuccess: false,
        onPressed: _nextQuestion,
      );
    }
  }

  void _nextQuestion() async {
    Navigator.of(context).pop();
    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        isAnswerSubmitted = false;
        showHint = false;
        _slideController.reset();
        _scaleController.reset();
        _startAnimations();
      });
      _saveProgress();
    } else {
      await _markCompleted();
      // Quiz complete, navigate to DashboardScreen
      Get.off(() => Dashboard(totalPoints: points));
    }
  }

  void toggleHint() {
    setState(() {
      showHint = !showHint;
    });
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt('progress_${widget.quizId}') ?? 0;
    final savedPoints = prefs.getInt('points_${widget.quizId}') ?? 0;
    if (!mounted) return;
    setState(() {
      currentQuestionIndex = savedIndex.clamp(0, widget.questions.length - 1);
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
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final availableHeight = screenHeight - appBarHeight - statusBarHeight;

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
              child: Column(
                children: [
                  // Fixed header section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Column(
                      children: [
                        _buildProgressIndicator(),
                        const SizedBox(height: 12),
                        _buildPointsDisplay(),
                      ],
                    ),
                  ),
                  
                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            _buildQuestionCard(),
                            const SizedBox(height: 16),
                            if (showHint) ...[
                              _buildHintCard(),
                              const SizedBox(height: 16),
                            ],
                            _buildAnswerOptions(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Fixed bottom action buttons
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: _buildActionButtons(),
                  ),
                ],
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
                colors: [
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.1),
                ],
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
          Expanded(
            child: ShaderMask(
              shaderCallback:
                  (bounds) => LinearGradient(
                    colors: [Colors.white, Colors.white.withOpacity(0.8)],
                  ).createShader(bounds),
              child: Text(
                widget.quizTitle,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
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
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            'Question ${currentQuestionIndex + 1} of ${widget.questions.length}',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.purple[800],
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / widget.questions.length,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[400]!),
              minHeight: 8,
            ),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber[300]!, Colors.orange[300]!],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                'Points: $value',
                style: GoogleFonts.poppins(
                  fontSize: 18,
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
    final questionData = widget.questions[currentQuestionIndex];
    final imagePath =
        questionData['image'] as String? ??
        questionData['imagePath'] as String?;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white.withOpacity(0.9)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.purple.withOpacity(0.1), width: 2),
      ),
      child: Column(
        children: [
          if (imagePath != null && imagePath.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imagePath.startsWith('http')
                    ? Image.network(
                        imagePath,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.image_not_supported, 
                                color: Colors.grey[400], size: 40),
                            ),
                      )
                    : Image.asset(
                        imagePath,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.image_not_supported, 
                                color: Colors.grey[400], size: 40),
                            ),
                      ),
              ),
            ),
          Text(
            questionData['question'],
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.purple[800],
              height: 1.3,
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber[300]!, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber[200],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lightbulb, color: Colors.amber[800], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.questions[currentQuestionIndex]['hint'],
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.amber[800],
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerOptions() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: constraints.maxWidth > 400 ? 1.8 : 1.6,
          ),
          itemCount: widget.questions[currentQuestionIndex]['options'].length,
          itemBuilder: (context, index) {
            String option =
                widget.questions[currentQuestionIndex]['options'][index];
            bool isSelected = selectedAnswer == option;
            bool isCorrect =
                option ==
                (widget.questions[currentQuestionIndex]['answer'] as String? ??
                    widget.questions[currentQuestionIndex]['correctAnswer']
                        as String);
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
              buttonColor = isSelected ? Colors.purple[500]! : Colors.blue[400]!;
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
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: buttonColor.withOpacity(0.4),
                            blurRadius: isSelected ? 12 : 6,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border:
                            isSelected
                                ? Border.all(color: Colors.white, width: 2.5)
                                : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => selectAnswer(option),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (showResult && isCorrect)
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                if (showResult && isSelected && !isCorrect)
                                  Icon(Icons.cancel, color: Colors.white, size: 22),
                                if (showResult) const SizedBox(height: 6),
                                Flexible(
                                  child: Text(
                                    option,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildEnhancedButton(
            label: isAnswerSubmitted ? 'Next Question' : 'Submit Answer',
            icon: isAnswerSubmitted ? Icons.arrow_forward : Icons.send,
            color: Colors.purple[600]!,
            onPressed: isAnswerSubmitted ? _nextQuestion : submitAnswer,
            enabled: selectedAnswer != null,
            isPrimary: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildEnhancedButton(
            label: showHint ? 'Hide Hint' : 'Show Hint',
            icon: Icons.lightbulb_outline,
            color: Colors.amber[600]!,
            onPressed: toggleHint,
            isPrimary: false,
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
    bool isPrimary = false,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow:
            enabled
                ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
                : null,
      ),
      child: ElevatedButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? color : Colors.grey[400],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: enabled ? 6 : 2,
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    isSuccess
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
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          isSuccess
                              ? [Colors.green[400]!, Colors.green[600]!]
                              : [Colors.orange[400]!, Colors.orange[600]!],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: (isSuccess ? Colors.green : Colors.orange)
                            .withOpacity(0.4),
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