import 'package:nextgen_learners/constant/import_export.dart';

class BirdsView extends StatefulWidget {
  const BirdsView({super.key});

  @override
  State<BirdsView> createState() => _BirdsViewState();
}

class _BirdsViewState extends State<BirdsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomMCQWidget(
          questions: birds,
          quizTitle: "Birds",
          quizId: 'birds',
        ),
      ),
    );
  }
}
