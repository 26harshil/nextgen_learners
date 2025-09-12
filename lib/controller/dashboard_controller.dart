
import 'package:nextgen_learners/constant/import_export.dart';

class DashboardController extends GetxController {
  var colors = <Map<String, dynamic>>[].obs;
  var fruits = <Map<String, dynamic>>[].obs;
  var math = <Map<String, dynamic>>[].obs;
  var vegetables = <Map<String, dynamic>>[].obs;
  var vehicleName = <Map<String, dynamic>>[].obs;
  var animalName = <Map<String, dynamic>>[].obs;
    var birds = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs; // Track loading state
  var sounds = <Map<String, dynamic>>[].obs;
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchAllQuizzes();
  }

  Future<void> fetchAllQuizzes() async {
    isLoading.value = true;
    await Future.wait([
      _apiService.fetchQuiz('colors', colors),
      _apiService.fetchQuiz('fruits', fruits),
      _apiService.fetchQuiz('math', math),
      _apiService.fetchQuiz('vegetables', vegetables),
      _apiService.fetchQuiz('vehicles', vehicleName),
      _apiService.fetchQuiz('animalname', animalName),
      _apiService.fetchQuiz('birds', birds),
      _apiService.fetchQuiz('sounds', sounds),
    ]);
    isLoading.value = false;
    printAllQuizzes();
  }

  void printAllQuizzes() {
    print('--- All Quiz Data at ${DateTime.now()} ---');
    print('Colors Quiz: $colors');
    print('Fruits Quiz: $fruits');
    print('Math Quiz: $math');
    print('Vegetables Quiz: $vegetables');
    print('Vehicles Quiz: $vehicleName');
    print('Animals Quiz: $animalName');
    print('Birds Quiz: $birds');
     print('Birds Quiz: $sounds');
    print('---------------------');
  }
}
