import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextgen_learners/constant/CustomContainer.dart';
import 'package:nextgen_learners/constant/string_constant.dart';
import 'package:nextgen_learners/controller/dashboard_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kDashboardGradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [HOME_SCREEN_COLOR_LIGHT_PEACH, HOME_SCREEN_COLOR_LIGHT_PURPLE],
  ),
);

class Dashboard extends StatefulWidget {
  final int totalPoints;
  const Dashboard({super.key, required this.totalPoints});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  int cumulativePoints = 0;

  final DashboardController _controller = Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadCumulativePoints();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  Future<void> _loadCumulativePoints() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? previousScores = prefs.getStringList('quiz_scores') ?? [];
    int previousTotal = previousScores.fold(
      0,
      (sum, score) => sum + int.parse(score),
    );
    int newTotal = previousTotal + widget.totalPoints;
    await prefs.setStringList('quiz_scores', [
      ...previousScores,
      widget.totalPoints.toString(),
    ]);
    setState(() {
      cumulativePoints = newTotal;
    });
  }

  Future<bool> _isCompleted(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('completed_$id') ?? false;
  }

  Future<List<String>> _loadBadges() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('badges') ?? [];
  }

  Widget _tileWithTick({
    required String quizId,
    required CustomContainer tile,
  }) {
    return FutureBuilder<bool>(
      future: _isCompleted(quizId),
      builder: (context, snapshot) {
        final completed = snapshot.data ?? false;
        return Stack(
          children: [
            tile,
            if (completed)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 18),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAchievementsRow() {
    return FutureBuilder<List<String>>(
      future: _loadBadges(),
      builder: (context, snapshot) {
        final badges = snapshot.data ?? [];
        if (badges.isEmpty) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: badges.map((id) {
                final badgeMap = {
                  'animal_name': 'animalQuizz',
                  'animal_sound': 'soundQuizz',
                  'math': 'mathQuizz',
                  'vehicals': 'vehicleQuizz',
                  'fruits': 'fruitQuizz',
                  'vegetables': 'vegetableQuizz',
                  'colors': 'colorQuizz',
                  'birds': 'birdQuizz',
                };
                final badgeName = badgeMap[id] ?? id;
                final path = 'badges/$badgeName.png';
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Tooltip(
                    message: 'Completed: ${badgeName.replaceAll('Quizz', '')}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        path,
                        height: 48,
                        width: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 48,
                          width: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.green[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.emoji_events,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.school, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NEXTGEN LEARNERS',
                    style: GoogleFonts.fredoka(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'Learning Made Fun! 🌟',
                    style: GoogleFonts.fredoka(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple[400]!,
                Colors.pink[400]!,
                Colors.orange[300]!,
              ],
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.star, color: Colors.yellow, size: 24),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Colors.white,
              HOME_SCREEN_COLOR_LIGHT_PEACH.withOpacity(0.3),
              HOME_SCREEN_COLOR_LIGHT_PURPLE.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Obx(() {
                      if (_controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Column(
                        children: [
                          // Welcome Section
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(bottom: 30),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.cyan[50]!, Colors.blue[50]!],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '🎉 Welcome to Learning Adventure! 🚀',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Choose your favorite topic to start learning!',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 16,
                                    color: Colors.indigo[500],
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.yellow[100],
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.yellow.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Total Points: $cumulativePoints',
                                        style: GoogleFonts.fredoka(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Achievements Row
                          _buildAchievementsRow(),

                          // Learning Categories Grid
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: 0.9,
                              children: [
                                _tileWithTick(
                                  quizId: 'animal_name',
                                  tile: CustomContainer(
                                    key: UniqueKey(),
                                    newPage: ANIMAL_Name_SCREEN,
                                    title: "Animals",
                                    subtitle: "Meet cute animals!",
                                    img: 'assets/home_screen/lion.jpg',
                                    primaryColor:
                                        ANIMAL_SCREEN_COLOR_LIGHT_PINK,
                                    secondaryColor:
                                        ANIMAL_SCREEN_COLOR_LIGHT_LAVENDER,
                                    delay: 200,
                                  ),
                                ),
                                _tileWithTick(
                                  quizId: 'animal_sound',
                                  tile: CustomContainer(
                                    key: UniqueKey(),
                                    newPage: ANIMAL_SOUND_SCREEN,
                                    title: "Animal Sounds",
                                    subtitle: "Hear them roar!",
                                    img: 'assets/home_screen/sound.webp',
                                    primaryColor:
                                        ANIMALSOUND_COLOR_LIGHT_ORANGE,
                                    secondaryColor:
                                        ANIMALSOUND_COLOR_LIGHT_CYAN,
                                    delay: 400,
                                  ),
                                ),
                                _tileWithTick(
                                  quizId: 'math',
                                  tile: CustomContainer(
                                    key: UniqueKey(),
                                    newPage: MATH_SCREEN,
                                    title: "Math Fun",
                                    subtitle: "Numbers & counting!",
                                    img: 'assets/home_screen/math.webp',
                                    primaryColor: MATH_COLOR_LIGHT_PEACH,
                                    secondaryColor: MATH_COLOR_SOFT_PINK,
                                    delay: 600,
                                  ),
                                ),
                                _tileWithTick(
                                  quizId: 'vehicals',
                                  tile: CustomContainer(
                                    key: UniqueKey(),
                                    newPage: VEHICLE_NAME_SCREEN,
                                    title: "Vehicles",
                                    subtitle: "Cars, trains & more!",
                                    img: 'assets/home_screen/vehicals.jpg',
                                    primaryColor: VEHICLES_COLOR_LIGHT_BLUE,
                                    secondaryColor: VEHICLES_COLOR_SKY_BLUE,
                                    delay: 800,
                                  ),
                                ),
                                _tileWithTick(
                                  quizId: 'fruits',
                                  tile: CustomContainer(
                                    key: UniqueKey(),
                                    newPage: FRUITS_SCREEN,
                                    title: "Fruits",
                                    subtitle: "Learn about tasty fruits!",
                                    img: 'assets/home_screen/fruits.jpg',
                                    primaryColor: Colors.red[100]!,
                                    secondaryColor: Colors.orange[100]!,
                                    delay: 1000,
                                  ),
                                ),
                                _tileWithTick(
                                  quizId: 'vegetables',
                                  tile: CustomContainer(
                                    key: UniqueKey(),
                                    newPage: VEGETABLES_SCREEN,
                                    title: "Vegetables",
                                    subtitle: "Discover healthy veggies!",
                                    img: 'assets/home_screen/vegetables.jpg',
                                    primaryColor: Colors.green[100]!,
                                    secondaryColor: Colors.lime[100]!,
                                    delay: 1200,
                                  ),
                                ),
                                _tileWithTick(
                                  quizId: 'colors',
                                  tile: CustomContainer(
                                    key: UniqueKey(),
                                    newPage: COLORS_Screen,
                                    title: "Colors",
                                    subtitle: "Explore vibrant colors!",
                                    img: 'assets/home_screen/colors.webp',
                                    primaryColor: Colors.blue[100]!,
                                    secondaryColor: Colors.purple[100]!,
                                    delay: 1400,
                                  ),
                                ),
                                _tileWithTick(
                                  quizId: 'birds',
                                  tile: CustomContainer(
                                    key: UniqueKey(),
                                    newPage: BIRDS_SCREEN,
                                    title: "Birds",
                                    subtitle: "Learn about birds!",
                                    img: 'assets/home_screen/birds.jpg',
                                    primaryColor: MATH_COLOR_LIGHT_PEACH,
                                    secondaryColor: MATH_COLOR_SOFT_PINK,
                                    delay: 1600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Updated _markCompleted method for CustomMCQWidget to handle badge awarding with 75% score requirement
Future<void> _markCompleted(dynamic widget) async {
  final prefs = await SharedPreferences.getInstance();
  // Assume widget.score is the number of correct answers and widget.totalQuestions is the total number of questions
  // Each question is worth 1 point for simplicity
  final double scorePercentage = (widget.score / widget.totalQuestions) * 100;
  
  // Only mark as completed and award badge if score is at least 75%
  if (scorePercentage >= 75.0) {
    await prefs.setBool('completed_${widget.quizId}', true);
    await prefs.remove('progress_${widget.quizId}');
    await prefs.remove('points_${widget.quizId}');
    final badges = prefs.getStringList('badges') ?? [];
    // Map quiz IDs to badge names
    const badgeMap = {
      'animal_name': 'animalQuizz',
      'animal_sound': 'soundQuizz',
      'math': 'mathQuizz',
      'vehicals': 'vehicleQuizz',
      'fruits': 'fruitQuizz',
      'vegetables': 'vegetableQuizz',
      'colors': 'colorQuizz',
      'birds': 'birdQuizz',
    };
    final badgeName = badgeMap[widget.quizId] ?? widget.quizId;
    if (!badges.contains(badgeName)) {
      badges.add(badgeName);
      await prefs.setStringList('badges', badges);
    }
  }
}