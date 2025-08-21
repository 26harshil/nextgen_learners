import 'package:nextgen_learners/constant/import_export.dart';

class FruitsView extends StatefulWidget {
  const FruitsView({super.key});

  @override
  State<FruitsView> createState() => _FruitsScreenState();
}

class _FruitsScreenState extends State<FruitsView> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _questions = [];
  int? _backendQuizId; // numeric quiz id from backend (if found)
  String _title = "Fruit NAME QUIZ";
  int _userId = 0;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Center(
        child: CustomMCQWidget(
          questions: _questions.isNotEmpty ? _questions : fruits,
          quizTitle: _title,
          quizId: 'fruits',
          onAnswerSubmitted: (questionId, isCorrect) {
            // TODO: Optionally post progress to backend here
            print('Answer submitted -> qId: $questionId, correct: $isCorrect, user: $_userId');
          },
        ),
      ),
    );
  }
}
