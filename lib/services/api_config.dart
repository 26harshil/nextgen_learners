import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nextgen_learners/constant/import_export.dart';

class ApiConfig {
  static const String _defaultBaseUrl =
      'https://nextgen-learners-backend.onrender.com/';

  static String get baseHost {
    final configured = dotenv.env['BASE_URL']?.trim();
    if (configured != null && configured.isNotEmpty) {
      final parsed = Uri.tryParse(configured);
      final isHttpUrl =
          parsed != null &&
          parsed.hasScheme &&
          (parsed.scheme == 'http' || parsed.scheme == 'https') &&
          (parsed.host.isNotEmpty || configured.startsWith('http://localhost') || configured.startsWith('https://localhost'));

      if (isHttpUrl) {
        return configured.endsWith('/') ? configured : '$configured/';
      }

      if (kDebugMode) {
        debugPrint(
          'Ignoring invalid BASE_URL (must be http/https): $configured',
        );
      }
    }

    return _defaultBaseUrl;
  }

  // Full quiz endpoint builder: e.g. https://host/Quizz/colors
  static String quizUrl(String quizId) => '${baseHost}Quizz/$quizId';

  static const List<String> _defaultQuizPaths = <String>[
    'Quizz',
    'Quiz',
    'quiz',
    'api/quiz',
    'api/quizz',
  ];

  static const Map<String, List<String>> _quizIdAliases =
      <String, List<String>>{
        'sounds': <String>['sounds', 'animal_sound', 'animal-sound', 'sound'],
        'animalname': <String>['animalname', 'animal_name', 'animals'],
        'vehicles': <String>['vehicles', 'vehicals', 'vehicle'],
      };

  static List<String> quizCategoryAliases(String quizId) {
    final normalized = quizId.trim();
    if (normalized.isEmpty) return <String>[];

    final aliases = _quizIdAliases[normalized.toLowerCase()];
    if (aliases == null || aliases.isEmpty) {
      return <String>[normalized];
    }

    final seen = <String>{};
    final ordered = <String>[];
    for (final value in aliases) {
      if (seen.add(value)) ordered.add(value);
    }
    if (seen.add(normalized)) ordered.insert(0, normalized);
    return ordered;
  }

  static List<String> quizPathCandidates() {
    final fromEnv = dotenv.env['QUIZ_PATHS']?.trim();
    if (fromEnv == null || fromEnv.isEmpty) {
      return _defaultQuizPaths;
    }

    final parts =
        fromEnv
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

    return parts.isEmpty ? _defaultQuizPaths : parts;
  }

  static List<String> quizUrlsFor(String quizId) {
    final paths = quizPathCandidates();
    final categories = quizCategoryAliases(quizId);
    final urls = <String>[];

    for (final path in paths) {
      final normalizedPath =
          path.startsWith('/') ? path.substring(1) : path;
      for (final category in categories) {
        urls.add('$baseHost$normalizedPath/$category');
      }
    }

    return urls;
  }

  static String soundUrl(String soundPath) => '${baseHost}sounds/$soundPath';

  // Headers without API key
  static Map<String, String> headers({Map<String, String>? extra}) {
    return <String, String>{
      'Content-Type': 'application/json',
      if (extra != null) ...extra,
    };
  }
}
