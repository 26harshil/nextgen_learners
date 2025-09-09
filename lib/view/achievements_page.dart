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
    {'id': 'First_Step', 'name': 'First Step', 'desc': 'Complete your first quiz', 'icon': Icons.flag, 'color': Colors.green},
    {'id': 'Quick_Learner', 'name': 'Quick Learner', 'desc': 'Score 100% in any quiz', 'icon': Icons.bolt, 'color': Colors.orange},
    {'id': 'Explorer', 'name': 'Explorer', 'desc': 'Try 3 different categories', 'icon': Icons.explore, 'color': Colors.blue},
    {'id': 'Half_Way', 'name': 'Half Way Hero', 'desc': 'Complete 4 quizzes', 'icon': Icons.trending_up, 'color': Colors.purple},
    {'id': 'Perfect_Score', 'name': 'Perfect Score', 'desc': 'Get 2 perfect scores', 'icon': Icons.star, 'color': Colors.amber},
    {'id': 'Almost_There', 'name': 'Almost There', 'desc': 'Complete 6 quizzes', 'icon': Icons.emoji_events, 'color': Colors.indigo},
    {'id': 'Quiz_Master', 'name': 'Quiz Master', 'desc': 'Complete all 8 quizzes', 'icon': Icons.military_tech, 'color': Colors.red},
    {'id': 'Champion', 'name': 'Champion', 'desc': 'Average score above 80%', 'icon': Icons.workspace_premium, 'color': Colors.teal},
  ];

  final List<Map<String, dynamic>> _milestones = [
    {'title': 'First Quiz', 'reward': '🌟', 'completed': false, 'required': 1},
    {'title': '2 Quizzes', 'reward': '⭐', 'completed': false, 'required': 2},
    {'title': 'Half Way (4 Quizzes)', 'reward': '🏆', 'completed': false, 'required': 4},
    {'title': '6 Quizzes', 'reward': '👑', 'completed': false, 'required': 6},
    {'title': 'All 8 Quizzes', 'reward': '💎', 'completed': false, 'required': 8},
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
      _averageScore = _totalQuizzes > 0 ? _totalScore / _totalQuizzes : 0;
      _userLevel = _calculateLevel();
      _updateMilestones();
    });
  }

  String _calculateLevel() {
    if (_totalQuizzes == 8) return 'Master';
    if (_totalQuizzes >= 6) return 'Expert';
    if (_totalQuizzes >= 4) return 'Intermediate';
    if (_totalQuizzes >= 2) return 'Learner';
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Achievements',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 22,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          _buildMotivationCard(),
          const SizedBox(height: 24),
          _buildUserProfileCard(),
          const SizedBox(height: 24),
          _buildStatsGrid(),
          const SizedBox(height: 24),
          _buildQuizProgress(),
          const SizedBox(height: 24),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildUserProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[400]!, Colors.cyan[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
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
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _getLevelEmoji(),
                style: TextStyle(fontSize: 40),
              ),
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
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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

  String _getLevelEmoji() {
    switch (_userLevel) {
      case 'Master':
        return '👑';
      case 'Expert':
        return '🏆';
      case 'Intermediate':
        return '⭐';
      case 'Learner':
        return '🌟';
      default:
        return '✨';
    }
  }

  Widget _buildQuizProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
                'Quiz Completion',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
              Text(
                '$_totalQuizzes/8',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _totalQuizzes / 8,
              backgroundColor: Colors.purple[100],
              valueColor: AlwaysStoppedAnimation<Color>(
                _totalQuizzes == 8 ? Colors.green[600]! : Colors.purple[600]!,
              ),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _totalQuizzes == 8
                ? '🎉 Congratulations! All quizzes completed!'
                : '${8 - _totalQuizzes} more quizzes to complete all challenges!',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
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
      childAspectRatio: 1.4,
      children: [
        _buildStatCard(
          icon: Icons.quiz,
          title: 'Quizzes Done',
          value: '$_totalQuizzes/8',
          color: Colors.blue,
          progress: _totalQuizzes / 8,
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
          value: '${_badges.length}/8',
          color: Colors.purple,
          progress: _badges.length / 8,
        ),
        _buildStatCard(
          icon: Icons.speed,
          title: 'Average Score',
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
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          if (progress != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.history, color: Colors.purple[600], size: 20),
              ),
              const SizedBox(width: 12),
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
          const SizedBox(height: 20),
          _buildActivityItem('Completed Animals Quiz', '2 hours ago', Icons.pets, Colors.green),
          const SizedBox(height: 12),
          _buildActivityItem('Earned "Quick Learner" badge', 'Yesterday', Icons.emoji_events, Colors.amber),
          const SizedBox(height: 12),
          _buildActivityItem('Completed Math Quiz', '2 days ago', Icons.calculate, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMotivationCard(),
          const SizedBox(height: 24),
          _buildBadgeStats(),
          const SizedBox(height: 24),
          Text(
            'Earned Badges (${_badges.length}/8)',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.purple[800],
            ),
          ),
          const SizedBox(height: 16),
          _badges.isEmpty ? _buildEmptyBadgesState() : _buildEarnedBadgesGrid(),
          const SizedBox(height: 28),
          Text(
            'All Badges',
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

  Widget _buildBadgeStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber[100]!, Colors.orange[100]!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                '${_badges.length}',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
              ),
              Text(
                'Earned',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.orange[300],
          ),
          Column(
            children: [
              Text(
                '${8 - _badges.length}',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[600],
                ),
              ),
              Text(
                'Remaining',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.orange[300],
          ),
          Column(
            children: [
              Text(
                '${(_badges.length / 8 * 100).toStringAsFixed(0)}%',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
              ),
              Text(
                'Complete',
                style: GoogleFonts.poppins(
                  fontSize: 14,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLevelProgressCard(),
          const SizedBox(height: 24),
          _buildOverallProgress(),
          const SizedBox(height: 24),
          Text(
            'Milestones',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.purple[800],
            ),
          ),
          const SizedBox(height: 16),
          ..._milestones.map((milestone) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildMilestoneCard(milestone),
          )),
        ],
      ),
    );
  }

  Widget _buildOverallProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
            'Overall Progress',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple[800],
            ),
          ),
          const SizedBox(height: 20),
          _buildProgressItem('Quizzes', _totalQuizzes, 8, Colors.blue),
          const SizedBox(height: 16),
          _buildProgressItem('Badges', _badges.length, 8, Colors.purple),
          const SizedBox(height: 16),
          _buildProgressItem('Milestones', _milestones.where((m) => m['completed']).length, 5, Colors.green),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String title, int current, int total, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '$current/$total',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: current / total,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelProgressCard() {
    int nextLevelQuizzes = 0;
    String nextLevel = '';
    
    if (_totalQuizzes < 2) {
      nextLevelQuizzes = 2;
      nextLevel = 'Learner';
    } else if (_totalQuizzes < 4) {
      nextLevelQuizzes = 4;
      nextLevel = 'Intermediate';
    } else if (_totalQuizzes < 6) {
      nextLevelQuizzes = 6;
      nextLevel = 'Expert';
    } else if (_totalQuizzes < 8) {
      nextLevelQuizzes = 8;
      nextLevel = 'Master';
    }

    double progress = _totalQuizzes == 8 ? 1.0 : (_totalQuizzes % nextLevelQuizzes) / nextLevelQuizzes;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[100]!, Colors.cyan[100]!],
        ),
        borderRadius: BorderRadius.circular(24),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Level',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        _getLevelEmoji(),
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.purple[600],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _userLevel,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          if (_totalQuizzes < 8) ...[
            const SizedBox(height: 24),
            Text(
              'Progress to $nextLevel',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[600]!),
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${nextLevelQuizzes - _totalQuizzes} more quizzes to reach $nextLevel level',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ] else ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700]),
                  const SizedBox(width: 12),
                  Text(
                    'Maximum level reached!',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(Map<String, dynamic> milestone) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: milestone['completed'] ? Colors.green[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: milestone['completed'] ? Colors.green[300]! : Colors.grey[300]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: milestone['completed'] 
                ? Colors.green.withOpacity(0.1) 
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: milestone['completed'] 
                  ? Colors.green[100] 
                  : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                milestone['reward'],
                style: const TextStyle(fontSize: 28),
              ),
            ),
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
                    color: milestone['completed'] 
                        ? Colors.green[800] 
                        : Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  milestone['completed'] 
                      ? 'Completed! Well done!' 
                      : 'Complete ${milestone['required']} quizzes',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (milestone['completed'])
            Icon(Icons.check_circle, color: Colors.green[600], size: 28),
        ],
      ),
    );
  }

  Widget _buildMotivationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[100]!, Colors.cyan[50]!],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                'assets/home_screen/buddy.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text('🤖', style: TextStyle(fontSize: 28)),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _quote,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.purple[900],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyBadgesState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple[100]!, width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, size: 72, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No badges yet',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.purple[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete quizzes to earn shiny badges!',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
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
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: _badges.length,
      itemBuilder: (context, index) {
        final badgeId = _badges[index];
        final badge = _allBadges.firstWhere(
          (b) => b['id'] == badgeId,
          orElse: () => {'id': badgeId, 'name': badgeId, 'icon': Icons.star, 'color': Colors.grey},
        );
        return _buildEarnedBadgeTile(badge);
      },
    );
  }

  Widget _buildEarnedBadgeTile(Map<String, dynamic> badge) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (badge['color'] as Color).withOpacity(0.1),
            (badge['color'] as Color).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (badge['color'] as Color).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (badge['color'] as Color).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            badge['icon'],
            size: 36,
            color: badge['color'],
          ),
          const SizedBox(height: 8),
          Text(
            badge['name'],
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllBadgesList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.6,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEarned ? (badge['color'] as Color).withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isEarned ? (badge['color'] as Color) : Colors.grey[300]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isEarned 
                ? (badge['color'] as Color).withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                badge['icon'],
                size: 36,
                color: isEarned ? badge['color'] : Colors.grey[400],
              ),
              if (!isEarned)
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            badge['name'],
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isEarned ? Colors.grey[800] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            badge['desc'],
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isEarned) ...[
            const SizedBox(height: 6),
            Icon(Icons.check_circle, color: Colors.green[600], size: 18),
          ],
        ],
      ),
    );
  }
}