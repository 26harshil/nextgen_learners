import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'dart:convert';

class Quiz {
  final String questionText;
  final String imageUrl;
  final String hint;
  final String funFact;
  final List<Option> options;
  final String soundUrl; // optional fallback if bytes not present
  final Uint8List? soundDataBytes; // decoded from base64 JSON

  Quiz({
    required this.questionText,
    required this.imageUrl,
    required this.hint,
    required this.funFact,
    required this.options,
    this.soundUrl = '',
    this.soundDataBytes,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    try {
      final opts =
          (json['options'] as List<dynamic>? ?? [])
              .map((e) => Option.fromJson(e as Map<String, dynamic>))
              .toList();

      // Fallbacks for different backends/fields
      final String soundUrl =
          json['soundUrl']?.toString() ?? json['sound']?.toString() ?? '';
      final String? soundBase64 = (json['soundData'] ?? json['sound_data'] ?? json['soundBase64'])?.toString();
      Uint8List? soundBytes;
      if (soundBase64 != null && soundBase64.isNotEmpty) {
        try {
          soundBytes = base64.decode(soundBase64);
        } catch (_) {
          soundBytes = null;
        }
      }
      return Quiz(
        questionText:
            json['questionText']?.toString() ??
            json['question']?.toString() ?? // fallback keys
            '',
        imageUrl:
            json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
        hint: json['hint']?.toString() ?? '',
        funFact: json['funFact']?.toString() ?? json['info']?.toString() ?? '',
        options: opts,
        soundUrl: soundUrl,
        soundDataBytes: soundBytes,
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Quiz.fromJson failed for item: $json');
        debugPrint('$e\n$st');
      }
      // return a safe empty quiz rather than throwing
      return Quiz(
        questionText: '',
        imageUrl: '',
        hint: '',
        funFact: '',
        options: [],
        soundUrl: '',
        soundDataBytes: null,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'questionText': questionText,
      'imageUrl': imageUrl,
      'hint': hint,
      'funFact': funFact,
      'options': options.map((option) => option.toJson()).toList(),
      'soundUrl': soundUrl,
      'soundDataBytes': soundDataBytes,
    };
  }
}

class Option {
  final String optionText;
  final bool isCorrect;

  Option({required this.optionText, required this.isCorrect});

  factory Option.fromJson(Map<String, dynamic> json) {
    try {
      return Option(
        optionText:
            json['optionText']?.toString() ??
            json['text']?.toString() ?? // fallback key
            '',
        isCorrect:
            (json['isCorrect'] == true) || (json['correct'] == true) || false,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Option.fromJson failed for item: $json');
        debugPrint('$e');
      }
      return Option(optionText: '', isCorrect: false);
    }
  }

  Map<String, dynamic> toJson() {
    return {'optionText': optionText, 'isCorrect': isCorrect};
  }
}
