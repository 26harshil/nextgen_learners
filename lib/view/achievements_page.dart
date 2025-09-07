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
  String _quote = '';
  late TabController _tabController;
  int _totalQuizzes = 0;
  int _totalScore = 0;
  String _userLevel = 'Beginner';

  final List<String> _quotes = const [
    'Learning is a treasure that will follow its owner everywhere.',
    'Small steps every day lead to big achievements.',
    'You are braver than you believe, stronger than you seem, and smarter than you think.',
    'Every quiz you finish is a new star in your sky. Keep shining!',
    'Knowledge is power, and you\'re becoming more powerful every day!',
    'The expert in anything was once a beginner. Keep going!',
  ];

  final List<Map<String, dynamic>> _allBadges = [
    {'id': 'First_Step', 'name': 'First Step', 'desc': 'Complete your first quiz', 'icon': Icons.flag},
    {'id': 'Quick_Learner', 'name': 'Quick Learner', 'desc': 'Score 100% in any quiz', 'icon': Icons.bolt},
    {'id': 'Explorer', 'name': 'Explorer', 'desc': 'Try 3 different categories', 'icon': Icons.explore},
    {'id': 'Champion', 'name': 'Champion', 'desc': 'Complete 10 quizzes', 'icon': Icons.emoji_events},
    {'id': 'Perfect_Score', 'name': 'Perfect Score', 'desc': 'Get 5 perfect scores', 'icon': Icons.star},
    {'id': 'Knowledge_Seeker', 'name': 'Knowledge Seeker', 'desc': 'Complete all categories', 'icon': Icons.school},
    {'id': 'Quiz_Master', 'name': 'Quiz Master', 'desc': 'Complete 25 quizzes', 'icon': Icons.military_tech},
    {'id': 'Genius', 'name': 'Genius', 'desc': 'Achieve 1000 total points', 'icon': Icons.psychology},
  ];

  final List<Map<String, dynamic>> _milestones = [
    {'title': '5 Quizzes', 'reward': '🌟', 'completed': false, 'required': 5},
    {'title': '10 Quizzes', 'reward': '🏆', 'completed': false, 'required': 10},
    {'title': '25 Quizzes', 'reward': '👑', 'completed': false, 'required': 25},
    {'title': '50 Quizzes', 'reward': '🎯', 'completed': false, 'required': 50},
    {'title': '100 Quizzes', 'reward': '💎', 'completed': false, 'required': 100},
  ];

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
    });
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalQuizzes = prefs.getInt('total_quizzes') ?? 0;
      _totalScore = prefs.getInt('total_score') ?? 0;
      _userLevel = _calculateLevel();
      _updateMilestones();
    });
  }

  String _calculateLevel() {
    if (_totalQuizzes >= 50) return 'Expert';
    if (_totalQuizzes >= 25) return 'Advanced';
    if (_totalQuizzes >= 10) return 'Intermediate';
    return 'Beginner';
  }

  void _updateMilestones() {
    for (var milestone in _milestones) {
      milestone['completed'] = _totalQuizzes >= milestone['required'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Achievements',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.white,
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
                Colors.purple[400]!.withOpacity(0.9),
                Colors.cyan[300]!.withOpacity(0.9),
              ],
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Stats', icon: Icon(Icons.bar_chart, size: 20)),
            Tab(text: 'Badges', icon: Icon(Icons.emoji_events, size: 20)),
            Tab(text: 'Progress', icon: Icon(Icons.trending_up, size: 20)),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple[50]!,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _buildMotivationCard(),
          const SizedBox(height: 20),
          _buildUserProfileCard(),
          const SizedBox(height: 20),
          _buildStatsGrid(),
          const SizedBox(height: 20),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildUserProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[400]!, Colors.cyan[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white.withOpacity(0.3),
            child: Text(
              '🌟',
              style: TextStyle(fontSize: 40),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Little Champion',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Level: $_userLevel',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
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

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          icon: Icons.quiz,
          title: 'Quizzes Done',
          value: _totalQuizzes.toString(),
          color: Colors.blue,
        ),
        _buildStatCard(
          icon: Icons.star,
          title: 'Total Points',
          value: _totalScore.toString(),
          color: Colors.orange,
        ),
        _buildStatCard(
          icon: Icons.emoji_events,
          title: 'Badges Earned',
          value: _badges.length.toString(),
          color: Colors.purple,
        ),
        _buildStatCard(
          icon: Icons.calendar_today,
          title: 'Days Active',
          value: '7',
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
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: Colors.purple[600]),
              const SizedBox(width: 8),
              Text(
                'Recent Activity',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildActivityItem('Completed Animals Quiz', '2 hours ago', Icons.pets),
          _buildActivityItem('Earned "Quick Learner" badge', 'Yesterday', Icons.emoji_events),
          _buildActivityItem('Completed Math Quiz', '2 days ago', Icons.calculate),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.purple[50],
            child: Icon(icon, size: 20, color: Colors.purple[600]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMotivationCard(),
          const SizedBox(height: 20),
          Text(
            'Earned Badges (${_badges.length})',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.purple[800],
            ),
          ),
          const SizedBox(height: 16),
          _badges.isEmpty ? _buildEmptyBadgesState() : _buildEarnedBadgesGrid(),
          const SizedBox(height: 24),
          Text(
            'Available Badges',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.purple[800],
            ),
          ),
          const SizedBox(height: 16),
          _buildAllBadgesList(),
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLevelProgressCard(),
          const SizedBox(height: 20),
          Text(
            'Milestones',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.purple[800],
            ),
          ),
          const SizedBox(height: 16),
          ..._milestones.map((milestone) => _buildMilestoneCard(milestone)),
        ],
      ),
    );
  }

  Widget _buildLevelProgressCard() {
    double progress = (_totalQuizzes % 10) / 10;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[100]!, Colors.cyan[100]!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 6),
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
                'Current Level',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.purple[800],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.purple[600],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _userLevel,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Progress to next level',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[600]!),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            '${(_totalQuizzes % 10)} / 10 quizzes',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(Map<String, dynamic> milestone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: milestone['completed'] ? Colors.green[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: milestone['completed'] ? Colors.green[300]! : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Text(
            milestone['reward'],
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone['title'],
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  milestone['completed'] ? 'Completed!' : 'Complete ${milestone['required']} quizzes',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (milestone['completed'])
            Icon(Icons.check_circle, color: Colors.green[600], size: 24),
        ],
      ),
    );
  }

  Widget _buildMotivationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[100]!, Colors.cyan[50]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/home_screen/buddy.png',
              height: 48,
              width: 48,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _quote,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.purple[900],
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyBadgesState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple[100]!),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No badges yet',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.purple[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete quizzes to earn shiny badges!',
              style: GoogleFonts.poppins(color: Colors.grey[700]),
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
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: _badges.length,
      itemBuilder: (context, index) {
        final id = _badges[index];
        final assetPath = 'assets/badges/$id.png';
        return _BadgeTile(id: id, assetPath: assetPath, earned: true);
      },
    );
  }

  Widget _buildAllBadgesList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: _allBadges.length,
      itemBuilder: (context, index) {
        final badge = _allBadges[index];
        final isEarned = _badges.contains(badge['id']);
        return _buildBadgeCard(badge, isEarned);
      },
    );
  }

  Widget _buildBadgeCard(Map<String, dynamic> badge, bool isEarned) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isEarned ? Colors.purple[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEarned ? Colors.purple[300]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            badge['icon'],
            size: 32,
            color: isEarned ? Colors.purple[600] : Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            badge['name'],
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isEarned ? Colors.purple[800] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            badge['desc'],
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
          if (isEarned) ...[
            const SizedBox(height: 4),
            Icon(Icons.check_circle, color: Colors.green[600], size: 16),
          ],
        ],
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final String id;
  final String assetPath;
  final bool earned;

  const _BadgeTile({
    required this.id,
    required this.assetPath,
    required this.earned,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: earned ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: earned ? Colors.purple.withOpacity(0.2) : Colors.grey[300]!,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder<bool>(
                future: _assetExists(context, assetPath),
                builder: (context, snapshot) {
                  final exists = snapshot.data ?? false;
                  if (exists) {
                    return Image.asset(
                      assetPath,
                      fit: BoxFit.contain,
                    );
                  }
                  return _fallbackChip();
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              id.replaceAll('_', ' '),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: earned ? Colors.purple[800] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackChip() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: earned
              ? [Colors.purple[100]!, Colors.cyan[100]!]
              : [Colors.grey[200]!, Colors.grey[300]!],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.emoji_events,
        color: earned ? Colors.amber[700] : Colors.grey[500],
        size: 32,
      ),
    );
  }

  Future<bool> _assetExists(BuildContext context, String asset) async {
    try {
      await DefaultAssetBundle.of(context).load(asset);
      return true;
    } catch (_) {
      return false;
    }
  }
}