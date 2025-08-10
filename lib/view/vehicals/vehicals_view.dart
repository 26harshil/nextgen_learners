import 'package:nextgen_learners/constant/import_export.dart';

class VehicalsView extends StatefulWidget {
  const VehicalsView({super.key});

  @override
  _VehicalsViewState createState() => _VehicalsViewState();
}

class _VehicalsViewState extends State<VehicalsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Center(
          child: CustomMCQWidget(
            questions: vehical_questions,
            quizTitle: "Vehical",
          ),
        ),
      ),
    );
  }
}
