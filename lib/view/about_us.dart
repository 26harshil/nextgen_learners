import 'package:nextgen_learners/constant/import_export.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _floatController;
  late Animation<double> _logoAnimation;
  late Animation<double> _floatAnimation;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _logoAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _floatController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  Future<void> _shareApp() async {
    const String message =
        'Check out BrainZy – a fun and interactive learning app for kids! 🎮📚\n\nDownload now: https://play.google.com/store/apps/details?id=com.nextgen.learners';
    await Share.share(message);
  }

  Future<void> _rateApp() async {
    const String packageName = 'com.nextgen.learners';
    final Uri playStoreUri = Uri.parse('market://details?id=$packageName');
    final Uri webPlayStoreUri = Uri.parse(
      'https://play.google.com/store/apps/details?id=$packageName',
    );

    try {
      bool canLaunch = await canLaunchUrl(playStoreUri);
      if (canLaunch) {
        await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(webPlayStoreUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Get.snackbar(
        '⚠️ Oops!',
        'Could not open Play Store. Please try again later.',
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
        borderRadius: 15,
      );
    }
  }

  Future<void> _showMoreApps() async {
    const String developerLink =
        'https://play.google.com/store/apps/dev?id=7093579953062919700';
    await launchUrl(
      Uri.parse(developerLink),
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _checkUpdates() async {
    const String packageName = 'com.nextgen.learners';
    final Uri playStoreUri = Uri.parse('market://details?id=$packageName');
    await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      body: CustomScrollView(
        slivers: [
          // Enhanced Colorful App Bar with Centered Logo
          SliverAppBar(
            expandedHeight: 320,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.purple.shade500,
                      Colors.pink.shade400,
                      Colors.orange.shade400,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Animated decorative circles
                    ...List.generate(5, (index) {
                      return AnimatedBuilder(
                        animation: _floatAnimation,
                        builder: (context, child) {
                          return Positioned(
                            top: (index * 60.0) + _floatAnimation.value,
                            left: index.isEven ? -50 + (index * 30) : null,
                            right: index.isOdd ? -50 + (index * 30) : null,
                            child: Container(
                              width: 150 + (index * 20.0),
                              height: 150 + (index * 20.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(
                                  0.05 + (index * 0.01),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                    // Centered Content
                    Center(
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 40),
                            // Animated Logo - CENTERED
                            AnimatedBuilder(
                              animation: _logoAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _logoAnimation.value,
                                  child: Hero(
                                    tag: 'app_logo',
                                    child: Container(
                                      width: 130,
                                      height: 130,
                                      padding: const EdgeInsets.all(25),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            blurRadius: 30,
                                            spreadRadius: 5,
                                            offset: const Offset(0, 15),
                                          ),
                                          BoxShadow(
                                            color: Colors.purple.shade300
                                                .withOpacity(0.3),
                                            blurRadius: 20,
                                            spreadRadius: 2,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Image.asset(
                                        'assets/home_screen/buddy.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 15),
                            // App Name with Glow Effect
                            ShaderMask(
                              shaderCallback:
                                  (bounds) => LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.white.withOpacity(0.9),
                                      Colors.yellow.shade100,
                                      Colors.white.withOpacity(0.9),
                                      Colors.white,
                                    ],
                                    stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                                  ).createShader(bounds),
                              child: Text(
                                'BrainZy',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                    Shadow(
                                      color: Colors.purple.shade900.withOpacity(
                                        0.5,
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Version Badge with Animation
                            AnimatedBuilder(
                              animation: _floatAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _floatAnimation.value / 3),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.3),
                                          Colors.white.withOpacity(0.1),
                                          Colors.white.withOpacity(0.3),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: FutureBuilder<PackageInfo>(
                                      future: PackageInfo.fromPlatform(),
                                      builder: (context, snapshot) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.verified,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              snapshot.hasData
                                                  ? 'Version ${snapshot.data!.version}'
                                                  : 'Loading...',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.8,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            // Tagline
                            Text(
                              '✨ Making Learning Fun & Interactive ✨',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.95),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Get.back(),
              ),
            ),
          ),

          // Enhanced Content with better spacing
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.purple.shade50,
                    Colors.white,
                    Colors.pink.shade50.withOpacity(0.3),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Amazing Team Section
                    _buildTeamSection(),
                    const SizedBox(height: 30),

                    // About ASWDC Section
                    _buildAboutASWDC(),
                    const SizedBox(height: 30),

                    // Contact Section
                    _buildContactSection(),
                    const SizedBox(height: 30),

                    // Quick Actions Section
                    _buildEnhancedQuickActions(),
                    const SizedBox(height: 30),

                    // Footer with animation
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedQuickActions() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade100,
            Colors.pink.shade100,
            Colors.orange.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildEnhancedActionCard(
                  icon: Icons.share_rounded,
                  label: 'Share App',
                  gradient: [Colors.blue.shade400, Colors.cyan.shade600],
                  onTap: _shareApp,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildEnhancedActionCard(
                  icon: Icons.star_rounded,
                  label: 'Rate Us',
                  gradient: [Colors.amber.shade400, Colors.orange.shade600],
                  onTap: _rateApp,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildEnhancedActionCard(
                  icon: Icons.apps_rounded,
                  label: 'More Apps',
                  gradient: [Colors.green.shade400, Colors.teal.shade600],
                  onTap: _showMoreApps,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildEnhancedActionCard(
                  icon: Icons.system_update_rounded,
                  label: 'Updates',
                  gradient: [
                    Colors.purple.shade400,
                    Colors.deepPurple.shade600,
                  ],
                  onTap: _checkUpdates,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedActionCard({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: gradient.first.withOpacity(0.4),
                blurRadius: 18,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
            ],
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
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamSection() {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.indigo.shade50],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.blue.shade200, width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_alt_rounded,
                color: Colors.blue.shade600,
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                'Amazing Team',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTeamCard(
            emoji: '👨‍💻',
            role: 'Developer',
            name: 'Harshil Solanki',
            description: 'App Development & Design',
            color: Colors.purple,
          ),
          const SizedBox(height: 16),
          _buildTeamCard(
            emoji: '🎯',
            role: 'Mentor',
            name: 'Prof.Mehul Bhundiya',
            description: 'Project Guidance',
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildTeamCard(
            emoji: '🎓',
            role: 'Department',
            name: 'School of Computer Science',
            description: 'Academic Excellence',
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          _buildTeamCard(
            emoji: '🏛️',
            role: 'Institution',
            name: 'Darshan University',
            description: 'Rajkot, Gujarat, India',
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard({
    required String emoji,
    required String role,
    required String name,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(emoji, style: TextStyle(fontSize: 28))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    role,
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade50, Colors.pink.shade50],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.red.shade200, width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.contact_support_rounded,
                color: Colors.red.shade600,
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                'Get In Touch',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildContactItem(
            icon: Icons.email_rounded,
            label: 'Email Us',
            value: 'harshilsolanki26102005@gmail.com',
            gradient: [Colors.blue.shade400, Colors.blue.shade600],
            onTap:
                () => launchUrl(
                  Uri.parse('mailto:harshilsolanki26102005@gmail.com'),
                ),
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.phone_rounded,
            label: 'Call Us',
            value: '+91 7016978473',
            gradient: [Colors.green.shade400, Colors.green.shade600],
            onTap: () => launchUrl(Uri.parse('tel:+917016978473')),
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.language_rounded,
            label: 'Website',
            value: 'www.nextgen-learners.com',
            gradient: [Colors.purple.shade400, Colors.purple.shade600],
            onTap: () => launchUrl(Uri.parse('https://nextgen-learners.com')),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: gradient.first,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.shade100,
            Colors.pink.shade100,
            Colors.orange.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.copyright, size: 18, color: Colors.grey.shade700),
              const SizedBox(width: 6),
              Text(
                '${DateTime.now().year} BrainZy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'All Rights Reserved',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Made with',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.favorite, color: Colors.red.shade500, size: 20),
                const SizedBox(width: 8),
                Text(
                  'in India',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
                Text('🇮🇳', style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutASWDC() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced Logo Section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFFFFFF), // Pure white
                Color(0xFFFFFFFF), // Soft cream (light yellowish)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 90,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/home_screen/du_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.school_rounded,
                            color: Color(0xFF6366f1),
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: 90,
                height: 90,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/home_screen/ASWC.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text(
                          'ASWDC',
                          style: TextStyle(
                            color: Color(0xFF6366f1),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        ShaderMask(
          shaderCallback:
              (bounds) => const LinearGradient(
                colors: [Color(0xFF6366f1), Color(0xFF8b5cf6)],
              ).createShader(bounds),
          child: const Text(
            'About ASWDC',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366f1), Color(0xFF8b5cf6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366f1).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Text(
            'ASWDC is the Application, Software and Website Development Center at Darshan Engineering College, operated by students and faculty of the Computer Engineering Department.',
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
              height: 1.6,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFf8fafc),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF6366f1).withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366f1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const SizedBox.shrink(), // Placeholder for icon
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Our Mission',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1f2937),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Bridge the gap between university curriculum and industry demands. Students learn cutting-edge technologies, develop real-world applications, and gain professional experience under the guidance of industry experts and faculty members.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF374151),
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
