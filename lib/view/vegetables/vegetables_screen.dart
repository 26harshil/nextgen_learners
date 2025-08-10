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
      body: Center(
        child: CustomMCQWidget(
          questions: vegetableQuestions,
          quizTitle: "vegetable NAME",
        ),
      ),
    );
  }
}
