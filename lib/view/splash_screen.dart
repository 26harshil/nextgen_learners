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
  late AnimationController _textAnimationController;
  late AnimationController _quoteAnimationController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _textScaleAnimation;
  late Animation<double> _quoteOpacityAnimation;
  late Animation<Offset> _quoteSlideAnimation;

  final List<String> _motivationalQuotes = [
    "Every expert was once a beginner",
    "Learning is a treasure that follows you everywhere",
    "The beautiful thing about learning is that nobody can take it from you",
    "Education is the passport to the future",
    "Knowledge is power, wisdom is light",
    "Small steps daily lead to big achievements",
  ];

  String _currentQuote = "";

  @override
  void initState() {
    super.initState();

    // Pick a random quote
    _currentQuote = _motivationalQuotes[math.Random().nextInt(_motivationalQuotes.length)];

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

    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _quoteAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Create animations
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _textScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: Curves.bounceOut,
      ),
    );

    _quoteOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _quoteAnimationController,
        curve: Curves.easeIn,
      ),
    );

    _quoteSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _quoteAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Start animations
    _scaleController.forward();
    _rotationController.repeat();
    _bounceController.repeat(reverse: true);
    
    // Delay text animation
    Future.delayed(const Duration(milliseconds: 500), () {
      _textAnimationController.forward();
    });
    
    // Delay quote animation
    Future.delayed(const Duration(milliseconds: 1000), () {
      _quoteAnimationController.forward();
    });

    // Navigate to Dashboard after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      Get.off(() => const Dashboard(totalPoints: 0));
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _bounceController.dispose();
    _textAnimationController.dispose();
    _quoteAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
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
        child: Stack(
          children: [
            // Floating decorative elements
            ..._buildFloatingElements(),
            
            // Main content
            Center(
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
                                blurRadius: 20,
                                offset: const Offset(0, 10),
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
                  const SizedBox(height: 40),
                  
                  // App Name with animation
                  ScaleTransition(
                    scale: _textScaleAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.withOpacity(0.1),
                            Colors.pink.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.purple.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.purple[600]!,
                            Colors.pink[600]!,
                            Colors.blue[600]!,
                          ],
                        ).createShader(bounds),
                        child: Text(
                          'BrainZy',
                          style: GoogleFonts.poppins(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Motivational Quote
                  SlideTransition(
                    position: _quoteSlideAnimation,
                    child: FadeTransition(
                      opacity: _quoteOpacityAnimation,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.format_quote,
                              color: Colors.purple[400],
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _currentQuote,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.purple[700],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
            
            // Bottom section with app name and logos
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tagline
                    FadeTransition(
                      opacity: _quoteOpacityAnimation,
                      child: Text(
                        'Learn • Play • Grow',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.purple[600],
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Logos side by side
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // DU Logo
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/home_screen/du_logo.png',
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 30),
                        
                        // ASWDC Logo
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/home_screen/ASWC.png',
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    
                    // Powered by text
                    FadeTransition(
                      opacity: _quoteOpacityAnimation,
                      child: Text(
                        'Powered by DU & ASWDC',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Loading indicator at bottom
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.purple[100],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[400]!),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFloatingElements() {
    return List.generate(8, (index) {
      return AnimatedBuilder(
        animation: _bounceController,
        builder: (context, child) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          
          return Positioned(
            left: (index % 4) * (screenWidth / 4) + 20,
            top: (index ~/ 4) * (screenHeight / 2) + 
                 math.sin(_bounceController.value * 2 * math.pi + index) * 20,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: [
                  Colors.purple[200],
                  Colors.pink[200],
                  Colors.blue[200],
                  Colors.cyan[200],
                ][index % 4]?.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      );
    });
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
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    [
                      Colors.yellow[400]!,
                      Colors.pink[400]!,
                      Colors.cyan[400]!,
                      Colors.orange[400]!,
                      Colors.purple[400]!,
                      Colors.green[400]!,
                    ][index],
                    Colors.white,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: Text('⭐', style: TextStyle(fontSize: 14)),
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
            math.sin(_bounceController.value * 2 * math.pi + delay / 1000) * 12,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
        );
      },
    );
  }
}