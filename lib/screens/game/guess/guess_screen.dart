import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class GuessQuestion {
  final String imagePath;
  final List<String> options;
  final String correctAnswer;
  final String thaiMeaning;

  const GuessQuestion({
    required this.imagePath,
    required this.options,
    required this.correctAnswer,
    required this.thaiMeaning,
  });
}

class GuessCategory {
  final String title;
  final String subtitle;
  final String imagePath;
  final String questionFolder;
  final IconData icon;
  final Color color;

  const GuessCategory({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.questionFolder,
    required this.icon,
    required this.color,
  });
}

const Map<String, String> _animalMeanings = {
  'Bear': 'หมี',
  'Bird': 'นก',
  'Butterfly': 'ผีเสื้อ',
  'Cat': 'แมว',
  'Chicken': 'ไก่',
  'Cow': 'วัว',
  'Crocodile': 'จระเข้',
  'Dog': 'สุนัข',
  'Dolphin': 'โลมา',
  'Duck': 'เป็ด',
  'Elephant': 'ช้าง',
  'Fish': 'ปลา',
  'Frog': 'กบ',
  'Giraffe': 'ยีราฟ',
  'Horse': 'ม้า',
  'Koala': 'โคอาลา',
  'Lion': 'สิงโต',
  'Mosquito': 'ยุง',
  'Owl': 'นกฮูก',
  'Peacock': 'นกยูง',
  'Penguin': 'เพนกวิน',
  'Pig': 'หมู',
  'Rabbit': 'กระต่าย',
  'Sheep': 'แกะ',
  'Shrimp': 'กุ้ง',
  'Snake': 'งู',
  'Spider': 'แมงมุม',
  'Tiger': 'เสือ',
  'Turtle': 'เต่า',
  'Zebra': 'ม้าลาย',
};

const Map<String, String> _fruitMeanings = {
  'Apple': 'แอปเปิล',
  'Apricot': 'แอปริคอต',
  'Avocado': 'อะโวคาโด',
  'Banana': 'กล้วย',
  'Blackberry': 'แบล็กเบอร์รี',
  'Blueberry': 'บลูเบอร์รี',
  'Cantaloupe': 'แคนตาลูป',
  'Cherry': 'เชอร์รี',
  'Coconut': 'มะพร้าว',
  'Durian': 'ทุเรียน',
  'Grape': 'องุ่น',
  'Guava': 'ฝรั่ง',
  'Kiwi': 'กีวี',
  'Lemon': 'เลมอน',
  'Lime': 'มะนาว',
  'Longan': 'ลำไย',
  'Lychee': 'ลิ้นจี่',
  'Mango': 'มะม่วง',
  'Mangosteen': 'มังคุด',
  'Orange': 'ส้ม',
  'Papaya': 'มะละกอ',
  'Passion Fruit': 'เสาวรส',
  'Pineapple': 'สับปะรด',
  'Pomegranate': 'ทับทิม',
  'Rambutan': 'เงาะ',
  'Raspberry': 'ราสป์เบอร์รี',
  'Rose Apple': 'ชมพู่',
  'Starfruit': 'มะเฟือง',
  'Strawberry': 'สตรอว์เบอร์รี',
  'Watermelon': 'แตงโม',
};

const Map<String, String> _jobMeanings = {
  'Artist': 'ศิลปิน',
  'Athlete': 'นักกีฬา',
  'Carpenter': 'ช่างไม้',
  'Chef': 'พ่อครัว / แม่ครัว',
  'Dancer': 'นักเต้น',
  'Dentist': 'ทันตแพทย์',
  'Doctor': 'แพทย์',
  'Driver': 'คนขับรถ',
  'Electrician': 'ช่างไฟฟ้า',
  'Engineer': 'วิศวกร',
  'Farmer': 'เกษตรกร',
  'Firefighter': 'นักดับเพลิง',
  'Fisherman': 'ชาวประมง',
  'Journalist': 'นักข่าว',
  'Lawyer': 'ทนายความ',
  'Musician': 'นักดนตรี',
  'Nurse': 'พยาบาล',
  'Pharmacist': 'เภสัชกร',
  'Photographer': 'ช่างภาพ',
  'Pilot': 'นักบิน',
  'Policeofficer': 'ตำรวจ',
  'Postman': 'บุรุษไปรษณีย์',
  'Singer': 'นักร้อง',
  'Soldier': 'ทหาร',
  'Teacher': 'ครู',
};

const Map<String, String> _clothingMeanings = {
  'Backpack': 'กระเป๋าเป้',
  'Bag': 'กระเป๋าถือ',
  'Belt': 'เข็มขัด',
  'Boots': 'รองเท้าบูท',
  'Cap': 'หมวกแก๊ป',
  'Dress': 'ชุดเดรส',
  'Earrings': 'ต่างหู',
  'Glasses': 'แว่นตา',
  'Hat': 'หมวก',
  'Hoodie': 'เสื้อฮู้ด',
  'Jacket': 'เสื้อแจ็กเก็ต',
  'Jeans': 'กางเกงยีนส์',
  'Necklace': 'สร้อยคอ',
  'Pajamas': 'ชุดนอน',
  'Pants': 'กางเกงขายาว',
  'Raincoat': 'เสื้อกันฝน',
  'Ring': 'แหวน',
  'Scarf': 'ผ้าพันคอ',
  'Shirt': 'เสื้อเชิ้ต',
  'Shoes': 'รองเท้า',
  'Shorts': 'กางเกงขาสั้น',
  'Skirt': 'กระโปรง',
  'Socks': 'ถุงเท้า',
  'Sunglasses': 'แว่นกันแดด',
  'Sweater': 'เสื้อกันหนาว',
  'Swimsuit': 'ชุดว่ายน้ำ',
  'T-shirt': 'เสื้อยืด',
  'Tie': 'เนกไท',
  'Uniform': 'เครื่องแบบ',
  'Watch': 'นาฬิกาข้อมือ',
};

const Map<String, String> _sportMeanings = {
  'Archery': 'ยิงธนู',
  'Badminton': 'แบดมินตัน',
  'Baseball': 'เบสบอล',
  'Basketball': 'บาสเกตบอล',
  'Bowling': 'โบว์ลิ่ง',
  'Boxing': 'ชกมวย',
  'Cycling': 'ปั่นจักรยาน',
  'Golf': 'กอล์ฟ',
  'Gymnastics': 'ยิมนาสติก',
  'Hockey': 'ฮอกกี้',
  'Rugby': 'รักบี้',
  'Running': 'วิ่ง',
  'Skateboarding': 'สเกตบอร์ด',
  'Soccer': 'ฟุตบอล',
  'Surfing': 'โต้คลื่น',
  'Swimming': 'ว่ายน้ำ',
  'Table Tennis': 'ปิงปอง',
  'Taekwondo': 'เทควันโด',
  'Tennis': 'เทนนิส',
  'Volleyball': 'วอลเลย์บอล',
};

const Map<String, String> _bodyMeanings = {
  'Arm': 'แขน',
  'Belly': 'ท้อง',
  'Bone': 'กระดูก',
  'Brain': 'สมอง',
  'Cheek': 'แก้ม',
  'Chest': 'หน้าอก',
  'Chin': 'คาง',
  'Ear': 'หู',
  'Eye': 'ตา',
  'Eyebrow': 'คิ้ว',
  'Eyelash': 'ขนตา',
  'Face': 'ใบหน้า',
  'Finger': 'นิ้วมือ',
  'Foot': 'เท้า',
  'Forehead': 'หน้าผาก',
  'Hair': 'ผม',
  'Hand': 'มือ',
  'Head': 'ศีรษะ',
  'Heart': 'หัวใจ',
  'Leg': 'ขา',
  'Lip': 'ริมฝีปาก',
  'Lungs': 'ปอด',
  'Mouth': 'ปาก',
  'Nail': 'เล็บ',
  'Neck': 'คอ',
  'Nose': 'จมูก',
  'Shoulder': 'ไหล่',
  'Thigh': 'ต้นขา',
  'Tongue': 'ลิ้น',
  'Tooth': 'ฟัน',
};

const Map<String, String> _colorMeanings = {
  'Beige': 'สีเบจ',
  'Black': 'สีดำ',
  'Blue': 'สีน้ำเงิน',
  'Brown': 'สีน้ำตาล',
  'Dark Green': 'สีเขียวเข้ม',
  'Gold': 'สีทอง',
  'Gray': 'สีเทา',
  'Green': 'สีเขียว',
  'Indigo': 'สีคราม',
  'Light Green': 'สีเขียวอ่อน',
  'Navy': 'สีกรมท่า',
  'Orange': 'สีส้ม',
  'Pink': 'สีชมพู',
  'Purple': 'สีม่วง',
  'Red': 'สีแดง',
  'Silver': 'สีเงิน',
  'Violet': 'สีม่วงอมฟ้า',
  'White': 'สีขาว',
  'Yellow': 'สีเหลือง',
};

const Map<String, String> _placeMeanings = {
  'Airport': 'สนามบิน',
  'Bakery': 'ร้านเบเกอรี่',
  'Bank': 'ธนาคาร',
  'Bus Stop': 'ป้ายรถเมล์',
  'Church': 'โบสถ์',
  'Cinema': 'โรงภาพยนตร์',
  'Fire Station': 'สถานีดับเพลิง',
  'Gas Station': 'ปั๊มน้ำมัน',
  'Gym': 'โรงยิม',
  'Home': 'บ้าน',
  'Hospital': 'โรงพยาบาล',
  'Hotel': 'โรงแรม',
  'Library': 'ห้องสมุด',
  'Market': 'ตลาด',
  'Mosque': 'มัสยิด',
  'Museum': 'พิพิธภัณฑ์',
  'Park': 'สวนสาธารณะ',
  'Pharmacy': 'ร้านขายยา',
  'Police Station': 'สถานีตำรวจ',
  'Post Office': 'ที่ทำการไปรษณีย์',
  'Restaurant': 'ร้านอาหาร',
  'School': 'โรงเรียน',
  'Temple': 'วัด',
  'Train Station': 'สถานีรถไฟ',
  'Zoo': 'สวนสัตว์',
};

const Map<String, String> _vehicleMeanings = {
  'Airplane': 'เครื่องบิน',
  'Ambulance': 'รถพยาบาล',
  'Bicycle': 'จักรยาน',
  'Boat': 'เรือ',
  'Bus': 'รถโดยสาร',
  'Car': 'รถยนต์',
  'Firetruck': 'รถดับเพลิง',
  'Helicopter': 'เฮลิคอปเตอร์',
  'Motorcycle': 'รถจักรยานยนต์',
  'Rocket': 'จรวด',
  'Schoolbus': 'รถโรงเรียน',
  'Ship': 'เรือสินค้า',
  'Skytrain': 'รถไฟฟ้า',
  'Submarine': 'เรือดำน้ำ',
  'Taxi': 'แท็กซี่',
  'Train': 'รถไฟ',
  'Truck': 'รถบรรทุก',
  'Van': 'รถตู้',
};

class GuessScreen extends StatefulWidget {
  const GuessScreen({super.key});

  @override
  State<GuessScreen> createState() => _GuessScreenState();
}

class _GuessScreenState extends State<GuessScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  int currentIndex = 0;
  int score = 0;
  String? selectedAnswer;
  String? selectedCategory;
  bool isAnswerRevealed = false;
  bool isCurrentCorrect = false;
  bool isGameCompleted = false;

  static const List<Map<String, dynamic>> _optionThemes = [
    {
      'label': 'A',
      'main': Color(0xFF2563EB),
      'shadow': Color(0xFF1D4ED8),
    },
    {
      'label': 'B',
      'main': Color(0xFFEF4444),
      'shadow': Color(0xFFB91C1C),
    },
    {
      'label': 'C',
      'main': Color(0xFFF97316),
      'shadow': Color(0xFFC2410C),
    },
    {
      'label': 'D',
      'main': Color(0xFF10B981),
      'shadow': Color(0xFF047857),
    },
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.38);
    await _flutterTts.setPitch(1.30);
  }

  Future<void> _speakWord(String text) async {
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  static List<GuessQuestion> _buildAnimalQuestions() {
    final names = _animalMeanings.keys.toList();
    return List.generate(names.length, (index) {
      final answer = names[index];
      final options = <String>[
        answer,
        for (var offset = 1; offset <= 3; offset++)
          names[(index + offset) % names.length],
      ]..shuffle();
      final extension = answer == 'Sheep' || answer == 'Turtle' ? 'webp' : 'png';
      return GuessQuestion(
        imagePath: 'assets/images/guess/animal/$answer.$extension',
        options: options,
        correctAnswer: answer,
        thaiMeaning: _animalMeanings[answer]!,
      );
    });
  }

  static List<GuessQuestion> _buildFruitQuestions() {
    final names = _fruitMeanings.keys.toList();
    return List.generate(names.length, (index) {
      final answer = names[index];
      final options = <String>[
        answer,
        for (var offset = 1; offset <= 3; offset++)
          names[(index + offset) % names.length],
      ]..shuffle();
      final fileName = answer == 'Passion Fruit'
          ? 'Passionfruit'
          : answer == 'Rose Apple'
              ? 'Roseapple'
              : answer;

      return GuessQuestion(
        imagePath: 'assets/images/guess/fruit/$fileName.png',
        options: options,
        correctAnswer: answer,
        thaiMeaning: _fruitMeanings[answer]!,
      );
    });
  }

  static List<GuessQuestion> _buildJobQuestions() {
    final names = _jobMeanings.keys.toList();
    return List.generate(names.length, (index) {
      final answer = names[index];
      final options = <String>[
        answer,
        for (var offset = 1; offset <= 3; offset++)
          names[(index + offset) % names.length],
      ]..shuffle();

      return GuessQuestion(
        imagePath: 'assets/images/guess/jobs/$answer.png',
        options: options,
        correctAnswer: answer,
        thaiMeaning: _jobMeanings[answer]!,
      );
    });
  }

  static List<GuessQuestion> _buildClothingQuestions() {
    final names = _clothingMeanings.keys.toList();
    return List.generate(names.length, (index) {
      final answer = names[index];
      final options = <String>[
        answer,
        for (var offset = 1; offset <= 3; offset++)
          names[(index + offset) % names.length],
      ]..shuffle();

      return GuessQuestion(
        imagePath: 'assets/images/guess/Clothes/$answer.png',
        options: options,
        correctAnswer: answer,
        thaiMeaning: _clothingMeanings[answer]!,
      );
    });
  }

  static List<GuessQuestion> _buildSportQuestions() {
    final names = _sportMeanings.keys.toList();
    return List.generate(names.length, (index) {
      final answer = names[index];
      final options = <String>[
        answer,
        for (var offset = 1; offset <= 3; offset++)
          names[(index + offset) % names.length],
      ]..shuffle();
      final fileName = answer == 'Soccer'
          ? 'Sports'
          : answer == 'Table Tennis'
              ? 'Tabletennis'
              : answer;

      return GuessQuestion(
        imagePath: 'assets/images/guess/Sports/$fileName.png',
        options: options,
        correctAnswer: answer,
        thaiMeaning: _sportMeanings[answer]!,
      );
    });
  }

  static List<GuessQuestion> _buildBodyQuestions() {
    final names = _bodyMeanings.keys.toList();
    return List.generate(names.length, (index) {
      final answer = names[index];
      final options = <String>[
        answer,
        for (var offset = 1; offset <= 3; offset++)
          names[(index + offset) % names.length],
      ]..shuffle();

      return GuessQuestion(
        imagePath: 'assets/images/guess/Body/$answer.png',
        options: options,
        correctAnswer: answer,
        thaiMeaning: _bodyMeanings[answer]!,
      );
    });
  }

  static List<GuessQuestion> _buildColorQuestions() {
    final names = _colorMeanings.keys.toList();
    const fileNames = {
      'Dark Green': 'Darkgreen',
      'Light Green': 'Lightgreen',
    };
    return List.generate(names.length, (index) {
      final answer = names[index];
      final options = <String>[
        answer,
        for (var offset = 1; offset <= 3; offset++)
          names[(index + offset) % names.length],
      ]..shuffle();
      final fileName = fileNames[answer] ?? answer;
      final extension = answer == 'Dark Green' ? 'jpg' : 'png';

      return GuessQuestion(
        imagePath: 'assets/images/guess/Color/$fileName.$extension',
        options: options,
        correctAnswer: answer,
        thaiMeaning: _colorMeanings[answer]!,
      );
    });
  }

  static List<GuessQuestion> _buildPlaceQuestions() {
    final names = _placeMeanings.keys.toList();
    const fileNames = {
      'Bus Stop': 'Busstop',
      'Fire Station': 'Firestation',
      'Gas Station': 'Gasstation',
      'Police Station': 'Policestation',
      'Post Office': 'Postoffice',
      'Train Station': 'Trainstation',
    };
    return List.generate(names.length, (index) {
      final answer = names[index];
      final options = <String>[
        answer,
        for (var offset = 1; offset <= 3; offset++)
          names[(index + offset) % names.length],
      ]..shuffle();
      final fileName = fileNames[answer] ?? answer;

      return GuessQuestion(
        imagePath: 'assets/images/guess/Places/$fileName.png',
        options: options,
        correctAnswer: answer,
        thaiMeaning: _placeMeanings[answer]!,
      );
    });
  }

  static List<GuessQuestion> _buildVehicleQuestions() {
    final names = _vehicleMeanings.keys.toList();
    return List.generate(names.length, (index) {
      final answer = names[index];
      final options = <String>[
        answer,
        for (var offset = 1; offset <= 3; offset++)
          names[(index + offset) % names.length],
      ]..shuffle();

      return GuessQuestion(
        imagePath: 'assets/images/guess/Vehicles/$answer.png',
        options: options,
        correctAnswer: answer,
        thaiMeaning: _vehicleMeanings[answer]!,
      );
    });
  }

  final List<GuessQuestion> questions = [
    GuessQuestion(
      imagePath: 'assets/images/vocabulary/family/Grandparents.jpg',
      options: ['Parents', 'Grandparents', 'Family', 'Teachers'],
      correctAnswer: 'Grandparents',
      thaiMeaning: 'ปู่ย่า / ตายาย',
    ),
    GuessQuestion(
      imagePath: 'assets/images/vocabulary/family/Parents.png',
      options: ['Friends', 'Parents', 'Teachers', 'Doctors'],
      correctAnswer: 'Parents',
      thaiMeaning: 'พ่อแม่ / ผู้ปกครอง',
    ),
    GuessQuestion(
      imagePath: 'assets/images/vocabulary/family/Sibling.png',
      options: ['Sibling', 'Parents', 'Cousin', 'Neighbor'],
      correctAnswer: 'Sibling',
      thaiMeaning: 'พี่น้อง',
    ),
    ..._buildAnimalQuestions(),
    ..._buildFruitQuestions(),
    ..._buildJobQuestions(),
    ..._buildClothingQuestions(),
    ..._buildSportQuestions(),
    ..._buildBodyQuestions(),
    ..._buildColorQuestions(),
    ..._buildPlaceQuestions(),
    ..._buildVehicleQuestions(),
  ];

  final List<GuessCategory> categories = const [
    GuessCategory(title: 'สัตว์', imagePath: 'assets/images/Background/animal.webp', questionFolder: 'assets/images/guess/animal/', subtitle: 'เพื่อนตัวน้อยรอบตัวเรา', icon: Icons.pets_rounded, color: Color(0xFF7B68E8)),
    GuessCategory(title: 'ผลไม้', imagePath: 'assets/images/Background/fruit.png', questionFolder: 'assets/images/guess/fruit/', subtitle: 'ผลไม้สีสันน่ากิน', icon: Icons.local_dining_rounded, color: Color(0xFFC62828)),
    GuessCategory(title: 'อาชีพ', imagePath: 'assets/images/Background/career.png', questionFolder: 'assets/images/guess/jobs/', subtitle: 'มารู้จักอาชีพต่าง ๆ', icon: Icons.work_rounded, color: Color(0xFFE96554)),
    GuessCategory(title: 'เครื่องแต่งกาย', imagePath: 'assets/images/Background/clothes.png', questionFolder: 'assets/images/guess/Clothes/', subtitle: 'มาสนุกกับการแต่งตัว', icon: Icons.checkroom_rounded, color: Color(0xFFE85D9E)),
    GuessCategory(title: 'กีฬา', imagePath: 'assets/images/Background/sport.png', questionFolder: 'assets/images/guess/Sports/', subtitle: 'เกมและกิจกรรมโปรด', icon: Icons.sports_basketball_rounded, color: Color(0xFF009FA8)),
    GuessCategory(title: 'ร่างกาย', imagePath: 'assets/images/Background/body1.png', questionFolder: 'assets/images/guess/Body/', subtitle: 'รู้จักร่างกายของเรา', icon: Icons.face_rounded, color: Color(0xFFE7B339)),
    GuessCategory(title: 'สีสัน', imagePath: 'assets/images/Background/color.png', questionFolder: 'assets/images/guess/Color/', subtitle: 'มาสนุกกับสีต่าง ๆ', icon: Icons.palette_rounded, color: Color(0xFF26A36B)),
    GuessCategory(title: 'สถานที่', imagePath: 'assets/images/Background/location1.png', questionFolder: 'assets/images/guess/Places/', subtitle: 'สถานที่ใกล้ตัว', icon: Icons.location_city_rounded, color: Color(0xFFF28B36)),
    GuessCategory(title: 'ยานพาหนะ', imagePath: 'assets/images/Background/vehicle.png', questionFolder: 'assets/images/guess/Vehicles/', subtitle: 'ยานพาหนะบนท้องถนน', icon: Icons.local_shipping_rounded, color: Color(0xFF3556C8)),
  ];

  List<GuessQuestion> get activeQuestions {
    final category = categories.firstWhere((item) => item.title == selectedCategory);
    return questions
        .where((question) => question.imagePath.startsWith(category.questionFolder))
        .toList();
  }

  void _startCategory(GuessCategory category) {
    setState(() {
      selectedCategory = category.title;
      currentIndex = 0;
      selectedAnswer = null;
      score = 0;
      isAnswerRevealed = false;
      isCurrentCorrect = false;
      isGameCompleted = false;
    });
  }

  void _onSelectOption(String option) {
    if (isAnswerRevealed) return;

    final currentQ = activeQuestions[currentIndex];
    final bool correct = option == currentQ.correctAnswer;

    setState(() {
      selectedAnswer = option;
      isAnswerRevealed = true;
      isCurrentCorrect = correct;
      if (correct) score += 10;
    });

    _speakWord(currentQ.correctAnswer);

    _showAnswerFeedbackSheet(isCorrect: correct, currentQ: currentQ);
  }

  void _showAnswerFeedbackSheet({
    required bool isCorrect,
    required GuessQuestion currentQ,
  }) {
    final Color sheetBg = isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final Color sheetBorder = isCorrect ? const Color(0xFF047857) : const Color(0xFFB91C1C);

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(
              color: sheetBorder,
              width: 3.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 110,
                child: Image.asset(
                  isCorrect
                      ? 'assets/images/character/bravo.png'
                      : 'assets/images/character/sad.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.emoji_events_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isCorrect ? 'ถูกต้อง เก่งมาก!' : 'ยังไม่ถูกต้อง',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(0, 1.5),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (isCorrect)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.stars_rounded,
                        color: Color(0xFFF59E0B),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '+10 คะแนน (สะสม: $score)',
                        style: const TextStyle(
                          color: Color(0xFF047857),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'เฉลย คือ: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        TextSpan(
                          text: '${currentQ.correctAnswer} (${currentQ.thaiMeaning})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFB91C1C),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              // ปุ่มกด "ต่อไป" โดยนำลูกศรออกเรียบร้อย
              GestureDetector(
                onTap: () {
                  Navigator.pop(sheetContext);
                  _goToNextQuestion();
                },
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB45309),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.only(bottom: 4.5),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        currentIndex < activeQuestions.length - 1
                            ? 'ต่อไป'
                            : 'ดูสรุปผลคะแนน',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Color(0xFFB45309),
                              offset: Offset(0, 1.5),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _goToNextQuestion() {
    if (currentIndex < activeQuestions.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswer = null;
        isAnswerRevealed = false;
        isCurrentCorrect = false;
      });
    } else {
      setState(() {
        isGameCompleted = true;
      });
    }
  }

  // ================= หน้าจอเฉลิมฉลองตอนจบเกม (โทนสีเขียวสดใส) =================
  Widget _buildSummaryScreen() {
    const Color victoryBgTop = Color(0xFF10B981);
    const Color victoryBgBottom = Color(0xFF047857);
    final int totalQuestions = activeQuestions.length;
    final int correctCount = (score / 10).round();
    final int percentage = totalQuestions > 0 ? ((correctCount / totalQuestions) * 100).round() : 100;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [victoryBgTop, victoryBgBottom],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 70,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.28),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: -40,
              right: -40,
              height: 360,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.12),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.elliptical(260, 90),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _ConfettiParticlesPainter(),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Center(
                      child: SizedBox(
                        width: 270,
                        height: 270,
                        child: Image.asset(
                          'assets/images/character/bravo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.emoji_events_rounded,
                            size: 150,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildStarIcon(56),
                        const SizedBox(width: 8),
                        _buildStarIcon(76),
                        const SizedBox(width: 8),
                        _buildStarIcon(56),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'เก่งมาก ยอดเยี่ยม',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Color(0xFF064E3B),
                            offset: Offset(0, 4),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        'คุณเล่นเกมหมวด "$selectedCategory" เสร็จแล้ว!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 125,
                            decoration: BoxDecoration(
                              color: const Color(0xFFA78BFA),
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(color: Colors.white, width: 2.2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.18),
                                  offset: const Offset(0, 5),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.monetization_on_rounded,
                                    color: Color(0xFFF59E0B),
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '+$score',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  'เหรียญที่ได้รับ',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            height: 125,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF472B6),
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(color: Colors.white, width: 2.2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.18),
                                  offset: const Offset(0, 5),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check_circle_rounded,
                                    color: Color(0xFF10B981),
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '$percentage%',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  'ความแม่นยำ',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = null;
                          currentIndex = 0;
                          selectedAnswer = null;
                          score = 0;
                          isAnswerRevealed = false;
                          isGameCompleted = false;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white38, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFFB45309),
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.home_rounded, color: Colors.white, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'รับคะแนน & กลับหน้าหลัก',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarIcon(double size) {
    return Icon(
      Icons.star_rounded,
      color: const Color(0xFFFBBF24),
      size: size,
      shadows: const [
        Shadow(
          color: Color(0xFFD97706),
          offset: Offset(0, 3.5),
          blurRadius: 0,
        ),
      ],
    );
  }

  // ================= หน้าจอเลือกหมวดหมู่ =================
  Widget _buildCategorySelectionScreen() {
    final List<GuessCategory> displayCategories = [...categories];
    const topBarColor = Color(0xFF16A34A);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFDCFCE7),
              Color(0xFFF0FDF4),
              Color(0xFFFFFFFF),
            ],
            stops: [0.0, 0.4, 0.9],
          ),
        ),
        child: Column(
          children: [
            Container(
              color: topBarColor,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => Navigator.maybePop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'ทายภาพ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 18, 24, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'ทายภาพแสนสนุก',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF16A34A),
                              letterSpacing: 0.4,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'เลือกหมวดหมู่',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.94,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final GuessCategory category = displayCategories[index];
                          final Color imageBackground = Color.alphaBlend(
                            category.color.withValues(alpha: .82),
                            Colors.white,
                          );
                          final Color imageBackgroundLight = Color.alphaBlend(
                            category.color.withValues(alpha: .68),
                            Colors.white,
                          );

                          return InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () => _startCategory(category),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: category.color.withValues(alpha: .16),
                                    blurRadius: 14,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [imageBackground, imageBackgroundLight],
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Image.asset(
                                        category.imagePath,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const SizedBox.expand(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                    color: Colors.white,
                                    child: Text(
                                      category.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF27324A),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: displayCategories.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= หน้าจอเล่นเกม =================
  @override
  Widget build(BuildContext context) {
    if (selectedCategory == null) return _buildCategorySelectionScreen();
    if (isGameCompleted) return _buildSummaryScreen();

    final GuessQuestion currentQ = activeQuestions[currentIndex];
    final double progress = (currentIndex + 1) / activeQuestions.length;
    const Color headerGreen = Color(0xFF16A34A);

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      body: Column(
        children: [
          // 1. แถบ Header สีเขียวชิดขอบบนพร้อมปุ่มย้อนกลับ
          Container(
            color: headerGreen,
            width: double.infinity,
            child: SafeArea(
              bottom: false,
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          setState(() {
                            selectedCategory = null;
                            currentIndex = 0;
                            selectedAnswer = null;
                            score = 0;
                            isAnswerRevealed = false;
                            isCurrentCorrect = false;
                            isGameCompleted = false;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'ทายภาพ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 38),
                  ],
                ),
              ),
            ),
          ),

          // 2. เนื้อหาคำถามและปุ่มคำตอบ
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
              child: Column(
                children: [
                  // แถบข้อมูล: ป้ายชื่อหมวด 3D, ข้อ X/รวมทั้งหมด, และ Progress Bar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFBBF7D0), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF16A34A).withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF16A34A),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFF15803D),
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                'หมวด$selectedCategory',
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                            const Spacer(),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF14532D),
                                ),
                                children: [
                                  const TextSpan(text: 'ข้อ '),
                                  TextSpan(
                                    text: '${currentIndex + 1}',
                                    style: const TextStyle(
                                      fontSize: 19,
                                      color: Color(0xFF16A34A),
                                    ),
                                  ),
                                  TextSpan(
                                    text: '/${activeQuestions.length}',
                                    style: const TextStyle(
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final double totalWidth = constraints.maxWidth;
                            final double currentPos = totalWidth * progress;

                            return Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Container(
                                  height: 12,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCFCE7),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: 12,
                                  width: currentPos,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4ADE80),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 300),
                                  left: math.max(0, currentPos - 10),
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(
                                        color: const Color(0xFF16A34A),
                                        width: 3.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.15),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // กรอบภาพคำถาม 3D Jelly Frame
                  Expanded(
                    flex: 11,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF064E3B),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: const Color(0xFF064E3B),
                            width: 3.5,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(22.0),
                            child: Image.asset(
                              currentQ.imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.image_rounded,
                                size: 80,
                                color: Color(0xFF10B981),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ข้อความ "ภาพนี้คืออะไรเอ่ย?"
                  Text(
                    isAnswerRevealed
                        ? 'เฉลย: ${currentQ.correctAnswer} (${currentQ.thaiMeaning})'
                        : 'ภาพนี้คืออะไรเอ่ย?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: isAnswerRevealed
                          ? (isCurrentCorrect ? const Color(0xFF15803D) : const Color(0xFFDC2626))
                          : const Color(0xFF064E3B),
                      letterSpacing: 0.3,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ตารางปุ่มตัวเลือก 4 ปุ่ม 4 สี 3D
                  Expanded(
                    flex: 9,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: currentQ.options.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 2.1,
                      ),
                      itemBuilder: (context, index) {
                        final String option = currentQ.options[index];
                        final theme = _optionThemes[index % _optionThemes.length];
                        final String letterBadge = theme['label'] as String;

                        Color btnColor = theme['main'] as Color;
                        Color shadowColor = theme['shadow'] as Color;

                        if (isAnswerRevealed) {
                          if (option == currentQ.correctAnswer) {
                            btnColor = const Color(0xFF10B981);
                            shadowColor = const Color(0xFF047857);
                          } else if (option == selectedAnswer) {
                            btnColor = const Color(0xFFEF4444);
                            shadowColor = const Color(0xFFB91C1C);
                          } else {
                            btnColor = Colors.grey.shade400;
                            shadowColor = Colors.grey.shade600;
                          }
                        }

                        return GestureDetector(
                          onTap: () => _onSelectOption(option),
                          child: Container(
                            decoration: BoxDecoration(
                              color: shadowColor,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            padding: const EdgeInsets.only(bottom: 5.5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: btnColor,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  width: 1.5,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 1.5),
                                          blurRadius: 1,
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      letterBadge,
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w900,
                                        color: btnColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      option,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.5,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.3,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black26,
                                            offset: Offset(0, 1.5),
                                            blurRadius: 1.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Particle Painter สำหรับ Confetti เฉลิมฉลอง
class _ConfettiParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(12345);
    final paint = Paint()..style = PaintingStyle.fill;

    final colors = [
      const Color(0xFFFBBF24),
      const Color(0xFFF472B6),
      const Color(0xFF34D399),
      const Color(0xFF60A5FA),
      const Color(0xFFC084FC),
      const Color(0xFFFB923C),
    ];

    for (int i = 0; i < 65; i++) {
      paint.color = colors[random.nextInt(colors.length)];
      final double x = random.nextDouble() * size.width;
      final double y = random.nextDouble() * size.height * 0.78;
      final double radius = random.nextDouble() * 4 + 3;

      if (random.nextBool()) {
        canvas.drawRect(
          Rect.fromLTWH(x, y, radius * 2.2, radius),
          paint,
        );
      } else {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}