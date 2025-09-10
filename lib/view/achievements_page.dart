import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage>
    with SingleTickerProviderStateMixin {
  List<String> _badges = [];
  List<String> _badgeAssetIds = [];
  String _quote = '';
  late TabController _tabController;
  int _totalQuizzes = 0;
  int _totalScore = 0;
  String _userLevel = 'Beginner';
  double _averageScore = 0;

  final List<String> _quotes = const [
    'Learning is a treasure that will follow its owner everywhere.',
    'Small steps every day lead to big achievements.',
    'You are braver than you believe, stronger than you seem, and smarter than you think.',
    'Every quiz you finish is a new star in your sky. Keep shining!',
    'Knowledge is power, and you\'re becoming more powerful every day!',
    'The expert in anything was once a beginner. Keep going!',
  ];

  final List<Map<String, dynamic>> _allBadges = [
    {'id': 'First_Step', 'name': 'First Step', 'desc': 'First quiz done', 'icon': Icons.flag, 'color': Colors.green},
    {'id': 'Quick_Learner', 'name': 'Quick Learn', 'desc': 'Score 100%', 'icon': Icons.bolt, 'color': Colors.orange},
    {'id': 'Explorer', 'name': 'Explorer', 'desc': '3 categories', 'icon': Icons.explore, 'color': Colors.blue},
    {'id': 'Half_Way', 'name': 'Half Way', 'desc': '4 quizzes', 'icon': Icons.trending_up, 'color': Colors.purple},
    {'id': 'Perfect_Score', 'name': 'Perfect', 'desc': '2 perfect', 'icon': Icons.star, 'color': Colors.amber},
    {'id': 'Almost_There', 'name': 'Almost', 'desc': '6 quizzes', 'icon': Icons.emoji_events, 'color': Colors.indigo},
    {'id': 'Quiz_Master', 'name': 'Master', 'desc': 'All 8 done', 'icon': Icons.military_tech, 'color': Colors.red},
    {'id': 'Champion', 'name': 'Champion', 'desc': 'Avg > 80%', 'icon': Icons.workspace_premium, 'color': Colors.teal},
  ];

  final List<Map<String, dynamic>> _milestones = [
    {'title': 'First Quiz', 'reward': '🌟', 'completed': false, 'required': 1},
    {'title': '2 Quizzes', 'reward': '⭐', 'completed': false, 'required': 2},
    {'title': 'Half Way', 'reward': '🏆', 'completed': false, 'required': 4},
    {'title': '6 Quizzes', 'reward': '👑', 'completed': false, 'required': 6},
    {'title': 'All 8 Done', 'reward': '💎', 'completed': false, 'required': 8},
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
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBadges();
    _loadStats();
    _pickQuote();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      _badgeAssetIds = _badges
          .map((id) => _stableToAssetId[id] ?? id)
          .toSet()
          .toList();
    });
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalQuizzes = prefs.getInt('total_quizzes') ?? 0;
      _totalScore = prefs.getInt('total_score') ?? 0;
      _averageScore = _totalQuizzes > 0 ? _totalScore / _totalQuizzes : 0;
      _userLevel = _calculateLevel();
      _updateMilestones();
    });
  }

  String _calculateLevel() {
    if (_totalQuizzes == 8) return 'Master';
    if (_totalQuizzes >= 6) return 'Expert';
    if (_totalQuizzes >= 4) return 'Inter';
    if (_totalQuizzes >= 2) return 'Learner';
    return 'Beginner';
  }

  void _updateMilestones() {
    for (var milestone in _milestones) {
      milestone['completed'] = _totalQuizzes >= milestone['required'];
    }
  }

  String _getLevelEmoji() {
    switch (_userLevel) {
      case 'Master':
        return '👑';
      case 'Expert':
        return '🏆';
      case 'Inter':
        return '⭐';
      case 'Learner':
        return '🌟';
      default:
        return '✨';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(
          'Achievements',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: isVerySmallDevice ? 16 : isSmallDevice ? 18 : 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple[400]!,
                Colors.cyan[400]!,
              ],
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelPadding: const EdgeInsets.symmetric(horizontal: 2),
          tabs: [
            Tab(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, size: isSmallDevice ? 16 : 18),
                  const SizedBox(height: 2),
                  Text('Stats', style: TextStyle(fontSize: isSmallDevice ? 10 : 11)),
                ],
              ),
            ),
            Tab(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, size: isSmallDevice ? 16 : 18),
                  const SizedBox(height: 2),
                  Text('Badges', style: TextStyle(fontSize: isSmallDevice ? 10 : 11)),
                ],
              ),
            ),
            Tab(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.trending_up, size: isSmallDevice ? 16 : 18),
                  const SizedBox(height: 2),
                  Text('Progress', style: TextStyle(fontSize: isSmallDevice ? 10 : 11)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple[50]!.withOpacity(0.5),
              Colors.white,
            ],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildStatsTab(),
            _buildBadgesTab(),
            _buildProgressTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;
    final padding = isVerySmallDevice ? 8.0 : isSmallDevice ? 10.0 : 14.0;
    final spacing = isVerySmallDevice ? 10.0 : isSmallDevice ? 12.0 : 16.0;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(padding),
      child: Column(
        children: [
          _buildMotivationCard(),
          SizedBox(height: spacing),
          _buildUserProfileCard(),
          SizedBox(height: spacing),
          _buildStatsGrid(),
          SizedBox(height: spacing),
          _buildQuizProgress(),
          SizedBox(height: spacing),
          _buildRecentActivity(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildUserProfileCard() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;

    return Container(
      padding: EdgeInsets.all(isVerySmallDevice ? 12 : isSmallDevice ? 14 : 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[400]!, Colors.cyan[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: isVerySmallDevice ? 50 : isSmallDevice ? 55 : 65,
            height: isVerySmallDevice ? 50 : isSmallDevice ? 55 : 65,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _getLevelEmoji(),
                style: TextStyle(fontSize: isVerySmallDevice ? 24 : isSmallDevice ? 28 : 32),
              ),
            ),
          ),
          SizedBox(width: isVerySmallDevice ? 8 : isSmallDevice ? 10 : 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Champion',
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 14 : isSmallDevice ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    _userLevel,
                    style: GoogleFonts.poppins(
                      fontSize: isVerySmallDevice ? 10 : isSmallDevice ? 11 : 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizProgress() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;

    return Container(
      padding: EdgeInsets.all(isVerySmallDevice ? 12 : isSmallDevice ? 14 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
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
                'Progress',
                style: GoogleFonts.poppins(
                  fontSize: isVerySmallDevice ? 13 : isSmallDevice ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
              Text(
                '$_totalQuizzes/8',
                style: GoogleFonts.poppins(
                  fontSize: isVerySmallDevice ? 16 : isSmallDevice ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _totalQuizzes / 8,
              backgroundColor: Colors.purple[100],
              valueColor: AlwaysStoppedAnimation<Color>(
                _totalQuizzes == 8 ? Colors.green[600]! : Colors.purple[600]!,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _totalQuizzes == 8
                ? '🎉 All done!'
                : '${8 - _totalQuizzes} more!',
            style: GoogleFonts.poppins(
              fontSize: isVerySmallDevice ? 10 : isSmallDevice ? 11 : 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: isVerySmallDevice ? 8 : 10,
      crossAxisSpacing: isVerySmallDevice ? 8 : 10,
      childAspectRatio: isVerySmallDevice ? 1.4 : isSmallDevice ? 1.5 : 1.6,
      children: [
        _buildStatCard(
          icon: Icons.quiz,
          title: 'Quiz',
          value: '$_totalQuizzes',
          color: Colors.blue,
          progress: _totalQuizzes / 8,
        ),
        _buildStatCard(
          icon: Icons.star,
          title: 'Points',
          value: _totalScore.toString(),
          color: Colors.orange,
        ),
        _buildStatCard(
          icon: Icons.emoji_events,
          title: 'Badge',
          value: '${_badgeAssetIds.length}',
          color: Colors.purple,
          progress: _badgeAssetIds.length / 8,
        ),
        _buildStatCard(
          icon: Icons.speed,
          title: 'Avg',
          value: '${_averageScore.toStringAsFixed(0)}%',
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    double? progress,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: isVerySmallDevice ? 18 : 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isVerySmallDevice ? 14 : isSmallDevice ? 15 : 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: isVerySmallDevice ? 9 : 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 3,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;

    return Container(
      padding: EdgeInsets.all(isVerySmallDevice ? 12 : isSmallDevice ? 14 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.history,
                  color: Colors.purple[600],
                  size: isVerySmallDevice ? 14 : 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Recent',
                style: GoogleFonts.poppins(
                  fontSize: isVerySmallDevice ? 13 : isSmallDevice ? 14 : 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildActivityItem('Quiz', '2h ago', Icons.pets, Colors.green),
          const SizedBox(height: 6),
          _buildActivityItem('Badge', 'Yesterday', Icons.emoji_events, Colors.amber),
          const SizedBox(height: 6),
          _buildActivityItem('Math', '2d ago', Icons.calculate, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallDevice = screenWidth < 320;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 14,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 10 : 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 9 : 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;
    final padding = isVerySmallDevice ? 8.0 : isSmallDevice ? 10.0 : 14.0;
    final spacing = isVerySmallDevice ? 10.0 : isSmallDevice ? 12.0 : 16.0;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMotivationCard(),
          SizedBox(height: spacing),
          _buildBadgeStats(),
          SizedBox(height: spacing),
          Text(
            'Earned (${_badgeAssetIds.length}/8)',
            style: GoogleFonts.poppins(
              fontSize: isVerySmallDevice ? 14 : isSmallDevice ? 15 : 17,
              fontWeight: FontWeight.w700,
              color: Colors.purple[800],
            ),
          ),
          const SizedBox(height: 10),
          _badgeAssetIds.isEmpty ? _buildEmptyBadgesState() : _buildEarnedBadgesGrid(),
          SizedBox(height: spacing),
          Text(
            'All Badges',
            style: GoogleFonts.poppins(
              fontSize: isVerySmallDevice ? 14 : isSmallDevice ? 15 : 17,
              fontWeight: FontWeight.w700,
              color: Colors.purple[800],
            ),
          ),
          const SizedBox(height: 10),
          _buildAllBadgesList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBadgeStats() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;

    return Container(
      padding: EdgeInsets.all(isVerySmallDevice ? 12 : isSmallDevice ? 14 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber[100]!, Colors.orange[100]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                '${_badgeAssetIds.length}',
                style: GoogleFonts.poppins(
                  fontSize: isVerySmallDevice ? 18 : isSmallDevice ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
              ),
              Text(
                'Earned',
                style: GoogleFonts.poppins(
                  fontSize: isVerySmallDevice ? 10 : 11,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
          Container(
            width: 1,
            height: 30,
            color: Colors.orange[300],
          ),
          Column(
            children: [
              Text(
                '${8 - _badgeAssetIds.length}',
                style: GoogleFonts.poppins(
                  fontSize: isVerySmallDevice ? 18 : isSmallDevice ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[600],
                ),
              ),
              Text(
                'Left',
                style: GoogleFonts.poppins(
                  fontSize: isVerySmallDevice ? 10 : 11,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
          Container(
            width: 1,
            height: 30,
            color: Colors.orange[300],
          ),
          Column(
            children: [
              Text(
                '${(_badgeAssetIds.length / 8 * 100).toStringAsFixed(0)}%',
                style: GoogleFonts.poppins(
                  fontSize: isVerySmallDevice ? 18 : isSmallDevice ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
              ),
              Text(
                'Done',
                style: GoogleFonts.poppins(
                  fontSize: isVerySmallDevice ? 10 : 11,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;
    final padding = isVerySmallDevice ? 8.0 : isSmallDevice ? 10.0 : 14.0;
    final spacing = isVerySmallDevice ? 10.0 : isSmallDevice ? 12.0 : 16.0;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLevelProgressCard(),
          SizedBox(height: spacing),
          _buildOverallProgress(),
          SizedBox(height: spacing),
          Text(
            'Milestones',
            style: GoogleFonts.poppins(
              fontSize: isVerySmallDevice ? 14 : isSmallDevice ? 15 : 17,
              fontWeight: FontWeight.w700,
              color: Colors.purple[800],
            ),
          ),
          const SizedBox(height: 10),
          ..._milestones.map((milestone) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildMilestoneCard(milestone),
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOverallProgress() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;

    return Container(
      padding: EdgeInsets.all(isVerySmallDevice ? 12 : isSmallDevice ? 14 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall',
            style: GoogleFonts.poppins(
              fontSize: isVerySmallDevice ? 13 : isSmallDevice ? 14 : 15,
              fontWeight: FontWeight.bold,
              color: Colors.purple[800],
            ),
          ),
          const SizedBox(height: 12),
          _buildProgressItem('Quizzes', _totalQuizzes, 8, Colors.blue),
          const SizedBox(height: 10),
          _buildProgressItem('Badges', _badgeAssetIds.length, 8, Colors.purple),
          const SizedBox(height: 10),
          _buildProgressItem('Milestones', _milestones.where((m) => m['completed']).length, 5, Colors.green),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String title, int current, int total, Color color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallDevice = screenWidth < 320;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: isVerySmallDevice ? 10 : 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '$current/$total',
              style: GoogleFonts.poppins(
                fontSize: isVerySmallDevice ? 10 : 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: current / total,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 5,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelProgressCard() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;

    int nextLevelQuizzes = 0;
    String nextLevel = '';

    if (_totalQuizzes < 2) {
      nextLevelQuizzes = 2;
      nextLevel = 'Learner';
    } else if (_totalQuizzes < 4) {
      nextLevelQuizzes = 4;
      nextLevel = 'Inter';
    } else if (_totalQuizzes < 6) {
      nextLevelQuizzes = 6;
      nextLevel = 'Expert';
    } else if (_totalQuizzes < 8) {
      nextLevelQuizzes = 8;
      nextLevel = 'Master';
    }

    double progress = _totalQuizzes == 8 ? 1.0 : (_totalQuizzes % nextLevelQuizzes) / nextLevelQuizzes;

    return Container(
      padding: EdgeInsets.all(isVerySmallDevice ? 12 : isSmallDevice ? 14 : 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[100]!, Colors.cyan[100]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Level',
            style: GoogleFonts.poppins(
              fontSize: isVerySmallDevice ? 12 : isSmallDevice ? 13 : 14,
              fontWeight: FontWeight.w600,
              color: Colors.purple[800],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                _getLevelEmoji(),
                style: TextStyle(fontSize: isVerySmallDevice ? 24 : 28),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple[600],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  _userLevel,
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 11 : 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          if (_totalQuizzes < 8) ...[
            const SizedBox(height: 12),
            Text(
              'Next: $nextLevel',
              style: GoogleFonts.poppins(
                fontSize: isVerySmallDevice ? 10 : 11,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[600]!),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${nextLevelQuizzes - _totalQuizzes} more',
              style: GoogleFonts.poppins(
                fontSize: isVerySmallDevice ? 9 : 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(Map<String, dynamic> milestone) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: milestone['completed'] ? Colors.green[50] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: milestone['completed'] ? Colors.green[300]! : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: milestone['completed'] ? Colors.green[100] : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                milestone['reward'],
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone['title'],
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 11 : 12,
                    fontWeight: FontWeight.w600,
                    color: milestone['completed'] ? Colors.green[800] : Colors.grey[800],
                  ),
                ),
                Text(
                  milestone['completed'] ? 'Done!' : '${milestone['required']} quiz',
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 9 : 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (milestone['completed'])
            Icon(Icons.check_circle, color: Colors.green[600], size: 20),
        ],
      ),
    );
  }

  Widget _buildMotivationCard() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[100]!, Colors.cyan[50]!],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('🤖', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _quote,
              style: GoogleFonts.poppins(
                fontSize: isVerySmallDevice ? 10 : isSmallDevice ? 11 : 12,
                fontWeight: FontWeight.w600,
                color: Colors.purple[900],
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyBadgesState() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.purple[100]!, width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 10),
            Text(
              'No badges yet',
              style: GoogleFonts.poppins(
                fontSize: isVerySmallDevice ? 14 : isSmallDevice ? 15 : 16,
                fontWeight: FontWeight.w700,
                color: Colors.purple[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Complete quizzes!',
              style: GoogleFonts.poppins(
                fontSize: isVerySmallDevice ? 10 : 11,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarnedBadgesGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallDevice = screenWidth < 320;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isVerySmallDevice ? 3 : 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
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
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: earned ? Colors.purple : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/$id.png',
            width: 40,
            height: 40,
          ),
          const SizedBox(height: 2),
          Text(
            _idToPrettyName[id] ?? id,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAllBadgesList() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: isVerySmallDevice ? 1.5 : isSmallDevice ? 1.6 : 1.7,
      ),
      itemCount: _allBadges.length,
      itemBuilder: (context, index) {
        final badge = _allBadges[index];
        final isEarned = _badgeAssetIds.contains(badge['id']);
        return _buildBadgeCard(badge, isEarned);
      },
    );
  }

  Widget _buildBadgeCard(Map<String, dynamic> badge, bool isEarned) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallDevice = screenWidth < 320;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isEarned ? (badge['color'] as Color).withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEarned ? (badge['color'] as Color) : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                badge['icon'],
                size: isVerySmallDevice ? 24 : 28,
                color: isEarned ? badge['color'] : Colors.grey[400],
              ),
              if (!isEarned)
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 14,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            badge['name'],
            style: GoogleFonts.poppins(
              fontSize: isVerySmallDevice ? 9 : 10,
              fontWeight: FontWeight.w600,
              color: isEarned ? Colors.grey[800] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            badge['desc'],
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 8,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (isEarned)
            const Icon(Icons.check_circle, color: Colors.green, size: 12),
        ],
      ),
    );
  }
}