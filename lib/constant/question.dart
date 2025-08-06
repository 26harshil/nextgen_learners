import 'package:nextgen_learners/constant/import_export.dart';

final List<Map<String, dynamic>> questions = [
  {
    "question": "What is 2 + 3?",
    "answers": ["4", "5", "6", "3"],
    "correct": "5",
    "explanation":
        "Start with 2 fingers. Now add 3 more fingers. Count them all: 1, 2, 3, 4, 5. So, 2 + 3 = 5.",
    "hint": "Try counting on your fingers: start with 2, then add 3 more!",
  },
  {
    "question": "What is 10 - 4?",
    "answers": ["7", "5", "6", "4"],
    "correct": "6",
    "explanation":
        "You have 10 things. Take away 4. Now count what’s left: 6. So, 10 - 4 = 6.",
    "hint": "Imagine 10 candies and take away 4. How many are left?",
  },
  {
    "question": "What comes after 7?",
    "answers": ["6", "8", "9", "5"],
    "correct": "8",
    "explanation":
        "Count from 6: 6, 7, 8. The number that comes right after 7 is 8.",
    "hint": "Count up from 7: what's the next number?",
  },
  {
    "question": "How many sides does a square have?",
    "answers": ["3", "5", "4", "6"],
    "correct": "4",
    "explanation":
        "A square has 4 equal sides — one on each edge. Imagine a box or window.",
    "hint": "Think of a box. How many sides does it have?",
  },
  {
    "question": "What is 5 + 5?",
    "answers": ["11", "9", "10", "12"],
    "correct": "10",
    "explanation":
        "Take 5 fingers on one hand, and 5 on the other. Count all: 1 to 10. That makes 10.",
    "hint": "Use both hands: count 5 fingers on each!",
  },
  {
    "question": "Which number is bigger? 12 or 9?",
    "answers": ["12", "9", "Same", "None"],
    "correct": "12",
    "explanation":
        "When you count: 9, 10, 11, 12... So, 12 comes after 9. That means 12 is bigger.",
    "hint": "Count from 9 to 12. Which number comes later?",
  },
  {
    "question": "Which shape has 3 sides?",
    "answers": ["Circle", "Triangle", "Square", "Rectangle"],
    "correct": "Triangle",
    "explanation":
        "A triangle has 3 straight lines. One, two, three sides. Like a slice of pizza!",
    "hint": "Think of a shape like a pizza slice. How many sides does it have?",
  },
  {
    "question": "What is 15 - 10?",
    "answers": ["4", "3", "5", "6"],
    "correct": "5",
    "explanation":
        "If you have 15 candies and give away 10, you count what’s left: 5.",
    "hint": "Imagine 15 toys and take away 10. Count what's left!",
  },
  {
    "question": "How many legs does a spider have?",
    "answers": ["6", "8", "10", "4"],
    "correct": "8",
    "explanation": "Spiders have 4 legs on each side. 4 + 4 = 8 legs.",
    "hint": "Picture a spider. Count its legs on both sides!",
  },
  {
    "question": "What is 3 + 6?",
    "answers": ["9", "7", "8", "6"],
    "correct": "9",
    "explanation":
        "Start with 3 fingers, add 6 more. Count: 1, 2, 3, 4, 5, 6, 7, 8, 9. That makes 9.",
    "hint":
        "Add 3 and 6 using your fingers. Start with 3, then count up 6 more!",
  },
  {
    "question": "What comes before 20?",
    "answers": ["21", "18", "19", "17"],
    "correct": "19",
    "explanation": "Count backward: 20, 19. So, 19 comes just before 20.",
    "hint": "Count down from 20. What's the number just before it?",
  },
  {
    "question": "What is 4 + 4?",
    "answers": ["8", "9", "7", "6"],
    "correct": "8",
    "explanation":
        "If you have 4 pencils and get 4 more, count them all: 1–8. That makes 8.",
    "hint": "Double 4 by adding it to itself. Try counting 4 + 4!",
  },
  {
    "question": "Which number is even?",
    "answers": ["5", "7", "8", "9"],
    "correct": "8",
    "explanation": "Even numbers end with 0, 2, 4, 6, or 8. So, 8 is even.",
    "hint": "Look for a number that ends with 0, 2, 4, 6, or 8!",
  },
  {
    "question": "What is double of 6?",
    "answers": ["12", "10", "8", "14"],
    "correct": "12",
    "explanation": "Doubling means 6 + 6 = 12.",
    "hint": "Double means adding the number to itself. Try 6 + 6!",
  },
  {
    "question": "Which number is smallest?",
    "answers": ["4", "7", "6", "5"],
    "correct": "4",
    "explanation": "4 is less than 5, 6, and 7 — it comes first when counting.",
    "hint": "Think of counting from 1. Which number comes first?",
  },
  {
    "question": "What is 20 - 10?",
    "answers": ["5", "10", "15", "20"],
    "correct": "10",
    "explanation": "Take 10 away from 20, you're left with 10.",
    "hint": "Imagine 20 blocks and remove 10. How many are left?",
  },
  {
    "question": "How many sides does a triangle have?",
    "answers": ["3", "4", "5", "6"],
    "correct": "3",
    "explanation":
        "A triangle has 3 corners and 3 sides. Like a slice of pizza.",
    "hint": "Think of a shape with 3 corners. How many sides does it have?",
  },
  {
    "question": "What is 7 + 2?",
    "answers": ["10", "8", "9", "7"],
    "correct": "9",
    "explanation": "Start at 7, count 2 more: 8, 9. That makes 9.",
    "hint": "Start at 7 and count up 2 more steps!",
  },
  {
    "question": "Which number is greater? 11 or 15?",
    "answers": ["11", "15", "Same", "10"],
    "correct": "15",
    "explanation": "15 comes after 11 when you count. So it’s greater.",
    "hint": "Count from 11 to 15. Which number is later?",
  },
  {
    "question": "What is half of 10?",
    "answers": ["4", "3", "5", "6"],
    "correct": "5",
    "explanation":
        "Half means sharing equally. 10 split in 2 parts is 5 and 5.",
    "hint": "Split 10 into two equal parts. How many in each part?",
  },
  {
    "question": "What is 6 - 2?",
    "answers": ["4", "5", "3", "6"],
    "correct": "4",
    "explanation": "If you take 2 away from 6, count what's left: 4.",
    "hint": "Start with 6 and take away 2. Count what's left!",
  },
  {
    "question": "How many corners does a rectangle have?",
    "answers": ["2", "3", "4", "5"],
    "correct": "4",
    "explanation": "A rectangle has 4 corners, just like a door or book.",
    "hint": "Think of a door. How many corners does it have?",
  },
  {
    "question": "Which number comes after 29?",
    "answers": ["28", "31", "30", "27"],
    "correct": "30",
    "explanation": "Count up: 28, 29, 30. So, 30 comes after 29.",
    "hint": "Count up from 29. What's the next number?",
  },
  {
    "question": "What is 3 + 5?",
    "answers": ["6", "7", "9", "8"],
    "correct": "8",
    "explanation": "Start with 3 fingers, add 5 more. Total = 8.",
    "hint": "Use your fingers: start with 3, then add 5 more!",
  },
  {
    "question": "Which shape is round?",
    "answers": ["Triangle", "Circle", "Square", "Rectangle"],
    "correct": "Circle",
    "explanation":
        "Circles are round with no corners. Like a ball or clock face.",
    "hint": "Think of a ball. Which shape has no corners?",
  },
  {
    "question": "What is 8 - 5?",
    "answers": ["4", "3", "2", "1"],
    "correct": "3",
    "explanation": "Take 5 from 8: count what's left — 3.",
    "hint": "Start with 8 and take away 5. How many are left?",
  },
  {
    "question": "What is 9 + 1?",
    "answers": ["10", "8", "11", "9"],
    "correct": "10",
    "explanation": "9 + 1 more equals 10. That's a full set of fingers!",
    "hint": "Start at 9 and add just 1 more!",
  },
  {
    "question": "Which number is odd?",
    "answers": ["4", "8", "7", "2"],
    "correct": "7",
    "explanation": "Odd numbers can’t be split into 2 equal groups. 7 is odd.",
    "hint": "Look for a number that can’t be split evenly into two groups!",
  },
  {
    "question": "How many days are in a week?",
    "answers": ["5", "6", "7", "8"],
    "correct": "7",
    "explanation":
        "There are 7 days — Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday.",
    "hint":
        "Think of the days you go to school and the weekend. How many total?",
  },
  {
    "question": "What is 12 - 6?",
    "answers": ["5", "6", "4", "8"],
    "correct": "6",
    "explanation":
        "12 take away 6 equals 6. You’re splitting it right in half.",
    "hint": "Split 12 into two equal parts. What’s half of 12?",
  },
  {
    "question": "What is 10 + 0?",
    "answers": ["10", "0", "1", "5"],
    "correct": "10",
    "explanation":
        "If you add nothing to 10, it stays the same. So, 10 + 0 = 10.",
    "hint": "What happens if you add nothing to 10?",
  },
  {
    "question": "Which number comes before 50?",
    "answers": ["49", "48", "51", "45"],
    "correct": "49",
    "explanation": "Counting backward: 50, 49. So, 49 comes just before 50.",
    "hint": "Count down from 50. What's the number just before?",
  },
  {
    "question": "What is 2 + 6?",
    "answers": ["7", "8", "6", "9"],
    "correct": "8",
    "explanation": "2 fingers + 6 fingers = 8 fingers in total.",
    "hint": "Use your fingers: start with 2, then add 6 more!",
  },
  {
    "question": "What is 14 - 7?",
    "answers": ["6", "5", "8", "7"],
    "correct": "7",
    "explanation":
        "If you take away 7 from 14, you’re left with 7. That’s half.",
    "hint": "Think of splitting 14 into two equal parts. What’s half?",
  },
  {
    "question": "Which number is greater? 17 or 13?",
    "answers": ["17", "13", "Same", "12"],
    "correct": "17",
    "explanation": "17 comes after 13. So 17 is the bigger number.",
    "hint": "Count from 13 to 17. Which number is later?",
  },
  {
    "question": "What is 5 more than 9?",
    "answers": ["13", "15", "14", "10"],
    "correct": "14",
    "explanation": "Start at 9 and count up 5 more: 10, 11, 12, 13, 14.",
    "hint": "Start at 9 and count up 5 steps!",
  },
  {
    "question": "Which number is between 8 and 10?",
    "answers": ["7", "9", "10", "6"],
    "correct": "9",
    "explanation": "Count: 8, 9, 10. So, 9 is in the middle.",
    "hint": "Count from 8 to 10. What’s the number in between?",
  },
  {
    "question": "How many hours in a day?",
    "answers": ["12", "20", "24", "22"],
    "correct": "24",
    "explanation":
        "A full day has 24 hours — morning, afternoon, evening, and night.",
    "hint": "Think of a whole day, from morning to night. How many hours?",
  },
  {
    "question": "What is 3 less than 12?",
    "answers": ["10", "11", "8", "9"],
    "correct": "9",
    "explanation": "Count backward from 12: 11, 10, 9. So, 12 - 3 = 9.",
    "hint": "Start at 12 and count back 3 steps!",
  },
  {
    "question": "What is 4 x 2?",
    "answers": ["6", "8", "10", "12"],
    "correct": "8",
    "explanation": "4 times 2 means 4 + 4 = 8.",
    "hint": "Think of 4 groups of 2. Add them together!",
  },
  {
    "question": "What is 16 divided by 4?",
    "answers": ["3", "4", "2", "5"],
    "correct": "4",
    "explanation": "16 shared between 4 people means everyone gets 4.",
    "hint": "Split 16 into 4 equal groups. How many in each?",
  },
  {
    "question": "What is 0 + 7?",
    "answers": ["0", "6", "7", "8"],
    "correct": "7",
    "explanation": "Adding zero doesn’t change anything. 0 + 7 = 7.",
    "hint": "What happens if you add nothing to 7?",
  },
  {
    "question": "How many tens are in 30?",
    "answers": ["1", "2", "3", "4"],
    "correct": "3",
    "explanation": "10 + 10 + 10 = 30, so there are 3 tens in 30.",
    "hint": "Count by 10s until you reach 30. How many tens?",
  },
  {
    "question": "What is 11 - 3?",
    "answers": ["7", "6", "8", "9"],
    "correct": "8",
    "explanation": "Start at 11, take away 3: 10, 9, 8.",
    "hint": "Start at 11 and count back 3 steps!",
  },
  {
    "question": "What is 6 + 6?",
    "answers": ["10", "11", "12", "13"],
    "correct": "12",
    "explanation": "6 + 6 is called a double — and 6 doubled is 12.",
    "hint": "Double 6 by adding it to itself!",
  },
  {
    "question": "What comes after 99?",
    "answers": ["100", "98", "101", "99"],
    "correct": "100",
    "explanation": "After 99 comes the first 3-digit number — 100!",
    "hint": "Count up from 99. What’s the next number?",
  },
  {
    "question": "What is the value of a dime in cents?",
    "answers": ["10", "5", "15", "25"],
    "correct": "10",
    "explanation":
        "A dime is worth 10 cents — smaller than a quarter but more than a nickel.",
    "hint": "Think of coins. How many cents is a dime worth?",
  },
  {
    "question": "What is 18 - 9?",
    "answers": ["10", "9", "8", "7"],
    "correct": "9",
    "explanation": "18 take away 9 is 9 — it’s a half!",
    "hint": "Split 18 into two equal parts. What’s half?",
  },
  {
    "question": "Which number comes just before 100?",
    "answers": ["98", "97", "99", "100"],
    "correct": "99",
    "explanation": "Count up: 98, 99, 100. So 99 is just before 100.",
    "hint": "Count down from 100. What’s the number just before?",
  },
  {
    "question": "How many minutes in an hour?",
    "answers": ["60", "30", "50", "100"],
    "correct": "60",
    "explanation":
        "One hour is always 60 minutes long — like from 2:00 to 3:00.",
    "hint": "Think of a clock. How many minutes make one hour?",
  },
];

final List<Map<String, dynamic>> animalquestions = [
  {
    'image':
        'https://tse1.mm.bing.net/th/id/OIP.PtoTy3zxmq89LA_fx2_rbAHaHq?rs=1&pid=ImgDetMain&o=7&rm=3',
    'question': 'Which animal is known as the King of the Jungle?',
    'options': ['Elephant', 'Tiger', 'Lion', 'Bear'],
    'answer': 'Lion',
    'hint': 'This animal is a big cat with a majestic mane.',
    'funFact':
        '🦁 Lions are called the King of the Jungle because of their strength, leadership, and majestic appearance. They live in groups called prides.',
  },
  {
    'image':
        'https://tse3.mm.bing.net/th/id/OIP.TGg5wMD-jRwcZyz1IxXH6gHaIN?w=1154&h=1280&rs=1&pid=ImgDetMain&o=7&rm=3',
    'question': 'Which animal has black and white stripes?',
    'options': ['Leopard', 'Giraffe', 'Zebra', 'Cow'],
    'answer': 'Zebra',
    'hint': 'This animal’s pattern is unique like a fingerprint.',
    'funFact':
        '🦓 Each zebra has a unique stripe pattern, which helps them blend into the grasslands and confuse predators.',
  },
  {
    'image':
        'https://img.freepik.com/premium-vector/cute-elephant-cartoon_160606-195.jpg?w=2000',
    'question': 'Which animal is the largest land mammal?',
    'options': ['Hippo', 'Elephant', 'Rhino', 'Buffalo'],
    'answer': 'Elephant',
    'hint': 'This animal has a long trunk and large ears.',
    'funFact':
        '🐘 Elephants can weigh up to 6,000 kg. They have long trunks used for drinking water, grabbing food, and social interactions.',
  },
  // Add more questions as needed, following the same structure
  // For brevity, only 3 questions are included here; extend the list to include all 50 questions similarly
];

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
final List<Map<String, dynamic>> math_questions = [
  {
    'question': '2 🍎 + 3 🍎 = ?',
    'correctAnswer': '5 🍎',
    'options': ['4 🍎', '5 🍎', '6 🍎', '3 🍎'],
    'hint': 'Count all the apples together!',
    'explanation':
        'When you have 2 apples and get 3 more, you have 5 apples in total!',
  },
  {
    'question': '1 ⭐ + 4 ⭐ = ?',
    'correctAnswer': '5 ⭐',
    'options': ['5 ⭐', '3 ⭐', '6 ⭐', '2 ⭐'],
    'hint': 'Add one star to four stars!',
    'explanation': 'One star plus four stars equals five shining stars!',
  },
  {
    'question': '3 🍌 + 2 🍌 = ?',
    'correctAnswer': '5 🍌',
    'options': ['4 🍌', '6 🍌', '5 🍌', '7 🍌'],
    'hint': 'Count all the bananas!',
    'explanation':
        'Three bananas plus two bananas makes five delicious bananas!',
  },
];

final List<Map<String, dynamic>> vehical_questions = [
  {
    'image':
        'https://thumbs.dreamstime.com/z/vector-cartoon-formula-race-car-isolated-white-available-eps-format-separated-groups-layers-easy-edit-148860896.jpg',
    'question': 'What vehicle is this?',
    'options': ['Car', 'Race Car', 'Truck', 'Bus'],
    'answer': 'Race Car',
    'hint': 'This vehicle is built for speed and races on tracks.',
    'funFact':
        '🏎️ Race cars are super fast and compete in exciting races like Formula 1!',
  },
  {
    'image':
        'https://png.pngtree.com/png-clipart/20230914/original/pngtree-subway-train-clipart-metro-train-on-the-city-vector-illustration-cartoon-png-image_11092381.png',
    'question': 'What vehicle is this?',
    'options': ['Bus', 'Train', 'Metro', 'Tram'],
    'answer': 'Metro',
    'hint': 'This vehicle runs underground in big cities.',
    'funFact':
        '🚇 Metros zip through tunnels to help people travel quickly in busy cities.',
  },
  {
    'image':
        'https://tse2.mm.bing.net/th/id/OIP.P_EhByY2mCk4cpK683xdLgHaGn?rs=1&pid=ImgDetMain&o=7&rm=3',
    'question': 'What vehicle is this?',
    'options': ['Helicopter', 'Subway', 'Train', 'Airplane'],
    'answer': 'Station Train',
    'hint': 'This vehicle stops at platforms and runs on long tracks.',
    'funFact':
        '🚉 Station trains carry passengers across cities and countries on rails.',
  },
  {
    'image':
        'https://tse1.mm.bing.net/th/id/OIP.epyCYhlZBt1DWPXbtMhMuwHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
    'question': 'What vehicle is this?',
    'options': ['Bus', 'Train', 'Cable Car', 'Plane'],
    'answer': 'Cable Car',
    'hint': 'This vehicle hangs from cables and climbs hills.',
    'funFact':
        '🚠 Cable cars glide up mountains, giving amazing views from the air!',
  },

  {
    'image':
        'https://tse1.mm.bing.net/th/id/OIP.VIA-fy87More6N8nJPysuQHaHa?rs=1&pid=ImgDetMain&o=7&rm=3',
    'question': 'What vehicle is this?',
    'options': ['Bus', 'Tram', 'Metro', 'Car'],
    'answer': 'Tram',
    'hint': 'This vehicle runs on tracks in city streets.',
    'funFact':
        '🚊 Trams roll through cities on tracks, making short trips easy and fun!',
  },
  {
    'image':
        'https://tse2.mm.bing.net/th/id/OIP.3-2H9wTMvwwO4aajuthOUQHaNL?rs=1&pid=ImgDetMain&o=7&rm=3',
    'question': 'What vehicle is this?',
    'options': ['Bus', 'Car', 'Train', 'Truck'],
    'answer': 'Car',
    'hint': 'This vehicle is small and used by families for daily travel.',
    'funFact':
        '🚗 Cars usually have 4 wheels and are the most common way families travel!',
  },
  {
    'image':
        'https://cdn1.vectorstock.com/i/1000x1000/76/60/cartoon-police-car-character-vector-20757660.jpg',
    'question': 'What vehicle is this?',
    'options': ['Ambulance', 'Truck', 'Police Car', 'Van'],
    'answer': 'Police Car',
    'hint': 'This vehicle has sirens and flashing lights for emergencies.',
    'funFact':
        '🚓 Police cars have sirens and flashing lights to move quickly and safely in emergencies.',
  },
  {
    'image':
        'https://tse1.mm.bing.net/th/id/OIP.aLEL24kuuwYueba5W0fLDAHaFN?rs=1&pid=ImgDetMain&o=7&rm=3',
    'question': 'What vehicle is this?',
    'options': ['Car', 'Ambulance', 'Fire Truck', 'Van'],
    'answer': 'Ambulance',
    'hint': 'This vehicle helps sick people get to the hospital.',
    'funFact':
        '🚑 Ambulances help carry sick or injured people quickly to the hospital.',
  },
  {
    'image':
        'https://tse4.mm.bing.net/th/id/OIP.gnjDXKsLPapziDRCnJQ0mgHaHG?rs=1&pid=ImgDetMain&o=7&rm=3',
    'question': 'What vehicle is this?',
    'options': ['Bus', 'Truck', 'Fire Truck', 'Car'],
    'answer': 'Fire Truck',
    'hint': 'This vehicle carries firefighters and hoses.',
    'funFact':
        '🚒 Fire trucks carry firefighters and long ladders to rescue people and stop fires!',
  },
  {
    'image':
        'https://tse4.mm.bing.net/th/id/OIP.LSGymr23B1s0vl3lgVvw4gHaGl?rs=1&pid=ImgDetMain&o=7&rm=3',
    'question': 'What vehicle is this?',
    'options': ['Truck', 'School Bus', 'Car', 'Van'],
    'answer': 'School Bus',
    'hint': 'This vehicle is yellow and takes kids to school.',
    'funFact':
        '🚌 School buses are usually yellow so kids can see them easily and stay safe.',
  },
  {
    'image':
        'https://img.freepik.com/premium-vector/road-bike-cartoon-illustration_1366-1286.jpg?w=2000',
    'question': 'What vehicle is this?',
    'options': ['Bike', 'Scooter', 'Bicycle', 'Car'],
    'answer': 'Bicycle',
    'hint': 'This vehicle has two wheels and is powered by pedaling.',
    'funFact':
        '🚲 Bicycles are fun, healthy, and great for the planet — no fuel needed!',
  },
  {
    'image':
        'https://img.freepik.com/premium-vector/scooter-vector-illustration-cartoon_969863-324054.jpg',
    'question': 'What vehicle is this?',
    'options': ['Bike', 'Scooter', 'Rickshaw', 'Van'],
    'answer': 'Scooter',
    'hint': 'This vehicle is small and zips through traffic.',
    'funFact':
        '🛵 Scooters are easy to ride and can zip through busy traffic quickly.',
  },
  {
    'image':
        'https://tse3.mm.bing.net/th/id/OIP.TPCPa11kwtoo9UlJ7zYwrwHaHE?rs=1&pid=ImgDetMain&o=7&rm=3',
    'question': 'What vehicle is this?',
    'options': ['Scooter', 'Cycle', 'Motorcycle', 'Car'],
    'answer': 'Motorcycle',
    'hint': 'This vehicle is fast and often used in races.',
    'funFact':
        '🏍️ Motorcycles can go really fast and are used in races and stunts too!',
  },
  {
    'image':
        'https://as1.ftcdn.net/v2/jpg/06/11/67/46/1000_F_611674669_hsK2ECmWekvQlfPX67cLf3ZflqVrowo2.jpg',
    'question': 'What vehicle is this?',
    'options': ['Tractor', 'Bus', 'Van', 'Truck'],
    'answer': 'Truck',
    'hint': 'This vehicle carries heavy loads across cities.',
    'funFact':
        '🚛 Trucks carry heavy loads like fruits, machines, and toys across cities!',
  },
];
List<Map<String, dynamic>> fruitQuestions = [
  {
    "question":
        "🍎 Which fruit is red or green and makes a crunchy sound when you bite it?",
    "options": ["🍎 Apple", "🍌 Banana", "🍊 Orange", "🍇 Grapes"],
    "answer": "🍎 Apple",
    "hint": "It’s round, crunchy, and often found in lunch boxes. 🍎",
    "funFact":
        "🍎 Apples float in water because 25% of their volume is air, making them perfect for bobbing games!",
    "emoji": "🍎",
    "color": "0xFFFF0000",
  },
  {
    "question": "🍌 Which fruit is long, yellow, and soft inside?",
    "options": ["🍇 Grapes", "🍌 Banana", "🍓 Strawberry", "🍍 Pineapple"],
    "answer": "🍌 Banana",
    "hint": "Monkeys love this fruit, and it grows in bunches. 🍌",
    "funFact":
        "🍌 Bananas are berries and contain potassium, which helps your muscles work properly!",
    "emoji": "🍌",
    "color": "0xFFFFFF00",
  },
  {
    "question": "🍊 Which fruit is round, orange, and full of juice?",
    "options": ["🍎 Apple", "🍊 Orange", "🍉 Watermelon", "🍑 Peach"],
    "answer": "🍊 Orange",
    "hint": "You can squeeze it to make a yummy drink. 🍊",
    "funFact":
        "🍊 Oranges are packed with vitamin C, which helps keep your immune system strong!",
    "emoji": "🍊",
    "color": "0xFFFFA500",
  },
  {
    "question": "🍇 Which fruit is small, round, and grows in bunches?",
    "options": ["🍓 Strawberry", "🍇 Grapes", "🍌 Banana", "🍍 Pineapple"],
    "answer": "🍇 Grapes",
    "hint":
        "They can be red, green, or purple and are fun to eat one by one. 🍇",
    "funFact": "🍇 Grapes are used to make juice, raisins, and even jelly!",
    "emoji": "🍇",
    "color": "0xFF800080",
  },
];
List<Map<String, dynamic>> vegetableQuestions = [
  {
    "question":
        "🥕 Which vegetable is orange and crunchy, and helps your eyes stay strong?",
    "options": ["🥕 Carrot", "🥔 Potato", "🥦 Broccoli", "🥒 Cucumber"],
    "answer": "🥕 Carrot",
    "hint": "Bugs Bunny loves this veggie! 🥕",
    "funFact":
        "🥕 Carrots are rich in beta-carotene, which your body turns into vitamin A for healthy eyes!",
    "emoji": "🥕",
    "color": "0xFFFFA500",
  },
  {
    "question":
        "🥔 Which vegetable is brown outside and soft inside when cooked?",
    "options": ["🥦 Broccoli", "🥔 Potato", "🥕 Carrot", "🌽 Corn"],
    "answer": "🥔 Potato",
    "hint": "You can mash it, fry it, or bake it. 🥔",
    "funFact":
        "🥔 Potatoes were the first vegetable grown in space, aboard the Space Shuttle Columbia in 1995!",
    "emoji": "🥔",
    "color": "0xFFA0522D",
  },
  {
    "question": "🥦 Which vegetable looks like a tiny green tree?",
    "options": ["🥒 Cucumber", "🥕 Carrot", "🥦 Broccoli", "🥔 Potato"],
    "answer": "🥦 Broccoli",
    "hint": "It’s green and super healthy for your body. 🥦",
    "funFact":
        "🥦 Broccoli is a superfood packed with vitamins C and K, and it’s related to cabbage and kale!",
    "emoji": "🥦",
    "color": "0xFF008000",
  },
  {
    "question": "🌽 Which vegetable is yellow and grows on a cob?",
    "options": ["🥔 Potato", "🌽 Corn", "🥦 Broccoli", "🥕 Carrot"],
    "answer": "🌽 Corn",
    "hint": "You can eat it on the cob or pop it into popcorn! 🌽",
    "funFact":
        "🌽 Corn is a staple crop worldwide and can be popped into popcorn when heated!",
    "emoji": "🌽",
    "color": "0xFFFFD700",
  },
];
List<Map<String, dynamic>> colorQuestions = [
  {
    "question": "🔴 What color is represented by this emoji and sound?",
    "options": ["Red", "Green", "Blue", "Yellow"],
    "answer": "🔴 Red",
    "hint": "Think of a ripe apple or a stop sign. 🔴",
    "funFact":
        "🔴 Red is the first color babies can see clearly, and it’s often used to grab attention!",
    "emoji": "🔴",
    "color": "0xFFFF0000",
  },
  {
    "question": "🟢 What color is represented by this emoji ?",
    "options": ["Yellow", "Green", "Red", "Purple"],
    "answer": "🟢 Green",
    "hint": "Think of grass or a lime. 🟢",
    "funFact":
        "🟢 Green is associated with nature and calmness, and it’s the most restful color for your eyes!",
    "emoji": "🟢",
    "color": "0xFF008000",
  },
  {
    "question": "🔵 What color is represented by this emoji ?",
    "options": ["Green", "Blue", "Yellow", "Red"],
    "answer": "🔵 Blue",
    "hint": "Think of the sky or the ocean. 🔵",
    "funFact":
        "🔵 Blue is the world’s favorite color and can make you feel calm and focused!",
    "emoji": "🔵",
    "color": "0xFF0000FF",
  },
  {
    "question": "🟡 What color is represented by this emoji ?",
    "options": ["Red", "Purple", "Yellow", "Green"],
    "answer": "🟡 Yellow",
    "hint": "Think of a bright sun or a lemon. 🟡",
    "funFact":
        "🟡 Yellow is the most visible color in daylight and is often used to signal caution or happiness!",
    "emoji": "🟡",
    "color": "0xFFFFFF00",
  },
];
