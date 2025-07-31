  import 'package:nextgen_learners/constant/import_export.dart';

  const kDashboardGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        HOME_SCREEN_COLOR_LIGHT_PEACH,
        HOME_SCREEN_COLOR_LIGHT_PURPLE,
      ],
    ),
  );

  class Dashboard extends StatefulWidget {
    const Dashboard({super.key});

    @override
    State<Dashboard> createState() => _DashboardState();
  }

  class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
    late AnimationController _fadeController;
    late AnimationController _scaleController;
    late Animation<double> _fadeAnimation;
    late Animation<double> _scaleAnimation;

    @override
    void initState() {
      super.initState();
      
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

      // Start animations
      _fadeController.forward();
      _scaleController.forward();
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
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 24,
                  ),
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
              child: const Icon(
                Icons.star,
                color: Colors.yellow,
                size: 24,
              ),
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
                      child: Column(
                        children: [
                          // Welcome Section
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(bottom: 30),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.cyan[50]!,
                                  Colors.blue[50]!,
                                ],
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
                                    fontSize: 22,
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
                              ],
                            ),
                          ),

                          // Learning Categories Grid
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: 0.9,
                              children: [
                                CustomContainer(
                                  newPage: ANIMAL_Name_SCREEN,
                                  title: "Animals",
                                  subtitle: "Meet cute animals!",
                               
                                  img: 'assets/home_screen/lion.jpg',
                                  primaryColor: ANIMAL_SCREEN_COLOR_LIGHT_PINK,
                                  secondaryColor: ANIMAL_SCREEN_COLOR_LIGHT_LAVENDER,
                                  delay: 200,
                                ),
                                CustomContainer(
                                  newPage: ANIMAL_SOUND_SCREEN,
                                  title: "Animal Sounds",
                                  subtitle: "Hear them roar!",
                                
                                  img: 'assets/home_screen/sound.webp',
                                  primaryColor: ANIMALSOUND_COLOR_LIGHT_ORANGE,
                                  secondaryColor: ANIMALSOUND_COLOR_LIGHT_CYAN,
                                  delay: 400,
                                ),
                                CustomContainer(
                                  newPage: MATH_SCREEN,
                                  title: "Math Fun",
                                  subtitle: "Numbers & counting!",
                                
                                  img: 'assets/home_screen/math.webp',
                                  primaryColor: MATH_COLOR_LIGHT_PEACH,
                                  secondaryColor: MATH_COLOR_SOFT_PINK,
                                  delay: 600,
                                ),
                                CustomContainer(
                                  newPage: VEHICLE_NAME_SCREEN,
                                  title: "Vehicles",
                                  subtitle: "Cars, trains & more!",
                              
                                  img: 'assets/home_screen/vehicals.jpg',
                                  primaryColor: VEHICLES_COLOR_LIGHT_BLUE,
                                  secondaryColor: VEHICLES_COLOR_SKY_BLUE,
                                  delay: 800,
                                ),
                              ],
                            ),
                          ),

                          // Fun Footer
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildBouncingEmoji('🎯', 0),
                                _buildBouncingEmoji('🌈', 200),
                                _buildBouncingEmoji('⭐', 400),
                                _buildBouncingEmoji('🎨', 600),
                                _buildBouncingEmoji('🎪', 800),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }


    Widget _buildBouncingEmoji(String emoji, int delay) {
      return TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 1500 + delay),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.bounceOut,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, (1 - value) * -30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          );
        },
      );
    }
  }