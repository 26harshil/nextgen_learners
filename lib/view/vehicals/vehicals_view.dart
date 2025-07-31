import 'package:flutter/material.dart';
import 'package:nextgen_learners/constant/import_export.dart';

class VehicalsView extends StatefulWidget {
  const VehicalsView({super.key});

  @override
  _VehicalsViewState createState() => _VehicalsViewState();
}

class _VehicalsViewState extends State<VehicalsView> {
  int currentQuestionIndex = 0;
  int points = 0;
  bool showHint = false;
  bool showFunFact = false;
  String? selectedAnswer;

  final List<Map<String, dynamic>> questions = [
    {
      'image': 'https://thumbs.dreamstime.com/z/vector-cartoon-formula-race-car-isolated-white-available-eps-format-separated-groups-layers-easy-edit-148860896.jpg',
      'question': 'What vehicle is this?',
      'options': ['Car', 'Race Car', 'Truck', 'Bus'],
      'answer': 'Race Car',
      'hint': 'This vehicle is built for speed and races on tracks.',
      'funFact': '🏎️ Race cars are super fast and compete in exciting races like Formula 1!'
    },
    {
      'image': 'https://png.pngtree.com/png-clipart/20230914/original/pngtree-subway-train-clipart-metro-train-on-the-city-vector-illustration-cartoon-png-image_11092381.png',
      'question': 'What vehicle is this?',
      'options': ['Bus', 'Train', 'Metro', 'Tram'],
      'answer': 'Metro',
      'hint': 'This vehicle runs underground in big cities.',
      'funFact': '🚇 Metros zip through tunnels to help people travel quickly in busy cities.'
    },
    {
      'image': 'https://tse2.mm.bing.net/th/id/OIP.P_EhByY2mCk4cpK683xdLgHaGn?rs=1&pid=ImgDetMain&o=7&rm=3',
      'question': 'What vehicle is this?',
      'options': ['Helicopter', 'Subway', 'Train', 'Airplane'],
      'answer': 'Station Train',
      'hint': 'This vehicle stops at platforms and runs on long tracks.',
      'funFact': '🚉 Station trains carry passengers across cities and countries on rails.'
    },
    {
      'image': 'https://tse1.mm.bing.net/th/id/OIP.epyCYhlZBt1DWPXbtMhMuwHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
      'question': 'What vehicle is this?',
      'options': ['Bus', 'Train', 'Cable Car', 'Plane'],
      'answer': 'Cable Car',
      'hint': 'This vehicle hangs from cables and climbs hills.',
      'funFact': '🚠 Cable cars glide up mountains, giving amazing views from the air!'
    },
    
    {
      'image': 'https://tse1.mm.bing.net/th/id/OIP.VIA-fy87More6N8nJPysuQHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
      'question': 'What vehicle is this?',
      'options': ['Bus', 'Tram', 'Metro', 'Car'],
      'answer': 'Tram',
      'hint': 'This vehicle runs on tracks in city streets.',
      'funFact': '🚊 Trams roll through cities on tracks, making short trips easy and fun!'
    },
    {
      'image': 'https://tse2.mm.bing.net/th/id/OIP.3-2H9wTMvwwO4aajuthOUQHaNL?rs=1&pid=ImgDetMain&o=7&rm=3',
      'question': 'What vehicle is this?',
      'options': ['Bus', 'Car', 'Train', 'Truck'],
      'answer': 'Car',
      'hint': 'This vehicle is small and used by families for daily travel.',
      'funFact': '🚗 Cars usually have 4 wheels and are the most common way families travel!'
    },
    {
      'image': 'https://cdn1.vectorstock.com/i/1000x1000/76/60/cartoon-police-car-character-vector-20757660.jpg',
      'question': 'What vehicle is this?',
      'options': ['Ambulance', 'Truck', 'Police Car', 'Van'],
      'answer': 'Police Car',
      'hint': 'This vehicle has sirens and flashing lights for emergencies.',
      'funFact': '🚓 Police cars have sirens and flashing lights to move quickly and safely in emergencies.'
    },
    {
      'image': 'https://tse1.mm.bing.net/th/id/OIP.aLEL24kuuwYueba5W0fLDAHaFN?rs=1&pid=ImgDetMain&o=7&rm=3',
      'question': 'What vehicle is this?',
      'options': ['Car', 'Ambulance', 'Fire Truck', 'Van'],
      'answer': 'Ambulance',
      'hint': 'This vehicle helps sick people get to the hospital.',
      'funFact': '🚑 Ambulances help carry sick or injured people quickly to the hospital.'
    },
    {
      'image': 'https://tse4.mm.bing.net/th/id/OIP.gnjDXKsLPapziDRCnJQ0mgHaHG?rs=1&pid=ImgDetMain&o=7&rm=3',
      'question': 'What vehicle is this?',
      'options': ['Bus', 'Truck', 'Fire Truck', 'Car'],
      'answer': 'Fire Truck',
      'hint': 'This vehicle carries firefighters and hoses.',
      'funFact': '🚒 Fire trucks carry firefighters and long ladders to rescue people and stop fires!'
    },
    {
      'image': 'https://tse4.mm.bing.net/th/id/OIP.LSGymr23B1s0vl3lgVvw4gHaGl?rs=1&pid=ImgDetMain&o=7&rm=3',
      'question': 'What vehicle is this?',
      'options': ['Truck', 'School Bus', 'Car', 'Van'],
      'answer': 'School Bus',
      'hint': 'This vehicle is yellow and takes kids to school.',
      'funFact': '🚌 School buses are usually yellow so kids can see them easily and stay safe.'
    },
    {
      'image': 'https://img.freepik.com/premium-vector/road-bike-cartoon-illustration_1366-1286.jpg?w=2000',
      'question': 'What vehicle is this?',
      'options': ['Bike', 'Scooter', 'Bicycle', 'Car'],
      'answer': 'Bicycle',
      'hint': 'This vehicle has two wheels and is powered by pedaling.',
      'funFact': '🚲 Bicycles are fun, healthy, and great for the planet — no fuel needed!'
    },
    {
      'image': 'https://img.freepik.com/premium-vector/scooter-vector-illustration-cartoon_969863-324054.jpg',
      'question': 'What vehicle is this?',
      'options': ['Bike', 'Scooter', 'Rickshaw', 'Van'],
      'answer': 'Scooter',
      'hint': 'This vehicle is small and zips through traffic.',
      'funFact': '🛵 Scooters are easy to ride and can zip through busy traffic quickly.'
    },
    {
      'image': 'https://tse3.mm.bing.net/th/id/OIP.TPCPa11kwtoo9UlJ7zYwrwHaHE?rs=1&pid=ImgDetMain&o=7&rm=3',
      'question': 'What vehicle is this?',
      'options': ['Scooter', 'Cycle', 'Motorcycle', 'Car'],
      'answer': 'Motorcycle',
      'hint': 'This vehicle is fast and often used in races.',
      'funFact': '🏍️ Motorcycles can go really fast and are used in races and stunts too!'
    },
    {
      'image': 'https://as1.ftcdn.net/v2/jpg/06/11/67/46/1000_F_611674669_hsK2ECmWekvQlfPX67cLf3ZflqVrowo2.jpg',
      'question': 'What vehicle is this?',
      'options': ['Tractor', 'Bus', 'Van', 'Truck'],
      'answer': 'Truck',
      'hint': 'This vehicle carries heavy loads across cities.',
      'funFact': '🚛 Trucks carry heavy loads like fruits, machines, and toys across cities!'
    },
    // {
    //   'image': 'assets/vehicles/tractor.png',
    //   'question': 'What vehicle is this?',
    //   'options': ['Bulldozer', 'Tractor', 'Truck', 'Train'],
    //   'answer': 'Tractor',
    //   'hint': 'This vehicle is used on farms to plow fields.',
    //   'funFact': '🚜 Tractors are used on farms to plow fields and pull heavy tools.'
    // },
    // {
    //   'image': 'assets/vehicles/train.png',
    //   'question': 'What vehicle is this?',
    //   'options': ['Plane', 'Ship', 'Train', 'Car'],
    //   'answer': 'Train',
    //   'hint': 'This vehicle runs on tracks and can be very long.',
    //   'funFact': '🚂 Trains run on tracks and can be very long — some even sleep overnight in them!'
    // },
    // {
    //   'image': 'assets/vehicles/airplane.png',
    //   'question': 'What vehicle is this?',
    //   'options': ['Helicopter', 'Rocket', 'Jet', 'Airplane'],
    //   'answer': 'Airplane',
    //   'hint': 'This vehicle flies high across the world.',
    //   'funFact': '✈️ Airplanes fly high in the sky and can travel across the world in hours!'
    // },
    // {
    //   'image': 'assets/vehicles/helicopter.png',
    //   'question': 'What vehicle is this?',
    //   'options': ['Helicopter', 'Plane', 'Kite', 'Jet'],
    //   'answer': 'Helicopter',
    //   'hint': 'This vehicle can hover and land on rooftops.',
    //   'funFact': '🚁 Helicopters can go up and down straight — even land on rooftops!'
    // },
    // {
    //   'image': 'assets/vehicles/ship.png',
    //   'question': 'What vehicle is this?',
    //   'options': ['Boat', 'Ship', 'Train', 'Truck'],
    //   'answer': 'Ship',
    //   'hint': 'This vehicle sails across oceans.',
    //   'funFact': '🚢 Ships carry people and cargo across oceans — some even have swimming pools!'
    // },
    // {
    //   'image': 'assets/vehicles/canoe.png',
    //   'question': 'What vehicle is this?',
    //   'options': ['Ship', 'Boat', 'Submarine', 'Car'],
    //   'answer': 'Boat',
    //   'hint': 'This vehicle moves with paddles on calm waters.',
    //   'funFact': '🛶 Canoes and rowboats move with paddles — perfect for calm lakes and rivers.'
    // },
    // {
    //   'image': 'assets/vehicles/ufo.png',
    //   'question': 'What vehicle is this?',
    //   'options': ['Rocket', 'Helicopter', 'UFO', 'Drone'],
    //   'answer': 'UFO',
    //   'hint': 'This mysterious vehicle might come from outer space!',
    //   'funFact': '🛸 UFO means “Unidentified Flying Object.” No one knows what it really is — maybe aliens?'
    // },
    // {
    //   'image': 'assets/vehicles/van.png',
    //   'question': 'What vehicle is this?',
    //   'options': ['Car', 'Truck', 'Van', 'Bus'],
    //   'answer': 'Van',
    //   'hint': 'This vehicle is roomy and great for carrying groups.',
    //   'funFact': '🚐 Vans are roomy and often used to carry goods, families, or sports teams.'
    // },
    // {
    //   'image': 'assets/vehicles/rocket.png',
    //   'question': 'What vehicle is this?',
    //   'options': ['Rocket', 'Airplane', 'Helicopter', 'Satellite'],
    //   'answer': 'Rocket',
    //   'hint': 'This vehicle blasts off to space.',
    //   'funFact': '🚀 Rockets blast into space — astronauts ride them to visit the moon and space stations!'
    // },
    // {
    //   'image': 'assets/vehicles/pickup_truck.png',
    //   'question': 'What vehicle is this?',
    //   'options': ['Truck', 'Van', 'Pickup', 'Bus'],
    //   'answer': 'Pickup',
    //   'hint': 'This vehicle has an open back for carrying things.',
    //   'funFact': '🛻 Pickup trucks have open backs to carry tools, bikes, or even puppies!'
    // },
    // {
    //   'image': 'assets/vehicles/bulldozer.png',
    //   'question': 'What vehicle is this?',
    //   'options': ['Tractor', 'Truck', 'Bulldozer', 'Van'],
    //   'answer': 'Bulldozer',
    //   'hint': 'This vehicle pushes dirt with a big blade.',
    //   'funFact': '🦺 Bulldozers push dirt and rocks on construction sites using their big blades.'
    // },
  ];

  void selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
      showFunFact = true;
      if (answer == questions[currentQuestionIndex]['answer']) {
        points += 10;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        currentQuestionIndex = 0; // Loop back to start
      }
      showHint = false;
      showFunFact = false;
      selectedAnswer = null;
    });
  }

  void toggleHint() {
    setState(() {
      showHint = !showHint;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar:  AppBar(
          leading: Tooltip(
            message: 'Back to previous screen',
            child: InkWell(
              onTap: () => Get.back(),
              borderRadius: BorderRadius.circular(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.purple[600]!, Colors.purple[400]!],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.black26,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                  semanticLabel: 'Back',
                ),
              ),
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/home_screen/buddy.png',
                height: 32,
                width: 32,
                fit: BoxFit.contain,
                semanticLabel: 'Math Adventure Quest Logo',
              ),
              const SizedBox(width: 8),
              Text(
                'Math Quest',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.white.withOpacity(0.1),
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple[100]!.withOpacity(0.3),
                  Colors.pink[100]!.withOpacity(0.3),
                ],
              ),
            ),
          ),
          toolbarHeight: 64,
          
        ),
        extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2196F3),
              Color(0xFFFFC107),
              Color(0xFFF44336),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo/icon
                Image.network(
                  currentQuestion['image'],
                  height: 120,
                  width: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.directions_car,
                    size: 120,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                const Text(
                  'Guess the Vehicle!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // Points display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black26,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'Points: $points',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Question display
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      currentQuestion['question'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Hint display
                if (showHint)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.yellow[100],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 6,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Hint: ${currentQuestion['hint']}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.brown[700],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // Answer options
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        _buildAnswerButton(
                          context,
                          currentQuestion['options'][0],
                          Colors.blue,
                          currentQuestion['answer'],
                        ),
                        const SizedBox(height: 20),
                        _buildAnswerButton(
                          context,
                          currentQuestion['options'][1],
                          Colors.red,
                          currentQuestion['answer'],
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        _buildAnswerButton(
                          context,
                          currentQuestion['options'][2],
                          Colors.blue,
                          currentQuestion['answer'],
                        ),
                        const SizedBox(height: 20),
                        _buildAnswerButton(
                          context,
                          currentQuestion['options'][3],
                          Colors.red,
                          currentQuestion['answer'],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Fun fact display
                if (showFunFact)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 6,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      currentQuestion['funFact'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                const SizedBox(height: 30),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      context,
                      label: showFunFact ? 'Next Question' : 'Submit Answer',
                      color: Colors.blue[700]!,
                      onPressed: showFunFact
                          ? nextQuestion
                          : () {
                              if (selectedAnswer != null) {
                                selectAnswer(selectedAnswer!);
                              }
                            },
                      enabled: selectedAnswer != null || showFunFact,
                    ),
                    const SizedBox(width: 20),
                    _buildActionButton(
                      context,
                      label: showHint ? 'Hide Hint' : 'Show Hint',
                      color: Colors.green[600]!,
                      onPressed: toggleHint,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerButton(
    BuildContext context,
    String answer,
    Color color,
    String correctAnswer,
  ) {
    bool isSelected = selectedAnswer == answer;
    bool isCorrect = answer == correctAnswer;

    return GestureDetector(
      onTap: showFunFact
          ? null
          : () {
              setState(() {
                selectedAnswer = answer;
              });
            },
      child: Container(
        height: 60,
        width: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isSelected && isCorrect ? Colors.green[400]! : color,
              isSelected && !isCorrect ? Colors.red[400]! : color.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black26,
              offset: Offset(2, 2),
            ),
          ],
          border: isSelected
              ? Border.all(color: Colors.white, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            answer,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required Color color,
    required VoidCallback onPressed,
    bool enabled = true,
  }) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}