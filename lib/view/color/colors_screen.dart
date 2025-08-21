import 'package:nextgen_learners/constant/import_export.dart';

class ColorsView extends StatefulWidget {
  const ColorsView({super.key});

  @override
  State<ColorsView> createState() => _ColorsScreenState();
}

class _ColorsScreenState extends State<ColorsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomMCQWidget(
          questions: colors,
          quizTitle: "Colors QUIZ",
          quizId: 'colors',
        ),
      ),
    );
  }
}
