import 'package:nextgen_learners/constant/import_export.dart';
import 'package:nextgen_learners/view/splash_screen.dart';

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
        GetPage(name: SPLASH_SCREEN, page: () => SplashScreen()),
        GetPage(name: ANIMAL_Name_SCREEN, page: () => AnimalNameView()),
        GetPage(name: ANIMAL_SOUND_SCREEN, page: () => AnimalSoundView()),
        GetPage(name: MATH_SCREEN, page: () => MathViews()),
        GetPage(name: VEHICLE_NAME_SCREEN, page: () => VehicalsView()),
      ],
    );
  }
}
