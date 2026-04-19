import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math' as math;
import 'dart:convert';

import 'package:nextgen_learners/constant/import_export.dart';

class AnimalSoundView extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final String quizId;

  const AnimalSoundView({
    super.key,
    required this.questions,
    required this.quizId,
  });

  @override
  _AnimalSoundViewState createState() => _AnimalSoundViewState();
}

class _AnimalSoundViewState extends State<AnimalSoundView> with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int points = 0;
  bool showHint = false;
  bool showFunFact = false;
  String? selectedAnswer;
  bool hasSubmitted = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isLoading = false;

  Map<int, String> userAnswers = {};
  Map<int, bool> questionResults = {};
  Set<int> viewedQuestions = {0};
  bool isAnswerSubmitted = false;

  late AnimationController _bounceController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _confettiController;
  late AnimationController _scaleController;

  late Animation<double> _bounceAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _confettiAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadProgress();
    _audioPlayer.setLoopMode(LoopMode.off);
    if (widget.questions.isNotEmpty) {
      _playSound();
    }
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

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
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
    final savedAnswersStr = prefs.getString('answers_${widget.quizId}');
    Map<int, String> loadedAnswers = {};
    if (savedAnswersStr != null) {
      final Map<String, String> decoded = json.decode(savedAnswersStr);
      loadedAnswers = decoded.map((k, v) => MapEntry(int.parse(k), v));
    }
    final savedResultsStr = prefs.getString('results_${widget.quizId}');
    Map<int, bool> loadedResults = {};
    if (savedResultsStr != null) {
      final Map<String, bool> decoded = json.decode(savedResultsStr);
      loadedResults = decoded.map((k, v) => MapEntry(int.parse(k), v));
    }
    final savedViewedStr = prefs.getString('viewed_${widget.quizId}');
    Set<int> loadedViewed = {0};
    if (savedViewedStr != null) {
      final List<String> decoded = json.decode(savedViewedStr);
      loadedViewed = decoded.map((s) => int.parse(s)).toSet();
    }
    if (!mounted) return;
    setState(() {
      final maxIndex = widget.questions.isEmpty ? 0 : (widget.questions.length - 1);
      currentQuestionIndex = savedIndex.clamp(0, maxIndex);
      points = savedPoints;
      userAnswers = loadedAnswers;
      questionResults = loadedResults;
      viewedQuestions = loadedViewed;
      viewedQuestions.add(currentQuestionIndex);
      selectedAnswer = userAnswers[currentQuestionIndex];
      hasSubmitted = userAnswers.containsKey(currentQuestionIndex);
      isAnswerSubmitted = hasSubmitted;
      showHint = false;
      showFunFact = false;
    });
    if (widget.questions.isNotEmpty) {
      _playSound();
    }
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('progress_${widget.quizId}', currentQuestionIndex);
    await prefs.setInt('points_${widget.quizId}', points);
    final encodedAnswers = json.encode(
      userAnswers.map((k, v) => MapEntry(k.toString(), v)),
    );
    final encodedResults = json.encode(
      questionResults.map((k, v) => MapEntry(k.toString(), v)),
    );
    final encodedViewed = json.encode(viewedQuestions.map((i) => i.toString()).toList());
    await prefs.setString('answers_${widget.quizId}', encodedAnswers);
    await prefs.setString('results_${widget.quizId}', encodedResults);
    await prefs.setString('viewed_${widget.quizId}', encodedViewed);
  }

  Future<void> _resetQuiz() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('progress_${widget.quizId}');
    await prefs.remove('points_${widget.quizId}');
    await prefs.remove('answers_${widget.quizId}');
    await prefs.remove('results_${widget.quizId}');
    await prefs.remove('viewed_${widget.quizId}');
    await prefs.remove('completed_${widget.quizId}');
    final badges = prefs.getStringList('badges') ?? [];
    badges.remove(widget.quizId);
    await prefs.setStringList('badges', badges);
    setState(() {
      userAnswers.clear();
      questionResults.clear();
      viewedQuestions.clear();
      viewedQuestions.add(0);
      currentQuestionIndex = 0;
      points = 0;
      selectedAnswer = null;
      hasSubmitted = false;
      isAnswerSubmitted = false;
      showHint = false;
      showFunFact = false;
      _slideController.reset();
      _slideController.forward();
    });
    await _playSound();
    Get.off(() => AnimalSoundView(
          questions: widget.questions,
          quizId: widget.quizId,
        ));
  }

  Future<void> _markCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Check if all questions are attempted
    final allQuestionsAttempted = userAnswers.length == widget.questions.length;
    
    // Count correct answers
    final correctCount = questionResults.values.where((result) => result).length;
    final halfQuestions = widget.questions.length / 2.0;
    final halfCorrect = correctCount >= halfQuestions;
    
    // Only mark as completed and award badge if all questions attempted and at least half are correct
    if (allQuestionsAttempted && halfCorrect) {
      await prefs.setBool('completed_${widget.quizId}', true);
      final badges = prefs.getStringList('badges') ?? [];
      if (!badges.contains(widget.quizId)) {
        badges.add(widget.quizId);
        await prefs.setStringList('badges', badges);
      }
    }
    
    // Always clear progress data
    await prefs.remove('progress_${widget.quizId}');
    await prefs.remove('points_${widget.quizId}');
    await prefs.remove('answers_${widget.quizId}');
    await prefs.remove('results_${widget.quizId}');
    await prefs.remove('viewed_${widget.quizId}');
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _confettiController.dispose();
    _scaleController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    final soundPath = widget.questions[currentQuestionIndex]['soundUrl']?.toString() ?? '';
    if (soundPath.isNotEmpty) {
      await playSound(soundPath);
    }
  }

  Future<void> playSound(String soundPath) async {
    if (soundPath.isEmpty) {
      _showEnhancedAlert(
        title: 'No Sound',
        message: 'No audio file available for this sound.',
        icon: Icons.volume_off,
        color: Colors.orange,
      );
      return;
    }

    try {
      setState(() => _isLoading = true);

      await _audioPlayer.stop();

      String audioUrl = soundPath;
      if (!audioUrl.startsWith('http')) {
        audioUrl = ApiConfig.soundUrl(audioUrl);
      } else if (audioUrl.startsWith('http://')) {
        audioUrl = audioUrl.replaceFirst('http://', 'https://');
      }

      print('Attempting to play audio from: $audioUrl');

      int maxRetries = 3;
      int retryCount = 0;
      bool success = false;
      List<int> retryDelays = [2, 5, 10];

      while (retryCount < maxRetries && !success) {
        try {
          await _audioPlayer.setUrl(audioUrl, preload: true);
          await _audioPlayer.play();
          success = true;
          _bounceController.forward().then((_) => _bounceController.reverse());
        } catch (e) {
          retryCount++;
          print('Attempt $retryCount failed. Error: $e');
          if (retryCount < maxRetries) {
            final delaySeconds = retryDelays[retryCount - 1];
            print('Retrying in $delaySeconds seconds...');
            await Future.delayed(Duration(seconds: delaySeconds));
          } else {
            throw e;
          }
        }
      }

      if (!success) {
        throw Exception('Failed after $maxRetries retries');
      }
    } catch (e) {
      print('Error playing sound: $e');
      if (mounted) {
        _showEnhancedAlert(
          title: 'Playback Error',
          message: 'Could not play the sound. The server might be starting up. Please try again in a moment.',
          icon: Icons.error_outline,
          color: Colors.red,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void selectAnswer(String answer) {
    if (hasSubmitted || userAnswers.containsKey(currentQuestionIndex)) return;
    setState(() {
      selectedAnswer = answer;
      _scaleController.forward().then((_) => _scaleController.reverse());
    });
  }

  void submitAnswer() {
    if (selectedAnswer == null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Incomplete Quiz',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              currentQuestionIndex == widget.questions.length - 1
                  ? 'You haven\'t selected an answer for the last question. Submit anyway to reset the quiz?'
                  : 'You haven\'t selected an answer. Submit anyway to reset the quiz?',
              style: GoogleFonts.poppins(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      await _resetQuiz();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Submit Anyway',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      hasSubmitted = true;
      isAnswerSubmitted = true;
      userAnswers[currentQuestionIndex] = selectedAnswer!;
      final options = widget.questions[currentQuestionIndex]['options'] as List<dynamic>? ?? [];
      final correctOption = options.firstWhere(
        (opt) => opt['isCorrect'] == true,
        orElse: () => {'optionText': ''},
      );
      final correctAnswer = correctOption['optionText']?.toString() ?? '';
      bool isCorrect = selectedAnswer == correctAnswer;
      questionResults[currentQuestionIndex] = isCorrect;

      if (isCorrect) {
        points += 10;
        _saveProgress();
        _confettiController.forward().then((_) => _confettiController.reset());
        _nextQuestion();
      } else {
        showFunFact = true;
        _showEnhancedAlert(
          title: 'Incorrect Answer',
          message: 'The correct answer is $correctAnswer. ${widget.questions[currentQuestionIndex]['funFact']?.toString() ?? ''}',
          icon: Icons.close,
          color: Colors.red,
          onPressed: () {
            Navigator.of(context).pop();
            _nextQuestion();
          },
        );
      }
    });
  }

  void _nextQuestion() async {
    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = userAnswers[currentQuestionIndex];
        showFunFact = false;
        showHint = false;
        hasSubmitted = userAnswers.containsKey(currentQuestionIndex);
        isAnswerSubmitted = userAnswers.containsKey(currentQuestionIndex);
        viewedQuestions.add(currentQuestionIndex);
        _slideController.reset();
        _slideController.forward();
      });
      await _saveProgress();
      await _playSound();
    } else {
      // Check if all questions are attempted before marking as completed
      if (userAnswers.length == widget.questions.length) {
        await _markCompleted();
      }
      _showQuizComplete();
    }
  }

  void _previousQuestion() async {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        selectedAnswer = userAnswers[currentQuestionIndex];
        showFunFact = false;
        showHint = false;
        hasSubmitted = userAnswers.containsKey(currentQuestionIndex);
        isAnswerSubmitted = userAnswers.containsKey(currentQuestionIndex);
        viewedQuestions.add(currentQuestionIndex);
        _slideController.reset();
        _slideController.forward();
      });
      await _playSound();
    }
  }

  void toggleHint() {
    setState(() {
      showHint = !showHint;
    });
  }

  void _showQuizComplete() {
    final percentage = (points / (widget.questions.length * 10)) * 100;
    final allQuestionsAttempted = userAnswers.length == widget.questions.length;
    final correctCount = questionResults.values.where((result) => result).length;
    final halfQuestions = widget.questions.length / 2.0;
    final halfCorrect = correctCount >= halfQuestions;
    String message;
    String emoji;
    Color alertColor = Colors.green;
    IconData alertIcon = Icons.celebration;

    if (allQuestionsAttempted && halfCorrect) {
      if (percentage >= 80) {
        message = 'Amazing! You\'re an animal sound expert! 🌟 Achievement Unlocked!';
        emoji = '🎉';
      } else if (percentage >= 60) {
        message = 'Great job! You know your animal sounds well! 👏 Achievement Unlocked!';
        emoji = '😊';
      } else {
        message = 'Good effort! You answered at least half correctly! 💪 Achievement Unlocked!';
        emoji = '🤗';
      }
    } else {
      message = 'Nice try! Answer all questions and get at least half correct next time to unlock the achievement! 💪';
      emoji = '😌';
      alertColor = Colors.blue;
      alertIcon = Icons.info;
    }

    _showEnhancedAlert(
      title: 'Quiz Complete! $emoji',
      message: '$message\n\nFinal Score: $points/${widget.questions.length * 10} points\n(${percentage.toStringAsFixed(0)}%)',
      icon: alertIcon,
      color: alertColor,
      onPressed: () {
        Navigator.of(context).pop();
        Get.off(() => Dashboard(totalPoints: points));
      },
    );
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final currentColor = Colors.blue;

    return Theme(
      data: _buildTheme(currentColor, isSmallScreen),
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: _buildCompactAppBar(context, isSmallScreen, currentColor),
        body: Container(
          decoration: _buildGradientBackground(currentColor),
          child: Stack(
            children: [
              _buildFloatingShapes(currentColor),
              _buildEnhancedMainContent(
                context,
                currentQuestion,
                screenWidth,
                screenHeight,
                isSmallScreen,
                currentColor,
              ),
              if (showFunFact && hasSubmitted) _buildConfettiOverlay(),
            ],
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
          fontSize: isSmallScreen ? 22 : 26,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: isSmallScreen ? 18 : 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: isSmallScreen ? 18 : 20,
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

  PreferredSizeWidget _buildCompactAppBar(BuildContext context, bool isSmallScreen, Color currentColor) {
    return AppBar(
      leading: _buildBackButton(),
      title: Text(
        'Sound Quiz 🐾',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      centerTitle: true,
      backgroundColor: currentColor.withOpacity(0.9),
      elevation: 0,
      toolbarHeight: isSmallScreen ? 60 : 70,
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext ctx) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Exit Quiz',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
                content: Text(
                  'Your progress will be saved. Do you want to exit the quiz?',
                  style: GoogleFonts.poppins(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await _saveProgress();
                          Navigator.of(ctx).pop();
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        child: Text(
                          'Exit',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
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
            painter: FloatingShapesPainter(animation: _pulseAnimation.value, color: currentColor),
            child: Container(),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedMainContent(
      BuildContext context, Map<String, dynamic> currentQuestion, double screenWidth, double screenHeight, bool isSmallScreen, Color currentColor) {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          _buildQuestionNavigator(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 20.0 : 28.0),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.02),
                _buildEnhancedPointsDisplay(context, isSmallScreen, currentColor),
                SizedBox(height: screenHeight * 0.02),
                _buildEnhancedSoundButton(currentQuestion, isSmallScreen, currentColor, screenHeight),
                SizedBox(height: screenHeight * 0.02),
                _buildEnhancedQuestionCard(context, currentQuestion, screenWidth, isSmallScreen, currentColor),
                if (showHint)
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.015),
                    child: _buildCompactHint(context, currentQuestion, screenWidth, isSmallScreen),
                  ),
                if (showFunFact && hasSubmitted)
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.015),
                    child: _buildCompactFunFact(context, currentQuestion, screenWidth, isSmallScreen),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 20.0 : 28.0, vertical: 12),
              child: _buildEnhancedAnswerGrid(context, currentQuestion, isSmallScreen, currentColor),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 20, vertical: isSmallScreen ? 16 : 20),
              child: _buildBottomActionButtons(context, currentQuestion, isSmallScreen, currentColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionNavigator() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  currentQuestionIndex = index;
                  selectedAnswer = userAnswers[index];
                  isAnswerSubmitted = userAnswers.containsKey(index);
                  hasSubmitted = userAnswers.containsKey(index);
                  viewedQuestions.add(index);
                  showHint = false;
                  showFunFact = false;
                  _slideController.reset();
                  _slideController.forward();
                });
                _playSound();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isCurrent ? 55 : 45,
                height: isCurrent ? 55 : 45,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                  border: isCurrent ? Border.all(color: Colors.white, width: 3) : null,
                  boxShadow: [
                    BoxShadow(
                      color: bgColor.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: icon != null
                      ? Icon(icon, color: Colors.white, size: 22)
                      : Text(
                          '${index + 1}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isCurrent ? 18 : 16,
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

  Widget _buildEnhancedPointsDisplay(BuildContext context, bool isSmallScreen, Color currentColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 24 : 28, vertical: isSmallScreen ? 12 : 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [currentColor.withOpacity(0.1), Colors.white]),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: currentColor.withOpacity(0.3), width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.amber[600], size: 26),
          const SizedBox(width: 10),
          Text(
            'Points: $points',
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 17 : 19,
              fontWeight: FontWeight.w700,
              color: currentColor,
            ),
          ),
          const SizedBox(width: 10),
          Icon(Icons.star, color: Colors.amber[600], size: 26),
        ],
      ),
    );
  }

  Widget _buildEnhancedSoundButton(Map<String, dynamic> currentQuestion, bool isSmallScreen, Color currentColor, double screenHeight) {
    return GestureDetector(
      onTap: () {
        final soundUrl = currentQuestion['soundUrl']?.toString();
        if (soundUrl == null || soundUrl.isEmpty) {
          _showEnhancedAlert(
            title: 'No Sound',
            message: 'Sound unavailable for this question.',
            icon: Icons.volume_off,
            color: Colors.red,
          );
        } else {
          _playSound();
        }
      },
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimation.value,
            child: Container(
              width: screenHeight * 0.16,
              height: screenHeight * 0.16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [currentColor.withOpacity(0.8), currentColor.withOpacity(0.6)],
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 25,
                    color: currentColor.withOpacity(0.3),
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                    )
                  : Icon(
                      Icons.volume_up,
                      size: screenHeight * 0.07,
                      color: Colors.white,
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedQuestionCard(BuildContext context, Map<String, dynamic> currentQuestion, double screenWidth, bool isSmallScreen, Color currentColor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 18 : 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, currentColor.withOpacity(0.05)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: currentColor.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: currentColor.withOpacity(0.1),
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        currentQuestion['questionText']?.toString() ?? 'Which animal makes this sound?',
        style: Theme.of(context).textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCompactHint(BuildContext context, Map<String, dynamic> currentQuestion, double screenWidth, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.amber[300]!, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb, color: Colors.amber[700], size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              currentQuestion['hint']?.toString() ?? 'Listen carefully!',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.brown[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactFunFact(BuildContext context, Map<String, dynamic> currentQuestion, double screenWidth, bool isSmallScreen) {
    final options = (currentQuestion['options'] as List<dynamic>?) ?? [];
    final correctOption = options.firstWhere(
      (opt) => opt['isCorrect'] == true,
      orElse: () => {'optionText': ''},
    );
    final correctAnswer = correctOption['optionText']?.toString() ?? '';
    final isCorrect = selectedAnswer == correctAnswer;

    if (!isCorrect) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green[300]!, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.psychology, color: Colors.green[600], size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              currentQuestion['funFact']?.toString() ?? 'Great job!',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.green[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedAnswerGrid(BuildContext context, Map<String, dynamic> currentQuestion, bool isSmallScreen, Color currentColor) {
    final options = (currentQuestion['options'] as List<dynamic>?) ?? [];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: isSmallScreen ? 16 : 20,
        mainAxisSpacing: isSmallScreen ? 16 : 20,
        childAspectRatio: isSmallScreen ? 2.1 : 2.4,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final answer = options[index]['optionText']?.toString() ?? '';
        final correctOption = options.firstWhere(
          (opt) => opt['isCorrect'] == true,
          orElse: () => {'optionText': ''},
        );
        final correctAnswer = correctOption['optionText']?.toString() ?? '';
        return _buildEnhancedAnswerButton(context, answer, correctAnswer, isSmallScreen, currentColor, index);
      },
    );
  }

  Widget _buildEnhancedAnswerButton(BuildContext context, String answer, String correctAnswer, bool isSmallScreen, Color currentColor, int index) {
    bool isSelected = selectedAnswer == answer;
    bool isCorrect = answer == correctAnswer;
    bool showResult = hasSubmitted;

    Color buttonColor;
    Color borderColor;
    double scale = 1.0;

    if (showResult) {
      if (isCorrect) {
        buttonColor = Colors.green;
        borderColor = Colors.green[700]!;
      } else if (isSelected) {
        buttonColor = Colors.red;
        borderColor = Colors.red[700]!;
      } else {
        buttonColor = Colors.grey;
        borderColor = Colors.grey[600]!;
      }
    } else if (isSelected) {
      buttonColor = Colors.deepPurple;
      borderColor = Colors.deepPurple[700]!;
      scale = 1.08;
    } else {
      buttonColor = Colors.blue[400]!;
      borderColor = Colors.blue[600]!;
    }

    return GestureDetector(
      onTap: showResult ? null : () => selectAnswer(answer),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(isSelected && !showResult ? scale : 1.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [buttonColor, buttonColor.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected && !showResult ? Colors.white : borderColor,
            width: isSelected && !showResult ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: isSelected && !showResult ? 15 : 8,
              color: buttonColor.withOpacity(0.4),
              offset: Offset(0, isSelected && !showResult ? 8 : 4),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              answer,
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 17 : 19,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionButtons(BuildContext context, Map<String, dynamic> currentQuestion, bool isSmallScreen, Color currentColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          label: 'Previous',
          icon: Icons.arrow_back,
          color: Colors.grey[600]!,
          onPressed: currentQuestionIndex > 0 ? _previousQuestion : null,
          enabled: currentQuestionIndex > 0,
          isSmallScreen: isSmallScreen,
        ),
        _buildActionButton(
          label: showHint ? 'Hide' : 'Hint',
          icon: showHint ? Icons.visibility_off : Icons.lightbulb,
          color: Colors.amber[600]!,
          onPressed: toggleHint,
          isSmallScreen: isSmallScreen,
        ),
        if (!hasSubmitted)
          _buildActionButton(
            label: 'Submit',
            icon: Icons.check,
            color: Colors.blue[600]!,
            onPressed: submitAnswer,
            enabled: true,
            isSmallScreen: isSmallScreen,
          )
        else
          _buildActionButton(
            label: currentQuestionIndex < widget.questions.length - 1 ? 'Next' : 'Finish',
            icon: Icons.arrow_forward,
            color: Colors.green[600]!,
            onPressed: _nextQuestion,
            isSmallScreen: isSmallScreen,
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
    bool enabled = true,
    required bool isSmallScreen,
  }) {
    return ElevatedButton.icon(
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
        disabledBackgroundColor: Colors.grey[300],
        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 20, vertical: isSmallScreen ? 12 : 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: enabled ? 6 : 2,
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
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: GoogleFonts.poppins(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: onPressed ?? () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
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

class FloatingShapesPainter extends CustomPainter {
  final double animation;
  final Color color;

  FloatingShapesPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 6; i++) {
      final x = (size.width * 0.15) + (i * size.width * 0.15);
      final y = (size.height * 0.1) + (math.sin((animation * 2 * math.pi) + (i * 0.5)) * 15);

      canvas.drawCircle(
        Offset(x, y),
        10 + (math.sin(animation * math.pi + i) * 5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

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

    for (int i = 0; i < 40; i++) {
      final paint = Paint()..color = colors[i % colors.length].withOpacity(1.0 - (animation * 0.7));
      final x = (size.width * (i % 10) * 0.1) + (math.sin(animation * math.pi * 2 + i) * 20);
      final y = (animation * size.height * 1.5) - (i * 10);

      if (y > 0 && y < size.height) {
        canvas.drawCircle(Offset(x, y), 4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}