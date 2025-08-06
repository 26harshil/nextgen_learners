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
              questions: fruitQuestions,
              quizTitle: "Fruit NAME QUIZ",
            ),
          ),
        ),
      ),
    );
  }
}
