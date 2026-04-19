import 'package:http/http.dart' as http;

import 'package:nextgen_learners/constant/import_export.dart';

class ApiService {
  static String get baseUrl => '${ApiConfig.baseHost}Quizz';

  List<dynamic> _extractItems(dynamic decoded) {
    if (decoded is List) return decoded;
    if (decoded is Map) {
      final candidates = <String>['data', 'questions', 'items', 'result'];
      for (final key in candidates) {
        final value = decoded[key];
        if (value is List) return value;
      }
    }
    return <dynamic>[];
  }

  Future<List<Quiz>> fetchQuiz(
    String category,
    RxList<Map<String, dynamic>> targetList,
  ) async {
    final urls = ApiConfig.quizUrlsFor(category);

    try {
      for (final url in urls) {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode != 200) {
          if (kDebugMode) {
            debugPrint('ApiService: ${response.statusCode} for $url');
          }
          continue;
        }

        final decoded = jsonDecode(response.body);
        final List<dynamic> data = _extractItems(decoded);
        if (data.isEmpty) {
          if (kDebugMode) {
            debugPrint('ApiService: empty payload for $url');
          }
          continue;
        }

        final quizzes =
            data
                .map((json) => Quiz.fromJson(Map<String, dynamic>.from(json)))
                .toList();
        targetList.assignAll(quizzes.map((quiz) => quiz.toJson()).toList());
        if (kDebugMode) {
          debugPrint(
            'ApiService: loaded ${quizzes.length} items for "$category" from $url',
          );
        }
        return quizzes;
      }

      throw Exception('Failed to load quiz data for $category');
    } catch (e) {
      print('Error fetching quiz for $category: $e');
      return [];
    }
  }
}
