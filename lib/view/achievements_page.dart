import 'package:nextgen_learners/constant/import_export.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  List<String> _badges = [];
  List<String> _badgeAssetIds = [];
  String _quote = '';
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _quotes = const [
    'Learning is a treasure that will follow its owner everywhere.',
    'Small steps every day lead to big achievements.',
    'You are braver than you believe, stronger than you seem, and smarter than you think.',
    'Every quiz you finish is a new star in your sky. Keep shining!',
    'Knowledge is power, and you\'re becoming more powerful every day!',
    'The expert in anything was once a beginner. Keep going!',
  ];

  static const Map<String, String> _idToPrettyName = {
    'animalQuizz': 'Animal Name',
    'birdQuizz': 'Bird',
    'colorQuizz': 'Color',
    'fruitQuizz': 'Fruit',
    'mathQuizz': 'Math',
    'soundQuizz': 'Sound',
    'vegetableQuizz': 'Vegetable',
    'vehicalQuizz': 'Vehicle',
  };

  static const Map<String, String> _stableToAssetId = {
    'animal_name': 'animalQuizz',
    'animal_sound': 'soundQuizz',
    'math': 'mathQuizz',
    'vehicals': 'vehicalQuizz',
    'fruits': 'fruitQuizz',
    'vegetables': 'vegetableQuizz',
    'colors': 'colorQuizz',
    'bird': 'birdQuizz',
    'sounds': 'soundQuizz',
    'vehicles': 'vehicalQuizz',
    'animalname': 'animalQuizz',
    'birds': 'birdQuizz',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    WidgetsBinding.instance.addObserver(this);
    _loadBadges();
    _pickQuote();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadBadges();
    }
  }

  void _pickQuote() {
    final index = DateTime.now().day % _quotes.length;
    _quote = _quotes[index];
  }

  Future<void> _loadBadges() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('badges') ?? [];
    setState(() {
      _badges = List<String>.from(list);
      _badgeAssetIds =
          _badges.map((id) => _stableToAssetId[id] ?? id).toSet().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        toolbarHeight: 60,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, color: Colors.amber, size: 24),
            const SizedBox(width: 8),
            Text(
              'Achievements',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 22,
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
              colors: [Colors.purple[400]!, Colors.cyan[400]!],
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, size: 18),
                  const SizedBox(width: 6),
                  Text('Badges', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lightbulb, size: 18),
                  const SizedBox(width: 6),
                  Text('Fun Facts', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.tips_and_updates, size: 18),
                  const SizedBox(width: 6),
                  Text('Tips', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple[50]!.withOpacity(0.5), Colors.white],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildBadgesTab(),
            _buildFunFactsTab(),
            _buildLearningTipsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesTab() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuoteCard(),
            const SizedBox(height: 20),
            _buildStatsSection(),
            const SizedBox(height: 20),
            _buildBadgesSection(),
            const SizedBox(height: 20),
            _buildMilestoneSection(),
            const SizedBox(height: 20),
            _buildEncouragementSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[100]!, Colors.blue[100]!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.format_quote,
              color: Colors.purple[600],
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _quote,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.purple[800],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.emoji_events,
            title: 'Badges Earned',
            value: '${_badgeAssetIds.length}',
            color: Colors.amber,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.school,
            title: 'Total Available',
            value: '8',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.percent,
            title: 'Progress',
            value: '${(_badgeAssetIds.length * 100 / 8).toStringAsFixed(0)}%',
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Badge Collection',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.purple[800],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_badgeAssetIds.length}/8',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _badgeAssetIds.isEmpty
              ? _buildEmptyBadgesState()
              : _buildEarnedBadgesGrid(),
        ],
      ),
    );
  }

  Widget _buildEmptyBadgesState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[50]!, Colors.blue[50]!],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple[200]!, width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 48, color: Colors.purple[400]),
            const SizedBox(height: 12),
            Text(
              'No badges yet!',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.purple[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete quizzes to earn badges',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarnedBadgesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: _badgeAssetIds.length,
      itemBuilder: (context, index) {
        final id = _badgeAssetIds[index];
        return _buildBadgeImageTile(id, earned: true);
      },
    );
  }

  Widget _buildBadgeImageTile(String id, {required bool earned}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: earned
              ? [Colors.purple[100]!, Colors.blue[100]!]
              : [Colors.grey[200]!, Colors.grey[300]!],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: earned ? Colors.purple[400]! : Colors.grey[400]!,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/badges/$id.png',
            width: 36,
            height: 36,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.emoji_events,
                size: 36,
                color: earned ? Colors.purple[400] : Colors.grey[400],
              );
            },
          ),
          const SizedBox(height: 2),
          Text(
            _idToPrettyName[id] ?? id,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: earned ? Colors.purple[700] : Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[50]!, Colors.yellow[50]!],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag, color: Colors.orange[600], size: 24),
              const SizedBox(width: 8),
              Text(
                'Learning Milestones',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.orange[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMilestoneItem('Complete your first quiz', _badgeAssetIds.isNotEmpty),
          _buildMilestoneItem('Earn 3 badges', _badgeAssetIds.length >= 3),
          _buildMilestoneItem('Earn 5 badges', _badgeAssetIds.length >= 5),
          _buildMilestoneItem('Complete all quizzes', _badgeAssetIds.length == 8),
        ],
      ),
    );
  }

  Widget _buildMilestoneItem(String text, bool achieved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            achieved ? Icons.check_circle : Icons.radio_button_unchecked,
            color: achieved ? Colors.green : Colors.grey[400],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: achieved ? Colors.grey[800] : Colors.grey[500],
                decoration: achieved ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEncouragementSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[50]!, Colors.blue[50]!],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(Icons.star, color: Colors.amber, size: 40),
          const SizedBox(height: 12),
          Text(
            'Keep Learning!',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Every quiz you complete makes you smarter!\nYou\'re doing amazing!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunFactsTab() {
    final funFacts = [
      {'icon': Icons.pets, 'fact': 'Dogs can understand up to 250 words and gestures!'},
      {'icon': Icons.calculate, 'fact': 'The number zero was invented in India!'},
      {'icon': Icons.palette, 'fact': 'The human eye can see about 10 million different colors!'},
      {'icon': Icons.eco, 'fact': 'Bananas are berries, but strawberries aren\'t!'},
      {'icon': Icons.directions_car, 'fact': 'The first car was invented in 1885!'},
      {'icon': Icons.music_note, 'fact': 'Cows produce more milk when listening to music!'},
      {'icon': Icons.flight, 'fact': 'Birds are the only animals with feathers!'},
      {'icon': Icons.restaurant, 'fact': 'Carrots were originally purple, not orange!'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(funFacts.length, (index) {
          final fact = funFacts[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.primaries[index % Colors.primaries.length].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    fact['icon'] as IconData,
                    color: Colors.primaries[index % Colors.primaries.length],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    fact['fact'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLearningTipsTab() {
    final tips = [
      {'title': 'Practice Daily', 'tip': 'Just 10 minutes a day can make a huge difference!'},
      {'title': 'Stay Curious', 'tip': 'Ask questions and explore new topics every day.'},
      {'title': 'Learn with Friends', 'tip': 'Share what you learn with friends and family!'},
      {'title': 'Take Breaks', 'tip': 'Rest your brain between learning sessions.'},
      {'title': 'Celebrate Success', 'tip': 'Reward yourself when you complete a quiz!'},
      {'title': 'Try Again', 'tip': 'It\'s okay to make mistakes - they help you learn!'},
      {'title': 'Mix It Up', 'tip': 'Try different quiz categories to learn more.'},
      {'title': 'Have Fun', 'tip': 'Learning is an adventure - enjoy the journey!'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(tips.length, (index) {
          final tip = tips[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.primaries[index % Colors.primaries.length].withOpacity(0.1),
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.primaries[index % Colors.primaries.length].withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.primaries[index % Colors.primaries.length].withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.primaries[index % Colors.primaries.length],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      tip['title'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text(
                    tip['tip'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}