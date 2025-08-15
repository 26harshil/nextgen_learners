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
      body: Center(
        child: CustomMCQWidget(
          questions: animalquestions,
          quizTitle: "ANIMAL NAME QUIZ",
          quizId: 'animal_name',
        ),
      ),
    );
  }
}
