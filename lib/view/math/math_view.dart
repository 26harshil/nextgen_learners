import 'package:nextgen_learners/constant/import_export.dart';

class MathViews extends StatefulWidget {
  const MathViews({super.key});

  @override
  State<MathViews> createState() => _MathViewsState();
}

class _MathViewsState extends State<MathViews> with TickerProviderStateMixin {
  // Dummy data for questions

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomMCQWidget(
        questions: math_questions,
        quizTitle: "Math Question",
      ),
    );
  }
}
