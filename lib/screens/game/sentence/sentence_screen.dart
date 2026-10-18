import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SentenceQuestionItem {
  final String imagePath;
  final String thaiSentence;
  final List<String> correctOrder;
  final List<String> scrambledWords;

  const SentenceQuestionItem({
    required this.imagePath,
    required this.thaiSentence,
    required this.correctOrder,
    required this.scrambledWords,
  });
}

class SentenceStage {
  final int stageNumber;
  final String title;
  final String subtitle;
  final List<SentenceQuestionItem> questions;

  const SentenceStage({
    required this.stageNumber,
    required this.title,
    required this.subtitle,
    required this.questions,
  });
}

class SentenceScreen extends StatefulWidget {
  const SentenceScreen({super.key});

  @override
  State<SentenceScreen> createState() => _SentenceScreenState();
}

class _SentenceScreenState extends State<SentenceScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  int? currentStageIndex;
  int currentQuestionIndex = 0;
  int stageScore = 0;
  bool isStageCompleted = false;

  List<String> availableWords = [];
  List<String> userSentence = [];

  final Map<int, int> stageStars = {};
  int unlockedMaxStage = 0;

  final List<SentenceStage> stages = const [
    SentenceStage(
      stageNumber: 1,
      title: 'ก้าวแรกนักผจญภัย',
      subtitle: 'ประโยคเริ่มต้น แสนง่ายและสนุก',
      questions: [
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/swimming.gif',
          thaiSentence: 'ฉันชอบว่ายน้ำ',
          correctOrder: ['I', 'like', 'swimming'],
          scrambledWords: ['swimming', 'I', 'like'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Parents.gif',
          thaiSentence: 'ฉันรักพ่อแม่ของฉัน',
          correctOrder: ['I', 'love', 'my', 'parents'],
          scrambledWords: ['my', 'parents', 'I', 'love'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/sea.gif',
          thaiSentence: 'พวกเราไปทะเล',
          correctOrder: ['We', 'go', 'to', 'sea'],
          scrambledWords: ['sea', 'We', 'to', 'go'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Apple.gif',
          thaiSentence: 'ฉันกินแอปเปิลสีแดง',
          correctOrder: ['I', 'eat', 'red', 'apples'],
          scrambledWords: ['apples', 'eat', 'red', 'I'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/birdSmall.gif',
          thaiSentence: 'นกตัวเล็กบินได้',
          correctOrder: ['Small', 'birds', 'can', 'fly'],
          scrambledWords: ['fly', 'Small', 'can', 'birds'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Fish.gif',
          thaiSentence: 'ปลาว่ายน้ำได้เร็ว',
          correctOrder: ['Fish', 'can', 'swim', 'fast'],
          scrambledWords: ['fast', 'swim', 'Fish', 'can'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Banana.gif',
          thaiSentence: 'ลิงชอบกล้วยหวาน',
          correctOrder: ['Monkeys', 'like', 'sweet', 'bananas'],
          scrambledWords: ['sweet', 'bananas', 'like', 'Monkeys'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Hat.gif',
          thaiSentence: 'ฉันใส่หมวกสีเหลือง',
          correctOrder: ['I', 'wear', 'a', 'yellow', 'hat'],
          scrambledWords: ['hat', 'I', 'a', 'yellow', 'wear'],
        ),
      ],
    ),
    SentenceStage(
      stageNumber: 2,
      title: 'ชีวิตประจำวันและอาหาร',
      subtitle: 'ประโยคกิจวัตรและของกินรอบตัว',
      questions: [
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Brushmyteeth.gif',
          thaiSentence: 'ฉันแปรงฟันทุกเช้า',
          correctOrder: ['I', 'brush', 'my', 'teeth', 'daily'],
          scrambledWords: ['daily', 'teeth', 'I', 'my', 'brush'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Milk.gif',
          thaiSentence: 'ฉันดื่มนมสดทุกวัน',
          correctOrder: ['I', 'drink', 'fresh', 'milk', 'daily'],
          scrambledWords: ['milk', 'fresh', 'daily', 'I', 'drink'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Washmyface.gif',
          thaiSentence: 'ฉันล้างหน้าของฉันวันนี้',
          correctOrder: ['I', 'wash', 'my', 'face', 'today'],
          scrambledWords: ['face', 'today', 'I', 'my', 'wash'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Bread.gif',
          thaiSentence: 'พวกเรากินขนมปังเป็นอาหารเช้า',
          correctOrder: ['We', 'eat', 'bread', 'for', 'breakfast'],
          scrambledWords: ['breakfast', 'eat', 'bread', 'for', 'We'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Pizza.gif',
          thaiSentence: 'พิซซ่านี้อร่อยมาก',
          correctOrder: ['This', 'pizza', 'is', 'very', 'delicious'],
          scrambledWords: ['delicious', 'pizza', 'is', 'This', 'very'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Dohomework.gif',
          thaiSentence: 'ฉันทำการบ้านของฉันตอนนี้',
          correctOrder: ['I', 'do', 'my', 'homework', 'now'],
          scrambledWords: ['now', 'my', 'homework', 'do', 'I'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Shoes.gif',
          thaiSentence: 'ฉันสวมรองเท้าคู่ใหม่',
          correctOrder: ['I', 'put', 'on', 'new', 'shoes'],
          scrambledWords: ['shoes', 'on', 'put', 'new', 'I'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Icecream.gif',
          thaiSentence: 'เด็กๆ ชอบไอศกรีมรสหวาน',
          correctOrder: ['Children', 'love', 'sweet', 'ice', 'cream'],
          scrambledWords: ['cream', 'love', 'sweet', 'ice', 'Children'],
        ),
      ],
    ),
    SentenceStage(
      stageNumber: 3,
      title: 'เพื่อนสัตว์และธรรมชาติ',
      subtitle: 'พฤติกรรมสัตว์และธรรมชาติแสนสวย',
      questions: [
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Cat.gif',
          thaiSentence: 'แมวกำลังนอนหลับตอนนี้',
          correctOrder: ['The', 'cat', 'is', 'sleeping', 'now'],
          scrambledWords: ['sleeping', 'cat', 'The', 'is', 'now'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Dog.gif',
          thaiSentence: 'สุนัขชอบวิ่งเร็วมาก',
          correctOrder: ['Dogs', 'like', 'to', 'run', 'fast'],
          scrambledWords: ['run', 'like', 'Dogs', 'to', 'fast'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/birdblue.gif',
          thaiSentence: 'นกสีฟ้ากำลังบินอยู่',
          correctOrder: ['The', 'blue', 'bird', 'is', 'flying'],
          scrambledWords: ['flying', 'is', 'blue', 'The', 'bird'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Rabbit.gif',
          thaiSentence: 'กระต่ายสีขาวกระโดดได้เร็ว',
          correctOrder: ['The', 'white', 'rabbit', 'hops', 'fast'],
          scrambledWords: ['fast', 'white', 'hops', 'rabbit', 'The'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Frog.gif',
          thaiSentence: 'กบสีเขียวกระโดดลงน้ำ',
          correctOrder: ['A', 'green', 'frog', 'can', 'jump'],
          scrambledWords: ['frog', 'can', 'jump', 'green', 'A'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Lion.gif',
          thaiSentence: 'สิงโตแข็งแรงมาก',
          correctOrder: ['The', 'lion', 'is', 'very', 'strong'],
          scrambledWords: ['strong', 'is', 'The', 'very', 'lion'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Horse.gif',
          thaiSentence: 'ม้าวิ่งได้เร็วมาก',
          correctOrder: ['Horses', 'can', 'run', 'very', 'fast'],
          scrambledWords: ['run', 'Horses', 'very', 'fast', 'can'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Duck.gif',
          thaiSentence: 'เป็ดว่ายน้ำในสระน้ำ',
          correctOrder: ['Ducks', 'swim', 'in', 'the', 'pond'],
          scrambledWords: ['pond', 'swim', 'Ducks', 'the', 'in'],
        ),
      ],
    ),
    SentenceStage(
      stageNumber: 4,
      title: 'อาชีพและกิจกรรมโปรด',
      subtitle: 'ผู้คนรอบตัว ยานพาหนะ และการเดินทาง',
      questions: [
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/teacher.gif',
          thaiSentence: 'พ่อของฉันเป็นคุณครู',
          correctOrder: ['My', 'father', 'is', 'a', 'teacher'],
          scrambledWords: ['teacher', 'My', 'is', 'father', 'a'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Programmer.gif',
          thaiSentence: 'เขาทำงานเป็นโปรแกรมเมอร์',
          correctOrder: ['He', 'works', 'as', 'a', 'programmer'],
          scrambledWords: ['a', 'works', 'He', 'programmer', 'as'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Truck.gif',
          thaiSentence: 'รถบรรทุกคันใหญ่สีแดง',
          correctOrder: ['The', 'big', 'truck', 'is', 'red'],
          scrambledWords: ['red', 'is', 'truck', 'The', 'big'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/basketball.gif',
          thaiSentence: 'ฉันชอบเล่นบาสเกตบอล',
          correctOrder: ['I', 'like', 'to', 'play', 'basketball'],
          scrambledWords: ['basketball', 'like', 'I', 'play', 'to'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Doctor.gif',
          thaiSentence: 'คุณหมอใจดีช่วยรักษาผู้ป่วย',
          correctOrder: ['The', 'kind', 'doctor', 'helps', 'patients'],
          scrambledWords: ['patients', 'doctor', 'helps', 'The', 'kind'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Airplane.gif',
          thaiSentence: 'เครื่องบินบินอยู่บนท้องฟ้า',
          correctOrder: ['The', 'airplane', 'flies', 'in', 'the', 'sky'],
          scrambledWords: ['the', 'sky', 'airplane', 'flies', 'in', 'The'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Pilot.gif',
          thaiSentence: 'นักบินขับเครื่องบินลำใหญ่ได้อย่างปลอดภัย',
          correctOrder: ['Pilots', 'can', 'fly', 'big', 'planes', 'safely'],
          scrambledWords: ['safely', 'fly', 'planes', 'big', 'can', 'Pilots'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Train.gif',
          thaiSentence: 'รถไฟแล่นเร็วมากวันนี้',
          correctOrder: ['The', 'train', 'moves', 'very', 'fast', 'today'],
          scrambledWords: ['today', 'fast', 'train', 'moves', 'very', 'The'],
        ),
      ],
    ),
    SentenceStage(
      stageNumber: 5,
      title: 'ยอดนักสืบแต่งประโยค',
      subtitle: 'ประโยคยาวท้าทายฝีมือระดับแชมป์',
      questions: [
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Owl.gif',
          thaiSentence: 'นกฮูกตื่นนอนในเวลากลางคืน',
          correctOrder: ['The', 'owl', 'wakes', 'up', 'at', 'night'],
          scrambledWords: ['night', 'The', 'up', 'owl', 'at', 'wakes'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Kangaroo.gif',
          thaiSentence: 'จิงโจ้สามารถกระโดดได้สูงมาก',
          correctOrder: ['A', 'kangaroo', 'can', 'jump', 'very', 'high'],
          scrambledWords: ['jump', 'high', 'A', 'very', 'kangaroo', 'can'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Readabook.gif',
          thaiSentence: 'เด็กๆ ชอบอ่านหนังสือในห้องสมุด',
          correctOrder: ['Children', 'like', 'reading', 'books', 'in', 'library'],
          scrambledWords: ['library', 'Children', 'in', 'books', 'like', 'reading'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Schoolbus.gif',
          thaiSentence: 'รถโรงเรียนสีเหลืองมาถึงแต่เช้า',
          correctOrder: ['The', 'yellow', 'school', 'bus', 'arrives', 'early'],
          scrambledWords: ['bus', 'early', 'The', 'arrives', 'school', 'yellow'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Firefighter.gif',
          thaiSentence: 'นักดับเพลิงขับรถคันใหญ่สีแดง',
          correctOrder: ['Firefighters', 'drive', 'a', 'big', 'red', 'truck'],
          scrambledWords: ['red', 'truck', 'drive', 'Firefighters', 'big', 'a'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Elephant.gif',
          thaiSentence: 'ช้างตัวใหญ่มีงวงยาว',
          correctOrder: ['The', 'big', 'elephant', 'has', 'a', 'long', 'trunk'],
          scrambledWords: ['trunk', 'elephant', 'long', 'has', 'The', 'big', 'a'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Chef.gif',
          thaiSentence: 'พ่อครัวทำอาหารอร่อยในห้องครัว',
          correctOrder: ['The', 'chef', 'cooks', 'yummy', 'food', 'in', 'kitchen'],
          scrambledWords: ['kitchen', 'The', 'food', 'in', 'chef', 'yummy', 'cooks'],
        ),
        SentenceQuestionItem(
          imagePath: 'assets/images/sentence/Giraffe.gif',
          thaiSentence: 'ยีราฟตัวสูงกินใบไม้สีเขียวทุกวัน',
          correctOrder: ['The', 'tall', 'giraffe', 'eats', 'green', 'leaves', 'daily'],
          scrambledWords: ['daily', 'green', 'leaves', 'eats', 'The', 'giraffe', 'tall'],
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setSpeechRate(0.42);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.awaitSpeakCompletion(true);
      await _flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        ],
      );
    } catch (e) {
      debugPrint("TTS Init Error: $e");
    }
  }

  Future<void> _speakText(String text, {required String language}) async {
    if (text.trim().isEmpty) return;
    try {
      await _flutterTts.stop();
      await _flutterTts.setLanguage(language);
      await Future.delayed(const Duration(milliseconds: 60));
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint("TTS Speak Error: $e");
    }
  }

  void _onStageTapped(int stageIdx) {
    if (stageIdx > unlockedMaxStage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('ด่านนี้ยังไม่ปลดล็อกนะจ๊ะ เล่นด่านก่อนหน้าให้ผ่านก่อนน้า! 🔒'),
          backgroundColor: const Color(0xFF7C3AED),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      );
      return;
    }

    final bool isCompletedBefore = stageStars.containsKey(stageIdx) && (stageStars[stageIdx] ?? 0) > 0;

    if (isCompletedBefore) {
      _showReplayDialog(stageIdx);
    } else {
      _enterStage(stageIdx);
    }
  }

  void _showReplayDialog(int stageIdx) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFF7C3AED), width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEF3C7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.stars_rounded,
                    color: Color(0xFFF59E0B),
                    size: 48,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'ด่าน ${stages[stageIdx].stageNumber}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF3B0764),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'คุณเคยเล่นผ่านด่านนี้ไปแล้ว\nต้องการทำอะไรดีจ๊ะ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    _enterStage(stageIdx);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD97706),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.replay_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'เล่นด่านนี้อีกครั้ง',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      stageStars.clear();
                      unlockedMaxStage = 0;
                    });
                    _enterStage(0);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C1D95),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'เริ่มใหม่ทั้งหมดตั้งแต่ด่าน 1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'ยกเลิก',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _enterStage(int stageIdx) {
    setState(() {
      currentStageIndex = stageIdx;
      currentQuestionIndex = 0;
      stageScore = 0;
      isStageCompleted = false;
      _loadCurrentQuestion();
    });
  }

  void _loadCurrentQuestion() {
    final currentStage = stages[currentStageIndex!];
    final currentQ = currentStage.questions[currentQuestionIndex];
    availableWords = List.from(currentQ.scrambledWords);
    userSentence.clear();
  }

  void _selectWord(int index) {
    setState(() {
      final word = availableWords.removeAt(index);
      userSentence.add(word);
    });
  }

  void _removeWord(int index) {
    setState(() {
      final word = userSentence.removeAt(index);
      availableWords.add(word);
    });
  }

  void _checkAnswer() {
    if (userSentence.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('แตะคำศัพท์ด้านล่างเพื่อเรียงประโยคก่อนนะจ๊ะ! 😊'),
          backgroundColor: const Color(0xFFF59E0B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      );
      return;
    }

    final currentStage = stages[currentStageIndex!];
    final currentQ = currentStage.questions[currentQuestionIndex];
    bool isCorrect = false;

    if (userSentence.length == currentQ.correctOrder.length) {
      isCorrect = true;
      for (int i = 0; i < userSentence.length; i++) {
        if (userSentence[i] != currentQ.correctOrder[i]) {
          isCorrect = false;
          break;
        }
      }
    }

    if (isCorrect) {
      setState(() => stageScore += 10);
      final fullSentence = currentQ.correctOrder.join(' ');
      _speakText(fullSentence, language: "en-US");
    }

    final fullSentence = currentQ.correctOrder.join(' ');
    _showAnswerFeedbackSheet(isCorrect: isCorrect, fullSentence: fullSentence);
  }

  void _showAnswerFeedbackSheet({
    required bool isCorrect,
    required String fullSentence,
  }) {
    final Color sheetBg = isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final Color sheetBorder = isCorrect ? const Color(0xFF047857) : const Color(0xFFB91C1C);
    final currentStage = stages[currentStageIndex!];

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
            border: Border.all(color: sheetBorder, width: 3.5),
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
                height: 105,
                child: Image.asset(
                  isCorrect ? 'assets/images/character/bravo.png' : 'assets/images/character/sad.png',
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
                    Shadow(color: Colors.black26, offset: Offset(0, 1.5), blurRadius: 2),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (isCorrect)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 3),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.stars_rounded, color: Color(0xFFF59E0B), size: 24),
                      const SizedBox(width: 8),
                      Text(
                        '+10 คะแนน (สะสม: $stageScore)',
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 3),
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
                          text: fullSentence,
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
              GestureDetector(
                onTap: () {
                  Navigator.pop(sheetContext);
                  if (currentQuestionIndex < currentStage.questions.length - 1) {
                    setState(() {
                      currentQuestionIndex++;
                      _loadCurrentQuestion();
                    });
                  } else {
                    setState(() {
                      stageStars[currentStageIndex!] = 3;
                      if (currentStageIndex! + 1 < stages.length) {
                        unlockedMaxStage = math.max(unlockedMaxStage, currentStageIndex! + 1);
                      }
                      isStageCompleted = true;
                    });
                  }
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
                    alignment: Alignment.center,
                    child: Text(
                      currentQuestionIndex < currentStage.questions.length - 1 ? 'ต่อไป' : 'ดูสรุปผลคะแนน',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(color: Color(0xFFB45309), offset: Offset(0, 1.5), blurRadius: 1),
                        ],
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

  Widget _buildSummaryScreen() {
    const Color victoryBgTop = Color(0xFF10B981);
    const Color victoryBgBottom = Color(0xFF047857);
    final currentStage = stages[currentStageIndex!];
    final int totalQuestions = currentStage.questions.length;
    final int correctCount = (stageScore / 10).round();
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
                  borderRadius: const BorderRadius.vertical(top: Radius.elliptical(260, 90)),
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
                          Shadow(color: Color(0xFF064E3B), offset: Offset(0, 4), blurRadius: 0),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
                      ),
                      child: Text(
                        'คุณผ่านด่านที่ ${currentStage.stageNumber} ครบทั้ง $totalQuestions ข้อแล้ว!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF047857),
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
                                  child: const Icon(Icons.monetization_on_rounded, color: Color(0xFFF59E0B), size: 30),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '+$stageScore',
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
                                ),
                                const Text(
                                  'เหรียญที่ได้รับ',
                                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.white70),
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
                                  child: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 30),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '$percentage%',
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
                                ),
                                const Text(
                                  'ความแม่นยำ',
                                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.white70),
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
                          if (currentStageIndex! + 1 < stages.length) {
                            currentStageIndex = currentStageIndex! + 1;
                            currentQuestionIndex = 0;
                            stageScore = 0;
                            isStageCompleted = false;
                            _loadCurrentQuestion();
                          } else {
                            currentStageIndex = null;
                            isStageCompleted = false;
                          }
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
                            BoxShadow(color: Color(0xFFB45309), offset: Offset(0, 5)),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.home_rounded, color: Colors.white, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              currentStageIndex! + 1 < stages.length ? 'ลุยด่านต่อไป' : 'กลับแผนที่ด่าน',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
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
        Shadow(color: Color(0xFFD97706), offset: Offset(0, 3.5), blurRadius: 0),
      ],
    );
  }

  Widget _buildStageMapScreen() {
    const topBarColor = Color(0xFF7C3AED);

    const List<Offset> nodeRatios = [
      Offset(0.50, 850.0),
      Offset(0.25, 660.0),
      Offset(0.74, 470.0),
      Offset(0.32, 280.0),
      Offset(0.50, 90.0),
    ];

    return Scaffold(
      body: Column(
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
                        child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'เรียงประโยค',
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
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF3B0764),
                    Color(0xFF581C87),
                    Color(0xFF6B21A8),
                    Color(0xFF7E22CE),
                    Color(0xFF4A044E),
                  ],
                  stops: [0.0, 0.25, 0.55, 0.80, 1.0],
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double screenWidth = constraints.maxWidth;
                  final List<Offset> points = nodeRatios
                      .map((p) => Offset(p.dx * screenWidth, p.dy))
                      .toList();

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    child: SizedBox(
                      width: screenWidth,
                      height: 980,
                      child: Stack(
                        children: [
                          _buildCloudPatch(left: -50, top: 120, width: 220, height: 110),
                          _buildCloudPatch(right: -40, top: 340, width: 240, height: 120),
                          _buildCloudPatch(left: -30, top: 520, width: 210, height: 105),
                          _buildCloudPatch(right: -50, top: 730, width: 230, height: 115),

                          Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: _ContourMapPainter(),
                              ),
                            ),
                          ),

                          _buildStarDot(x: screenWidth * 0.15, y: 70),
                          _buildStarDot(x: screenWidth * 0.82, y: 140),
                          _buildStarDot(x: screenWidth * 0.45, y: 210),
                          _buildStarDot(x: screenWidth * 0.88, y: 390),
                          _buildStarDot(x: screenWidth * 0.12, y: 440),
                          _buildStarDot(x: screenWidth * 0.52, y: 610),
                          _buildStarDot(x: screenWidth * 0.85, y: 780),
                          _buildStarDot(x: screenWidth * 0.18, y: 830),

                          Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: _CurvedDashedPathPainter(points: points),
                              ),
                            ),
                          ),

                          for (int i = 0; i < stages.length; i++)
                            Positioned(
                              left: points[i].dx - 62,
                              top: points[i].dy - 55,
                              child: _buildOrganicStageNode(
                                stage: stages[i],
                                index: i,
                                isUnlocked: i <= unlockedMaxStage,
                                isCompleted: (stageStars[i] ?? 0) > 0,
                                isStart: i == 0,
                                isFinalStage: i == stages.length - 1,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloudPatch({double? left, double? right, required double top, required double width, required double height}) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      child: IgnorePointer(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.all(Radius.elliptical(width, height)),
          ),
        ),
      ),
    );
  }

  Widget _buildStarDot({required double x, required double y}) {
    return Positioned(
      left: x,
      top: y,
      child: IgnorePointer(
        child: Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.65),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFDE047).withValues(alpha: 0.6),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrganicStageNode({
    required SentenceStage stage,
    required int index,
    required bool isUnlocked,
    required bool isCompleted,
    required bool isStart,
    required bool isFinalStage,
  }) {
    final bool showYellow = isCompleted || (isStart && !isCompleted);

    final Color mainColor = showYellow
        ? const Color(0xFFF59E0B)
        : (isFinalStage
            ? const Color(0xFF9333EA)
            : (isUnlocked ? const Color(0xFF8B5CF6) : const Color(0xFF581C87)));

    final Color bottomShadow = showYellow
        ? const Color(0xFFB45309)
        : (isFinalStage
            ? const Color(0xFF581C87)
            : (isUnlocked ? const Color(0xFF5B21B6) : const Color(0xFF3B0764)));

    return GestureDetector(
      onTap: () => _onStageTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 124,
            height: 96,
            decoration: BoxDecoration(
              color: bottomShadow,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(55),
                topRight: Radius.circular(42),
                bottomLeft: Radius.circular(45),
                bottomRight: Radius.circular(58),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.32),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.only(bottom: 5.5),
            child: Container(
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(52),
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.circular(42),
                  bottomRight: Radius.circular(55),
                ),
                border: Border.all(
                  color: showYellow
                      ? const Color(0xFFFDE047)
                      : (isFinalStage ? const Color(0xFFFDE047) : Colors.white.withValues(alpha: 0.35)),
                  width: showYellow || isFinalStage ? 2.8 : 2.2,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isCompleted
                          ? Icons.check_circle_rounded
                          : (isStart
                              ? Icons.flag_rounded
                              : (isFinalStage
                                  ? Icons.emoji_events_rounded
                                  : (isUnlocked ? Icons.lock_open_rounded : Icons.lock_rounded))),
                      color: showYellow ? Colors.white : (isFinalStage ? const Color(0xFFFDE047) : Colors.white),
                      size: 32,
                      shadows: const [
                        Shadow(color: Colors.black26, offset: Offset(0, 1.5), blurRadius: 2),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isStart && !isCompleted ? 'Start' : 'ด่าน ${stage.stageNumber}',
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.4,
                        shadows: [
                          Shadow(color: Colors.black26, offset: Offset(0, 1), blurRadius: 2),
                        ],
                      ),
                    ),
                    if (isCompleted) ...[
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          3,
                          (_) => const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentStageIndex == null) return _buildStageMapScreen();
    if (isStageCompleted) return _buildSummaryScreen();

    final currentStage = stages[currentStageIndex!];
    final currentQ = currentStage.questions[currentQuestionIndex];
    final double progress = (currentQuestionIndex + 1) / currentStage.questions.length;
    const Color headerColor = Color(0xFF7C3AED);

    final int totalWordsCount = currentQ.correctOrder.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF3E8FF),
      body: Column(
        children: [
          Container(
            color: headerColor,
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
                        onTap: () => setState(() => currentStageIndex = null),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'เรียงประโยค',
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

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFF4C1D95), width: 2.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF4C1D95),
                          offset: Offset(0, 3.5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7C3AED),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(color: Color(0xFF4C1D95), offset: Offset(0, 2)),
                                ],
                              ),
                              child: Text(
                                'ด่าน ${currentStage.stageNumber}',
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Spacer(),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF4C1D95),
                                ),
                                children: [
                                  const TextSpan(text: 'ข้อ '),
                                  TextSpan(
                                    text: '${currentQuestionIndex + 1}',
                                    style: const TextStyle(fontSize: 18, color: Color(0xFF7C3AED)),
                                  ),
                                  TextSpan(
                                    text: '/${currentStage.questions.length}',
                                    style: const TextStyle(color: Color(0xFF94A3B8)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final double totalWidth = constraints.maxWidth;
                            final double currentPos = totalWidth * progress;

                            return Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Container(
                                  height: 10,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDE9FE),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: 10,
                                  width: currentPos,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8B5CF6),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 300),
                                  left: math.max(0, currentPos - 9),
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(color: const Color(0xFF7C3AED), width: 3),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.15),
                                          blurRadius: 3,
                                          offset: const Offset(0, 1.5),
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

                  Container(
                    width: double.infinity,
                    height: 280,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C1D95),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4C1D95).withValues(alpha: 0.25),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFF3E8FF),
                            Color(0xFFE9D5FF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: const Color(0xFF4C1D95), width: 2.4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: -25,
                              right: -25,
                              child: Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDDD6FE).withValues(alpha: 0.65),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -25,
                              left: -25,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDDD6FE).withValues(alpha: 0.65),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            const Positioned(
                              top: 18,
                              left: 20,
                              child: Text('✦', style: TextStyle(color: Color(0xFFF59E0B), fontSize: 24, fontWeight: FontWeight.bold)),
                            ),
                            const Positioned(
                              top: 36,
                              left: 48,
                              child: Text('★', style: TextStyle(color: Colors.white, fontSize: 13)),
                            ),
                            const Positioned(
                              bottom: 22,
                              right: 22,
                              child: Text('✦', style: TextStyle(color: Color(0xFF7C3AED), fontSize: 26, fontWeight: FontWeight.bold)),
                            ),
                            const Positioned(
                              bottom: 42,
                              right: 48,
                              child: Text('★', style: TextStyle(color: Color(0xFFFBBF24), fontSize: 13)),
                            ),
                            const Positioned(
                              bottom: 26,
                              left: 22,
                              child: Text('✦', style: TextStyle(color: Color(0xFF8B5CF6), fontSize: 16)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(
                                currentQ.imagePath,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(Icons.movie_outlined, size: 70, color: Color(0xFFD8B4FE)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 3. ป้ายแคปซูลภาษาไทย (ปรับเพิ่ม Flexible เพื่อป้องกัน Text Overflow)
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 32,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C1D95),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              currentQ.thaiSentence,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _speakText(currentQ.thaiSentence, language: "th-TH"),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.volume_up_rounded, color: Color(0xFF7C3AED), size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 68),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFF4C1D95), width: 2.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF4C1D95),
                          offset: Offset(0, 3.5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(totalWordsCount, (index) {
                            final bool hasWord = index < userSentence.length;

                            if (hasWord) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: GestureDetector(
                                  onTap: () => _removeWord(index),
                                  child: _buildWordBlock(
                                    text: userSentence[index],
                                    bgColor: const Color(0xFF38BDF8),
                                    shadowColor: const Color(0xFF0284C7),
                                    textColor: Colors.white,
                                    isCompact: true,
                                  ),
                                ),
                              );
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: CustomPaint(
                                painter: _DashedRRectPainter(
                                  color: const Color(0xFFA78BFA),
                                  strokeWidth: 1.6,
                                  radius: 14,
                                ),
                                child: Container(
                                  width: 46,
                                  height: 42,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF7C3AED),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  Wrap(
                    spacing: 9,
                    runSpacing: 9,
                    alignment: WrapAlignment.center,
                    children: List.generate(availableWords.length, (index) {
                      return GestureDetector(
                        onTap: () => _selectWord(index),
                        child: _buildWordBlock(
                          text: availableWords[index],
                          bgColor: const Color(0xFFFBBF24),
                          shadowColor: const Color(0xFFD97706),
                          textColor: const Color(0xFF78350F),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: _checkAnswer,
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4C1D95),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.only(bottom: 4.5),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'ตรวจคำตอบ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(color: Color(0xFF4C1D95), offset: Offset(0, 1.5), blurRadius: 1),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildWordBlock({
    required String text,
    required Color bgColor,
    required Color shadowColor,
    required Color textColor,
    bool isCompact = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: shadowColor,
        borderRadius: BorderRadius.circular(isCompact ? 13 : 16),
      ),
      padding: EdgeInsets.only(bottom: isCompact ? 3 : 4),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 12 : 16,
          vertical: isCompact ? 6 : 8.5,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(isCompact ? 11 : 14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.2),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: isCompact ? 15 : 17,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;

  _DashedRRectPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.radius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0.0;
      const double dashLength = 4.5;
      const double dashGap = 3.5;

      while (distance < metric.length) {
        final extractPath = metric.extractPath(distance, distance + dashLength);
        canvas.drawPath(extractPath, paint);
        distance += dashLength + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CurvedDashedPathPainter extends CustomPainter {
  final List<Offset> points;
  _CurvedDashedPathPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.8
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPoint1 = Offset(p0.dx, (p0.dy + p1.dy) / 2);
      final controlPoint2 = Offset(p1.dx, (p0.dy + p1.dy) / 2);
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p1.dx, p1.dy);
    }

    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0.0;
      const double dashLength = 10.0;
      const double gapLength = 9.0;
      while (distance < metric.length) {
        final extractPath = metric.extractPath(distance, distance + dashLength);
        canvas.drawPath(extractPath, paint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ContourMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (double r = 80; r < size.height; r += 140) {
      final path = Path()
        ..moveTo(0, r)
        ..quadraticBezierTo(size.width * 0.45, r + 45, size.width, r - 30);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}