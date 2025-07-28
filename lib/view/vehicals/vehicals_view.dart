import 'package:flutter/material.dart';

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
      'image': 'assets/vehicles/race_car.png',
      'question': 'What vehicle is this?',
      'options': ['Car', 'Race Car', 'Truck', 'Bus'],
      'answer': 'Race Car',
      'hint': 'This vehicle is built for speed and races on tracks.',
      'funFact': '🏎️ Race cars are super fast and compete in exciting races like Formula 1!'
    },
    {
      'image': 'assets/vehicles/metro.png',
      'question': 'What vehicle is this?',
      'options': ['Bus', 'Train', 'Metro', 'Tram'],
      'answer': 'Metro',
      'hint': 'This vehicle runs underground in big cities.',
      'funFact': '🚇 Metros zip through tunnels to help people travel quickly in busy cities.'
    },
    {
      'image': 'assets/vehicles/station_train.png',
      'question': 'What vehicle is this?',
      'options': ['Helicopter', 'Subway', 'Station Train', 'Airplane'],
      'answer': 'Station Train',
      'hint': 'This vehicle stops at platforms and runs on long tracks.',
      'funFact': '🚉 Station trains carry passengers across cities and countries on rails.'
    },
    {
      'image': 'assets/vehicles/cable_car.png',
      'question': 'What vehicle is this?',
      'options': ['Bus', 'Train', 'Cable Car', 'Plane'],
      'answer': 'Cable Car',
      'hint': 'This vehicle hangs from cables and climbs hills.',
      'funFact': '🚠 Cable cars glide up mountains, giving amazing views from the air!'
    },
    {
      'image': 'assets/vehicles/monorail.png',
      'question': 'What vehicle is this?',
      'options': ['Monorail', 'Metro', 'Train', 'Truck'],
      'answer': 'Monorail',
      'hint': 'This vehicle runs on a single rail, often in theme parks.',
      'funFact': '🚟 Monorails glide smoothly on one rail, often seen in fun places like Disney!'
    },
    {
      'image': 'assets/vehicles/tram.png',
      'question': 'What vehicle is this?',
      'options': ['Bus', 'Tram', 'Metro', 'Car'],
      'answer': 'Tram',
      'hint': 'This vehicle runs on tracks in city streets.',
      'funFact': '🚊 Trams roll through cities on tracks, making short trips easy and fun!'
    },
    {
      'image': 'assets/vehicles/car.png',
      'question': 'What vehicle is this?',
      'options': ['Bus', 'Car', 'Train', 'Truck'],
      'answer': 'Car',
      'hint': 'This vehicle is small and used by families for daily travel.',
      'funFact': '🚗 Cars usually have 4 wheels and are the most common way families travel!'
    },
    {
      'image': 'assets/vehicles/police_car.png',
      'question': 'What vehicle is this?',
      'options': ['Ambulance', 'Truck', 'Police Car', 'Van'],
      'answer': 'Police Car',
      'hint': 'This vehicle has sirens and flashing lights for emergencies.',
      'funFact': '🚓 Police cars have sirens and flashing lights to move quickly and safely in emergencies.'
    },
    {
      'image': 'assets/vehicles/ambulance.png',
      'question': 'What vehicle is this?',
      'options': ['Car', 'Ambulance', 'Fire Truck', 'Van'],
      'answer': 'Ambulance',
      'hint': 'This vehicle helps sick people get to the hospital.',
      'funFact': '🚑 Ambulances help carry sick or injured people quickly to the hospital.'
    },
    {
      'image': 'assets/vehicles/fire_truck.png',
      'question': 'What vehicle is this?',
      'options': ['Bus', 'Truck', 'Fire Truck', 'Car'],
      'answer': 'Fire Truck',
      'hint': 'This vehicle carries firefighters and hoses.',
      'funFact': '🚒 Fire trucks carry firefighters and long ladders to rescue people and stop fires!'
    },
    {
      'image': 'assets/vehicles/school_bus.png',
      'question': 'What vehicle is this?',
      'options': ['Truck', 'School Bus', 'Car', 'Van'],
      'answer': 'School Bus',
      'hint': 'This vehicle is yellow and takes kids to school.',
      'funFact': '🚌 School buses are usually yellow so kids can see them easily and stay safe.'
    },
    {
      'image': 'assets/vehicles/bicycle.png',
      'question': 'What vehicle is this?',
      'options': ['Bike', 'Scooter', 'Bicycle', 'Car'],
      'answer': 'Bicycle',
      'hint': 'This vehicle has two wheels and is powered by pedaling.',
      'funFact': '🚲 Bicycles are fun, healthy, and great for the planet — no fuel needed!'
    },
    {
      'image': 'assets/vehicles/scooter.png',
      'question': 'What vehicle is this?',
      'options': ['Bike', 'Scooter', 'Rickshaw', 'Van'],
      'answer': 'Scooter',
      'hint': 'This vehicle is small and zips through traffic.',
      'funFact': '🛵 Scooters are easy to ride and can zip through busy traffic quickly.'
    },
    {
      'image': 'assets/vehicles/motorcycle.png',
      'question': 'What vehicle is this?',
      'options': ['Scooter', 'Cycle', 'Motorcycle', 'Car'],
      'answer': 'Motorcycle',
      'hint': 'This vehicle is fast and often used in races.',
      'funFact': '🏍️ Motorcycles can go really fast and are used in races and stunts too!'
    },
    {
      'image': 'assets/vehicles/truck.png',
      'question': 'What vehicle is this?',
      'options': ['Tractor', 'Bus', 'Van', 'Truck'],
      'answer': 'Truck',
      'hint': 'This vehicle carries heavy loads across cities.',
      'funFact': '🚛 Trucks carry heavy loads like fruits, machines, and toys across cities!'
    },
    {
      'image': 'assets/vehicles/tractor.png',
      'question': 'What vehicle is this?',
      'options': ['Bulldozer', 'Tractor', 'Truck', 'Train'],
      'answer': 'Tractor',
      'hint': 'This vehicle is used on farms to plow fields.',
      'funFact': '🚜 Tractors are used on farms to plow fields and pull heavy tools.'
    },
    {
      'image': 'assets/vehicles/train.png',
      'question': 'What vehicle is this?',
      'options': ['Plane', 'Ship', 'Train', 'Car'],
      'answer': 'Train',
      'hint': 'This vehicle runs on tracks and can be very long.',
      'funFact': '🚂 Trains run on tracks and can be very long — some even sleep overnight in them!'
    },
    {
      'image': 'assets/vehicles/airplane.png',
      'question': 'What vehicle is this?',
      'options': ['Helicopter', 'Rocket', 'Jet', 'Airplane'],
      'answer': 'Airplane',
      'hint': 'This vehicle flies high across the world.',
      'funFact': '✈️ Airplanes fly high in the sky and can travel across the world in hours!'
    },
    {
      'image': 'assets/vehicles/helicopter.png',
      'question': 'What vehicle is this?',
      'options': ['Helicopter', 'Plane', 'Kite', 'Jet'],
      'answer': 'Helicopter',
      'hint': 'This vehicle can hover and land on rooftops.',
      'funFact': '🚁 Helicopters can go up and down straight — even land on rooftops!'
    },
    {
      'image': 'assets/vehicles/ship.png',
      'question': 'What vehicle is this?',
      'options': ['Boat', 'Ship', 'Train', 'Truck'],
      'answer': 'Ship',
      'hint': 'This vehicle sails across oceans.',
      'funFact': '🚢 Ships carry people and cargo across oceans — some even have swimming pools!'
    },
    {
      'image': 'assets/vehicles/canoe.png',
      'question': 'What vehicle is this?',
      'options': ['Ship', 'Boat', 'Submarine', 'Car'],
      'answer': 'Boat',
      'hint': 'This vehicle moves with paddles on calm waters.',
      'funFact': '🛶 Canoes and rowboats move with paddles — perfect for calm lakes and rivers.'
    },
    {
      'image': 'assets/vehicles/ufo.png',
      'question': 'What vehicle is this?',
      'options': ['Rocket', 'Helicopter', 'UFO', 'Drone'],
      'answer': 'UFO',
      'hint': 'This mysterious vehicle might come from outer space!',
      'funFact': '🛸 UFO means “Unidentified Flying Object.” No one knows what it really is — maybe aliens?'
    },
    {
      'image': 'assets/vehicles/van.png',
      'question': 'What vehicle is this?',
      'options': ['Car', 'Truck', 'Van', 'Bus'],
      'answer': 'Van',
      'hint': 'This vehicle is roomy and great for carrying groups.',
      'funFact': '🚐 Vans are roomy and often used to carry goods, families, or sports teams.'
    },
    {
      'image': 'assets/vehicles/rocket.png',
      'question': 'What vehicle is this?',
      'options': ['Rocket', 'Airplane', 'Helicopter', 'Satellite'],
      'answer': 'Rocket',
      'hint': 'This vehicle blasts off to space.',
      'funFact': '🚀 Rockets blast into space — astronauts ride them to visit the moon and space stations!'
    },
    {
      'image': 'assets/vehicles/pickup_truck.png',
      'question': 'What vehicle is this?',
      'options': ['Truck', 'Van', 'Pickup', 'Bus'],
      'answer': 'Pickup',
      'hint': 'This vehicle has an open back for carrying things.',
      'funFact': '🛻 Pickup trucks have open backs to carry tools, bikes, or even puppies!'
    },
    {
      'image': 'assets/vehicles/bulldozer.png',
      'question': 'What vehicle is this?',
      'options': ['Tractor', 'Truck', 'Bulldozer', 'Van'],
      'answer': 'Bulldozer',
      'hint': 'This vehicle pushes dirt with a big blade.',
      'funFact': '🦺 Bulldozers push dirt and rocks on construction sites using their big blades.'
    },
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
                Image.asset(
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