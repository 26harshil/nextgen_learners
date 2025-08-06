import 'package:nextgen_learners/constant/import_export.dart';

class VegetablesView extends StatefulWidget {
  const VegetablesView({super.key});

  @override
  State<VegetablesView> createState() => _VegetablesScreenState();
}

class _VegetablesScreenState extends State<VegetablesView> {
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
              questions: vegetableQuestions,
              quizTitle: "vegetable NAME",
            ),
          ),
        ),
      ),
    );
  }
}
