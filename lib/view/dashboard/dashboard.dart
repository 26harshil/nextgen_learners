import 'package:nextgen_learners/constant/import_export.dart';

const kDashboardGradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      HOME_SCREEN_COLOR_LIGHT_PEACH,
      HOME_SCREEN_COLOR_LIGHT_PURPLE,
    ],
  ),
);

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NEXTGEN LEARNERS',
          style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Baloo2'),
        ),
        flexibleSpace: Container(decoration: kDashboardGradient),
      ),
      body: Container(
        decoration: kDashboardGradient,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomContainer(
                    newPage: ANIMAL_Name_SCREEN,
                    text: "Animals",
                    img: 'assets/home_screen/lion.jpg',
                    pcolor: ANIMAL_SCREEN_COLOR_LIGHT_PINK,
                    scolor: ANIMAL_SCREEN_COLOR_LIGHT_LAVENDER,
                  ),
                  const SizedBox(width: 20), // Spacing between containers
                  CustomContainer(
                    newPage: ANIMAL_SOUND_SCREEN,
                    text: "Animals Sound",
                    img: 'assets/home_screen/sound.webp',
                    pcolor: ANIMALSOUND_COLOR_LIGHT_ORANGE,
                    scolor: ANIMALSOUND_COLOR_LIGHT_CYAN,
                  ),
                ],
              ),
              const SizedBox(height: 20), // Spacing between rows
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomContainer(
                    newPage: MATH_SCREEN,
                    text: "Math",
                    img: 'assets/home_screen/math.webp',
                    pcolor: MATH_COLOR_LIGHT_PEACH,
                    scolor: MATH_COLOR_SOFT_PINK,
                  ),
                  const SizedBox(width: 20), // Spacing between containers
                  CustomContainer(
                    newPage: VEHICLE_NAME_SCREEN,
                    text: "Vehicles",
                    img: 'assets/home_screen/vehicals.jpg',
                    pcolor: VEHICLES_COLOR_LIGHT_BLUE,
                    scolor: VEHICLES_COLOR_SKY_BLUE,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
