import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextgen_learners/constant/CustomContainer.dart';
import 'package:nextgen_learners/constant/string_constant.dart';
import 'package:nextgen_learners/controller/dashboard_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nextgen_learners/view/about_us.dart';
import 'package:nextgen_learners/view/achievements_page.dart';

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
  late AnimationController _bounceController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  int cumulativePoints = 0;
  int completedQuizzes = 0;
  int maxPoints = 0;

  final DashboardController _controller = Get.put(DashboardController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadPoints();
    _loadCompletedQuizzes();
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

    _bounceController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  Future<void> _loadPoints() async {
    final prefs = await SharedPreferences.getInstance();

    // Load and calculate total points from all quizzes
    final quizIds = [
      'animal_name',
      'animal_sound',
      'math',
      'vehicals',
      'fruits',
      'vegetables',
      'colors',
    ];

    int totalMaxPoints = 0;
    int totalCurrentPoints = 0;
    int totalAttempts = 0;

    for (var quizId in quizIds) {
      // Get maximum points achieved for this quiz
      final maxPoints = prefs.getInt('max_points_$quizId') ?? 0;
      totalMaxPoints += maxPoints;

      // Get current session points (may be lower than max if user is retaking)
      final currentPoints =
          prefs.getInt('current_attempt_$quizId') ??
          prefs.getInt('points_$quizId') ??
          0;
      totalCurrentPoints += currentPoints;

      // Count total attempts across all quizzes
      final attempts = prefs.getInt('attempts_$quizId') ?? 0;
      totalAttempts += attempts;
    }

    // Update the points to show both current session and maximum achieved
    if (mounted) {
      setState(() {
        cumulativePoints = totalCurrentPoints;
        maxPoints = totalMaxPoints;
      });
    }

    print('Dashboard loaded:');
    print('Current session points: $totalCurrentPoints');
    print('Maximum points achieved: $totalMaxPoints');
    print('Total attempts across all quizzes: $totalAttempts');
  }

  Future<void> _loadCompletedQuizzes() async {
    final prefs = await SharedPreferences.getInstance();
    final quizIds = [
      'animal_name',
      'sounds',
      'math',
      'vehicles',
      'fruits',
      'vegetables',
      'colors',
      'birds',
    ];
    int count = 0;
    for (String id in quizIds) {
      if (prefs.getBool('completed_$id') ?? false) {
        count++;
      }
    }
    setState(() {
      completedQuizzes = count;
    });
  }

  Future<bool> _isCompleted(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('completed_$id') ?? false;
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
            // Ensure consistent size with SizedBox
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: tile,
            ),
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

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  Widget _buildEnhancedStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required Gradient gradient,
    String? subtitle,
    double? progress,
    bool showTrend = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon with background
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),

          // Value with animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1000),
            builder: (context, animValue, child) {
              return Transform.scale(
                scale: 0.9 + (animValue * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                    if (showTrend) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_upward, color: color, size: 14),
                    ],
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 4),

          // Label
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),

          // Progress bar if provided
          if (progress != null) ...[
            const SizedBox(height: 6),
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(2),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withOpacity(0.6)],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],

          // Subtitle if provided
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 9,
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildAppDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple[400]!,
              Colors.pink[400]!,
              Colors.orange[300]!,
              // Then transition to white/cyan
              Colors.white,
              Colors.cyan[50]!,
            ],
            stops: const [
              0.0, // Start with purple
              0.05, // Quick transition to pink
              0.1, // Then to orange
              0.4, // Fade to white
              1.0, // End with cyan
            ],
          ),
        ),
        child: AnimatedBuilder(
          animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: SafeArea(
                  top: true,
                  bottom: true,
                  minimum: const EdgeInsets.only(top: 8),
                  child: Column(
                    children: [
                      // Custom App Bar with fixed height
                      Container(
                        height: 100, // Fixed height for app bar
                        padding: const EdgeInsets.only(
                          top: 20,
                          bottom: 16,
                          left: 20,
                          right: 20,
                        ),
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
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Menu Button
                            InkWell(
                              onTap:
                                  () => _scaffoldKey.currentState?.openDrawer(),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Title
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'BrainZy',
                                    style: GoogleFonts.fredoka(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                          offset: const Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Learning Made Fun! 🌟',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.95),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Trophy Icon
                            AnimatedBuilder(
                              animation: _bounceAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _bounceAnimation.value,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.emoji_events,
                                      color: Colors.yellow,
                                      size: 24,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // Main Content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Obx(() {
                            if (_controller.isLoading.value) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.purple[400]!,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Loading awesome content...',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 16,
                                        color: Colors.purple[600],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Column(
                              children: [
                                // Welcome Section with Stats - Fixed height
                                // Inside the build method's Column > Expanded > Obx > Column
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.purple[400]!.withOpacity(0.9),
                                        Colors.blue[400]!.withOpacity(0.9),
                                        Colors.cyan[400]!.withOpacity(0.9),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.purple.withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.2),
                                        blurRadius: 15,
                                        offset: const Offset(-5, 5),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      // Decorative circles
                                      Positioned(
                                        top: -20,
                                        right: -20,
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withOpacity(
                                              0.1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: -30,
                                        left: -30,
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withOpacity(
                                              0.08,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Main content
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Welcome Header
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.2),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                    size: 20,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Flexible(
                                                  child: ShaderMask(
                                                    shaderCallback:
                                                        (bounds) =>
                                                            const LinearGradient(
                                                              colors: [
                                                                Colors.white,
                                                                Colors.white70,
                                                              ],
                                                            ).createShader(
                                                              bounds,
                                                            ),
                                                    child: Text(
                                                      'Learning Adventure',
                                                      style:
                                                          GoogleFonts.fredoka(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            letterSpacing: 0.5,
                                                          ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.2),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.rocket_launch,
                                                    color: Colors.orange,
                                                    size: 20,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 8),

                                            // Motivational text
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.15,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                'Keep learning, keep growing! 🌟',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color: Colors.white
                                                      .withOpacity(0.95),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),

                                            const SizedBox(height: 20),

                                            // Enhanced Stat Cards
                                            Row(
                                              children: [
                                                // Points Card
                                                // Progress Card
                                                Expanded(
                                                  child: _buildEnhancedStatCard(
                                                    icon: Icons.check_circle,
                                                    value:
                                                        '$completedQuizzes/8',
                                                    label: 'Completed',
                                                    color: Colors.green,
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        Colors.white
                                                            .withOpacity(0.95),
                                                        Colors.green[50]!
                                                            .withOpacity(0.95),
                                                      ],
                                                    ),
                                                    progress:
                                                        completedQuizzes / 8,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),

                                                // Percentage Card
                                                Expanded(
                                                  child: _buildEnhancedStatCard(
                                                    icon: Icons.trending_up,
                                                    value:
                                                        '${(completedQuizzes / 8 * 100).toInt()}%',
                                                    label: 'Progress',
                                                    color: Colors.blue,
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        Colors.white
                                                            .withOpacity(0.95),
                                                        Colors.blue[50]!
                                                            .withOpacity(0.95),
                                                      ],
                                                    ),
                                                    showTrend: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ), // Added missing comma here
                                Expanded(
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio:
                                        1.0, // Square cards for consistency
                                    physics: const BouncingScrollPhysics(),
                                    children: [
                                      _tileWithTick(
                                        quizId: 'animal_name',
                                        tile: CustomContainer(
                                          key: UniqueKey(),
                                          newPage: ANIMAL_Name_SCREEN,
                                          title: "Animals",
                                          subtitle: "Meet animals!",
                                          img: 'assets/home_screen/lion.jpg',
                                          primaryColor:
                                              ANIMAL_SCREEN_COLOR_LIGHT_PINK,
                                          secondaryColor:
                                              ANIMAL_SCREEN_COLOR_LIGHT_LAVENDER,
                                          delay: 200,
                                        ),
                                      ),
                                      _tileWithTick(
                                        quizId: 'sounds',
                                        tile: CustomContainer(
                                          key: UniqueKey(),
                                          newPage: ANIMAL_SOUND_SCREEN,
                                          title: "Sounds",
                                          subtitle: "Hear them!",
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
                                          subtitle: "Numbers!",
                                          img: 'assets/home_screen/math.webp',
                                          primaryColor: MATH_COLOR_LIGHT_PEACH,
                                          secondaryColor: MATH_COLOR_SOFT_PINK,
                                          delay: 600,
                                        ),
                                      ),
                                      _tileWithTick(
                                        quizId: 'vehicles',
                                        tile: CustomContainer(
                                          key: UniqueKey(),
                                          newPage: VEHICLE_NAME_SCREEN,
                                          title: "Vehicles",
                                          subtitle: "Cars & more!",
                                          img:
                                              'assets/home_screen/vehicals.jpg',
                                          primaryColor:
                                              VEHICLES_COLOR_LIGHT_BLUE,
                                          secondaryColor:
                                              VEHICLES_COLOR_SKY_BLUE,
                                          delay: 800,
                                        ),
                                      ),
                                      _tileWithTick(
                                        quizId: 'fruits',
                                        tile: CustomContainer(
                                          key: UniqueKey(),
                                          newPage: FRUITS_SCREEN,
                                          title: "Fruits",
                                          subtitle: "Tasty treats!",
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
                                          title: "Veggies",
                                          subtitle: "Healthy food!",
                                          img:
                                              'assets/home_screen/vegetables.jpg',
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
                                          subtitle: "Rainbow fun!",
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
                                          subtitle: "Flying high!",
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
                    ],
                  ), // Added missing ] here for outer Column children
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.purple[50]!],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple[400]!, Colors.pink[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/home_screen/buddy.png',
                        height: 60,
                        width: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'BrainZy',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            _buildDrawerItem(
              icon: Icons.home,
              title: 'Home',
              color: Colors.blue,
              onTap: () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              icon: Icons.emoji_events,
              title: 'Achievements',
              color: Colors.amber,
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const AchievementsPage());
              },
            ),
            _buildDrawerItem(
              icon: Icons.feedback_outlined,
              title: 'Feedback',
              color: Colors.teal,
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(FEEDBACK_SCREEN);
              },
            ),
            _buildDrawerItem(
              icon: Icons.info_outline,
              title: 'About Us',
              color: Colors.purple,
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const AboutUsPage());
              },
            ),

            const Spacer(),

            // Progress Summary
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple[100]!, Colors.pink[100]!],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Points',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.purple[700],
                        ),
                      ),
                      Text(
                        cumulativePoints.toString(),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: completedQuizzes / 8,
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.purple[400]!,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$completedQuizzes of 8 quizzes completed',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.purple[600],
                    ),
                  ),
                ],
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Keep going! Every question makes you smarter ✨',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.purple[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        hoverColor: color.withOpacity(0.05),
      ),
    );
  }
}
