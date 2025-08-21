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
      body: SafeArea(
        child: Obx(() {
          final list = vehicleName;
          if (list.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: CustomMCQWidget(
              questions: list.toList(),
              quizTitle: "Vehical",
              quizId: 'vehicals',
            ),
          );
        }),
      ),
    );
  }
}
