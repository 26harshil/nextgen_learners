import 'package:nextgen_learners/constant/import_export.dart';

class Quiz {
  final int questionId;
  final String questionText;
  final String? imageUrl;
  final String? soundUrl;
  final String? hint;
  final String? funFact;
  final List<Option> options;

  Quiz({
    required this.questionId,
    required this.questionText,
    this.imageUrl,
    this.soundUrl,
    this.hint,
    this.funFact,
    required this.options,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    try {
      final opts =
          (json['options'] as List<dynamic>? ?? [])
              .map((e) => Option.fromJson(e as Map<String, dynamic>))
              .toList();

      return Quiz(
        questionId: json['questionId']?.toInt() ?? 0,
        questionText: json['questionText']?.toString() ?? '',
        imageUrl: json['imageUrl']?.toString(),
        soundUrl: json['soundUrl']?.toString(),
        hint: json['hint']?.toString(),
        funFact: json['funFact']?.toString(),
        options: opts,
      );
    } catch (e, st) {
      if (kDebugMode) {
        print('Quiz.fromJson failed for item: $json');
        print('$e\n$st');
      }
      return Quiz(
        questionId: 0,
        questionText: '',
        imageUrl: null,
        soundUrl: null,
        hint: null,
        funFact: null,
        options: [],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'questionText': questionText,
      'imageUrl': imageUrl,
      'soundUrl': soundUrl,
      'hint': hint,
      'funFact': funFact,
      'options': options.map((option) => option.toJson()).toList(),
    };
  }
}

class Option {
  final int optionId;
  final String optionText;
  final bool isCorrect;

  Option({
    required this.optionId,
    required this.optionText,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    try {
      return Option(
        optionId: json['optionId']?.toInt() ?? 0,
        optionText: json['optionText']?.toString() ?? '',
        isCorrect: json['isCorrect'] == true,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Option.fromJson failed for item: $json');
        print('$e');
      }
      return Option(optionId: 0, optionText: '', isCorrect: false);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'optionId': optionId,
      'optionText': optionText,
      'isCorrect': isCorrect,
    };
  }
}
