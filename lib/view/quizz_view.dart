import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextgen_learners/constant/CustomeMcqContainer.dart';
import 'package:nextgen_learners/constant/string_constant.dart';
import 'package:nextgen_learners/services/api_config.dart';
import 'package:nextgen_learners/services/quiz_service.dart';

class QuizScreen extends StatelessWidget {
  final String quizId;

  const QuizScreen({super.key, required this.quizId});

  Widget _gradientScaffold({required Widget child}) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final apiUrl = ApiConfig.quizUrl(quizId);
    debugPrint('Quiz API URL: $apiUrl');

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: QuizService.fetchQuiz(apiUrl),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _gradientScaffold(
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
            ),
          );
        }

        // Error
        if (snapshot.hasError) {
          debugPrint('Quiz fetch error for "$quizId": ${snapshot.error}');
          return _gradientScaffold(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
                  const SizedBox(height: 12),
                  Text('Failed to load quiz.', style: GoogleFonts.fredoka(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Retry by navigating to the same route (rebuilds)
                          try {
                            final current = Get.currentRoute;
                            if (current.isNotEmpty) {
                              Get.offNamed(current);
                              return;
                            }
                          } catch (_) {}
                          Get.offNamed(DASHBOARD_SCREEN);
                        },
                        child: const Text('Retry'),
                      ),
                      OutlinedButton(
                        onPressed: () => Get.offNamed(DASHBOARD_SCREEN),
                        child: const Text('Back'),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }

        // Data ready
        final questions = snapshot.data ?? [];

        // Print fetched data to console for debugging (safe-print)
        debugPrint('Fetched questions (${questions.length}) for "$quizId":');
        for (var i = 0; i < questions.length; i++) {
          debugPrint('  [$i] ${questions[i]}');
        }

        // Empty dataset
        if (questions.isEmpty) {
          return _gradientScaffold(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.info_outline, size: 64, color: Colors.blueAccent),
                    const SizedBox(height: 12),
                    Text('No questions available for this quiz.', style: GoogleFonts.fredoka(fontSize: 18)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => Get.offNamed(DASHBOARD_SCREEN),
                      child: const Text('Back'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Normal UI: keep original look by embedding inside Scaffold with same gradient
        return _gradientScaffold(
          child: Center(
            child: CustomMCQWidget(
              questions: questions,
              quizTitle: quizId,
              quizId: quizId,
            ),
          ),
        );
      },
    );
  }
}