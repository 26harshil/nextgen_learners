import 'package:nextgen_learners/constant/import_export.dart';
import 'package:nextgen_learners/controller/dashboard_controller.dart';
import 'package:nextgen_learners/view/quizz_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Baloo2",
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Baloo2', // Reinforce the font family
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      initialRoute: SPLASH_SCREEN,
      getPages: [
        // Ensure splash route exists so initialRoute is resolvable
        GetPage(name: SPLASH_SCREEN, page: () => const SplashScreen()),
        GetPage(
          name: DASHBOARD_SCREEN,
          page: () => const Dashboard(totalPoints: 0),
          binding: BindingsBuilder(() {
            Get.put(DashboardController());
          }),
        ),
        GetPage(
          name: COLORS_Screen,
          page: () => const QuizScreen(quizId: 'colors'),
        ),
        GetPage(
          name: FRUITS_SCREEN,
          page: () => const QuizScreen(quizId: 'fruits'),
        ),
        GetPage(
          name: VEGETABLES_SCREEN,
          page: () => const QuizScreen(quizId: 'vegetables'),
        ),
        GetPage(
          name: VEHICLE_NAME_SCREEN,
          page: () => const QuizScreen(quizId: 'vehicles'),
        ),
        GetPage(
          name: MATH_SCREEN,
          page: () => const QuizScreen(quizId: 'math'),
        ),
        GetPage(
          name: ANIMAL_Name_SCREEN,
          page: () => const QuizScreen(quizId: 'animalname'),
        ),
        GetPage(
          name: ANIMAL_SOUND_SCREEN,
          page: () {
            final controller = Get.find<DashboardController>();
            return AnimalSoundView(
              questions: controller.sounds,
              quizId: 'sounds',
            );
          },
        ),
        GetPage(
          name: BIRDS_SCREEN,
          page: () => const QuizScreen(quizId: 'birds'),
        ),
      ],
    );
  }
}
