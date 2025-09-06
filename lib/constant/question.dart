import 'package:nextgen_learners/constant/import_export.dart';

var colors = <Map<String, dynamic>>[].obs;
var fruits = <Map<String, dynamic>>[].obs;
var math = <Map<String, dynamic>>[].obs;
var vegetables = <Map<String, dynamic>>[].obs;
var vehicleName = <Map<String, dynamic>>[].obs;
var animalName = <Map<String, dynamic>>[].obs;
var birds = <Map<String, dynamic>>[].obs;

final List<Map<String, dynamic>> Animal_sound_questions = [
  {
    'question': '🦁 Which animal makes this sound?',
    'sound': 'sounds/lion_roar.mp3',
    'options': ['🦁 Lion', '🐘 Elephant', '🐶 Dog', '🐱 Cat'],
    'answer': '🦁 Lion',
    'hint': 'This animal has a loud roar and a big mane. 🦁',
    'funFact':
        '🦁 Lions roar to talk to their pride and scare other animals. Their roar can be heard 5 miles away!',
    'emoji': '🦁',
    'color': Colors.orange,
  },
  {
    'question': '🐘 Which animal makes this sound?',
    'sound': 'sounds/elephant_trumpet.mp3',
    'options': ['🦒 Giraffe', '🐘 Elephant', '🦓 Zebra', '🐻 Bear'],
    'answer': '🐘 Elephant',
    'hint': 'This animal trumpets with its long trunk. 🐘',
    'funFact':
        '🐘 Elephants trumpet to communicate over long distances. Their trumpets can be heard up to 6 miles away!',
    'emoji': '🐘',
    'color': Colors.grey,
  },
  {
    'question': '🐶 Which animal makes this sound?',
    'sound': 'sounds/dog_bark.mp3',
    'options': ['🐱 Cat', '🐶 Dog', '🦁 Lion', '🦒 Giraffe'],
    'answer': '🐶 Dog',
    'hint': 'This animal barks to alert or play. 🐾',
    'funFact':
        '🐶 Dogs bark to communicate with humans and other dogs, and each bark can mean different things!',
    'emoji': '🐶',
    'color': Colors.brown,
  },
  {
    'question': '🐱 Which animal makes this sound?',
    'sound': 'assets/sounds/cat_meow.mp3',
    'options': ['🐶 Dog', '🐱 Cat', '🐘 Elephant', '🦓 Zebra'],
    'answer': '🐱 Cat',
    'hint': 'This animal meows to get attention. 🐱',
    'funFact':
        '🐱 Cats meow mostly to communicate with humans, not other cats, and each meow has a unique tone!',
    'emoji': '🐱',
    'color': Colors.purple,
  },
];
