import 'package:nextgen_learners/constant/import_export.dart';

class FruitsView extends StatefulWidget {
  const FruitsView({super.key});

  @override
  State<FruitsView> createState() => _FruitsScreenState();
}

class _FruitsScreenState extends State<FruitsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomMCQWidget(
          questions: fruitQuestions,
          quizTitle: "Fruit NAME QUIZ",
        ),
      ),
    );
  }
}
