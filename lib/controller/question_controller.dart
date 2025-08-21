// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:nextgen_learners/constant/question.dart';
// import 'package:nextgen_learners/model/question_model.dart';

// class QuizController extends GetxController {
 

//   Future<void> fetchQuiz(String category, RxList<Map<String, dynamic>> targetList) async {
//     try {
//       final response = await http.get(Uri.parse('http://localhost:5379/Quizz/$category'));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         if (category == 'colors') {
//           final quizzes = data.map((json) => QuizItem.fromJson(json)).toList();
//           targetList.assignAll(quizzes.map((quiz) => quiz.toWidgetFormat()).toList());
//         } else {
//           // Assuming other categories (vehicles, fruits, etc.) use SimpleQuizItem format
//           final quizzes = data.map((json) => SimpleQuizItem.fromJson(json)).toList();
//           targetList.assignAll(quizzes.map((quiz) => quiz.toWidgetFormat()).toList());
//         }
//       } else {
//         Get.snackbar('Error', 'Failed to fetch $category quizzes: ${response.statusCode}');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to fetch $category quizzes: $e');
//     }
//   }

//   void onAnswerSubmitted(int questionId, bool isCorrect) {
//     print('Question ID: $questionId, Is Correct: $isCorrect');
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     // Fetch all quizzes at startup
//     fetchQuiz('colors', colors);
//     fetchQuiz('fruits', fruits);
//     fetchQuiz('math', math);
//     fetchQuiz('vegetables', vegetables);
//     fetchQuiz('vehicles', vehicleName); // Corrected from 'vehicals'
//     fetchQuiz('animal_name', animalName); // Corrected from 'animalname'
//   }
// }