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
    return Theme(
      data: ThemeData(
        primaryColor: Colors.purple[700],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          primary: Colors.purple[600],
          secondary: Colors.cyan[400],
          surface: Colors.white,
        ),
      ),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple[100]!,
                Colors.pink[100]!,
                Colors.cyan[50]!,
                Colors.purple[50]!,
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomMCQWidget(
                questions: math_questions,
                quizTitle: "Math Question",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
