// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:nextgen_learners/constant/CustomContainer.dart';
// // import 'package:nextgen_learners/constant/string_constant.dart';
// // import 'package:nextgen_learners/controller/dashboard_controller.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:nextgen_learners/view/about_us.dart';
// // import 'package:nextgen_learners/view/achievements_page.dart';

// // const kDashboardGradient = BoxDecoration(
// //   gradient: LinearGradient(
// //     begin: Alignment.topLeft,
// //     end: Alignment.bottomRight,
// //     colors: [HOME_SCREEN_COLOR_LIGHT_PEACH, HOME_SCREEN_COLOR_LIGHT_PURPLE],
// //   ),
// // );

// // class Dashboard extends StatefulWidget {
// //   final int totalPoints;
// //   const Dashboard({super.key, required this.totalPoints});

// //   @override
// //   State<Dashboard> createState() => _DashboardState();
// // }

// // class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
// //   late AnimationController _fadeController;
// //   late AnimationController _scaleController;
// //   late Animation<double> _fadeAnimation;
// //   late Animation<double> _scaleAnimation;
// //   int cumulativePoints = 0;

// //   final DashboardController _controller = Get.put(DashboardController());
// //   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializeAnimations();
// //     _loadCumulativePoints();
// //   }

// //   void _initializeAnimations() {
// //     _fadeController = AnimationController(
// //       duration: const Duration(milliseconds: 1500),
// //       vsync: this,
// //     );

// //     _scaleController = AnimationController(
// //       duration: const Duration(milliseconds: 2000),
// //       vsync: this,
// //     );

// //     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
// //       CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
// //     );

// //     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
// //       CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
// //     );

// //     _fadeController.forward();
// //     _scaleController.forward();
// //   }

// //   Future<void> _loadCumulativePoints() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     List<String>? previousScores = prefs.getStringList('quiz_scores') ?? [];
// //     int previousTotal = previousScores.fold(
// //       0,
// //       (sum, score) => sum + int.parse(score),
// //     );
// //     int newTotal = previousTotal + widget.totalPoints;
// //     await prefs.setStringList('quiz_scores', [
// //       ...previousScores,
// //       widget.totalPoints.toString(),
// //     ]);
// //     setState(() {
// //       cumulativePoints = newTotal;
// //     });
// //   }

// //   Future<bool> _isCompleted(String id) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getBool('completed_$id') ?? false;
// //   }

// //   Future<List<String>> _loadBadges() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getStringList('badges') ?? [];
// //   }

// //   Widget _tileWithTick({
// //     required String quizId,
// //     required CustomContainer tile,
// //   }) {
// //     return FutureBuilder<bool>(
// //       future: _isCompleted(quizId),
// //       builder: (context, snapshot) {
// //         final completed = snapshot.data ?? false;
// //         return Stack(
// //           children: [
// //             tile,
// //             if (completed)
// //               Positioned(
// //                 top: 8,
// //                 right: 8,
// //                 child: Container(
// //                   padding: const EdgeInsets.all(6),
// //                   decoration: BoxDecoration(
// //                     color: Colors.green[600],
// //                     shape: BoxShape.circle,
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.green.withOpacity(0.3),
// //                         blurRadius: 8,
// //                         offset: const Offset(0, 3),
// //                       ),
// //                     ],
// //                   ),
// //                   child: const Icon(Icons.check, color: Colors.white, size: 18),
// //                 ),
// //               ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildAchievementsRow() {
// //     return FutureBuilder<List<String>>(
// //       future: _loadBadges(),
// //       builder: (context, snapshot) {
// //         final badges = snapshot.data ?? [];
// //         if (badges.isEmpty) return const SizedBox.shrink();
// //         return Container(
// //           width: double.infinity,
// //           padding: const EdgeInsets.all(12),
// //           margin: const EdgeInsets.only(bottom: 20),
// //           decoration: BoxDecoration(
// //             color: Colors.white.withOpacity(0.6),
// //             borderRadius: BorderRadius.circular(16),
// //           ),
// //           child: SingleChildScrollView(
// //             scrollDirection: Axis.horizontal,
// //             child: Row(
// //               children: badges.map((id) {
// //                 final badgeMap = {
// //                   'animal_name': 'animalQuizz',
// //                   'animal_sound': 'soundQuizz',
// //                   'math': 'mathQuizz',
// //                   'vehicals': 'vehicleQuizz',
// //                   'fruits': 'fruitQuizz',
// //                   'vegetables': 'vegetableQuizz',
// //                   'colors': 'colorQuizz',
// //                   'birds': 'birdQuizz',
// //                 };
// //                 final badgeName = badgeMap[id] ?? id;
// //                 final path = 'badges/$badgeName.png';
// //                 return Padding(
// //                   padding: const EdgeInsets.symmetric(horizontal: 6.0),
// //                   child: Tooltip(
// //                     message: 'Completed: ${badgeName.replaceAll('Quizz', '')}',
// //                     child: ClipRRect(
// //                       borderRadius: BorderRadius.circular(12),
// //                       child: Image.asset(
// //                         path,
// //                         height: 48,
// //                         width: 48,
// //                         fit: BoxFit.cover,
// //                         errorBuilder: (context, error, stackTrace) => Container(
// //                           height: 48,
// //                           width: 48,
// //                           alignment: Alignment.center,
// //                           decoration: BoxDecoration(
// //                             color: Colors.green[200],
// //                             borderRadius: BorderRadius.circular(12),
// //                           ),
// //                           child: const Icon(
// //                             Icons.emoji_events,
// //                             color: Colors.white,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 );
// //               }).toList(),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _fadeController.dispose();
// //     _scaleController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       key: _scaffoldKey,
// //       drawer: Drawer(
// //         child: SafeArea(
// //           child: ListView(
// //             padding: EdgeInsets.zero,
// //             children: [
// //               DrawerHeader(
// //                 decoration: BoxDecoration(
// //                   gradient: LinearGradient(
// //                     colors: [
// //                       Colors.purple[400]!.withOpacity(0.9),
// //                       Colors.cyan[300]!.withOpacity(0.9),
// //                     ],
// //                     begin: Alignment.topLeft,
// //                     end: Alignment.bottomRight,
// //                   ),
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     ClipRRect(
// //                       borderRadius: BorderRadius.circular(16),
// //                       child: Image.asset(
// //                         'assets/home_screen/buddy.png',
// //                         height: 60,
// //                         width: 60,
// //                         fit: BoxFit.contain,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             'NextGen Learners',
// //                             style: GoogleFonts.poppins(
// //                               fontSize: 18,
// //                               fontWeight: FontWeight.w800,
// //                               color: Colors.white,
// //                             ),
// //                           ),
// //                           const SizedBox(height: 4),
// //                           Text(
// //                             'Learn • Play • Achieve',
// //                             style: GoogleFonts.poppins(
// //                               fontSize: 12,
// //                               color: Colors.white70,
// //                               fontWeight: FontWeight.w600,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               ListTile(
// //                 leading: const Icon(Icons.info_outline, color: Colors.purple),
// //                 title: Text('About Us', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                   Get.to(() => const AboutUsPage());
// //                 },
// //               ),
// //               ListTile(
// //                 leading: const Icon(Icons.emoji_events, color: Colors.amber),
// //                 title: Text('Achievements', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                   Get.to(() => const AchievementsPage());
// //                 },
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //       appBar: AppBar(
// //         elevation: 0,
// //         title: FadeTransition(
// //           opacity: _fadeAnimation,
// //           child: Row(
// //             children: [
// //               Container(
// //                 padding: const EdgeInsets.all(8),
// //                 decoration: BoxDecoration(
// //                   color: Colors.white.withOpacity(0.2),
// //                   borderRadius: BorderRadius.circular(12),
// //                 ),
// //                 child: IconButton(
// //                   tooltip: 'Open menu',
// //                   onPressed: () => _scaffoldKey.currentState?.openDrawer(),
// //                   icon: const Icon(Icons.school, color: Colors.white, size: 24),
// //                 ),
// //               ),
// //               const SizedBox(width: 12),
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     'NEXTGEN LEARNERS',
// //                     style: GoogleFonts.fredoka(
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 18,
// //                       color: Colors.white,
// //                       letterSpacing: 1.2,
// //                     ),
// //                   ),
// //                   Text(
// //                     'Learning Made Fun! 🌟',
// //                     style: GoogleFonts.fredoka(
// //                       fontSize: 12,
// //                       color: Colors.white.withOpacity(0.9),
// //                       fontWeight: FontWeight.w500,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //         flexibleSpace: Container(
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(
// //               begin: Alignment.topLeft,
// //               end: Alignment.bottomRight,
// //               colors: [
// //                 Colors.purple[400]!,
// //                 Colors.pink[400]!,
// //                 Colors.orange[300]!,
// //               ],
// //             ),
// //           ),
// //         ),
// //         actions: [
// //           Container(
// //             margin: const EdgeInsets.only(right: 16),
// //             padding: const EdgeInsets.all(8),
// //             decoration: BoxDecoration(
// //               color: Colors.white.withOpacity(0.2),
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //             child: const Icon(Icons.star, color: Colors.yellow, size: 24),
// //           ),
// //         ],
// //       ),
// //       body: Container(
// //         decoration: BoxDecoration(
// //           gradient: RadialGradient(
// //             center: Alignment.center,
// //             radius: 1.5,
// //             colors: [
// //               Colors.white,
// //               HOME_SCREEN_COLOR_LIGHT_PEACH.withOpacity(0.3),
// //               HOME_SCREEN_COLOR_LIGHT_PURPLE.withOpacity(0.3),
// //             ],
// //           ),
// //         ),
// //         child: SafeArea(
// //           child: AnimatedBuilder(
// //             animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
// //             builder: (context, child) {
// //               return FadeTransition(
// //                 opacity: _fadeAnimation,
// //                 child: Transform.scale(
// //                   scale: _scaleAnimation.value,
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(20.0),
// //                     child: Obx(() {
// //                       if (_controller.isLoading.value) {
// //                         return const Center(child: CircularProgressIndicator());
// //                       }
// //                       return Column(
// //                         children: [
// //                           // Welcome Section
// //                           Container(
// //                             width: double.infinity,
// //                             padding: const EdgeInsets.all(20),
// //                             margin: const EdgeInsets.only(bottom: 30),
// //                             decoration: BoxDecoration(
// //                               gradient: LinearGradient(
// //                                 colors: [Colors.cyan[50]!, Colors.blue[50]!],
// //                               ),
// //                               borderRadius: BorderRadius.circular(20),
// //                               boxShadow: [
// //                                 BoxShadow(
// //                                   color: Colors.blue.withOpacity(0.1),
// //                                   blurRadius: 15,
// //                                   offset: const Offset(0, 5),
// //                                 ),
// //                               ],
// //                             ),
// //                             child: Column(
// //                               children: [
// //                                 Text(
// //                                   '🎉 Welcome to Learning Adventure! 🚀',
// //                                   style: GoogleFonts.fredoka(
// //                                     fontSize: 20,
// //                                     fontWeight: FontWeight.bold,
// //                                     color: Colors.indigo[700],
// //                                   ),
// //                                   textAlign: TextAlign.center,
// //                                 ),
// //                                 const SizedBox(height: 8),
// //                                 Text(
// //                                   'Choose your favorite topic to start learning!',
// //                                   style: GoogleFonts.fredoka(
// //                                     fontSize: 16,
// //                                     color: Colors.indigo[500],
// //                                     fontWeight: FontWeight.w500,
// //                                   ),
// //                                   textAlign: TextAlign.center,
// //                                 ),
// //                                 const SizedBox(height: 12),
// //                                 Container(
// //                                   padding: const EdgeInsets.symmetric(
// //                                     horizontal: 16,
// //                                     vertical: 8,
// //                                   ),
// //                                   decoration: BoxDecoration(
// //                                     color: Colors.yellow[100],
// //                                     borderRadius: BorderRadius.circular(12),
// //                                     boxShadow: [
// //                                       BoxShadow(
// //                                         color: Colors.yellow.withOpacity(0.3),
// //                                         blurRadius: 10,
// //                                         offset: const Offset(0, 3),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                   child: Row(
// //                                     mainAxisSize: MainAxisSize.min,
// //                                     children: [
// //                                       const Icon(
// //                                         Icons.star,
// //                                         color: Colors.yellow,
// //                                         size: 24,
// //                                       ),
// //                                       const SizedBox(width: 8),
// //                                       Text(
// //                                         'Total Points: $cumulativePoints',
// //                                         style: GoogleFonts.fredoka(
// //                                           fontSize: 25,
// //                                           fontWeight: FontWeight.bold,
// //                                           color: Colors.indigo[700],
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),

// //                           // Achievements Row
// //                           _buildAchievementsRow(),

// //                           // Learning Categories Grid
// //                           Expanded(
// //                             child: GridView.count(
// //                               crossAxisCount: 2,
// //                               crossAxisSpacing: 20,
// //                               mainAxisSpacing: 20,
// //                               childAspectRatio: 0.9,
// //                               children: [
// //                                 _tileWithTick(
// //                                   quizId: 'animal_name',
// //                                   tile: CustomContainer(
// //                                     key: UniqueKey(),
// //                                     newPage: ANIMAL_Name_SCREEN,
// //                                     title: "Animals",
// //                                     subtitle: "Meet cute animals!",
// //                                     img: 'assets/home_screen/lion.jpg',
// //                                     primaryColor:
// //                                         ANIMAL_SCREEN_COLOR_LIGHT_PINK,
// //                                     secondaryColor:
// //                                         ANIMAL_SCREEN_COLOR_LIGHT_LAVENDER,
// //                                     delay: 200,
// //                                   ),
// //                                 ),
// //                                 _tileWithTick(
// //                                   quizId: 'animal_sound',
// //                                   tile: CustomContainer(
// //                                     key: UniqueKey(),
// //                                     newPage: ANIMAL_SOUND_SCREEN,
// //                                     title: "Animal Sounds",
// //                                     subtitle: "Hear them roar!",
// //                                     img: 'assets/home_screen/sound.webp',
// //                                     primaryColor:
// //                                         ANIMALSOUND_COLOR_LIGHT_ORANGE,
// //                                     secondaryColor:
// //                                         ANIMALSOUND_COLOR_LIGHT_CYAN,
// //                                     delay: 400,
// //                                   ),
// //                                 ),
// //                                 _tileWithTick(
// //                                   quizId: 'math',
// //                                   tile: CustomContainer(
// //                                     key: UniqueKey(),
// //                                     newPage: MATH_SCREEN,
// //                                     title: "Math Fun",
// //                                     subtitle: "Numbers & counting!",
// //                                     img: 'assets/home_screen/math.webp',
// //                                     primaryColor: MATH_COLOR_LIGHT_PEACH,
// //                                     secondaryColor: MATH_COLOR_SOFT_PINK,
// //                                     delay: 600,
// //                                   ),
// //                                 ),
// //                                 _tileWithTick(
// //                                   quizId: 'vehicals',
// //                                   tile: CustomContainer(
// //                                     key: UniqueKey(),
// //                                     newPage: VEHICLE_NAME_SCREEN,
// //                                     title: "Vehicles",
// //                                     subtitle: "Cars, trains & more!",
// //                                     img: 'assets/home_screen/vehicals.jpg',
// //                                     primaryColor: VEHICLES_COLOR_LIGHT_BLUE,
// //                                     secondaryColor: VEHICLES_COLOR_SKY_BLUE,
// //                                     delay: 800,
// //                                   ),
// //                                 ),
// //                                 _tileWithTick(
// //                                   quizId: 'fruits',
// //                                   tile: CustomContainer(
// //                                     key: UniqueKey(),
// //                                     newPage: FRUITS_SCREEN,
// //                                     title: "Fruits",
// //                                     subtitle: "Learn about tasty fruits!",
// //                                     img: 'assets/home_screen/fruits.jpg',
// //                                     primaryColor: Colors.red[100]!,
// //                                     secondaryColor: Colors.orange[100]!,
// //                                     delay: 1000,
// //                                   ),
// //                                 ),
// //                                 _tileWithTick(
// //                                   quizId: 'vegetables',
// //                                   tile: CustomContainer(
// //                                     key: UniqueKey(),
// //                                     newPage: VEGETABLES_SCREEN,
// //                                     title: "Vegetables",
// //                                     subtitle: "Discover healthy veggies!",
// //                                     img: 'assets/home_screen/vegetables.jpg',
// //                                     primaryColor: Colors.green[100]!,
// //                                     secondaryColor: Colors.lime[100]!,
// //                                     delay: 1200,
// //                                   ),
// //                                 ),
// //                                 _tileWithTick(
// //                                   quizId: 'colors',
// //                                   tile: CustomContainer(
// //                                     key: UniqueKey(),
// //                                     newPage: COLORS_Screen,
// //                                     title: "Colors",
// //                                     subtitle: "Explore vibrant colors!",
// //                                     img: 'assets/home_screen/colors.webp',
// //                                     primaryColor: Colors.blue[100]!,
// //                                     secondaryColor: Colors.purple[100]!,
// //                                     delay: 1400,
// //                                   ),
// //                                 ),
// //                                 _tileWithTick(
// //                                   quizId: 'birds',
// //                                   tile: CustomContainer(
// //                                     key: UniqueKey(),
// //                                     newPage: BIRDS_SCREEN,
// //                                     title: "Birds",
// //                                     subtitle: "Learn about birds!",
// //                                     img: 'assets/home_screen/birds.jpg',
// //                                     primaryColor: MATH_COLOR_LIGHT_PEACH,
// //                                     secondaryColor: MATH_COLOR_SOFT_PINK,
// //                                     delay: 1600,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                       );
// //                     }),
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildAppDrawer(BuildContext context) {
// //     return Drawer(
// //       child: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //             colors: [Colors.white, Colors.purple[50]!],
// //           ),
// //         ),
// //         child: SafeArea(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               DrawerHeader(
// //                 decoration: BoxDecoration(
// //                   gradient: LinearGradient(
// //                     colors: [
// //                       Colors.purple[400]!.withOpacity(0.9),
// //                       Colors.cyan[300]!.withOpacity(0.9),
// //                     ],
// //                     begin: Alignment.topLeft,
// //                     end: Alignment.bottomRight,
// //                   ),
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     ClipRRect(
// //                       borderRadius: BorderRadius.circular(16),
// //                       child: Image.asset(
// //                         'assets/home_screen/buddy.png',
// //                         height: 60,
// //                         width: 60,
// //                         fit: BoxFit.contain,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             'NextGen Learners',
// //                             style: GoogleFonts.poppins(
// //                               fontSize: 18,
// //                               fontWeight: FontWeight.w800,
// //                               color: Colors.white,
// //                             ),
// //                           ),
// //                           const SizedBox(height: 4),
// //                           Text(
// //                             'Learn • Play • Achieve',
// //                             style: GoogleFonts.poppins(
// //                               fontSize: 12,
// //                               color: Colors.white70,
// //                               fontWeight: FontWeight.w600,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               ListTile(
// //                 leading: const Icon(Icons.info_outline, color: Colors.purple),
// //                 title: Text(
// //                   'About Us',
// //                   style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
// //                 ),
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                   Get.to(() => const AboutUsPage());
// //                 },
// //               ),
// //               ListTile(
// //                 leading: const Icon(Icons.emoji_events, color: Colors.amber),
// //                 title: Text(
// //                   'Achievements',
// //                   style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
// //                 ),
// //                 onTap: () {
// //                   Navigator.pop(context);
// //                   Get.to(() => const AchievementsPage());
// //                 },
// //               ),
// //               const Spacer(),
// //               Padding(
// //                 padding: const EdgeInsets.all(12.0),
// //                 child: Text(
// //                   'Keep going! Every question makes you smarter ✨',
// //                   textAlign: TextAlign.center,
// //                   style: GoogleFonts.poppins(
// //                     fontSize: 12,
// //                     color: Colors.purple[700],
// //                     fontWeight: FontWeight.w600,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // Updated _markCompleted method for CustomMCQWidget to handle badge awarding with 75% score requirement
// // Future<void> _markCompleted(dynamic widget) async {
// //   final prefs = await SharedPreferences.getInstance();
// //   // Assume widget.score is the number of correct answers and widget.totalQuestions is the total number of questions
// //   // Each question is worth 1 point for simplicity
// //   final double scorePercentage = (widget.score / widget.totalQuestions) * 100;
  
// //   // Only mark as completed and award badge if score is at least 75%
// //   if (scorePercentage >= 75.0) {
// //     await prefs.setBool('completed_${widget.quizId}', true);
// //     await prefs.remove('progress_${widget.quizId}');
// //     await prefs.remove('points_${widget.quizId}');
// //     final badges = prefs.getStringList('badges') ?? [];
// //     // Map quiz IDs to badge names
// //     const badgeMap = {
// //       'animal_name': 'animalQuizz',
// //       'animal_sound': 'soundQuizz',
// //       'math': 'mathQuizz',
// //       'vehicals': 'vehicleQuizz',
// //       'fruits': 'fruitQuizz',
// //       'vegetables': 'vegetableQuizz',
// //       'colors': 'colorQuizz',
// //       'birds': 'birdQuizz',
// //     };
// //     final badgeName = badgeMap[widget.quizId] ?? widget.quizId;
// //     if (!badges.contains(badgeName)) {
// //       badges.add(badgeName);
// //       await prefs.setStringList('badges', badges);
// //     }
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:nextgen_learners/constant/CustomContainer.dart';
// import 'package:nextgen_learners/constant/string_constant.dart';
// import 'package:nextgen_learners/controller/dashboard_controller.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:nextgen_learners/view/about_us.dart';
// import 'package:nextgen_learners/view/achievements_page.dart';

// const kDashboardGradient = BoxDecoration(
//   gradient: LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [HOME_SCREEN_COLOR_LIGHT_PEACH, HOME_SCREEN_COLOR_LIGHT_PURPLE],
//   ),
// );

// class Dashboard extends StatefulWidget {
//   final int totalPoints;
//   const Dashboard({super.key, required this.totalPoints});

//   @override
//   State<Dashboard> createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
//   late AnimationController _fadeController;
//   late AnimationController _scaleController;
//   late AnimationController _bounceController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _bounceAnimation;
//   int cumulativePoints = 0;
//   int completedQuizzes = 0;

//   final DashboardController _controller = Get.put(DashboardController());
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _loadCumulativePoints();
//     _loadCompletedQuizzes();
//   }

//   void _initializeAnimations() {
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     );

//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     );

//     _bounceController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
//     );

//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
//     );

//     _bounceAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
//       CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
//     );

//     _fadeController.forward();
//     _scaleController.forward();
//   }

//   Future<void> _loadCumulativePoints() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? previousScores = prefs.getStringList('quiz_scores') ?? [];
//     int previousTotal = previousScores.fold(
//       0,
//       (sum, score) => sum + int.parse(score),
//     );
//     int newTotal = previousTotal + widget.totalPoints;
//     await prefs.setStringList('quiz_scores', [
//       ...previousScores,
//       widget.totalPoints.toString(),
//     ]);
//     setState(() {
//       cumulativePoints = newTotal;
//     });
//   }

//   Future<void> _loadCompletedQuizzes() async {
//     final prefs = await SharedPreferences.getInstance();
//     final quizIds = ['animal_name', 'animal_sound', 'math', 'vehicals', 'fruits', 'vegetables', 'colors', 'birds'];
//     int count = 0;
//     for (String id in quizIds) {
//       if (prefs.getBool('completed_$id') ?? false) {
//         count++;
//       }
//     }
//     setState(() {
//       completedQuizzes = count;
//     });
//   }

//   Future<bool> _isCompleted(String id) async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('completed_$id') ?? false;
//   }

//   Future<List<String>> _loadBadges() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getStringList('badges') ?? [];
//   }

//   Widget _tileWithTick({
//     required String quizId,
//     required CustomContainer tile,
//   }) {
//     return FutureBuilder<bool>(
//       future: _isCompleted(quizId),
//       builder: (context, snapshot) {
//         final completed = snapshot.data ?? false;
//         return Stack(
//           children: [
//             tile,
//             if (completed)
//               Positioned(
//                 top: 8,
//                 right: 8,
//                 child: Container(
//                   padding: const EdgeInsets.all(6),
//                   decoration: BoxDecoration(
//                     color: Colors.green[600],
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.green.withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: const Icon(Icons.check, color: Colors.white, size: 18),
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildAchievementsRow() {
//     return FutureBuilder<List<String>>(
//       future: _loadBadges(),
//       builder: (context, snapshot) {
//         final badges = snapshot.data ?? [];
//         if (badges.isEmpty) {
//           return Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             margin: const EdgeInsets.only(bottom: 20),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.orange[50]!, Colors.yellow[50]!],
//               ),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.orange[200]!),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.emoji_events, color: Colors.orange[600], size: 24),
//                 const SizedBox(width: 12),
//                 Text(
//                   'Complete quizzes to earn badges!',
//                   style: GoogleFonts.fredoka(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.orange[800],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
        
//         return Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(12),
//           margin: const EdgeInsets.only(bottom: 20),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.white, Colors.purple[50]!],
//             ),
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.purple.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(Icons.emoji_events, color: Colors.amber[700], size: 20),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Your Achievements',
//                     style: GoogleFonts.fredoka(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.purple[800],
//                     ),
//                   ),
//                   const Spacer(),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.purple[100],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       '${badges.length} badges',
//                       style: GoogleFonts.fredoka(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.purple[700],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: badges.map((id) {
//                     final badgeMap = {
//                       'animal_name': 'animalQuizz',
//                       'animal_sound': 'soundQuizz',
//                       'math': 'mathQuizz',
//                       'vehicals': 'vehicleQuizz',
//                       'fruits': 'fruitQuizz',
//                       'vegetables': 'vegetableQuizz',
//                       'colors': 'colorQuizz',
//                       'birds': 'birdQuizz',
//                     };
//                     final badgeName = badgeMap[id] ?? id;
//                     final path = 'badges/$badgeName.png';
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 6.0),
//                       child: Tooltip(
//                         message: 'Completed: ${badgeName.replaceAll('Quizz', '')}',
//                         child: Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.purple.withOpacity(0.1),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.asset(
//                               path,
//                               height: 48,
//                               width: 48,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) => Container(
//                                 height: 48,
//                                 width: 48,
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [Colors.purple[300]!, Colors.pink[300]!],
//                                   ),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: const Icon(
//                                   Icons.emoji_events,
//                                   color: Colors.white,
//                                   size: 24,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _scaleController.dispose();
//     _bounceController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: _buildAppDrawer(context),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.purple[100]!,
//               Colors.white,
//               Colors.cyan[50]!,
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: AnimatedBuilder(
//             animation: Listenable.merge([_fadeAnimation, _scaleAnimation]),
//             builder: (context, child) {
//               return FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: Transform.scale(
//                   scale: _scaleAnimation.value,
//                   child: Column(
//                     children: [
//                       // Custom App Bar
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [
//                               Colors.purple[400]!,
//                               Colors.pink[400]!,
//                               Colors.orange[300]!,
//                             ],
//                           ),
//                           borderRadius: const BorderRadius.only(
//                             bottomLeft: Radius.circular(30),
//                             bottomRight: Radius.circular(30),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.purple.withOpacity(0.3),
//                               blurRadius: 15,
//                               offset: const Offset(0, 5),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             // Menu Button
//                             InkWell(
//                               onTap: () => _scaffoldKey.currentState?.openDrawer(),
//                               borderRadius: BorderRadius.circular(12),
//                               child: Container(
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.2),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: const Icon(
//                                   Icons.menu,
//                                   color: Colors.white,
//                                   size: 24,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             // Title
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'NEXTGEN LEARNERS',
//                                     style: GoogleFonts.fredoka(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20,
//                                       color: Colors.white,
//                                       letterSpacing: 1.2,
//                                       shadows: [
//                                         Shadow(
//                                           color: Colors.black.withOpacity(0.2),
//                                           blurRadius: 4,
//                                           offset: const Offset(2, 2),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Text(
//                                     'Learning Made Fun! 🌟',
//                                     style: GoogleFonts.fredoka(
//                                       fontSize: 13,
//                                       color: Colors.white.withOpacity(0.95),
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             // Trophy Icon
//                             AnimatedBuilder(
//                               animation: _bounceAnimation,
//                               builder: (context, child) {
//                                 return Transform.scale(
//                                   scale: _bounceAnimation.value,
//                                   child: Container(
//                                     padding: const EdgeInsets.all(10),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white.withOpacity(0.2),
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: const Icon(
//                                       Icons.emoji_events,
//                                       color: Colors.yellow,
//                                       size: 24,
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
                      
//                       // Main Content
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Obx(() {
//                             if (_controller.isLoading.value) {
//                               return Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     CircularProgressIndicator(
//                                       valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[400]!),
//                                     ),
//                                     const SizedBox(height: 20),
//                                     Text(
//                                       'Loading awesome content...',
//                                       style: GoogleFonts.fredoka(
//                                         fontSize: 16,
//                                         color: Colors.purple[600],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }
//                             return Column(
//                               children: [
//                                 // Welcome Section with Stats
//                                 Container(
//                                   width: double.infinity,
//                                   padding: const EdgeInsets.all(20),
//                                   margin: const EdgeInsets.only(bottom: 20),
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [
//                                         Colors.cyan[100]!,
//                                         Colors.blue[100]!,
//                                         Colors.purple[100]!,
//                                       ],
//                                     ),
//                                     borderRadius: BorderRadius.circular(24),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.blue.withOpacity(0.2),
//                                         blurRadius: 20,
//                                         offset: const Offset(0, 8),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Text(
//                                         '🎉 Welcome to Your Learning Adventure! 🚀',
//                                         style: GoogleFonts.fredoka(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.indigo[700],
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                       const SizedBox(height: 16),
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                         children: [
//                                           _buildStatCard(
//                                             icon: Icons.star,
//                                             value: cumulativePoints.toString(),
//                                             label: 'Points',
//                                             color: Colors.yellow[700]!,
//                                             bgColor: Colors.yellow[50]!,
//                                           ),
//                                           _buildStatCard(
//                                             icon: Icons.check_circle,
//                                             value: '$completedQuizzes/8',
//                                             label: 'Completed',
//                                             color: Colors.green[700]!,
//                                             bgColor: Colors.green[50]!,
//                                           ),
//                                           _buildStatCard(
//                                             icon: Icons.trending_up,
//                                             value: '${(completedQuizzes / 8 * 100).toInt()}%',
//                                             label: 'Progress',
//                                             color: Colors.blue[700]!,
//                                             bgColor: Colors.blue[50]!,
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),

                              

//                                 // Categories Header
//                                 Padding(
//                                   padding: const EdgeInsets.only(bottom: 16),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         'Choose Your Topic',
//                                         style: GoogleFonts.fredoka(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.indigo[800],
//                                         ),
//                                       ),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                         decoration: BoxDecoration(
//                                           color: Colors.purple[100],
//                                           borderRadius: BorderRadius.circular(20),
//                                         ),
//                                         child: Text(
//                                           '8 Topics',
//                                           style: GoogleFonts.fredoka(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.purple[700],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),

//                                 // Learning Categories Grid
//                                 Expanded(
//                                   child: GridView.count(
//                                     crossAxisCount: 2,
//                                     crossAxisSpacing: 16,
//                                     mainAxisSpacing: 16,
//                                     childAspectRatio: 0.95,
//                                     children: [
//                                       _tileWithTick(
//                                         quizId: 'animal_name',
//                                         tile: CustomContainer(
//                                           key: UniqueKey(),
//                                           newPage: ANIMAL_Name_SCREEN,
//                                           title: "Animals",
//                                           subtitle: "Meet cute animals!",
//                                           img: 'assets/home_screen/lion.jpg',
//                                           primaryColor: ANIMAL_SCREEN_COLOR_LIGHT_PINK,
//                                           secondaryColor: ANIMAL_SCREEN_COLOR_LIGHT_LAVENDER,
//                                           delay: 200,
//                                         ),
//                                       ),
//                                       _tileWithTick(
//                                         quizId: 'animal_sound',
//                                         tile: CustomContainer(
//                                           key: UniqueKey(),
//                                           newPage: ANIMAL_SOUND_SCREEN,
//                                           title: "Animal Sounds",
//                                           subtitle: "Hear them roar!",
//                                           img: 'assets/home_screen/sound.webp',
//                                           primaryColor: ANIMALSOUND_COLOR_LIGHT_ORANGE,
//                                           secondaryColor: ANIMALSOUND_COLOR_LIGHT_CYAN,
//                                           delay: 400,
//                                         ),
//                                       ),
//                                       _tileWithTick(
//                                         quizId: 'math',
//                                         tile: CustomContainer(
//                                           key: UniqueKey(),
//                                           newPage: MATH_SCREEN,
//                                           title: "Math Fun",
//                                           subtitle: "Numbers & counting!",
//                                           img: 'assets/home_screen/math.webp',
//                                           primaryColor: MATH_COLOR_LIGHT_PEACH,
//                                           secondaryColor: MATH_COLOR_SOFT_PINK,
//                                           delay: 600,
//                                         ),
//                                       ),
//                                       _tileWithTick(
//                                         quizId: 'vehicals',
//                                         tile: CustomContainer(
//                                           key: UniqueKey(),
//                                           newPage: VEHICLE_NAME_SCREEN,
//                                           title: "Vehicles",
//                                           subtitle: "Cars, trains & more!",
//                                           img: 'assets/home_screen/vehicals.jpg',
//                                           primaryColor: VEHICLES_COLOR_LIGHT_BLUE,
//                                           secondaryColor: VEHICLES_COLOR_SKY_BLUE,
//                                           delay: 800,
//                                         ),
//                                       ),
//                                       _tileWithTick(
//                                         quizId: 'fruits',
//                                         tile: CustomContainer(
//                                           key: UniqueKey(),
//                                           newPage: FRUITS_SCREEN,
//                                           title: "Fruits",
//                                           subtitle: "Tasty & healthy!",
//                                           img: 'assets/home_screen/fruits.jpg',
//                                           primaryColor: Colors.red[100]!,
//                                           secondaryColor: Colors.orange[100]!,
//                                           delay: 1000,
//                                         ),
//                                       ),
//                                       _tileWithTick(
//                                         quizId: 'vegetables',
//                                         tile: CustomContainer(
//                                           key: UniqueKey(),
//                                           newPage: VEGETABLES_SCREEN,
//                                           title: "Vegetables",
//                                           subtitle: "Healthy veggies!",
//                                           img: 'assets/home_screen/vegetables.jpg',
//                                           primaryColor: Colors.green[100]!,
//                                           secondaryColor: Colors.lime[100]!,
//                                           delay: 1200,
//                                         ),
//                                       ),
//                                       _tileWithTick(
//                                         quizId: 'colors',
//                                         tile: CustomContainer(
//                                           key: UniqueKey(),
//                                           newPage: COLORS_Screen,
//                                           title: "Colors",
//                                           subtitle: "Rainbow fun!",
//                                           img: 'assets/home_screen/colors.webp',
//                                           primaryColor: Colors.blue[100]!,
//                                           secondaryColor: Colors.purple[100]!,
//                                           delay: 1400,
//                                         ),
//                                       ),
//                                       _tileWithTick(
//                                         quizId: 'birds',
//                                         tile: CustomContainer(
//                                           key: UniqueKey(),
//                                           newPage: BIRDS_SCREEN,
//                                           title: "Birds",
//                                           subtitle: "Flying friends!",
//                                           img: 'assets/home_screen/birds.jpg',
//                                           primaryColor: MATH_COLOR_LIGHT_PEACH,
//                                           secondaryColor: MATH_COLOR_SOFT_PINK,
//                                           delay: 1600,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             );
//                           }),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatCard({
//     required IconData icon,
//     required String value,
//     required String label,
//     required Color color,
//     required Color bgColor,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 24),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: GoogleFonts.fredoka(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           Text(
//             label,
//             style: GoogleFonts.fredoka(
//               fontSize: 11,
//               color: color.withOpacity(0.8),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAppDrawer(BuildContext context) {
//     return Drawer(
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Colors.white, Colors.purple[50]!],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               DrawerHeader(

//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.purple[400]!,
//                       Colors.pink[400]!,
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(50),
//                         child: Image.asset(
//                           'assets/home_screen/buddy.png',
//                           height: 60,
//                           width: 60,
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       'NextGen Learners',
//                       style: GoogleFonts.poppins(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w800,
//                         color: Colors.white,
//                       ),
//                     ),
                    
                    
//                   ],
//                 ),
//               ),
              
//               // Menu Items
//               _buildDrawerItem(
//                 icon: Icons.home,
//                 title: 'Home',
//                 color: Colors.blue,
//                 onTap: () => Navigator.pop(context),
//               ),
//               _buildDrawerItem(
//                 icon: Icons.emoji_events,
//                 title: 'Achievements',
//                 color: Colors.amber,
//                 onTap: () {
//                   Navigator.pop(context);
//                   Get.to(() => const AchievementsPage());
//                 },
//               ),
//               _buildDrawerItem(
//                 icon: Icons.info_outline,
//                 title: 'About Us',
//                 color: Colors.purple,
//                 onTap: () {
//                   Navigator.pop(context);
//                   Get.to(() => const AboutUsPage());
//                 },
//               ),
              
//               const Spacer(),
              
//               // Progress Summary
//               Container(
//                 margin: const EdgeInsets.all(16),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.purple[100]!, Colors.pink[100]!],
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Total Points',
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: Colors.purple[700],
//                           ),
//                         ),
//                         Text(
//                           cumulativePoints.toString(),
//                           style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.purple[800],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     LinearProgressIndicator(
//                       value: completedQuizzes / 8,
//                       backgroundColor: Colors.white,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[400]!),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       '$completedQuizzes of 8 quizzes completed',
//                       style: GoogleFonts.poppins(
//                         fontSize: 12,
//                         color: Colors.purple[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               // Footer
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   'Keep going! Every question makes you smarter ✨',
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.poppins(
//                     fontSize: 12,
//                     color: Colors.purple[700],
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDrawerItem({
//     required IconData icon,
//     required String title,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       child: ListTile(
//         leading: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(icon, color: color, size: 24),
//         ),
//         title: Text(
//           title,
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.w600,
//             fontSize: 15,
//           ),
//         ),
//         trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
//         onTap: onTap,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         hoverColor: color.withOpacity(0.05),
//       ),
//     );
//   }
// }
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

  final DashboardController _controller = Get.put(DashboardController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadCumulativePoints();
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

  Future<void> _loadCompletedQuizzes() async {
    final prefs = await SharedPreferences.getInstance();
    final quizIds = ['animal_name', 'animal_sound', 'math', 'vehicals', 'fruits', 'vegetables', 'colors', 'birds'];
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

  Widget _buildAchievementsRow() {
    return FutureBuilder<List<String>>(
      future: _loadBadges(),
      builder: (context, snapshot) {
        final badges = snapshot.data ?? [];
        if (badges.isEmpty) {
          return Container(
            width: double.infinity,
            height: 80, // Fixed height
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange[50]!, Colors.yellow[50]!],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events, color: Colors.orange[600], size: 24),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    'Complete quizzes to earn badges!',
                    style: GoogleFonts.fredoka(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[800],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }
        
        return Container(
          width: double.infinity,
          height: 110, // Fixed height for badges container
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.purple[50]!],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.emoji_events, color: Colors.amber[700], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Your Achievements',
                    style: GoogleFonts.fredoka(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.purple[800],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${badges.length} badges',
                      style: GoogleFonts.fredoka(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48, // Fixed height for badges row
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
                          child: Container(
                            width: 48, // Fixed width
                            height: 48, // Fixed height
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                path,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 40,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.purple[300]!, Colors.pink[300]!],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.emoji_events,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildAppDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple[100]!,
              Colors.white,
              Colors.cyan[50]!,
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
                  child: Column(
                    children: [
                      // Custom App Bar with fixed height
                      Container(
                        height: 100, // Fixed height for app bar
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                              onTap: () => _scaffoldKey.currentState?.openDrawer(),
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
                                    'NEXTGEN LEARNERS',
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
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[400]!),
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
                                Container(
                                  width: double.infinity,
                                  height: 140, // Fixed height
                                  padding: const EdgeInsets.all(20),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.cyan[100]!,
                                        Colors.blue[100]!,
                                        Colors.purple[100]!,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.2),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '🎉 Welcome to Your Learning Adventure! 🚀',
                                        style: GoogleFonts.fredoka(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo[700],
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: _buildStatCard(
                                              icon: Icons.star,
                                              value: cumulativePoints.toString(),
                                              label: 'Points',
                                              color: Colors.yellow[700]!,
                                              bgColor: Colors.yellow[50]!,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: _buildStatCard(
                                              icon: Icons.check_circle,
                                              value: '$completedQuizzes/8',
                                              label: 'Completed',
                                              color: Colors.green[700]!,
                                              bgColor: Colors.green[50]!,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: _buildStatCard(
                                              icon: Icons.trending_up,
                                              value: '${(completedQuizzes / 8 * 100).toInt()}%',
                                              label: 'Progress',
                                              color: Colors.blue[700]!,
                                              bgColor: Colors.blue[50]!,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Achievements Row
                                _buildAchievementsRow(),

                                // Categories Header - Fixed height
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Choose Your Topic',
                                        style: GoogleFonts.fredoka(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo[800],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.purple[100],
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '8 Topics',
                                          style: GoogleFonts.fredoka(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.purple[700],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Learning Categories Grid with consistent sizing
                                Expanded(
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 1.0, // Square cards for consistency
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
                                          primaryColor: ANIMAL_SCREEN_COLOR_LIGHT_PINK,
                                          secondaryColor: ANIMAL_SCREEN_COLOR_LIGHT_LAVENDER,
                                          delay: 200,
                                        ),
                                      ),
                                      _tileWithTick(
                                        quizId: 'animal_sound',
                                        tile: CustomContainer(
                                          key: UniqueKey(),
                                          newPage: ANIMAL_SOUND_SCREEN,
                                          title: "Sounds",
                                          subtitle: "Hear them!",
                                          img: 'assets/home_screen/sound.webp',
                                          primaryColor: ANIMALSOUND_COLOR_LIGHT_ORANGE,
                                          secondaryColor: ANIMALSOUND_COLOR_LIGHT_CYAN,
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
                                        quizId: 'vehicals',
                                        tile: CustomContainer(
                                          key: UniqueKey(),
                                          newPage: VEHICLE_NAME_SCREEN,
                                          title: "Vehicles",
                                          subtitle: "Cars & more!",
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
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      height: 80, // Fixed height for all stat cards
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.fredoka(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: GoogleFonts.fredoka(
                fontSize: 10,
                color: color.withOpacity(0.8),
              ),
              maxLines: 1,
            ),
          ),
        ],
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
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple[400]!,
                      Colors.pink[400]!,
                    ],
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
                      'NextGen Learners',
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
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[400]!),
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
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hoverColor: color.withOpacity(0.05),
      ),
    );
  }
}