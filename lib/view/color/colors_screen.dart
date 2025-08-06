import 'package:flutter/material.dart';
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
              questions: colorQuestions,
              quizTitle: "Colors QUIZ",
            ),
          ),
        ),
      ),
    );
  }
}
