import 'package:http/http.dart' as http;

import 'package:nextgen_learners/constant/import_export.dart';

class ApiService {
  static const String baseUrl =
      'https://nextgen-learners-backend.onrender.com/Quizz';
  // http://localhost:5379/Quizz
  Future<List<Quiz>> fetchQuiz(
    String category,
    RxList<Map<String, dynamic>> targetList,
  ) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$category'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final quizzes = data.map((json) => Quiz.fromJson(json)).toList();
        targetList.assignAll(quizzes.map((quiz) => quiz.toJson()).toList());
        return quizzes;
      } else {
        throw Exception('Failed to load quiz data for $category');
      }
    } catch (e) {
      print('Error fetching quiz for $category: $e');
      return [];
    }
  }
}
