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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        toolbarHeight: isSmallDevice ? 56 : null,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Achievements',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: isVerySmallDevice ? 18 : isSmallDevice ? 20 : 22,
            ),
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
          labelPadding: EdgeInsets.symmetric(horizontal: isSmallDevice ? 4 : 8),
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: isVerySmallDevice ? 10 : isSmallDevice ? 11 : 12,
          ),
          tabs: [
            Tab(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bar_chart, size: isSmallDevice ? 18 : 20),
                    const SizedBox(height: 2),
                    const Text('Stats'),
                  ],
                ),
              ),
            ),
            Tab(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.emoji_events, size: isSmallDevice ? 18 : 20),
                    const SizedBox(height: 2),
                    const Text('Badges'),
                  ],
                ),
              ),
            ),
            Tab(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up, size: isSmallDevice ? 18 : 20),
                    const SizedBox(height: 2),
                    const Text('Progress'),
                  ],
                ),
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
    final padding = isVerySmallDevice ? 10.0 : isSmallDevice ? 14.0 : 18.0;
    final spacing = isVerySmallDevice ? 12.0 : isSmallDevice ? 16.0 : 20.0;
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: spacing),
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
      padding: EdgeInsets.all(isVerySmallDevice ? 14 : isSmallDevice ? 18 : 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[400]!, Colors.cyan[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isSmallDevice ? 16 : 20),
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
            width: isVerySmallDevice ? 60 : isSmallDevice ? 70 : 80,
            height: isVerySmallDevice ? 60 : isSmallDevice ? 70 : 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _getLevelEmoji(),
                style: TextStyle(fontSize: isVerySmallDevice ? 28 : isSmallDevice ? 32 : 40),
              ),
            ),
          ),
          SizedBox(width: isVerySmallDevice ? 10 : isSmallDevice ? 14 : 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Little Champion',
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 16 : isSmallDevice ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isSmallDevice ? 6 : 8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isVerySmallDevice ? 10 : isSmallDevice ? 12 : 14,
                    vertical: isVerySmallDevice ? 4 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Level: $_userLevel',
                    style: GoogleFonts.poppins(
                      fontSize: isVerySmallDevice ? 11 : isSmallDevice ? 12 : 13,
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
      padding: EdgeInsets.all(isVerySmallDevice ? 14 : isSmallDevice ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallDevice ? 16 : 20),
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
              Expanded(
                child: Text(
                  'Quiz Completion',
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 14 : isSmallDevice ? 15 : 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$_totalQuizzes/8',
                style: GoogleFonts.poppins(
                  fontSize: isVerySmallDevice ? 18 : isSmallDevice ? 20 : 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[600],
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallDevice ? 10 : 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _totalQuizzes / 8,
              backgroundColor: Colors.purple[100],
              valueColor: AlwaysStoppedAnimation<Color>(
                _totalQuizzes == 8 ? Colors.green[600]! : Colors.purple[600]!,
              ),
              minHeight: isSmallDevice ? 10 : 12,
            ),
          ),
          SizedBox(height: isSmallDevice ? 8 : 10),
          Text(
            _totalQuizzes == 8
                ? '🎉 Congratulations! All quizzes completed!'
                : '${8 - _totalQuizzes} more to complete!',
            style: GoogleFonts.poppins(
              fontSize: isVerySmallDevice ? 11 : isSmallDevice ? 12 : 13,
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
      mainAxisSpacing: isVerySmallDevice ? 10 : isSmallDevice ? 12 : 14,
      crossAxisSpacing: isVerySmallDevice ? 10 : isSmallDevice ? 12 : 14,
      childAspectRatio: isVerySmallDevice ? 1.0 : isSmallDevice ? 1.15 : 1.3,
      children: [
        _buildStatCard(
          icon: Icons.quiz,
          title: 'Quizzes',
          value: '$_totalQuizzes/8',
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
          title: 'Badges',
          value: '${_badges.length}/8',
          color: Colors.purple,
          progress: _badges.length / 8,
        ),
        _buildStatCard(
          icon: Icons.speed,
          title: 'Average',
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
      padding: EdgeInsets.symmetric(
        horizontal: isVerySmallDevice ? 10 : isSmallDevice ? 12 : 16,
        vertical: isVerySmallDevice ? 12 : isSmallDevice ? 14 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallDevice ? 14 : 18),
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
            padding: EdgeInsets.all(isVerySmallDevice ? 6 : isSmallDevice ? 8 : 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon, 
              color: color, 
              size: isVerySmallDevice ? 20 : isSmallDevice ? 22 : 26,
            ),
          ),
          SizedBox(height: isVerySmallDevice ? 6 : isSmallDevice ? 8 : 10),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isVerySmallDevice ? 16 : isSmallDevice ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: isVerySmallDevice ? 2 : 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: isVerySmallDevice ? 10 : isSmallDevice ? 11 : 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          if (progress != null) ...[
            SizedBox(height: isVerySmallDevice ? 4 : 6),
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
      padding: EdgeInsets.all(isVerySmallDevice ? 14 : isSmallDevice ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallDevice ? 16 : 20),
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
                padding: EdgeInsets.all(isVerySmallDevice ? 5 : isSmallDevice ? 6 : 8),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.history, 
                  color: Colors.purple[600], 
                  size: isVerySmallDevice ? 16 : isSmallDevice ? 18 : 20,
                ),
              ),
              SizedBox(width: isSmallDevice ? 8 : 10),
              Text(
                'Recent Activity',
                style: GoogleFonts.poppins(
                  fontSize: isVerySmallDevice ? 14 : isSmallDevice ? 15 : 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),
            ],
          ),
          SizedBox(height: isVerySmallDevice ? 12 : isSmallDevice ? 14 : 16),
          _buildActivityItem('Animals Quiz', '2 hours ago', Icons.pets, Colors.green),
          SizedBox(height: isVerySmallDevice ? 6 : isSmallDevice ? 8 : 10),
          _buildActivityItem('New Badge', 'Yesterday', Icons.emoji_events, Colors.amber),
          SizedBox(height: isVerySmallDevice ? 6 : isSmallDevice ? 8 : 10),
          _buildActivityItem('Math Quiz', '2 days ago', Icons.calculate, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;
    
    return Container(
      padding: EdgeInsets.all(isVerySmallDevice ? 8 : isSmallDevice ? 10 : 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: isVerySmallDevice ? 30 : isSmallDevice ? 34 : 38,
            height: isVerySmallDevice ? 30 : isSmallDevice ? 34 : 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon, 
              size: isVerySmallDevice ? 14 : isSmallDevice ? 16 : 18, 
              color: color,
            ),
          ),
          SizedBox(width: isVerySmallDevice ? 8 : isSmallDevice ? 10 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 11 : isSmallDevice ? 12 : 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 10 : isSmallDevice ? 11 : 12,
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
    final padding = isVerySmallDevice ? 10.0 : isSmallDevice ? 14.0 : 18.0;
    final spacing = isVerySmallDevice ? 12.0 : isSmallDevice ? 16.0 : 20.0;
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: spacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMotivationCard(),
          SizedBox(height: spacing),
          _buildBadgeStats(),
          SizedBox(height: spacing),
          Text(
            'Earned (${_badges.length}/8)',
            style: GoogleFonts.poppins(
              fontSize: isVerySmallDevice ? 16 : isSmallDevice ? 17 : 19,
              fontWeight: FontWeight.w700,
              color: Colors.purple[800],
            ),
          ),
          SizedBox(height: isSmallDevice ? 10 : 14),
          _badges.isEmpty ? _buildEmptyBadgesState() : _buildEarnedBadgesGrid(),
          SizedBox(height: isVerySmallDevice ? 16 : isSmallDevice ? 20 : 24),
          Text(
            'All Badges',
            style: GoogleFonts.poppins(
              fontSize: isVerySmallDevice ? 16 : isSmallDevice ? 17 : 19,
              fontWeight: FontWeight.w700,
              color: Colors.purple[800],
            ),
          ),
          SizedBox(height: isSmallDevice ? 10 : 14),
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
      padding: EdgeInsets.all(isVerySmallDevice ? 14 : isSmallDevice ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber[100]!, Colors.orange[100]!],
        ),
        borderRadius: BorderRadius.circular(isSmallDevice ? 16 : 20),
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
          Expanded(
            child: Column(
              children: [
                Text(
                  '${_badges.length}',
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 22 : isSmallDevice ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                Text(
                  'Earned',
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 11 : isSmallDevice ? 12 : 13,
                    color: Colors.orange[700],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: isVerySmallDevice ? 35 : isSmallDevice ? 40 : 45,
            color: Colors.orange[300],
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '${8 - _badges.length}',
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 22 : isSmallDevice ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[600],
                  ),
                ),
                Text(
                  'Left',
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 11 : isSmallDevice ? 12 : 13,
                    color: Colors.orange[700],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: isVerySmallDevice ? 35 : isSmallDevice ? 40 : 45,
            color: Colors.orange[300],
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '${(_badges.length / 8 * 100).toStringAsFixed(0)}%',
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 22 : isSmallDevice ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                Text(
                  'Done',
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 11 : isSmallDevice ? 12 : 13,
                    color: Colors.orange[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;
    final padding = isVerySmallDevice ? 10.0 : isSmallDevice ? 14.0 : 18.0;
    final spacing = isVerySmallDevice ? 12.0 : isSmallDevice ? 16.0 : 20.0;
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: spacing),
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
              fontSize: isVerySmallDevice ? 16 : isSmallDevice ? 17 : 19,
              fontWeight: FontWeight.w700,
              color: Colors.purple[800],
            ),
          ),
          SizedBox(height: isSmallDevice ? 10 : 14),
          ..._milestones.map((milestone) => Padding(
            padding: EdgeInsets.only(bottom: isVerySmallDevice ? 8 : isSmallDevice ? 10 : 12),
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
      padding: EdgeInsets.all(isVerySmallDevice ? 14 : isSmallDevice ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallDevice ? 16 : 20),
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
              fontSize: isVerySmallDevice ? 14 : isSmallDevice ? 15 : 17,
              fontWeight: FontWeight.bold,
              color: Colors.purple[800],
            ),
          ),
          SizedBox(height: isVerySmallDevice ? 12 : isSmallDevice ? 14 : 18),
          _buildProgressItem('Quizzes', _totalQuizzes, 8, Colors.blue),
          SizedBox(height: isVerySmallDevice ? 10 : isSmallDevice ? 12 : 14),
          _buildProgressItem('Badges', _badges.length, 8, Colors.purple),
          SizedBox(height: isVerySmallDevice ? 10 : isSmallDevice ? 12 : 14),
          _buildProgressItem('Milestones', _milestones.where((m) => m['completed']).length, 5, Colors.green),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String title, int current, int total, Color color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
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
                fontSize: isVerySmallDevice ? 11 : isSmallDevice ? 12 : 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '$current/$total',
              style: GoogleFonts.poppins(
                fontSize: isVerySmallDevice ? 11 : isSmallDevice ? 12 : 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: isVerySmallDevice ? 4 : 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: current / total,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: isVerySmallDevice ? 5 : isSmallDevice ? 6 : 7,
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
      padding: EdgeInsets.all(isVerySmallDevice ? 14 : isSmallDevice ? 18 : 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[100]!, Colors.cyan[100]!],
        ),
        borderRadius: BorderRadius.circular(isSmallDevice ? 16 : 20),
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
            'Current Level',
            style: GoogleFonts.poppins(
              fontSize: isVerySmallDevice ? 13 : isSmallDevice ? 14 : 15,
              fontWeight: FontWeight.w600,
              color: Colors.purple[800],
            ),
          ),
          SizedBox(height: isVerySmallDevice ? 6 : 8),
          Row(
            children: [
              Text(
                _getLevelEmoji(),
                style: TextStyle(fontSize: isVerySmallDevice ? 26 : isSmallDevice ? 30 : 34),
              ),
              SizedBox(width: isVerySmallDevice ? 8 : isSmallDevice ? 10 : 12),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isVerySmallDevice ? 10 : isSmallDevice ? 12 : 14,
                  vertical: isVerySmallDevice ? 5 : isSmallDevice ? 6 : 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple[600],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _userLevel,
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 12 : isSmallDevice ? 13 : 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          if (_totalQuizzes < 8) ...[
            SizedBox(height: isVerySmallDevice ? 12 : isSmallDevice ? 16 : 20),
            Text(
              'Progress to $nextLevel',
              style: GoogleFonts.poppins(
                fontSize: isVerySmallDevice ? 11 : isSmallDevice ? 12 : 13,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: isVerySmallDevice ? 6 : 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[600]!),
                minHeight: isVerySmallDevice ? 7 : isSmallDevice ? 8 : 9,
              ),
            ),
            SizedBox(height: isVerySmallDevice ? 4 : 6),
            Text(
              '${nextLevelQuizzes - _totalQuizzes} more to $nextLevel level',
              style: GoogleFonts.poppins(
                fontSize: isVerySmallDevice ? 10 : isSmallDevice ? 11 : 12,
                color: Colors.grey[600],
              ),
            ),
          ] else ...[
            SizedBox(height: isVerySmallDevice ? 12 : isSmallDevice ? 14 : 16),
            Container(
              padding: EdgeInsets.all(isVerySmallDevice ? 8 : isSmallDevice ? 10 : 12),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700], size: isVerySmallDevice ? 16 : 18),
                  SizedBox(width: isVerySmallDevice ? 6 : 8),
                  Text(
                    'Maximum level!',
                    style: GoogleFonts.poppins(
                      fontSize: isVerySmallDevice ? 11 : isSmallDevice ? 12 : 13,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;
    
    return Container(
      padding: EdgeInsets.all(isVerySmallDevice ? 12 : isSmallDevice ? 14 : 16),
      decoration: BoxDecoration(
        color: milestone['completed'] ? Colors.green[50] : Colors.white,
        borderRadius: BorderRadius.circular(isSmallDevice ? 12 : 14),
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
            width: isVerySmallDevice ? 38 : isSmallDevice ? 42 : 46,
            height: isVerySmallDevice ? 38 : isSmallDevice ? 42 : 46,
            decoration: BoxDecoration(
              color: milestone['completed'] 
                  ? Colors.green[100] 
                  : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                milestone['reward'],
                style: TextStyle(fontSize: isVerySmallDevice ? 20 : isSmallDevice ? 22 : 24),
              ),
            ),
          ),
          SizedBox(width: isVerySmallDevice ? 10 : isSmallDevice ? 12 : 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone['title'],
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 12 : isSmallDevice ? 13 : 14,
                    fontWeight: FontWeight.w600,
                    color: milestone['completed'] 
                        ? Colors.green[800] 
                        : Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  milestone['completed'] 
                      ? 'Completed!' 
                      : 'Need ${milestone['required']} quizzes',
                  style: GoogleFonts.poppins(
                    fontSize: isVerySmallDevice ? 10 : isSmallDevice ? 11 : 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (milestone['completed'])
            Icon(Icons.check_circle, 
              color: Colors.green[600], 
              size: isVerySmallDevice ? 20 : isSmallDevice ? 22 : 24),
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
      padding: EdgeInsets.all(isVerySmallDevice ? 12 : isSmallDevice ? 14 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[100]!, Colors.cyan[50]!],
        ),
        borderRadius: BorderRadius.circular(isSmallDevice ? 14 : 16),
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
            width: isVerySmallDevice ? 44 : isSmallDevice ? 48 : 52,
            height: isVerySmallDevice ? 44 : isSmallDevice ? 48 : 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/home_screen/buddy.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text('🤖', style: TextStyle(fontSize: isVerySmallDevice ? 22 : 26)),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: isVerySmallDevice ? 10 : isSmallDevice ? 12 : 14),
          Expanded(
            child: Text(
              _quote,
              style: GoogleFonts.poppins(
                fontSize: isVerySmallDevice ? 11 : isSmallDevice ? 12 : 13,
                fontWeight: FontWeight.w600,
                color: Colors.purple[900],
                height: 1.3,
              ),
              maxLines: 3,
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
      padding: EdgeInsets.symmetric(
        vertical: isVerySmallDevice ? 28 : isSmallDevice ? 32 : 36,
        horizontal: isVerySmallDevice ? 20 : isSmallDevice ? 24 : 28,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallDevice ? 14 : 18),
        border: Border.all(color: Colors.purple[100]!, width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events, 
              size: isVerySmallDevice ? 48 : isSmallDevice ? 56 : 64, 
              color: Colors.grey[400]),
            SizedBox(height: isVerySmallDevice ? 10 : isSmallDevice ? 12 : 14),
            Text(
              'No badges yet',
              style: GoogleFonts.poppins(
                fontSize: isVerySmallDevice ? 16 : isSmallDevice ? 17 : 19,
                fontWeight: FontWeight.w700,
                color: Colors.purple[700],
              ),
            ),
            SizedBox(height: isVerySmallDevice ? 4 : 6),
            Text(
              'Complete quizzes to earn badges!',
              style: GoogleFonts.poppins(
                fontSize: isVerySmallDevice ? 11 : isSmallDevice ? 12 : 13,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallDevice = screenWidth < 320;
    final crossAxisCount = isVerySmallDevice ? 2 : 3;
    final spacing = isVerySmallDevice ? 10.0 : screenWidth < 360 ? 12.0 : 14.0;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;
    
    return Container(
      padding: EdgeInsets.all(isVerySmallDevice ? 6 : isSmallDevice ? 8 : 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (badge['color'] as Color).withOpacity(0.1),
            (badge['color'] as Color).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(isSmallDevice ? 10 : 14),
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
            size: isVerySmallDevice ? 22 : isSmallDevice ? 26 : 30,
            color: badge['color'],
          ),
          SizedBox(height: isVerySmallDevice ? 3 : 5),
          Text(
            badge['name'],
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: isVerySmallDevice ? 8 : isSmallDevice ? 9 : 10,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
            maxLines: 2,
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
    final spacing = isVerySmallDevice ? 10.0 : isSmallDevice ? 12.0 : 14.0;
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: isVerySmallDevice ? 1.1 : isSmallDevice ? 1.25 : 1.4,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallDevice = screenWidth < 360;
    final isVerySmallDevice = screenWidth < 320;
    
    return Container(
      padding: EdgeInsets.all(isVerySmallDevice ? 10 : isSmallDevice ? 12 : 14),
      decoration: BoxDecoration(
        color: isEarned ? (badge['color'] as Color).withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(isSmallDevice ? 12 : 16),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                badge['icon'],
                size: isVerySmallDevice ? 26 : isSmallDevice ? 30 : 34,
                color: isEarned ? badge['color'] : Colors.grey[400],
              ),
              if (!isEarned)
                Container(
                  width: isVerySmallDevice ? 28 : isSmallDevice ? 32 : 36,
                  height: isVerySmallDevice ? 28 : isSmallDevice ? 32 : 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    size: isVerySmallDevice ? 14 : isSmallDevice ? 16 : 18,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
          SizedBox(height: isVerySmallDevice ? 4 : isSmallDevice ? 6 : 8),
          Text(
            badge['name'],
            style: GoogleFonts.poppins(
              fontSize: isVerySmallDevice ? 10 : isSmallDevice ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: isEarned ? Colors.grey[800] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Text(
            badge['desc'],
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: isVerySmallDevice ? 8 : isSmallDevice ? 9 : 10,
              color: Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isEarned) ...[
            SizedBox(height: isVerySmallDevice ? 2 : 4),
            Icon(Icons.check_circle, 
              color: Colors.green[600], 
              size: isVerySmallDevice ? 14 : isSmallDevice ? 15 : 16),
          ],
        ],
      ),
    );
  }
}