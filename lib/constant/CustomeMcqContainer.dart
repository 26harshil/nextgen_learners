import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:nextgen_learners/constant/import_export.dart';

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

class _CustomMCQWidgetState extends State<CustomMCQWidget> with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  int points = 0;
  String? selectedAnswer;
  bool showHint = false;
  bool isAnswerSubmitted = false;
  bool isQuizCompleted = false;

  Map<int, String> userAnswers = {};
  Map<int, bool> questionResults = {};
  Set<int> viewedQuestions = {};

  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
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
    if (userAnswers.containsKey(currentQuestionIndex) || isQuizCompleted) return;
    setState(() {
      selectedAnswer = answer;
    });
  }

  void submitAnswer() {
    if (selectedAnswer == null) {
      _showIncompleteQuizDialog();
      return;
    }

    if (userAnswers.containsKey(currentQuestionIndex) || isQuizCompleted) return;

    setState(() {
      isAnswerSubmitted = true;
      userAnswers[currentQuestionIndex] = selectedAnswer!;
    });

    final q = widget.questions[currentQuestionIndex];
    final List<dynamic> opts = (q['options'] is List) ? q['options'] as List : <dynamic>[];
    String? correctAnswerText = (q['answer'] as String?) ?? (q['correctAnswer'] as String?);
    bool isCorrect;

    if (opts.isNotEmpty && opts.first is Map) {
      dynamic match;
      try {
        match = opts.firstWhere(
          (o) => ((o['optionText'] ?? o['text'] ?? o['value'] ?? '').toString()) == selectedAnswer,
        );
      } catch (_) {
        match = null;
      }
      isCorrect = match != null &&
          ((match['isCorrect'] == true) || (match['correct'] == true) || (match['answer'] == true));
      if (correctAnswerText == null) {
        try {
          final corr = opts.firstWhere(
            (o) => o['isCorrect'] == true || o['correct'] == true || o['answer'] == true,
          );
          correctAnswerText = (corr['optionText'] ?? corr['text'] ?? corr['value'] ?? '').toString();
        } catch (_) {
          correctAnswerText = '';
        }
      }
    } else {
      isCorrect = selectedAnswer == correctAnswerText;
    }

    questionResults[currentQuestionIndex] = isCorrect;
    widget.onAnswerSubmitted?.call(q['questionId'], isCorrect);

    _saveProgress();

    if (isCorrect) {
      setState(() {
        points += 10;
      });
      if (currentQuestionIndex < widget.questions.length - 1) {
        _nextQuestion();
      } else {
        _checkQuizCompletion();
      }
    } else {
      _showEnhancedDialog(
        title: 'Almost there! 🤔',
        message: 'That\'s not quite right. The correct answer is $correctAnswerText. '
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
      builder: (context) => ScaleTransition(
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
                    color: Colors.black,
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
                  horizontal: 16,
                  vertical: 8,
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
    setState(() {
      currentQuestionIndex--;
      selectedAnswer = userAnswers[currentQuestionIndex];
      isAnswerSubmitted = userAnswers.containsKey(currentQuestionIndex);
      showHint = false;
      _slideController.reset();
      _scaleController.reset();
      _startAnimations();
    });
    _saveProgress();
  }

  void _checkQuizCompletion() async {
    if (isQuizCompleted) {
      return;
    }
    final int total = widget.questions.length;
    final int correctCount = questionResults.values.where((b) => b).length;
    final bool passed = correctCount > (total / 2);
    final bool allAnswered = userAnswers.length == total;

    if (allAnswered && passed) {
      await _markCompleted();
      Get.off(() => Dashboard(totalPoints: points));
    } else if (!allAnswered) {
      _showIncompleteQuizDialog();
    } else {
      // All answered but score <= 50%: reset attempt without awarding badge
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('progress_${widget.quizId}');
      await prefs.remove('answers_${widget.quizId}');
      await prefs.remove('results_${widget.quizId}');
      await prefs.remove('current_attempt_${widget.quizId}');

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Keep Trying!',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          content: Text(
            'You answered $correctCount out of $total correctly.\n\nYou need more than half correct to complete and earn a badge. The quiz will reset now.',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[800],
              height: 1.4,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Get.off(() => CustomMCQWidget(
                      questions: widget.questions,
                      quizTitle: widget.quizTitle,
                      quizId: widget.quizId,
                      onAnswerSubmitted: widget.onAnswerSubmitted,
                    ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Try Again',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _showIncompleteQuizDialog() {
    final unanswered = <int>[];
    for (int i = 0; i < widget.questions.length; i++) {
      if (!userAnswers.containsKey(i)) {
        unanswered.add(i + 1);
      }
    }

    if (unanswered.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Quiz Not Complete',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        content: Text(
          'You have ${unanswered.length} unanswered question(s): ${unanswered.join(", ")}.\n\nWould you like to go back and answer them or reset the quiz?',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[800],
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Reset the quiz completely (attempt only) without revoking prior completion/points
              final prefs = await SharedPreferences.getInstance();
              setState(() {
                userAnswers.clear();
                questionResults.clear();
                points = 0;
                currentQuestionIndex = 0;
                selectedAnswer = null;
                isAnswerSubmitted = false;
                // keep prior completion state as-is; we're resetting only this attempt
                viewedQuestions.clear();
                viewedQuestions.add(0);
                _slideController.reset();
                _scaleController.reset();
                _startAnimations();
              });
              await prefs.remove('progress_${widget.quizId}');
              await prefs.remove('answers_${widget.quizId}');
              await prefs.remove('results_${widget.quizId}');
              await prefs.remove('current_attempt_${widget.quizId}');
              // Navigate back to the quiz start
              Get.off(() => CustomMCQWidget(
                    questions: widget.questions,
                    quizTitle: widget.quizTitle,
                    quizId: widget.quizId,
                    onAnswerSubmitted: widget.onAnswerSubmitted,
                  ));
            },
            child: Text(
              'Reset Quiz',
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
                viewedQuestions.add(currentQuestionIndex);
                _slideController.reset();
                _scaleController.reset();
                _startAnimations();
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
              foregroundColor: Colors.white,
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
    final answersJson = prefs.getString('answers_${widget.quizId}');
    final resultsJson = prefs.getString('results_${widget.quizId}');
    final isCompleted = prefs.getBool('completed_${widget.quizId}') ?? false;
    if (!mounted) return;
    setState(() {
      final maxIndex = widget.questions.isEmpty ? 0 : (widget.questions.length - 1);
      userAnswers.clear();
      questionResults.clear();
      if (answersJson != null && answersJson.isNotEmpty) {
        try {
          final Map<String, dynamic> map = jsonDecode(answersJson);
          map.forEach((k, v) {
            final idx = int.tryParse(k);
            if (idx != null) userAnswers[idx] = (v ?? '').toString();
          });
        } catch (_) {}
      }
      if (resultsJson != null && resultsJson.isNotEmpty) {
        try {
          final Map<String, dynamic> map = jsonDecode(resultsJson);
          map.forEach((k, v) {
            final idx = int.tryParse(k);
            if (idx != null) questionResults[idx] = (v == true);
          });
        } catch (_) {}
      }
      points = questionResults.values.where((b) => b).length * 10;
      isQuizCompleted = isCompleted;
      viewedQuestions.addAll(userAnswers.keys);
      int? firstUnanswered;
      for (int i = 0; i < widget.questions.length; i++) {
        if (!userAnswers.containsKey(i)) {
          firstUnanswered = i;
          break;
        }
      }
      final fallbackIndex = savedIndex.clamp(0, maxIndex);
      currentQuestionIndex = firstUnanswered ?? fallbackIndex;
      selectedAnswer = userAnswers[currentQuestionIndex];
      isAnswerSubmitted = userAnswers.containsKey(currentQuestionIndex);
    });
    if (mounted && userAnswers.length == widget.questions.length && !isQuizCompleted) {
      final int total = widget.questions.length;
      final int correctCount = questionResults.values.where((b) => b).length;
      final bool passed = correctCount > (total / 2);
      if (passed) {
        await _markCompleted();
        if (mounted) {
          Get.off(() => Dashboard(totalPoints: points));
        }
      }
    }
    _saveProgress();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('progress_${widget.quizId}', currentQuestionIndex);
    final encodedAnswers = jsonEncode(
      userAnswers.map((k, v) => MapEntry(k.toString(), v)),
    );
    final encodedResults = jsonEncode(
      questionResults.map((k, v) => MapEntry(k.toString(), v)),
    );
    await prefs.setString('answers_${widget.quizId}', encodedAnswers);
    await prefs.setString('results_${widget.quizId}', encodedResults);
  }

  Future<void> _markCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('completed_${widget.quizId}', true);
    await prefs.setInt('points_${widget.quizId}', points);
    await prefs.remove('current_attempt_${widget.quizId}');
    await prefs.remove('progress_${widget.quizId}');
    final badges = prefs.getStringList('badges') ?? [];
    if (!badges.contains(widget.quizId)) {
      badges.add(widget.quizId);
      await prefs.setStringList('badges', badges);
    }
    if (mounted) {
      setState(() {
        isQuizCompleted = true;
      });
    }
  }

  String? _getCorrectAnswer(int index) {
    final q = widget.questions[index];
    final List<dynamic> opts = (q['options'] is List) ? q['options'] as List : <dynamic>[];
    String? correctAnswerText = (q['answer'] as String?) ?? (q['correctAnswer'] as String?);

    if (correctAnswerText == null && opts.isNotEmpty && opts.first is Map) {
      try {
        final corr = opts.firstWhere(
          (o) => o['isCorrect'] == true || o['correct'] == true || o['answer'] == true,
        );
        correctAnswerText = (corr['optionText'] ?? corr['text'] ?? corr['value'] ?? '').toString();
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
        primaryColor: Colors.blue[700],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue[600],
          secondary: Colors.orange[400],
          surface: Colors.white,
        ),
      ),
      child: Scaffold(
        appBar: _buildEnhancedAppBar(context),
        body: widget.questions.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue[100]!,
                      Colors.green[100]!,
                      Colors.orange[50]!,
                      Colors.blue[50]!,
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Column(
                          children: [
                            _buildQuestionNavigator(),
                            const SizedBox(height: 12),
                            _buildPointsDisplay(),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
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
    );
  }

  PreferredSizeWidget _buildEnhancedAppBar(BuildContext context) {
    return AppBar(
      leading: Tooltip(
        message: 'Back to Dashboard',
        child: Container(
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Get.off(() => Dashboard(totalPoints: points)),
              borderRadius: BorderRadius.circular(16),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
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
            padding: const EdgeInsets.all(4),
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
              height: 24,
              width: 24,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.quizTitle,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[100]!,
              Colors.green[100]!,
              Colors.orange[50]!,
              Colors.blue[50]!,
            ],
          ),
        ),
      ),
      elevation: 0,
    );
  }

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
            bgColor = Colors.blue[600]!;
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
                  _slideController.reset();
                  _scaleController.reset();
                  _startAnimations();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isCurrent ? 50 : 40,
                height: isCurrent ? 50 : 40,
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
                      ? Icon(icon, color: Colors.white, size: 20)
                      : Text(
                          '${index + 1}',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
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
              colors: [Colors.orange[300]!, Colors.yellow[300]!],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Colors.black, size: 22),
              const SizedBox(width: 8),
              Text(
                'Points: $value',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.black.withOpacity(0.1), width: 2),
      ),
      child: Column(
        children: [
          Text(
            (questionData['questionText'] ?? questionData['question'] ?? '').toString(),
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildHintCard() {
    final questionData = widget.questions[currentQuestionIndex];
    final hintText = questionData['hint'] as String? ?? 'Keep trying!';
    final imagePath = questionData['imageUrl'] as String? ??
        questionData['image'] as String? ??
        questionData['imagePath'] as String?;
    final hintImage = questionData['hintImage'] as String? ??
        questionData['hintImageUrl'] as String? ??
        questionData['hintImagePath'] as String?;

    final String normalizedImage = (imagePath ?? '').trim();
    final String normalizedHintImage = (hintImage ?? '').trim();
    String? networkImageUrl;
    String? networkHintImageUrl;
    if (normalizedImage.isNotEmpty) {
      if (normalizedImage.startsWith('http') || normalizedImage.startsWith('data:')) {
        networkImageUrl = normalizedImage;
      } else if (normalizedImage.startsWith('/')) {
        networkImageUrl = ApiConfig.baseHost + normalizedImage.substring(1);
      } else if (!normalizedImage.startsWith('assets/')) {
        networkImageUrl = ApiConfig.baseHost + normalizedImage;
      }
    }
    if (normalizedHintImage.isNotEmpty) {
      if (normalizedHintImage.startsWith('http') || normalizedHintImage.startsWith('data:')) {
        networkHintImageUrl = normalizedHintImage;
      } else if (normalizedHintImage.startsWith('/')) {
        networkHintImageUrl = ApiConfig.baseHost + normalizedHintImage.substring(1);
      } else if (!normalizedHintImage.startsWith('assets/')) {
        networkHintImageUrl = ApiConfig.baseHost + normalizedHintImage;
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.yellow[100]!.withOpacity(0.8),
            Colors.orange[50]!.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange[300]!, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lightbulb,
                  color: Colors.orange[800],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  hintText,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          if (showHint && (normalizedImage.isNotEmpty || normalizedHintImage.isNotEmpty))
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
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
                  child: (normalizedHintImage.isNotEmpty
                      ? (networkHintImageUrl != null
                          ? Image.network(
                              networkHintImageUrl,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 100,
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
                              normalizedHintImage,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 100,
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
                            ))
                      : (networkImageUrl != null
                          ? Image.network(
                              networkImageUrl,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 100,
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
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 100,
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
                            ))),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnswerOptions() {
    final bool isReviewMode = userAnswers.containsKey(currentQuestionIndex) || isQuizCompleted;
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
          itemCount: ((widget.questions[currentQuestionIndex]['options'] as List?) ?? const []).length,
          itemBuilder: (context, index) {
            final options = (widget.questions[currentQuestionIndex]['options'] as List?) ?? const [];
            final opt = options[index];
            final String option = (opt is Map)
                ? (opt['optionText'] ?? opt['text'] ?? opt['value'] ?? '').toString()
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
              buttonColor = isSelected ? Colors.blue[500]! : Colors.orange[400]!;
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
                        border: (isSelected || isUserAnswer) ? Border.all(color: Colors.white, width: 2.5) : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: isReviewMode ? null : () => selectAnswer(option),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (icon != null) Icon(icon, color: Colors.white, size: 22),
                                if (icon != null) const SizedBox(height: 6),
                                Flexible(
                                  child: Text(
                                    option,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
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
    final bool isReviewMode = userAnswers.containsKey(currentQuestionIndex) || isQuizCompleted;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: currentQuestionIndex > 0 ? _previousQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: currentQuestionIndex > 0 ? Colors.blue[600] : Colors.grey[400],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                elevation: currentQuestionIndex > 0 ? 5 : 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back, size: 18, color: Colors.black),
                  const SizedBox(width: 4),
                  Text(
                    'Previous',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: toggleHint,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[600],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                elevation: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.orange[200],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      showHint ? Icons.lightbulb_outline : Icons.lightbulb,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Hint',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ElevatedButton(
              onPressed: isReviewMode ? _nextQuestion : (selectedAnswer != null ? submitAnswer : null),
              style: ElevatedButton.styleFrom(
                backgroundColor: isReviewMode || selectedAnswer != null ? Colors.blue[600] : Colors.grey[400],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                elevation: isReviewMode || selectedAnswer != null ? 5 : 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isReviewMode ? 'Next' : 'Submit',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 18, color: Colors.black),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}