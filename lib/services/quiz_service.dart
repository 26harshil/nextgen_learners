import 'package:http/http.dart' as http;
import 'package:nextgen_learners/constant/import_export.dart';

class QuizService {
  /// Fetch quiz JSON from [apiUrl], log the raw response (debug only),
  /// sanitize values (convert numbers/null -> String) and normalize options.
  static Future<List<Map<String, dynamic>>> fetchQuiz(String apiUrl) async {
    try {
      if (kDebugMode) debugPrint('Fetching quiz from: $apiUrl');
      final resp = await http.get(Uri.parse(apiUrl));
      if (kDebugMode) {
        final preview =
            resp.body.length > 1000
                ? resp.body.substring(0, 1000) + '... (truncated)'
                : resp.body;
        debugPrint('HTTP ${resp.statusCode} -> ${preview}');
      }

      if (resp.statusCode != 200) {
        throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
      }

      final decoded = json.decode(resp.body);

      List<dynamic> rawList;
      if (decoded is List) {
        rawList = decoded;
      } else if (decoded is Map && decoded['data'] is List) {
        rawList = decoded['data'] as List;
      } else {
        throw Exception(
          'Unexpected JSON format: expecting List or {"data": List}',
        );
      }

      // Sanitize each question and options
      final sanitized =
          rawList.map<Map<String, dynamic>>((rawItem) {
            final Map<String, dynamic> item =
                (rawItem is Map)
                    ? Map<String, dynamic>.from(rawItem)
                    : <String, dynamic>{};

            final String questionText =
                (item['questionText'] ?? item['question'] ?? '').toString();
            final String imageUrl =
                (item['imageUrl'] ?? item['image'] ?? '').toString().trim();
            final String soundUrl =
                (item['soundUrl'] ?? item['sound'] ?? '').toString();
            final String? soundBase64 =
                (item['sound_data'] ?? item['soundData'] ?? item['soundBase64'])
                    ?.toString();
            Uint8List? soundBytes;
            if (soundBase64 != null && soundBase64.isNotEmpty) {
              try {
                soundBytes = base64.decode(soundBase64);
              } catch (_) {
                soundBytes = null;
              }
            }
            final String hint = (item['hint'] ?? '').toString();
            final String funFact =
                (item['funFact'] ?? item['info'] ?? '').toString();
            final dynamic qId =
                item.containsKey('questionId') ? item['questionId'] : null;

            final List<dynamic> rawOptions =
                (item['options'] is List)
                    ? item['options'] as List
                    : <dynamic>[];
            final options =
                rawOptions.map<Map<String, dynamic>>((optRaw) {
                  final Map<String, dynamic> opt =
                      (optRaw is Map)
                          ? Map<String, dynamic>.from(optRaw)
                          : <String, dynamic>{};
                  return <String, dynamic>{
                    'optionId': opt['optionId'] ?? opt['id'] ?? null,
                    'optionText':
                        (opt['optionText'] ?? opt['text'] ?? opt['value'] ?? '')
                            .toString(),
                    'isCorrect':
                        (opt['isCorrect'] == true) ||
                        (opt['correct'] == true) ||
                        (opt['answer'] == true),
                  };
                }).toList();

            final map = <String, dynamic>{
              'questionText': questionText,
              'imageUrl': imageUrl,
              'soundUrl': soundUrl,
              'hint': hint,
              'funFact': funFact,
              'options': options,
            };
            if (qId != null) map['questionId'] = qId;
            return map;
          }).toList();

      if (kDebugMode) debugPrint('Sanitized items: ${sanitized.length}');
      return sanitized;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('QuizService.fetchQuiz error: $e\n$st');
      }
      rethrow;
    }
  }

  static List<dynamic> _extractItems(dynamic decoded) {
    if (decoded is List) {
      return decoded;
    }
    if (decoded is Map && decoded['data'] is List) {
      return decoded['data'] as List;
    }
    if (decoded is Map && decoded['questions'] is List) {
      return decoded['questions'] as List;
    }
    if (decoded is Map && decoded['items'] is List) {
      return decoded['items'] as List;
    }
    return <dynamic>[];
  }

  /// Fetch by [quizId] and try multiple endpoint/category variants.
  static Future<List<Map<String, dynamic>>> fetchQuizById(String quizId) async {
    final urls = ApiConfig.quizUrlsFor(quizId);
    Object? lastError;

    for (final url in urls) {
      try {
        if (kDebugMode) debugPrint('Trying quiz endpoint: $url');
        final resp = await http.get(Uri.parse(url));
        if (resp.statusCode != 200) {
          if (kDebugMode) {
            debugPrint('HTTP ${resp.statusCode} for $url');
          }
          continue;
        }

        final decoded = json.decode(resp.body);
        final rawList = _extractItems(decoded);
        if (rawList.isEmpty) {
          if (kDebugMode) debugPrint('No quiz items in payload for $url');
          continue;
        }

        final sanitized =
            rawList.map<Map<String, dynamic>>((rawItem) {
              final Map<String, dynamic> item =
                  (rawItem is Map)
                      ? Map<String, dynamic>.from(rawItem)
                      : <String, dynamic>{};

              final String questionText =
                  (item['questionText'] ?? item['question'] ?? '').toString();
              final String imageUrl =
                  (item['imageUrl'] ?? item['image'] ?? '').toString().trim();
              final String soundUrl =
                  (item['soundUrl'] ?? item['sound'] ?? '').toString();
              final String hint = (item['hint'] ?? '').toString();
              final String funFact =
                  (item['funFact'] ?? item['info'] ?? '').toString();
              final dynamic qId =
                  item.containsKey('questionId') ? item['questionId'] : null;

              final List<dynamic> rawOptions =
                  (item['options'] is List) ? item['options'] as List : <dynamic>[];
              final options =
                  rawOptions.map<Map<String, dynamic>>((optRaw) {
                    final Map<String, dynamic> opt =
                        (optRaw is Map)
                            ? Map<String, dynamic>.from(optRaw)
                            : <String, dynamic>{};
                    return <String, dynamic>{
                      'optionId': opt['optionId'] ?? opt['id'] ?? null,
                      'optionText':
                          (opt['optionText'] ?? opt['text'] ?? opt['value'] ?? '')
                              .toString(),
                      'isCorrect':
                          (opt['isCorrect'] == true) ||
                          (opt['correct'] == true) ||
                          (opt['answer'] == true),
                    };
                  }).toList();

              final map = <String, dynamic>{
                'questionText': questionText,
                'imageUrl': imageUrl,
                'soundUrl': soundUrl,
                'hint': hint,
                'funFact': funFact,
                'options': options,
              };
              if (qId != null) map['questionId'] = qId;
              return map;
            }).toList();

        return sanitized;
      } catch (e) {
        lastError = e;
      }
    }

    if (lastError != null) {
      throw Exception('Failed to load quiz "$quizId": $lastError');
    }
    throw Exception('Failed to load quiz "$quizId" from known endpoints.');
  }
}
