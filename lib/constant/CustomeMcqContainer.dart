import 'package:nextgen_learners/constant/import_export.dart' hide AudioPlayer;
import 'package:audioplayers/audioplayers.dart';
import 'package:nextgen_learners/services/api_config.dart';
import 'dart:typed_data';

class CustomMCQWidget extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final String quizTitle;
  final String quizId;
  final void Function(dynamic questionId, bool isCorrect)? onAnswerSubmitted;

  const CustomMCQWidget({
    super.key,
    required this.questions,
    required this.quizTitle,
    required this.quizId,
    this.onAnswerSubmitted,
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

  // Store answers for each question
  Map<int, String> userAnswers = {};
  Map<int, bool> questionResults = {};
  Set<int> viewedQuestions = {};

  // Audio
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoadingSound = false;

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
    _initAudio();
    _loadProgress();
    viewedQuestions.add(0);
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

  void _initAudio() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  Future<void> _playOrStopSound() async {
    final questionData = widget.questions[currentQuestionIndex];
    final Uint8List? soundBytes = questionData['soundDataBytes'] as Uint8List?;
    final String soundUrl =
        (questionData['soundUrl'] ?? questionData['sound'] ?? '').toString();

    if (_isPlaying) {
      await _stopAudio();
    } else {
      setState(() {
        _isLoadingSound = true;
      });
      try {
        if (soundBytes != null && soundBytes.isNotEmpty) {
          await _audioPlayer.play(BytesSource(soundBytes));
        } else if (soundUrl.isNotEmpty) {
          await _audioPlayer.play(UrlSource(soundUrl));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error playing sound: $e')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoadingSound = false;
          });
        }
      }
    }
  }

  Future<void> _stopAudio() async {
    try {
      await _audioPlayer.stop();
    } catch (_) {}
  }

  @override
  void dispose() {
    try {
      _audioPlayer.stop();
    } catch (_) {}
    try {
      _audioPlayer.dispose();
    } catch (_) {}
    _pulseController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void selectAnswer(String answer) {
    if (userAnswers.containsKey(currentQuestionIndex))
      return; // Already answered
    setState(() {
      selectedAnswer = answer;
    });
  }

  void submitAnswer() {
    if (selectedAnswer == null || userAnswers.containsKey(currentQuestionIndex))
      return;

    setState(() {
      isAnswerSubmitted = true;
      userAnswers[currentQuestionIndex] = selectedAnswer!;
    });

    final q = widget.questions[currentQuestionIndex];
    final List<dynamic> opts =
        (q['options'] is List) ? q['options'] as List : <dynamic>[];
    String? correctAnswerText =
        (q['answer'] as String?) ?? (q['correctAnswer'] as String?);
    bool isCorrect;

    if (opts.isNotEmpty && opts.first is Map) {
      dynamic match;
      try {
        match = opts.firstWhere(
          (o) =>
              ((o['optionText'] ?? o['text'] ?? o['value'] ?? '').toString()) ==
              selectedAnswer,
        );
      } catch (_) {
        match = null;
      }
      isCorrect =
          match != null &&
          ((match['isCorrect'] == true) ||
              (match['correct'] == true) ||
              (match['answer'] == true));
      if (correctAnswerText == null) {
        try {
          final corr = opts.firstWhere(
            (o) =>
                o['isCorrect'] == true ||
                o['correct'] == true ||
                o['answer'] == true,
          );
          correctAnswerText =
              (corr['optionText'] ?? corr['text'] ?? corr['value'] ?? '')
                  .toString();
        } catch (_) {
          correctAnswerText = '';
        }
      }
    } else {
      isCorrect = selectedAnswer == correctAnswerText;
    }

    questionResults[currentQuestionIndex] = isCorrect;
    widget.onAnswerSubmitted?.call(q['questionId'], isCorrect);

    if (isCorrect) {
      setState(() {
        points += 10;
      });
      _saveProgress();
      _showEnhancedDialog(
        title: 'Fantastic! 🎉',
        message:
            (widget.questions[currentQuestionIndex]['funFact'] as String? ??
                widget.questions[currentQuestionIndex]['explanation']
                    as String? ??
                ''),
        isSuccess: true,
        onPressed: _handleDialogContinue,
      );
    } else {
      _showEnhancedDialog(
        title: 'Almost there! 🤔',
        message:
            'That\'s not quite right. The correct answer is $correctAnswerText. '
            '${(widget.questions[currentQuestionIndex]['funFact'] as String? ?? widget.questions[currentQuestionIndex]['explanation'] as String? ?? '')}',
        isSuccess: false,
        onPressed: _handleDialogContinue,
      );
    }
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
      builder:
          (context) => ScaleTransition(
            scale: _scaleAnimation,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  Icon(
                    isSuccess ? Icons.check_circle : Icons.error_outline,
                    color: isSuccess ? Colors.green[600] : Colors.red[600],
                    size: 30,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.purple[800],
                      ),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Text(
                  message.isEmpty ? 'No additional info available.' : message,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[800],
                    height: 1.4,
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _handleDialogContinue() {
    Navigator.of(context).pop();
    if (currentQuestionIndex < widget.questions.length - 1) {
      _nextQuestion();
    } else {
      _checkQuizCompletion();
    }
  }

  void _nextQuestion() async {
    if (currentQuestionIndex >= widget.questions.length - 1) {
      _checkQuizCompletion();
      return;
    }

    await _stopAudio();
    setState(() {
      currentQuestionIndex++;
      viewedQuestions.add(currentQuestionIndex);
      selectedAnswer = userAnswers[currentQuestionIndex];
      isAnswerSubmitted = userAnswers.containsKey(currentQuestionIndex);
      showHint = false;
      _slideController.reset();
      _scaleController.reset();
      _startAnimations();
    });
    _saveProgress();
  }

  void _previousQuestion() async {
    if (currentQuestionIndex <= 0) return;

    await _stopAudio();
    setState(() {
      currentQuestionIndex--;
      selectedAnswer = userAnswers[currentQuestionIndex];
      isAnswerSubmitted = userAnswers.containsKey(currentQuestionIndex);
      showHint = false;
      _slideController.reset();
      _scaleController.reset();
      _startAnimations();
    });
  }

  void _checkQuizCompletion() async {
    // Check if all questions are answered
    if (userAnswers.length == widget.questions.length) {
      await _markCompleted();
      Get.off(() => Dashboard(totalPoints: points));
    } else {
      // Show message that there are unanswered questions
      _showIncompleteQuizDialog();
    }
  }

  void _showIncompleteQuizDialog() {
    final unanswered = <int>[];
    for (int i = 0; i < widget.questions.length; i++) {
      if (!userAnswers.containsKey(i)) {
        unanswered.add(i + 1);
      }
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Quiz Not Complete',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.purple[800],
              ),
            ),
            content: Text(
              'You have ${unanswered.length} unanswered question(s): ${unanswered.join(", ")}.\n\nWould you like to go back and answer them?',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[800],
                height: 1.4,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _markCompleted();
                  Get.off(() => Dashboard(totalPoints: points));
                },
                child: Text(
                  'Submit Anyway',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.red[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    currentQuestionIndex = unanswered.first - 1;
                    selectedAnswer = null;
                    isAnswerSubmitted = false;
                  });
                },
                child: Text(
                  'Go to Question',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
    );
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
      final maxIndex =
          widget.questions.isEmpty ? 0 : (widget.questions.length - 1);
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

  String? _getCorrectAnswer(int index) {
    final q = widget.questions[index];
    final List<dynamic> opts =
        (q['options'] is List) ? q['options'] as List : <dynamic>[];
    String? correctAnswerText =
        (q['answer'] as String?) ?? (q['correctAnswer'] as String?);

    if (correctAnswerText == null && opts.isNotEmpty && opts.first is Map) {
      try {
        final corr = opts.firstWhere(
          (o) =>
              o['isCorrect'] == true ||
              o['correct'] == true ||
              o['answer'] == true,
        );
        correctAnswerText =
            (corr['optionText'] ?? corr['text'] ?? corr['value'] ?? '')
                .toString();
      } catch (_) {
        correctAnswerText = null;
      }
    }
    return correctAnswerText;
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
        body:
            widget.questions.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Container(
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
                                _buildQuestionNavigator(),
                                const SizedBox(height: 12),
                                // _buildProgressIndicator(),
                                // const SizedBox(height: 12),
                                _buildPointsDisplay(),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),

                          // Scrollable content
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
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

  // Widget _buildProgressIndicator() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [
  //           Colors.white.withOpacity(0.2),
  //           Colors.white.withOpacity(0.1),
  //         ],
  //       ),
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(color: Colors.white.withOpacity(0.3)),
  //     ),
  //     child: Column(
  //       children: [
  //         Text(
  //           'Question ${currentQuestionIndex + 1} of ${widget.questions.length}',
  //           style: GoogleFonts.poppins(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.purple[800],
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(10),
  //           child: LinearProgressIndicator(
  //             value: (currentQuestionIndex + 1) / widget.questions.length,
  //             backgroundColor: Colors.white.withOpacity(0.3),
  //             valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[400]!),
  //             minHeight: 8,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildQuestionNavigator() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.questions.length,
        itemBuilder: (context, index) {
          final bool isAnswered = userAnswers.containsKey(index);
          final bool isCorrect = questionResults[index] ?? false;
          final bool isCurrent = index == currentQuestionIndex;
          final bool isViewed = viewedQuestions.contains(index);

          Color bgColor;
          IconData? icon;

          if (isCurrent) {
            bgColor = Colors.purple[600]!;
          } else if (isAnswered) {
            bgColor = isCorrect ? Colors.green[500]! : Colors.red[500]!;
            icon = isCorrect ? Icons.check : Icons.close;
          } else if (isViewed) {
            bgColor = Colors.orange[400]!;
          } else {
            bgColor = Colors.grey[400]!;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  currentQuestionIndex = index;
                  selectedAnswer = userAnswers[index];
                  isAnswerSubmitted = userAnswers.containsKey(index);
                  viewedQuestions.add(index);
                  showHint = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isCurrent ? 50 : 40,
                height: isCurrent ? 50 : 40,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                  border:
                      isCurrent
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                  boxShadow: [
                    BoxShadow(
                      color: bgColor.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child:
                      icon != null
                          ? Icon(icon, color: Colors.white, size: 20)
                          : Text(
                            '${index + 1}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isCurrent ? 16 : 14,
                            ),
                          ),
                ),
              ),
            ),
          );
        },
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
        questionData['imageUrl'] as String? ??
        questionData['image'] as String? ??
        questionData['imagePath'] as String?;
    final Uint8List? soundBytes = questionData['soundDataBytes'] as Uint8List?;
    final String soundUrl =
        (questionData['soundUrl'] ?? questionData['sound'] ?? '').toString();
    final bool hasSound =
        (soundBytes != null && soundBytes.isNotEmpty) || soundUrl.isNotEmpty;

    final String normalizedImage = (imagePath ?? '').trim();
    String? networkImageUrl;
    if (normalizedImage.isNotEmpty) {
      if (normalizedImage.startsWith('http') ||
          normalizedImage.startsWith('data:')) {
        networkImageUrl = normalizedImage;
      } else if (normalizedImage.startsWith('/')) {
        networkImageUrl = ApiConfig.baseHost + normalizedImage.substring(1);
      } else if (!normalizedImage.startsWith('assets/')) {
        networkImageUrl = ApiConfig.baseHost + normalizedImage;
      }
    }

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
          if (normalizedImage.isNotEmpty)
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
                child:
                    networkImageUrl != null
                        ? Image.network(
                          networkImageUrl,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey[400],
                                  size: 40,
                                ),
                              ),
                        )
                        : Image.asset(
                          normalizedImage,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey[400],
                                  size: 40,
                                ),
                              ),
                        ),
              ),
            ),
          Text(
            (questionData['questionText'] ?? questionData['question'] ?? '')
                .toString(),
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.purple[800],
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          if (hasSound)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoadingSound ? null : _playOrStopSound,
                icon:
                    _isLoadingSound
                        ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : Icon(
                          _isPlaying ? Icons.stop_circle : Icons.volume_up,
                        ),
                label: Text(_isPlaying ? 'Stop Sound' : 'Play Sound'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[500],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
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
              (widget.questions[currentQuestionIndex]['hint'] as String? ??
                  'Keep trying!'),
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
    final bool isReviewMode = userAnswers.containsKey(currentQuestionIndex);
    final String? userAnswer = userAnswers[currentQuestionIndex];
    final String? correctAnswer = _getCorrectAnswer(currentQuestionIndex);

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
          itemCount:
              ((widget.questions[currentQuestionIndex]['options'] as List?) ??
                      const [])
                  .length,
          itemBuilder: (context, index) {
            final options =
                (widget.questions[currentQuestionIndex]['options'] as List?) ??
                const [];
            final opt = options[index];
            final String option =
                (opt is Map)
                    ? (opt['optionText'] ?? opt['text'] ?? opt['value'] ?? '')
                        .toString()
                    : opt.toString();

            bool isSelected = selectedAnswer == option;
            bool isUserAnswer = userAnswer == option;
            bool isCorrect = option == correctAnswer;

            Color buttonColor;
            IconData? icon;

            if (isReviewMode) {
              if (isCorrect) {
                buttonColor = Colors.green[400]!;
                icon = Icons.check_circle;
              } else if (isUserAnswer && !isCorrect) {
                buttonColor = Colors.red[400]!;
                icon = Icons.cancel;
              } else {
                buttonColor = Colors.grey[400]!;
              }
            } else if (isAnswerSubmitted) {
              if (isCorrect) {
                buttonColor = Colors.green[400]!;
              } else if (isSelected && !isCorrect) {
                buttonColor = Colors.red[400]!;
              } else {
                buttonColor = Colors.grey[400]!;
              }
            } else {
              buttonColor =
                  isSelected ? Colors.purple[500]! : Colors.blue[400]!;
            }

            return TweenAnimationBuilder(
              duration: Duration(milliseconds: 300 + (index * 100)),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: GestureDetector(
                    onTap: isReviewMode ? null : () => selectAnswer(option),
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
                            blurRadius: isSelected || isUserAnswer ? 12 : 6,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border:
                            (isSelected || isUserAnswer)
                                ? Border.all(color: Colors.white, width: 2.5)
                                : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap:
                              isReviewMode ? null : () => selectAnswer(option),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (icon != null)
                                  Icon(icon, color: Colors.white, size: 22),
                                if (icon != null) const SizedBox(height: 6),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Previous Question Button
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: currentQuestionIndex > 0 ? _previousQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    currentQuestionIndex > 0
                        ? Colors.purple[600]
                        : Colors.grey[400],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: currentQuestionIndex > 0 ? 5 : 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back, size: 20, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Previous',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Hint Button
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: toggleHint,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    showHint ? Icons.lightbulb_outline : Icons.lightbulb,
                    size: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    showHint ? 'Hide Hint' : 'Show Hint',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Next/Submit Button
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ElevatedButton(
              onPressed:
                  userAnswers.containsKey(currentQuestionIndex)
                      ? _nextQuestion
                      : selectedAnswer != null
                      ? submitAnswer
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    userAnswers.containsKey(currentQuestionIndex) ||
                            selectedAnswer != null
                        ? Colors.purple[600]
                        : Colors.grey[400],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation:
                    userAnswers.containsKey(currentQuestionIndex) ||
                            selectedAnswer != null
                        ? 5
                        : 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userAnswers.containsKey(currentQuestionIndex)
                        ? 'Next'
                        : 'Submit',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
