// Import your MathViews widget

import 'dart:math' as math;

import 'package:nextgen_learners/constant/import_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;
  // late Animation<double> _rotationAnimation;
  // late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create animations
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );    // Start animations
    _scaleController.forward();
    _rotationController.repeat();
    _bounceController.repeat(reverse: true);

    // Navigate to MathViews after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      Get.off(() => const Dashboard(totalPoints: 0));
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient and main content
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Colors.purple[100]!,
                  Colors.pink[100]!,
                  Colors.cyan[50]!,
                  Colors.purple[50]!,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated mascot with rotating stars
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Main mascot image with scale animation
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/home_screen/buddy.png',
                            height: 150,
                            width: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      // Rotating stars around mascot
                      ...List.generate(6, (index) => _buildRotatingStar(index)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Five bouncing emojis
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBouncingEmoji('🎯', 0),
                      _buildBouncingEmoji('🚀', 200),
                      _buildBouncingEmoji('⭐', 400),
                      _buildBouncingEmoji('🎨', 600),
                      _buildBouncingEmoji('🎪', 800),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // DU logo at top-left
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  'assets/home_screen/du_logo.png',
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRotatingStar(int index) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        final angle =
            (_rotationController.value * 2 * math.pi) + (index * math.pi / 3);
        return Transform.translate(
          offset: Offset(math.cos(angle) * 80, math.sin(angle) * 80),
          child: Transform.rotate(
            angle: -_rotationController.value * 2 * math.pi,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color:
                    [
                      Colors.yellow,
                      Colors.pink,
                      Colors.cyan,
                      Colors.orange,
                      Colors.purple,
                      Colors.green,
                    ][index],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: Text('⭐', style: TextStyle(fontSize: 12)),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBouncingEmoji(String emoji, int delay) {
    return AnimatedBuilder(
      animation: _bounceController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            math.sin(_bounceController.value * 2 * math.pi + delay / 1000) * 10,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(emoji, style: const TextStyle(fontSize: 28)),
          ),
        );
      },
    );
  }
}
