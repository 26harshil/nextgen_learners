import 'package:nextgen_learners/constant/import_export.dart';

class AnimalNameView extends StatefulWidget {
  const AnimalNameView({super.key});

  @override
  _AnimalQuizState createState() => _AnimalQuizState();
}

class _AnimalQuizState extends State<AnimalNameView> {
  @override
  Widget build(BuildContext context) {
    // final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4CAF50), Color(0xFF2196F3), Color(0xFFFF9800)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: CustomMCQWidget(
              questions: animalquestions,
              quizTitle: "ANIMAL NAME QUIZ",
            ),
          ),
        ),
      ),
    );
  }
}
