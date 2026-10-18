import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
// อวาตาร์ของผู้ใช้จากหน้าโปรไฟล์ (ปรับ path ให้ตรงกับตำแหน่ง profile_screen.dart ในโปรเจกต์)
import '../../profile_screen.dart'
    show AvatarProfile, AvatarPainter, kSkinTones, kHairColors, kMaleOutfits, kFemaleOutfits;

final Random _rng = Random();
T _pick<T>(List<T> l) => l[_rng.nextInt(l.length)];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  } catch (_) {}
  // โหลดความคืบหน้าที่บันทึกไว้ก่อนเปิดแอป (ด่านที่ปลดล็อก / ดาว / เหรียญ / สมุดสะสม)
  await GameProgress.load();
  runApp(const BridgeBuilderApp());
}

class BridgeBuilderApp extends StatelessWidget {
  const BridgeBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bridge Builder Grammar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Mitr',
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF4DA3FF),
      ),
      // หน้าแรกของแอปคือ "หน้าเลือกด่าน" เสมอ (ไม่เข้าเกมเองอัตโนมัติ)
      initialRoute: '/',
      routes: {
        '/': (_) => const LevelSelectScreen(),
      },
    );
  }
}

// ==========================================
// พาเลตสีสดใส + ปุ่มลูกกวาด (ใช้ทั้งแอป)
// ==========================================
class _C {
  static const ink = Color(0xFF3A2E7A);
  static const inkSoft = Color(0xFF7A6FC0);

  static const pink = Color(0xFFFF5FA2);
  static const pinkDk = Color(0xFFD62A7A);
  static const orange = Color(0xFFFFA62B);
  static const orangeDk = Color(0xFFE5700A);
  static const yellow = Color(0xFFFFE23D);
  static const yellowDk = Color(0xFFF0A800);
  static const green = Color(0xFF4CEB8B);
  static const greenDk = Color(0xFF15A85F);
  static const blue = Color(0xFF3DB4FF);
  static const blueDk = Color(0xFF1E6FE0);
  static const purple = Color(0xFFA37BFF);
  static const purpleDk = Color(0xFF6A3FE0);
  // ignore: unused_field
  static const teal = Color(0xFF3DDDE0);
  static const tealDk = Color(0xFF0FA3B1);
  static const grey = Color(0xFFC9CEDF);
  static const greyDk = Color(0xFF9097B5);
}

BoxDecoration _candy(Color a, Color b, Color edge, {double r = 18, double lift = 4}) => BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [a, b]),
      borderRadius: BorderRadius.circular(r),
      border: Border.all(color: Colors.white, width: 3),
      boxShadow: [
        BoxShadow(color: edge, offset: Offset(0, lift + 1)),
        const BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 6)),
      ],
    );

/// ของตกแต่งลอยขึ้นช้าๆ เป็นพื้นหลัง (เมฆ ดาว ลูกโป่ง ฯลฯ) ให้หน้าจอดูมีชีวิตชีวา
class _FloatingBackdrop extends StatefulWidget {
  const _FloatingBackdrop();

  @override
  State<_FloatingBackdrop> createState() => _FloatingBackdropState();
}

class _FloatingBackdropState extends State<_FloatingBackdrop> with SingleTickerProviderStateMixin {
  static const _items = ['☁️', '⭐', '🎈', '🌈', '✨', '🍭', '🦋', '🌸', '☁️', '⭐', '🎈', '✨'];
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 18))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, box) {
          return AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              final kids = <Widget>[];
              for (int i = 0; i < _items.length; i++) {
                final seed = i / _items.length;
                final t = (_c.value + seed) % 1.0;
                final x = ((seed * 7.0) % 1.0) * (box.maxWidth - 30);
                final y = box.maxHeight * (1.05 - t * 1.2);
                kids.add(Positioned(
                  left: x + sin(t * pi * 4 + i) * 14,
                  top: y,
                  child: Opacity(
                    opacity: 0.4,
                    child: Text(_items[i], style: TextStyle(fontSize: 22.0 + (i % 3) * 8)),
                  ),
                ));
              }
              return Stack(clipBehavior: Clip.hardEdge, children: kids);
            },
          );
        },
      ),
    );
  }
}

/// เด้งขึ้นลงเบาๆ ตลอดเวลา (ใช้กับมาสคอต/ไอคอน)
class _Bounce extends StatefulWidget {
  final Widget child;
  final double height;
  const _Bounce({required this.child, this.height = 6});

  @override
  State<_Bounce> createState() => _BounceState();
}

class _BounceState extends State<_Bounce> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
    ..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -widget.height * Curves.easeInOut.transform(_c.value)),
        child: child,
      ),
      child: widget.child,
    );
  }
}

class _Candy extends StatefulWidget {
  final Widget child;
  final Color a;
  final Color b;
  final Color edge;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final double radius;
  final bool full;
  const _Candy({
    required this.child,
    required this.a,
    required this.b,
    required this.edge,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.radius = 18,
    this.full = false,
  });

  @override
  State<_Candy> createState() => _CandyState();
}

class _CandyState extends State<_Candy> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _down = true),
      onTapUp: (_) => setState(() => _down = false),
      onTapCancel: () => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          width: widget.full ? double.infinity : null,
          alignment: widget.full ? Alignment.center : null,
          decoration: _candy(widget.a, widget.b, widget.edge, r: widget.radius),
          child: Stack(
            children: [
              Padding(padding: widget.padding, child: widget.child),
              // แถบเงาสะท้อนด้านบน ทำให้ปุ่มดูมันวาวเหมือนลูกกวาด
              Positioned(
                top: 3,
                left: widget.radius * 0.7,
                right: widget.radius * 0.7,
                height: 5,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(95),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _whitePill(String text, Color color, {double size = 14}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withAlpha(90), width: 2),
      boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 6, offset: Offset(0, 3))],
    ),
    child: Text(text, style: TextStyle(fontSize: size, fontWeight: FontWeight.w900, color: color)),
  );
}

// ==========================================
// 1. โมเดลข้อมูลโจทย์ภาษาอังกฤษ (Grammar Question Model)
// ==========================================
class Question {
  final String sentence;
  final List<String> options;
  final String correctAnswer;
  final String keyWord;
  final String grammarRule;
  final String emoji;
  final String thai;

  Question({
    required this.sentence,
    required this.options,
    required this.correctAnswer,
    required this.keyWord,
    required this.grammarRule,
    this.emoji = '✏️',
    this.thai = '',
  });

  int get blankCount => RegExp(r'_{3,}').allMatches(sentence).length;
  List<String> get answerParts => correctAnswer.split(' / ');

  String get fullSentence {
    String s = sentence;
    for (final p in answerParts) {
      s = s.replaceFirst(RegExp(r'_{3,}'), p);
    }
    return s.replaceAll(' .', '.');
  }
}

Question _mk(String s, List<String> o, String a, String k, String r, String e, String t) => Question(
      sentence: s,
      options: o,
      correctAnswer: a,
      keyWord: k,
      grammarRule: r,
      emoji: e,
      thai: t,
    );

// ==========================================
// 2. คลังโจทย์เรียงตามหมวดและระดับความยาก (รองรับ 50 ด่าน)
// ==========================================
class QuestionBank {
  /// จำนวนโจทย์ [ง่าย, กลาง, ยาก] ของแต่ละด่าน คำนวณจากเลขด่าน (1-50)
  static List<int> mixFor(int level) {
    final lv = level.clamp(1, GameProgress.totalLevels).toInt();
    final total = 4 + (lv - 1) ~/ 17; // 4 → 6 ข้อ
    final p = (lv - 1) / (GameProgress.totalLevels - 1);
    final hard = (total * ((p - 0.3) / 0.7).clamp(0.0, 1.0).toDouble()).round();
    var easy = (total * (1 - p * 1.7).clamp(0.0, 1.0).toDouble()).round();
    if (easy + hard > total) easy = total - hard;
    final medium = total - easy - hard;
    return [easy, medium, hard];
  }

  static List<Question> getQuestionsForLevel(int level, [Set<String>? seen]) {
    final mix = mixFor(level);
    final used = seen ?? <String>{};
    List<Question> take(List<Question> pool, int n) {
      final fresh = pool.where((q) => !used.contains(q.sentence)).toList()..shuffle(_rng);
      final old = pool.where((q) => used.contains(q.sentence)).toList()..shuffle(_rng);
      return [...fresh, ...old].take(n).toList();
    }

    return [...take(_easy, mix[0]), ...take(_medium, mix[1]), ...take(_hard, mix[2])];
  }

  static final List<Question> _easy = [
    Question(
      sentence: "I _______ a good student.",
      options: ["am", "is", "are"],
      correctAnswer: "am",
      keyWord: "I",
      grammarRule: "I (ฉัน) ใช้คู่กับ am เสมอ เช่น I am a student นะ",
      emoji: '🧒',
      thai: "ฉันเป็นนักเรียนที่ดี",
    ),
    Question(
      sentence: "She _______ a cat.",
      options: ["have", "has", "having"],
      correctAnswer: "has",
      keyWord: "She",
      grammarRule: "He / She / It ใช้ has ส่วน I / You / We / They ใช้ have นะ",
      emoji: '🐱',
      thai: "เธอมีแมวหนึ่งตัว",
    ),
    Question(
      sentence: "He _______ an apple every day.",
      options: ["eat", "eats", "eating"],
      correctAnswer: "eats",
      keyWord: "every day",
      grammarRule: "He / She / It ใน Present Simple กริยาต้องเติม s เช่น eats นะ",
      emoji: '🍎',
      thai: "เขากินแอปเปิลทุกวัน",
    ),
    Question(
      sentence: "They _______ playing football.",
      options: ["is", "am", "are"],
      correctAnswer: "are",
      keyWord: "They",
      grammarRule: "They (พวกเขา) และ We (พวกเรา) ใช้กับ are นะ",
      emoji: '⚽',
      thai: "พวกเขากำลังเล่นฟุตบอล",
    ),
    Question(
      sentence: "This is Sarah. _______ is my best friend.",
      options: ["She", "Her", "He"],
      correctAnswer: "She",
      keyWord: "Sarah",
      grammarRule: "Sarah เป็นผู้หญิง เราจึงใช้ She (เธอ) นะ",
      emoji: '👧',
      thai: "นี่คือซาร่าห์ เธอเป็นเพื่อนสนิทของฉัน",
    ),
    Question(
      sentence: "I see _______ elephant.",
      options: ["a", "an"],
      correctAnswer: "an",
      keyWord: "elephant",
      grammarRule: "คำที่ขึ้นต้นด้วยเสียงสระ (a e i o u) ใช้ an เช่น an elephant, an egg นะ",
      emoji: '🐘',
      thai: "ฉันเห็นช้างหนึ่งตัว",
    ),
    Question(
      sentence: "Two _______ are playing.",
      options: ["cat", "cats", "cates"],
      correctAnswer: "cats",
      keyWord: "Two",
      grammarRule: "มีมากกว่า 1 ตัว ต้องเติม s ท้ายคำนาม เช่น two cats นะ",
      emoji: '🐈',
      thai: "แมวสองตัวกำลังเล่นกัน",
    ),
    Question(
      sentence: "This is my brother. _______ is tall.",
      options: ["He", "She", "It"],
      correctAnswer: "He",
      keyWord: "brother",
      grammarRule: "brother คือพี่/น้องชาย ผู้ชายใช้ He นะ",
      emoji: '👦',
      thai: "นี่คือพี่ชายของฉัน เขาตัวสูง",
    ),
    Question(
      sentence: "We _______ in the park.",
      options: ["is", "am", "are"],
      correctAnswer: "are",
      keyWord: "We",
      grammarRule: "We (พวกเรา) ใช้กับ are นะ",
      emoji: '🌳',
      thai: "พวกเราอยู่ที่สวนสาธารณะ",
    ),
    Question(
      sentence: "The bird _______ in the sky.",
      options: ["fly", "flies", "flying"],
      correctAnswer: "flies",
      keyWord: "bird",
      grammarRule: "นกตัวเดียว (It) กริยาต้องเติม s: fly เปลี่ยนเป็น flies นะ",
      emoji: '🐦',
      thai: "นกบินอยู่บนท้องฟ้า",
    ),
    Question(
      sentence: "You _______ my friend.",
      options: ["is", "am", "are"],
      correctAnswer: "are",
      keyWord: "You",
      grammarRule: "You (เธอ) ใช้กับ are เสมอ นะ",
      emoji: '🤝',
      thai: "เธอเป็นเพื่อนของฉัน",
    ),
    Question(
      sentence: "It _______ a red ball.",
      options: ["am", "is", "are"],
      correctAnswer: "is",
      keyWord: "It",
      grammarRule: "It (มัน) ใช้กับ is นะ",
      emoji: '🔴',
      thai: "มันคือลูกบอลสีแดง",
    ),
    Question(
      sentence: "I _______ milk every morning.",
      options: ["drink", "drinks", "drinking"],
      correctAnswer: "drink",
      keyWord: "I",
      grammarRule: "I / You / We / They ใช้กริยาธรรมดา ไม่ต้องเติม s นะ",
      emoji: '🥛',
      thai: "ฉันดื่มนมทุกเช้า",
    ),
    _mk("My mom _______ a teacher.", ["is", "are", "am"], "is", "mom",
        "My mom = She ใช้กับ is นะ", '👩‍🏫', "แม่ของฉันเป็นครู"),
    _mk("I _______ two eyes.", ["have", "has", "am"], "have", "I",
        "I ใช้ have (ไม่ใช่ has) นะ", '👀', "ฉันมีตาสองข้าง"),
    _mk("The dogs _______ big.", ["is", "are", "am"], "are", "dogs",
        "dogs หลายตัว ใช้ are นะ", '🐕', "สุนัขพวกนั้นตัวใหญ่"),
    _mk("He _______ a ball.", ["have", "has", "having"], "has", "He",
        "He / She / It ใช้ has นะ", '🏀', "เขามีลูกบอลหนึ่งลูก"),
    _mk("She _______ to school every day.", ["go", "goes", "going"], "goes", "every day",
        "She ใน Present Simple เติม es: go เป็น goes นะ", '🏫', "เธอไปโรงเรียนทุกวัน"),
    _mk("I like _______ orange.", ["a", "an"], "an", "orange",
        "orange ขึ้นต้นด้วยเสียงสระ ใช้ an นะ", '🍊', "ฉันชอบส้มหนึ่งผล"),
    _mk("There is _______ egg in the box.", ["a", "an"], "an", "egg",
        "egg ขึ้นต้นด้วยเสียงสระ ใช้ an นะ", '🥚', "มีไข่หนึ่งฟองอยู่ในกล่อง"),
    _mk("Three _______ are in the bag.", ["book", "books", "bookes"], "books", "Three",
        "มีมากกว่า 1 เล่ม เติม s เป็น books นะ", '📚', "หนังสือสามเล่มอยู่ในกระเป๋า"),
    _mk("My friends _______ happy.", ["is", "are", "am"], "are", "friends",
        "friends หลายคน ใช้ are นะ", '😄', "เพื่อนของฉันมีความสุข"),
    _mk("We _______ rice for lunch.", ["eat", "eats", "eating"], "eat", "We",
        "We ใช้กริยาธรรมดา ไม่เติม s นะ", '🍚', "พวกเรากินข้าวเป็นมื้อเที่ยง"),
    _mk("The sun _______ hot.", ["is", "are", "am"], "is", "sun",
        "The sun ตัวเดียว (It) ใช้ is นะ", '☀️', "ดวงอาทิตย์ร้อน"),
    _mk("Mr. and Mrs. Lee are kind. _______ are my neighbors.", ["They", "He", "She"], "They", "Mr. and Mrs. Lee",
        "สองคนขึ้นไปใช้ They (พวกเขา) นะ", '🏠', "คุณลีและภรรยาใจดี พวกเขาเป็นเพื่อนบ้านของฉัน"),
    _mk("My sister _______ a doll.", ["have", "has", "having"], "has", "sister",
        "My sister = She ใช้ has นะ", '🪆', "พี่สาวของฉันมีตุ๊กตา"),
    _mk("The boy _______ football.", ["play", "plays", "playing"], "plays", "boy",
        "The boy = He กริยาเติม s เป็น plays นะ", '⚽', "เด็กชายเล่นฟุตบอล"),
    _mk("You and I _______ friends.", ["is", "am", "are"], "are", "You and I",
        "You and I = We ใช้ are นะ", '👭', "เธอกับฉันเป็นเพื่อนกัน"),
    _mk("A bus _______ big.", ["is", "are", "am"], "is", "bus",
        "A bus คันเดียว (It) ใช้ is นะ", '🚌', "รถบัสคันใหญ่"),
  ];

  static final List<Question> _medium = [
    Question(
      sentence: "Yesterday, I _______ a great movie.",
      options: ["watch", "watched", "watching", "watches"],
      correctAnswer: "watched",
      keyWord: "Yesterday",
      grammarRule: "'Yesterday' (เมื่อวาน) บอกอดีต กริยาต้องเติม -ed เช่น watched นะ",
      emoji: '🎬',
      thai: "เมื่อวานฉันดูหนังสนุกมาก",
    ),
    Question(
      sentence: "The cat is sleeping _______ the table.",
      options: ["in", "under", "at", "on"],
      correctAnswer: "under",
      keyWord: "table",
      grammarRule: "'under' แปลว่า 'ใต้' แมวนอนใต้โต๊ะนั่นเอง",
      emoji: '🐱',
      thai: "แมวกำลังนอนอยู่ใต้โต๊ะ",
    ),
    Question(
      sentence: "Birds _______ fly high in the sky.",
      options: ["can", "can't", "is"],
      correctAnswer: "can",
      keyWord: "fly high",
      grammarRule: "'can' บอกว่าทำได้ นกบินได้ ก็ใช้ can นะ",
      emoji: '🐦',
      thai: "นกบินสูงบนท้องฟ้าได้",
    ),
    Question(
      sentence: "She _______ her homework last night.",
      options: ["finish", "finishes", "finished", "finishing"],
      correctAnswer: "finished",
      keyWord: "last night",
      grammarRule: "'last night' (เมื่อคืน) คืออดีต ต้องใช้ finished นะ",
      emoji: '📝',
      thai: "เมื่อคืนเธอทำการบ้านเสร็จ",
    ),
    Question(
      sentence: "There _______ three apples on the table.",
      options: ["is", "are", "am"],
      correctAnswer: "are",
      keyWord: "three apples",
      grammarRule: "ของหลายชิ้นใช้ There are ถ้ามีชิ้นเดียวใช้ There is นะ",
      emoji: '🍎',
      thai: "มีแอปเปิลสามลูกอยู่บนโต๊ะ",
    ),
    Question(
      sentence: "My dad _______ a big car.",
      options: ["drive", "drives", "driving"],
      correctAnswer: "drives",
      keyWord: "dad",
      grammarRule: "My dad = He กริยาต้องเติม s เป็น drives นะ",
      emoji: '🚗',
      thai: "พ่อของฉันขับรถคันใหญ่",
    ),
    Question(
      sentence: "She is _______ a letter now.",
      options: ["write", "writes", "writing"],
      correctAnswer: "writing",
      keyWord: "now",
      grammarRule: "is + V-ing แปลว่า 'กำลังทำอยู่' ตอนนี้ (now) ใช้ writing นะ",
      emoji: '✉️',
      thai: "ตอนนี้เธอกำลังเขียนจดหมาย",
    ),
    Question(
      sentence: "I go to school _______ bus.",
      options: ["by", "in", "at", "on"],
      correctAnswer: "by",
      keyWord: "bus",
      grammarRule: "เดินทางโดยพาหนะใช้ by เช่น by bus, by car, by train นะ",
      emoji: '🚌',
      thai: "ฉันไปโรงเรียนโดยรถบัส",
    ),
    Question(
      sentence: "We _______ a picnic last Sunday.",
      options: ["have", "had", "having", "has"],
      correctAnswer: "had",
      keyWord: "last Sunday",
      grammarRule: "'last Sunday' คืออดีต have เปลี่ยนเป็น had นะ",
      emoji: '🧺',
      thai: "วันอาทิตย์ที่แล้วพวกเราไปปิกนิก",
    ),
    Question(
      sentence: "My birthday is _______ July.",
      options: ["in", "on", "at"],
      correctAnswer: "in",
      keyWord: "July",
      grammarRule: "ชื่อเดือนใช้ in เช่น in July, in May นะ",
      emoji: '🎂',
      thai: "วันเกิดของฉันอยู่ในเดือนกรกฎาคม",
    ),
    Question(
      sentence: "The baby _______ walk yet. He is only one.",
      options: ["can't", "can", "must"],
      correctAnswer: "can't",
      keyWord: "yet",
      grammarRule: "can't แปลว่าทำไม่ได้ ทารกอายุแค่หนึ่งขวบยังเดินไม่ได้นะ",
      emoji: '👶',
      thai: "ทารกยังเดินไม่ได้ เขาอายุแค่หนึ่งขวบ",
    ),
    Question(
      sentence: "Tom _______ his teeth every morning.",
      options: ["brush", "brushes", "brushing"],
      correctAnswer: "brushes",
      keyWord: "every morning",
      grammarRule: "Tom = He กริยาลงท้าย sh ต้องเติม es เป็น brushes นะ",
      emoji: '🦷',
      thai: "ทอมแปรงฟันทุกเช้า",
    ),
    _mk("Look! The baby is _______.", ["cry", "cries", "crying"], "crying", "Look",
        "is + V-ing แปลว่ากำลังทำอยู่ ใช้ crying นะ", '👶', "ดูสิ! ทารกกำลังร้องไห้"),
    _mk("I will visit my grandma _______ Sunday.", ["in", "on", "at"], "on", "Sunday",
        "วันในสัปดาห์ใช้ on เช่น on Sunday, on Monday นะ", '👵', "ฉันจะไปเยี่ยมคุณยายวันอาทิตย์"),
    _mk("She goes to bed _______ 9 o'clock.", ["in", "on", "at"], "at", "9 o'clock",
        "เวลาเป๊ะๆ ใช้ at เช่น at 9 o'clock นะ", '🛏️', "เธอเข้านอนตอนเก้าโมง"),
    _mk("Last year, we _______ to Phuket.", ["go", "went", "goes", "going"], "went", "Last year",
        "Last year คืออดีต go เปลี่ยนเป็น went นะ", '🏝️', "ปีที่แล้วพวกเราไปภูเก็ต"),
    _mk("He _______ not like carrots.", ["do", "does", "is"], "does", "He",
        "He / She / It ใช้ does not นะ", '🥕', "เขาไม่ชอบแครอท"),
    _mk("_______ you like pizza?", ["Do", "Does", "Is"], "Do", "you",
        "คำถามกับ You / I / We / They ขึ้นต้นด้วย Do นะ", '🍕', "เธอชอบพิซซ่าไหม"),
    _mk("The pen is _______ the book and the bag.", ["in", "on", "between", "under"], "between", "and",
        "between แปลว่า 'ระหว่าง' สองสิ่งนะ", '🖊️', "ปากกาอยู่ระหว่างหนังสือกับกระเป๋า"),
    _mk("Mia _______ her bike yesterday.", ["ride", "rode", "riding", "rides"], "rode", "yesterday",
        "yesterday คืออดีต ride เปลี่ยนเป็น rode (กริยาไม่ปกติ) นะ", '🚲', "เมื่อวานเมียขี่จักรยาน"),
    _mk("I can _______ English well.", ["speak", "speaks", "speaking"], "speak", "can",
        "หลัง can ใช้กริยาช่อง 1 ไม่ต้องเติม s นะ", '🗣️', "ฉันพูดภาษาอังกฤษได้ดี"),
    _mk("There _______ a book on the desk.", ["is", "are", "am"], "is", "a book",
        "ของชิ้นเดียวใช้ There is นะ", '📖', "มีหนังสือหนึ่งเล่มอยู่บนโต๊ะ"),
    _mk("They are _______ TV now.", ["watch", "watches", "watching"], "watching", "now",
        "are + V-ing แปลว่ากำลังทำอยู่ ใช้ watching นะ", '📺', "ตอนนี้พวกเขากำลังดูทีวี"),
    _mk("We _______ tired last night.", ["was", "were", "are", "is"], "were", "last night",
        "อดีตของ We / You / They ใช้ were นะ", '😴', "เมื่อคืนพวกเราเหนื่อย"),
    _mk("The movie starts _______ 7 pm.", ["in", "on", "at"], "at", "7 pm",
        "เวลาเป๊ะๆ ใช้ at เช่น at 7 pm นะ", '🍿', "หนังเริ่มตอนหนึ่งทุ่ม"),
    _mk("She _______ her mother in the kitchen yesterday.", ["help", "helped", "helping", "helps"], "helped", "yesterday",
        "yesterday คืออดีต เติม -ed เป็น helped นะ", '👩‍🍳', "เมื่อวานเธอช่วยแม่ในครัว"),
  ];

  static final List<Question> _hard = [
    Question(
      sentence: "I _______ a boy. She _______ a girl.",
      options: ["am / is", "is / am", "are / is", "am / are"],
      correctAnswer: "am / is",
      keyWord: "She",
      grammarRule: "I ใช้ am ส่วน She ใช้ is นะ",
      emoji: '👫',
      thai: "ฉันเป็นเด็กผู้ชาย เธอเป็นเด็กผู้หญิง",
    ),
    Question(
      sentence: "They _______ playing and I _______ reading.",
      options: ["are / am", "is / am", "are / is", "am / are"],
      correctAnswer: "are / am",
      keyWord: "They",
      grammarRule: "They ใช้ are ส่วน I ใช้ am นะ",
      emoji: '📚',
      thai: "พวกเขากำลังเล่น และฉันกำลังอ่านหนังสือ",
    ),
    Question(
      sentence: "The dog _______ and the birds _______ .",
      options: ["barks / sing", "bark / sings", "barks / sings", "barking / sing"],
      correctAnswer: "barks / sing",
      keyWord: "birds",
      grammarRule: "The dog ตัวเดียวเติม s: barks ส่วน the birds หลายตัวไม่เติม s: sing นะ",
      emoji: '🐶',
      thai: "สุนัขเห่า และนกร้องเพลง",
    ),
    Question(
      sentence: "Yesterday I _______ to the zoo and _______ a lion.",
      options: ["went / saw", "go / see", "went / see", "goed / saw"],
      correctAnswer: "went / saw",
      keyWord: "Yesterday",
      grammarRule: "Yesterday คืออดีต: go เปลี่ยนเป็น went และ see เปลี่ยนเป็น saw นะ",
      emoji: '🦁',
      thai: "เมื่อวานฉันไปสวนสัตว์และเห็นสิงโต",
    ),
    Question(
      sentence: "He _______ to music while _______ .",
      options: ["listens / studying", "listen / study", "listened / studied", "listening / studies"],
      correctAnswer: "listens / studying",
      keyWord: "while",
      grammarRule: "He ใช้กริยาเติม s (listens) และหลัง 'while' ตามด้วย V-ing (studying) นะ",
      emoji: '🎧',
      thai: "เขาฟังเพลงขณะที่กำลังเรียน",
    ),
    Question(
      sentence: "If it _______ tomorrow, we _______ stay at home.",
      options: ["rains / will", "rain / would", "rained / will", "raining / shall"],
      correctAnswer: "rains / will",
      keyWord: "tomorrow",
      grammarRule: "If + Present Simple (rains), ตามด้วย will + กริยาช่อง 1 นะ",
      emoji: '🌧️',
      thai: "ถ้าพรุ่งนี้ฝนตก พวกเราจะอยู่บ้าน",
    ),
    Question(
      sentence: "She _______ a book and he _______ a game.",
      options: ["reads / plays", "read / plays", "reads / play", "reading / plays"],
      correctAnswer: "reads / plays",
      keyWord: "and",
      grammarRule: "She และ he ตัวเดียว กริยาต้องเติม s: reads, plays นะ",
      emoji: '🎮',
      thai: "เธออ่านหนังสือและเขาเล่นเกม",
    ),
    Question(
      sentence: "We _______ happy because we _______ a gift.",
      options: ["are / have", "is / has", "are / has", "am / have"],
      correctAnswer: "are / have",
      keyWord: "because",
      grammarRule: "We ใช้ are และใช้ have (ไม่ใช่ has) นะ",
      emoji: '🎁',
      thai: "พวกเรามีความสุขเพราะพวกเรามีของขวัญ",
    ),
    Question(
      sentence: "Last week, Tom _______ a fish and _______ it.",
      options: ["caught / ate", "catch / eat", "caught / eat", "catched / ate"],
      correctAnswer: "caught / ate",
      keyWord: "Last week",
      grammarRule: "Last week คืออดีต: catch เปลี่ยนเป็น caught, eat เปลี่ยนเป็น ate (กริยาไม่ปกติ) นะ",
      emoji: '🎣',
      thai: "สัปดาห์ที่แล้วทอมจับปลาได้และกินมัน",
    ),
    Question(
      sentence: "The kids _______ in the garden and the cat _______ under the tree.",
      options: ["play / sleeps", "plays / sleeps", "play / sleep", "playing / sleeps"],
      correctAnswer: "play / sleeps",
      keyWord: "kids",
      grammarRule: "the kids (หลายคน) ไม่เติม s: play ส่วน the cat (ตัวเดียว) เติม s: sleeps นะ",
      emoji: '🌳',
      thai: "เด็กๆ เล่นในสวน และแมวนอนอยู่ใต้ต้นไม้",
    ),
    Question(
      sentence: "If I _______ hungry, I _______ eat an apple.",
      options: ["am / will", "is / will", "am / would", "are / will"],
      correctAnswer: "am / will",
      keyWord: "If",
      grammarRule: "If + Present Simple (I am) ตามด้วย will + กริยาช่อง 1 นะ",
      emoji: '🍏',
      thai: "ถ้าฉันหิว ฉันจะกินแอปเปิล",
    ),
    Question(
      sentence: "My sister _______ dancing now, but I _______ singing.",
      options: ["is / am", "are / am", "is / is", "am / is"],
      correctAnswer: "is / am",
      keyWord: "but",
      grammarRule: "My sister = She ใช้ is ส่วน I ใช้ am นะ",
      emoji: '💃',
      thai: "ตอนนี้พี่สาวฉันกำลังเต้น แต่ฉันกำลังร้องเพลง",
    ),
    _mk("She _______ a song and they _______ dancing.", ["sings / are", "sing / is", "sings / is", "singing / are"], "sings / are", "and",
        "She เติม s: sings ส่วน They ใช้ are นะ", '🎤', "เธอร้องเพลงและพวกเขากำลังเต้น"),
    _mk("Yesterday he _______ a cake and _______ it.", ["made / ate", "make / eat", "made / eat", "maked / ate"], "made / ate", "Yesterday",
        "อดีต: make เป็น made และ eat เป็น ate (กริยาไม่ปกติ) นะ", '🎂', "เมื่อวานเขาทำเค้กและกินมัน"),
    _mk("If you _______ hard, you _______ pass the test.", ["study / will", "studied / will", "study / would", "studying / will"], "study / will", "If",
        "If + Present Simple (study) ตามด้วย will + กริยาช่อง 1 นะ", '📝', "ถ้าเธอตั้งใจเรียน เธอจะสอบผ่าน"),
    _mk("I _______ playing now, but yesterday I _______ reading.", ["am / was", "is / was", "am / is", "are / were"], "am / was", "but",
        "now ใช้ am ส่วน yesterday ใช้ was (อดีตของ I) นะ", '🎲', "ตอนนี้ฉันกำลังเล่น แต่เมื่อวานฉันกำลังอ่านหนังสือ"),
    _mk("My parents _______ at home and my brother _______ at school.", ["are / is", "is / are", "are / are", "am / is"], "are / is", "and",
        "parents หลายคนใช้ are ส่วน brother คนเดียวใช้ is นะ", '🏡', "พ่อแม่อยู่บ้านและพี่ชายอยู่โรงเรียน"),
    _mk("Last night, I _______ dinner and then _______ TV.", ["ate / watched", "eat / watch", "ate / watch", "eated / watched"], "ate / watched", "Last night",
        "Last night คืออดีต: ate (eat) และ watched นะ", '🍽️', "เมื่อคืนฉันกินข้าวเย็นแล้วดูทีวี"),
    _mk("She _______ a doctor, and her sons _______ students.", ["is / are", "are / is", "is / is", "am / are"], "is / are", "and",
        "She ใช้ is ส่วน sons หลายคนใช้ are นะ", '🩺', "เธอเป็นหมอ และลูกชายของเธอเป็นนักเรียน"),
    _mk("He _______ swim, but he _______ fly.", ["can / can't", "can't / can", "can / can", "must / can't"], "can / can't", "but",
        "can ทำได้ can't ทำไม่ได้ คนบินไม่ได้นะ", '🏊', "เขาว่ายน้ำได้ แต่บินไม่ได้"),
    _mk("Every day, she _______ up at six and _______ breakfast.", ["wakes / eats", "wake / eat", "wakes / eat", "waking / eats"], "wakes / eats", "Every day",
        "She ใน Present Simple กริยาต้องเติม s: wakes, eats นะ", '🌅', "ทุกวันเธอตื่นหกโมงและกินอาหารเช้า"),
    _mk("We _______ to the beach last Sunday and _______ shells.", ["went / found", "go / find", "went / find", "goed / found"], "went / found", "last Sunday",
        "last Sunday คืออดีต: go เป็น went, find เป็น found นะ", '🏖️', "วันอาทิตย์ที่แล้วพวกเราไปทะเลและเจอเปลือกหอย"),
  ];
}

// ==========================================
// 3. เอฟเฟกต์เล็ก ๆ (ประกาย / แผ่นไม้ร่วง / ฝนคอนเฟตตี)
// ==========================================
class _Fx {
  final int id;
  final double x;
  final double y;
  final List<String> emojis;
  _Fx(this.id, this.x, this.y, this.emojis);
}

class _BurstFx extends StatefulWidget {
  final List<String> emojis;
  final VoidCallback onDone;
  const _BurstFx({super.key, required this.emojis, required this.onDone});

  @override
  State<_BurstFx> createState() => _BurstFxState();
}

class _BurstFxState extends State<_BurstFx> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )
    ..addStatusListener((s) {
      if (s == AnimationStatus.completed) widget.onDone();
    })
    ..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        const count = 10;
        return SizedBox(
          width: 140,
          height: 140,
          child: Stack(
            children: List.generate(count, (i) {
              final ang = pi * 2 * i / count;
              final r = 10 + 55 * Curves.easeOut.transform(t);
              return Positioned(
                left: 70 + cos(ang) * r - 10,
                top: 70 + sin(ang) * r - 10 - 16 * t,
                child: Opacity(
                  opacity: (1 - t).clamp(0.0, 1.0),
                  child: Text(
                    widget.emojis.isEmpty ? '✨' : widget.emojis[i % widget.emojis.length],
                    style: TextStyle(fontSize: 14 + 12 * (1 - t)),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class _FallingPlank extends StatefulWidget {
  final double drop;
  final VoidCallback onDone;
  const _FallingPlank({super.key, required this.drop, required this.onDone});

  @override
  State<_FallingPlank> createState() => _FallingPlankState();
}

class _FallingPlankState extends State<_FallingPlank> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )
    ..addStatusListener((s) {
      if (s == AnimationStatus.completed) widget.onDone();
    })
    ..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        final jitter = t < 0.2 ? sin(t * 90) * 3 : 0.0;
        final f = ((t - 0.2) / 0.8).clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(jitter, f * f * widget.drop),
          child: Transform.rotate(
            angle: f * 1.3,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Opacity(
                  opacity: (1 - f * 0.85).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFFA4B8), Color(0xFFE53960)]),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFFA3173A), width: 1.5),
                    ),
                  ),
                ),
                if (t < 0.25)
                  const Positioned(top: -14, left: 2, child: Text('💥', style: TextStyle(fontSize: 20))),
                if (f > 0.8)
                  const Positioned(top: -8, left: 0, child: Text('💦', style: TextStyle(fontSize: 22))),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ConfettiPiece {
  final double x;
  final double delay;
  final double size;
  final double sway;
  final String emoji;
  _ConfettiPiece(this.x, this.delay, this.size, this.sway, this.emoji);
}

class _ConfettiRain extends StatefulWidget {
  final VoidCallback onDone;
  const _ConfettiRain({super.key, required this.onDone});

  @override
  State<_ConfettiRain> createState() => _ConfettiRainState();
}

class _ConfettiRainState extends State<_ConfettiRain> with SingleTickerProviderStateMixin {
  static const _items = ['🎉', '🎊', '⭐', '✨', '🌟', '🎈', '💖', '🍭'];

  late final List<_ConfettiPiece> _pieces = List.generate(
    32,
    (i) => _ConfettiPiece(
      _rng.nextDouble(),
      _rng.nextDouble() * 0.35,
      18 + _rng.nextDouble() * 16,
      8 + _rng.nextDouble() * 18,
      _items[_rng.nextInt(_items.length)],
    ),
  );

  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )
    ..addStatusListener((s) {
      if (s == AnimationStatus.completed) widget.onDone();
    })
    ..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        return AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            final kids = <Widget>[];
            for (final p in _pieces) {
              final t = ((_c.value - p.delay) / (1 - p.delay)).clamp(0.0, 1.0).toDouble();
              if (t <= 0 || t >= 1) continue;
              final op = t > 0.85 ? (1 - t) / 0.15 : 1.0;
              kids.add(Positioned(
                left: p.x * (box.maxWidth - 30) + sin(t * pi * 4 + p.x * 9) * p.sway,
                top: -40 + (box.maxHeight + 60) * t,
                child: Opacity(opacity: op, child: Text(p.emoji, style: TextStyle(fontSize: p.size))),
              ));
            }
            return Stack(children: kids);
          },
        );
      },
    );
  }
}

// ==========================================
// ธีมฉากแต่ละโลก (โลกละ 10 ด่าน)
// ==========================================
class _SceneTheme {
  final String name;
  final String icon;
  final String sun;
  final String floater;
  final String bird;
  final String fish;
  final String deco;
  final Color skyTop;
  final Color skyBottom;
  final Color pageBottom;
  final Color hill1;
  final Color hill2;
  final Color waterTop;
  final Color waterBottom;
  final Color grass;
  final Color rock;
  final Color rockLine;
  final Color accent;
  final Color accentDk;

  const _SceneTheme({
    required this.name,
    required this.icon,
    required this.sun,
    required this.floater,
    required this.bird,
    required this.fish,
    required this.deco,
    required this.skyTop,
    required this.skyBottom,
    required this.pageBottom,
    required this.hill1,
    required this.hill2,
    required this.waterTop,
    required this.waterBottom,
    required this.grass,
    required this.rock,
    required this.rockLine,
    required this.accent,
    required this.accentDk,
  });
}

// ==========================================
// 4. วาดฉากหลัง
// ==========================================
class _SceneGeo {
  final double w;
  final double h;
  final int slots;
  final double cliffW;
  final double bridgeLeft;
  final double bridgeRight;
  final double slotW;
  final double deckY;
  final double waterTop;

  _SceneGeo(this.w, this.h, this.slots)
      : cliffW = w * 0.2,
        bridgeLeft = w * 0.2,
        bridgeRight = w - w * 0.2,
        slotW = (w - w * 0.4) / max(1, slots),
        deckY = h * 0.5,
        waterTop = h * 0.74;

  double slotLeft(int i) => bridgeLeft + i * slotW;
  double slotCenter(int i) => bridgeLeft + (i + 0.5) * slotW;
}

class _ScenePainter extends CustomPainter {
  final double t;
  final double wobble;
  final int tier;
  final _SceneGeo g;
  final _SceneTheme th;

  _ScenePainter({required this.t, required this.wobble, required this.tier, required this.g, required this.th});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawCircle(Offset(w * 0.28, h * 0.68), h * 0.24, Paint()..color = th.hill1.withAlpha(170));
    canvas.drawCircle(Offset(w * 0.66, h * 0.72), h * 0.2, Paint()..color = th.hill2.withAlpha(160));
    canvas.drawCircle(Offset(w * 0.92, h * 0.66), h * 0.16, Paint()..color = th.hill1.withAlpha(130));

    final water = Rect.fromLTWH(0, g.waterTop, w, h - g.waterTop);
    canvas.drawRect(
      water,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [th.waterTop, th.waterBottom],
        ).createShader(water),
    );
    for (int layer = 0; layer < 3; layer++) {
      final path = Path()..moveTo(0, h);
      final dir = layer.isEven ? 1.0 : -1.0;
      for (double x = 0; x <= w; x += 5) {
        final y = g.waterTop + layer * 7 + sin(x / w * pi * 4 + t * pi * 2 * dir + layer) * 3.5;
        path.lineTo(x, y);
      }
      path.lineTo(w, h);
      path.close();
      canvas.drawPath(path, Paint()..color = Colors.white.withAlpha(40 + layer * 12));
    }

    final rock = Paint()..color = th.rock;
    final rockLine = Paint()..color = th.rockLine;
    final grass = Paint()..color = th.grass;
    canvas.drawRRect(RRect.fromLTRBAndCorners(-10, g.deckY, g.cliffW, h, topRight: const Radius.circular(16)), rock);
    canvas.drawRRect(RRect.fromLTRBAndCorners(w - g.cliffW, g.deckY, w + 10, h, topLeft: const Radius.circular(16)), rock);
    canvas.drawRect(Rect.fromLTWH(g.cliffW - 10, g.deckY + 20, 10, h - g.deckY), rockLine);
    canvas.drawRect(Rect.fromLTWH(w - g.cliffW, g.deckY + 20, 10, h - g.deckY), rockLine);
    canvas.drawRRect(RRect.fromLTRBAndCorners(-10, g.deckY, g.cliffW, g.deckY + 14, topRight: const Radius.circular(16)), grass);
    canvas.drawRRect(RRect.fromLTRBAndCorners(w - g.cliffW, g.deckY, w + 10, g.deckY + 14, topLeft: const Radius.circular(16)), grass);

    if (tier > 0) {
      final glow = tier == 2 ? const Color(0xFF00E5FF) : const Color(0xFFFFD54F);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(g.bridgeLeft - 4, g.deckY - 4 + wobble, g.bridgeRight - g.bridgeLeft + 8, 24),
          const Radius.circular(12),
        ),
        Paint()
          ..color = glow.withAlpha(130)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
      );
    }

    final ropeColor = tier == 2
        ? const Color(0xFF00D5F0)
        : tier == 1
            ? const Color(0xFFFFB300)
            : const Color(0xFFFF7BAC);
    final post = Paint()
      ..color = const Color(0xFF8D5A3B)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final rope = Paint()
      ..color = ropeColor
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final top = g.deckY - 34 + wobble;
    canvas.drawLine(Offset(g.bridgeLeft, g.deckY), Offset(g.bridgeLeft, g.deckY - 38), post);
    canvas.drawLine(Offset(g.bridgeRight, g.deckY), Offset(g.bridgeRight, g.deckY - 38), post);
    final ropePath = Path()
      ..moveTo(g.bridgeLeft, top)
      ..quadraticBezierTo((g.bridgeLeft + g.bridgeRight) / 2, top + 22, g.bridgeRight, top);
    canvas.drawPath(ropePath, rope);
    final hanger = Paint()
      ..color = ropeColor.withAlpha(180)
      ..strokeWidth = 1.5;
    for (int i = 0; i < g.slots; i++) {
      final u = (i + 0.5) / g.slots;
      final yCurve = top + 44 * u * (1 - u);
      canvas.drawLine(Offset(g.slotCenter(i), yCurve), Offset(g.slotCenter(i), g.deckY + wobble), hanger);
    }
  }

  @override
  bool shouldRepaint(covariant _ScenePainter old) => true;
}

// ==========================================
// ตั้งค่า + ความคืบหน้าของผู้เล่น
// ==========================================
class GameSettings {
  static bool sound = true;
  static bool music = true;
  static bool voice = true; // เสียงอ่านคำ/ประโยค (TTS)
}

/// เสียงอ่านภาษาอังกฤษ (Text-to-Speech) ช้าๆ ชัดๆ สำหรับเด็ก
class VoiceHub {
  static final FlutterTts _tts = FlutterTts();
  static bool _ready = false;

  static Future<void> _init() async {
    if (_ready) return;
    _ready = true;
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.42);
      await _tts.setPitch(1.1);
      await _tts.setVolume(1.0);
    } catch (_) {}
  }

  /// อ่านข้อความ (ตัดช่องว่างให้เป็น "blank" และเปลี่ยน ' / ' เป็นจังหวะหยุด)
  static Future<void> speak(String text) async {
    if (!GameSettings.voice) return;
    try {
      await _init();
      await _tts.stop();
      final clean = text
          .replaceAll(RegExp(r'_{3,}'), ' blank ')
          .replaceAll(' / ', ', ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      if (clean.isEmpty) return;
      await _tts.speak(clean);
    } catch (_) {}
  }

  static Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}

class AudioHub {
  static final List<AudioPlayer> _pool = List.generate(6, (_) => AudioPlayer());
  static int _i = 0;
  static final AudioPlayer _bgm = AudioPlayer();
  static String? _bgmName;
  static String? _playing;

  static Future<void> sfx(String name, {double volume = 1.0}) async {
    if (!GameSettings.sound) return;
    try {
      final pl = _pool[_i];
      _i = (_i + 1) % _pool.length;
      await pl.stop();
      await pl.setVolume(volume);
      await pl.play(AssetSource('sounds/$name'));
    } catch (_) {}
  }

  static Future<void> playBgm(String name) async {
    _bgmName = name;
    if (!GameSettings.music) {
      await stopBgm();
      return;
    }
    if (_playing == name) return;
    try {
      _playing = name;
      await _bgm.stop();
      await _bgm.setReleaseMode(ReleaseMode.loop);
      await _bgm.setVolume(0.3);
      await _bgm.play(AssetSource('sounds/$name'));
    } catch (_) {
      _playing = null;
    }
  }

  static Future<void> stopBgm() async {
    _playing = null;
    try {
      await _bgm.stop();
    } catch (_) {}
  }

  static Future<void> refreshBgm() async {
    final n = _bgmName;
    if (n != null) await playBgm(n);
  }

  static Future<void> duck(bool on) async {
    try {
      await _bgm.setVolume(on ? 0.1 : 0.3);
    } catch (_) {}
  }

  static Future<void> pauseBgm() async {
    try {
      await _bgm.pause();
    } catch (_) {}
  }

  static Future<void> resumeBgm() async {
    if (!GameSettings.music || _playing == null) return;
    try {
      await _bgm.resume();
    } catch (_) {}
  }
}

class GameProgress {
  static const int totalLevels = 50;
  static const int levelsPerWorld = 10;
  static const int worldCount = 5;
  static const int bonusStart = 50; // สติกเกอร์ 0-49 = ผ่านด่าน, 50-74 = โบนัสเพอร์เฟกต์

  static const List<String> stickers = [
    '🦊', '🐯', '🦁', '🐸', '🐵', '🐰', '🐨', '🦄', '🐙', '🦋',
    '🐧', '🐢', '🐶', '🐱', '🐻', '🐘', '🦒', '🐬', '🦉', '🐝',
    '🐞', '🦀', '🐳', '🦓', '🐷', '🐮', '🦆', '🐔', '🦖', '🐊',
    '🐹', '🐭', '🐺', '🦝', '🐗', '🐴', '🦔', '🐿️', '🦘', '🦥',
    '🦦', '🦨', '🦡', '🐫', '🦛', '🦏', '🐃', '🐑', '🐐', '🦌',
    '🐕', '🐩', '🐈', '🐓', '🦃', '🦚', '🦜', '🦢', '🦩', '🕊️',
    '🐦', '🐤', '🐟', '🐠', '🐡', '🦈', '🐋', '🦭', '🦑', '🦐',
    '🦞', '🐌', '🦗', '🕷️', '🐜',
  ];

  static final Map<int, int> stars = {};
  static final Set<int> collection = {};

  static bool isUnlocked(int level) => level <= 1 || stars.containsKey(level - 1);
  static int get totalStars => stars.values.fold(0, (a, b) => a + b);

  static int get nextLevel {
    for (int l = 1; l <= totalLevels; l++) {
      if (!stars.containsKey(l)) return l;
    }
    return totalLevels;
  }

  static void record(int level, int s) {
    stars[level] = max(stars[level] ?? 0, s);
    save();
  }

  static void reset() {
    stars.clear();
    collection.clear();
    save();
  }

  // ---------- บันทึก / โหลดความคืบหน้า ----------
  static Future<void> save() async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString('stars', stars.entries.map((e) => '${e.key}:${e.value}').join(','));
      await p.setString('collection', collection.join(','));
      await p.setBool('sound', GameSettings.sound);
      await p.setBool('music', GameSettings.music);
      await p.setBool('voice', GameSettings.voice);
    } catch (_) {}
  }

  static bool _loaded = false;
  static Future<void> ensureLoaded() async {
    if (!_loaded) await load();
  }

  static Future<void> load() async {
    _loaded = true;
    try {
      final p = await SharedPreferences.getInstance();
      stars.clear();
      for (final part in (p.getString('stars') ?? '').split(',')) {
        final kv = part.split(':');
        if (kv.length != 2) continue;
        final k = int.tryParse(kv[0]);
        final v = int.tryParse(kv[1]);
        if (k == null || v == null || k < 1 || k > totalLevels) continue;
        stars[k] = v.clamp(0, 3).toInt();
      }
      collection.clear();
      for (final part in (p.getString('collection') ?? '').split(',')) {
        final i = int.tryParse(part);
        if (i != null && i >= 0 && i < stickers.length) collection.add(i);
      }
      GameSettings.sound = p.getBool('sound') ?? true;
      GameSettings.music = p.getBool('music') ?? true;
      GameSettings.voice = p.getBool('voice') ?? true;
    } catch (_) {}
  }

  /// โลกที่ 0-4 (โลกละ 10 ด่าน)
  static int stageOf(int level) => ((level - 1) ~/ levelsPerWorld).clamp(0, worldCount - 1).toInt();
  static const List<String> _diff = ['ง่ายมาก', 'ง่าย', 'ปานกลาง', 'ยาก', 'ยากมาก'];
  static String difficultyLabel(int level) => _diff[stageOf(level)];
  static String flames(int level) => '🔥' * (stageOf(level) + 1);
}

// ==========================================
// 5. หน้าเลือกด่าน (Level Select Screen)
// ==========================================
class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> with WidgetsBindingObserver {
  late int _selected = GameProgress.nextLevel;

  // ---- ค่าของแผนที่ทางยาว (ด่าน 1 อยู่ล่างสุด เลื่อนขึ้นไปหาด่าน 50) ----
  static const double _step = 104.0;
  static const double _topPad = 110.0;
  static const double _botPad = 130.0;
  static const double _mapH = _topPad + (GameProgress.totalLevels - 1) * _step + _botPad;
  static double _yOf(int l) => _mapH - _botPad - (l - 1) * _step;
  static Offset _pt(int l, double w) => Offset(w / 2 + sin((l - 1) * 0.9) * w * 0.27, _yOf(l));

  late final ScrollController _scroll = ScrollController(initialScrollOffset: max(0.0, _yOf(_selected) - 330));
  double _viewH = 600;

  void _scrollToSelected({bool animate = false}) {
    if (!_scroll.hasClients) return;
    final target = (_yOf(_selected) - _viewH * 0.6).clamp(0.0, _scroll.position.maxScrollExtent).toDouble();
    if (animate) {
      _scroll.animateTo(target, duration: const Duration(milliseconds: 450), curve: Curves.easeOutCubic);
    } else {
      _scroll.jumpTo(target);
    }
  }

  void _scrollAfterFrame({bool animate = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scrollToSelected(animate: animate);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AvatarProfile.instance.load(); // โหลดอวาตาร์เพื่อแสดงบนแผนที่
    AudioHub.playBgm('bgm_menu.wav');
    _scrollAfterFrame();
    GameProgress.ensureLoaded().then((_) {
      if (mounted) {
        setState(() => _selected = GameProgress.nextLevel);
        _scrollAfterFrame(animate: true);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scroll.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AudioHub.resumeBgm();
    } else if (state == AppLifecycleState.paused) {
      AudioHub.pauseBgm();
    }
  }

  int get _world => GameProgress.stageOf(_selected);

  Future<void> _play() async {
    AudioHub.sfx('select.mp3');
    final before = GameProgress.stars.length;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => GrammarBridgeGame(startLevel: _selected)),
    );
    if (!mounted) return;
    AudioHub.playBgm('bgm_menu.wav');
    if (GameProgress.stars.length > before) AudioHub.sfx('unlock.mp3');
    setState(() => _selected = GameProgress.nextLevel);
    _scrollAfterFrame(animate: true);
  }

  void _back() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('ออกจากแอป?'),
          content: const Text('คุณต้องการออกจากเกมใช่หรือไม่?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ยกเลิก')),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                SystemNavigator.pop();
              },
              child: const Text('ออกจากเกม'),
            ),
          ],
        ),
      );
    }
  }

  /// ปุ่มด่านทรงกลมบนแผนที่ (ดาวอยู่ใต้ปุ่ม)
  Widget _node(int level, double cx, double cy) {
    final th = _GrammarBridgeGameState._themes[GameProgress.stageOf(level)];
    final unlocked = GameProgress.isUnlocked(level);
    final sel = level == _selected;
    final got = GameProgress.stars[level] ?? 0;
    final Color a;
    final Color b;
    final Color edge;
    if (!unlocked) {
      a = const Color(0xFFD9DDEB);
      b = _C.grey;
      edge = _C.greyDk;
    } else if (sel) {
      a = _C.green;
      b = const Color(0xFF2DCB7F);
      edge = _C.greenDk;
    } else if (got > 0) {
      a = _C.yellow;
      b = _C.orange;
      edge = _C.orangeDk;
    } else {
      a = th.accent.withAlpha(235);
      b = th.accent;
      edge = th.accentDk;
    }
    return Positioned(
      left: cx - 34,
      top: cy - 28,
      width: 72,
      height: 100,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (unlocked) {
            if (level == _selected) {
              _play();
            } else {
              AudioHub.sfx('click.mp3');
              setState(() => _selected = level);
            }
          } else {
            AudioHub.sfx('locked.mp3');
            HapticFeedback.lightImpact();
          }
        },
        child: Column(
          children: [
            AnimatedScale(
              scale: sel ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: _candy(a, b, edge, r: 30).copyWith(
                      boxShadow: [
                        BoxShadow(color: edge, offset: const Offset(0, 5)),
                        if (sel) const BoxShadow(color: Color(0xAAFFFFFF), blurRadius: 16, spreadRadius: 5),
                      ],
                    ),
                    child: unlocked
                        ? Text('$level',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              shadows: [Shadow(color: Color(0x66000000), offset: Offset(0, 2), blurRadius: 2)],
                            ))
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.lock_rounded, color: Colors.white, size: 18),
                              Text('$level',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white)),
                            ],
                          ),
                  ),
                  if (level % GameProgress.levelsPerWorld == 0)
                    const Positioned(top: -12, right: -8, child: Text('🏁', style: TextStyle(fontSize: 20))),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (unlocked)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFE08A), width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    3,
                    (i) => Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: i < got ? const Color(0xFFFFB800) : const Color(0xFFE3E6F2),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _ribbon(int k, double cy) {
    final th = _GrammarBridgeGameState._themes[k];
    final first = k * GameProgress.levelsPerWorld + 1;
    int done = 0;
    for (int l = first; l < first + GameProgress.levelsPerWorld; l++) {
      if (GameProgress.stars.containsKey(l)) done++;
    }
    return Positioned(
      left: 0,
      right: 0,
      top: cy - 19,
      child: IgnorePointer(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [th.accent, th.accentDk]),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 3))],
            ),
            child: Text('${th.icon} โลก ${k + 1}: ${th.name}  $done/${GameProgress.levelsPerWorld}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  shadows: [Shadow(color: Color(0x55000000), offset: Offset(0, 2), blurRadius: 2)],
                )),
          ),
        ),
      ),
    );
  }

  /// แผนที่ทางยาวคดเคี้ยว เลื่อนขึ้น-ลงได้ (ด่าน 1 อยู่ล่างสุด)
  Widget _buildMap() {
    final worlds = GameProgress.worldCount;
    final per = GameProgress.levelsPerWorld;
    double bnd(int k) {
      if (k <= 0) return _mapH;
      if (k >= worlds) return 0;
      return (_yOf(per * k) + _yOf(per * k + 1)) / 2;
    }

    return Container(
      margin: const EdgeInsets.only(top: 6),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
        child: LayoutBuilder(
          builder: (context, c) {
            _viewH = c.maxHeight;
            final w = c.maxWidth;
            final pts = [for (int l = 1; l <= GameProgress.totalLevels; l++) _pt(l, w)];
            final kids = <Widget>[];

            for (int k = 0; k < worlds; k++) {
              final th = _GrammarBridgeGameState._themes[k];
              final top = bnd(k + 1);
              final h = bnd(k) - top;
              kids.add(Positioned(
                left: 0,
                right: 0,
                top: top,
                height: h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [th.skyTop, th.skyBottom],
                    ),
                  ),
                ),
              ));
              final emojis = [th.deco, th.floater, th.bird, th.sun];
              for (int j = 0; j < 7; j++) {
                kids.add(Positioned(
                  top: top + (j + 0.5) * h / 7 - 15,
                  left: j.isEven ? 4 : null,
                  right: j.isEven ? null : 4,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: 0.85,
                      child: Text(emojis[j % emojis.length], style: TextStyle(fontSize: 36.0 + (j % 3) * 6)),
                    ),
                  ),
                ));
              }
            }

            // แถบเมฆคั่นระหว่างโลก ช่วยให้ฉากต่อกันนุ่มนวล
            for (int k = 1; k < worlds; k++) {
              kids.add(Positioned(
                left: 0,
                right: 0,
                top: bnd(k) - 26,
                child: IgnorePointer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      6,
                      (i) => Text('☁️', style: TextStyle(fontSize: 46.0 + (i % 2) * 10, color: Colors.white)),
                    ),
                  ),
                ),
              ));
            }

            kids.add(Positioned.fill(
              child: CustomPaint(painter: _MapPathPainter(pts, GameProgress.nextLevel)),
            ));

            for (int k = 0; k < worlds; k++) {
              kids.add(_ribbon(k, k == 0 ? _mapH - 38 : bnd(k)));
            }

            for (int l = 1; l <= GameProgress.totalLevels; l++) {
              kids.add(_node(l, pts[l - 1].dx, pts[l - 1].dy));
            }

            final sp = pts[_selected - 1];
            final th = _GrammarBridgeGameState._themes[GameProgress.stageOf(_selected)];
            kids.add(AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              left: sp.dx - 23,
              top: sp.dy - 28 - 54,
              child: IgnorePointer(child: _Bounce(height: 8, child: _UserAvatarToken(accent: th.accent))),
            ));

            return SingleChildScrollView(
              controller: _scroll,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(width: w, height: _mapH, child: Stack(clipBehavior: Clip.hardEdge, children: kids)),
            );
          },
        ),
      ),
    );
  }

  Widget _dialogBox(Color border, Widget child) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: border, width: 5),
          boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 14, offset: Offset(0, 6))],
        ),
        child: child,
      ),
    );
  }

  Widget _closeButton(BuildContext ctx, Color a, Color b, Color shadow) {
    return _Candy(
      full: true,
      a: a,
      b: b,
      edge: shadow,
      radius: 16,
      onTap: () {
        AudioHub.sfx('click.mp3');
        Navigator.pop(ctx);
      },
      child: const Text('ปิด', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
    );
  }

  void _showBook() {
    AudioHub.sfx('sticker.mp3', volume: 0.7);
    showDialog(
      context: context,
      builder: (ctx) => _dialogBox(
        _C.pink,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('📖 สมุดสะสม ${GameProgress.collection.length}/${GameProgress.stickers.length}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: _C.pinkDk)),
            const SizedBox(height: 4),
            const Text('ผ่านด่านเพื่อสะสมเพื่อนสัตว์ และตอบถูกทุกข้อในด่านเลขคู่เพื่อรับของโบนัส',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _C.inkSoft)),
            const SizedBox(height: 10),
            Flexible(
              child: GridView.count(
                crossAxisCount: 5,
                shrinkWrap: true,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: List.generate(GameProgress.stickers.length, (i) {
                  final got = GameProgress.collection.contains(i);
                  final hint = i < GameProgress.bonusStart
                      ? 'ด่าน ${i + 1}'
                      : 'เพอร์เฟกต์ ด่าน ${(i - GameProgress.bonusStart + 1) * 2}';
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: got ? const Color(0xFFFFF3E0) : const Color(0xFFF0F2FA),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: got ? _C.orange : const Color(0xFFD5D9E8), width: 2),
                    ),
                    child: got
                        ? Text(GameProgress.stickers[i], style: const TextStyle(fontSize: 28))
                        : Padding(
                            padding: const EdgeInsets.all(2),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('❓', style: TextStyle(fontSize: 18)),
                                  Text(hint, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: _C.greyDk)),
                                ],
                              ),
                            ),
                          ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            _closeButton(ctx, _C.pink, const Color(0xFFFF4F90), _C.pinkDk),
          ],
        ),
      ),
    );
  }

  void _showSettings() {
    AudioHub.sfx('click.mp3');
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => _dialogBox(
          _C.purple,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⚙️ ตั้งค่า', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: _C.purpleDk)),
              const SizedBox(height: 6),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: _C.green,
                value: GameSettings.sound,
                onChanged: (v) {
                  setD(() => GameSettings.sound = v);
                  AudioHub.sfx('click.mp3');
                  GameProgress.save();
                },
                title: const Text('🔊 เสียงเอฟเฟกต์', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: _C.ink)),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: _C.green,
                value: GameSettings.music,
                onChanged: (v) {
                  setD(() => GameSettings.music = v);
                  AudioHub.refreshBgm();
                  GameProgress.save();
                },
                title: const Text('🎵 เพลงประกอบ', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: _C.ink)),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: _C.green,
                value: GameSettings.voice,
                onChanged: (v) {
                  setD(() => GameSettings.voice = v);
                  if (v) VoiceHub.speak('Hello! Let us build a bridge.');
                  GameProgress.save();
                },
                title: const Text('🗣️ เสียงอ่านภาษาอังกฤษ', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: _C.ink)),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () async {
                  final ok = await showDialog<bool>(
                    context: ctx,
                    builder: (c) => AlertDialog(
                      title: const Text('รีเซ็ตความคืบหน้า?'),
                      content: const Text('ดาวและสมุดสะสมจะหายทั้งหมดนะ'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('ยกเลิก')),
                        TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('รีเซ็ต')),
                      ],
                    ),
                  );
                  if (ok == true) {
                    GameProgress.reset();
                    if (mounted) {
                      setState(() => _selected = 1);
                      _scrollAfterFrame(animate: true);
                    }
                    if (ctx.mounted) Navigator.pop(ctx);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBF0),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFA4B8), width: 2),
                  ),
                  child: const Text('🗑️ เริ่มเล่นใหม่ทั้งหมด',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFFD42A55))),
                ),
              ),
              const SizedBox(height: 12),
              _closeButton(ctx, _C.purple, const Color(0xFF8A63F0), _C.purpleDk),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final th = _GrammarBridgeGameState._themes[_world];
    return Scaffold(
      body: _GameScaffoldBody(
        title: 'สร้างสะพาน',
        color: const Color(0xFF2F6FE0),
        onBack: _back,
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [th.skyTop, th.skyBottom, th.pageBottom],
          ),
        ),
        child: Stack(children: [
          const Positioned.fill(child: _FloatingBackdrop()),
          SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                child: Row(
                  children: [
                    _whitePill('⭐ ${GameProgress.totalStars}/${GameProgress.totalLevels * 3}', _C.orangeDk, size: 15),
                    const Spacer(),
                    const _CoinPill(),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _Bounce(child: Text('🐼', style: TextStyle(fontSize: 34))),
                  const SizedBox(width: 8),
                  // ป้ายไม้
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFFCB80), Color(0xFFE8933F)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF8A4E1F), width: 4),
                      boxShadow: const [
                        BoxShadow(color: Color(0xFF6B3A14), offset: Offset(0, 5)),
                        BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 8)),
                      ],
                    ),
                    child: const Text('🌉 เลือกด่าน',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          shadows: [
                            Shadow(color: Color(0xFF6B3A14), offset: Offset(2, 2)),
                            Shadow(color: Color(0xFF6B3A14), offset: Offset(-2, -2)),
                            Shadow(color: Color(0xFF6B3A14), offset: Offset(2, -2)),
                            Shadow(color: Color(0xFF6B3A14), offset: Offset(-2, 2)),
                          ],
                        )),
                  ),
                  const SizedBox(width: 8),
                  const _Bounce(height: 9, child: Text('🎈', style: TextStyle(fontSize: 32))),
                ],
              ),
              const SizedBox(height: 2),
              Text('ผ่านแล้ว ${GameProgress.stars.length}/${GameProgress.totalLevels} ด่าน',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _C.ink)),
              Expanded(child: _buildMap()),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                child: Column(
                  children: [
                    _whitePill('ความยาก: ${GameProgress.difficultyLabel(_selected)} ${GameProgress.flames(_selected)}', _C.ink,
                        size: 13),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _Candy(
                            full: true,
                            onTap: _play,
                            a: _C.green,
                            b: const Color(0xFF2DCB7F),
                            edge: _C.greenDk,
                            radius: 26,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text('▶️ PLAY  LEVEL $_selected',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  shadows: [Shadow(color: Color(0x44000000), offset: Offset(0, 2), blurRadius: 2)],
                                )),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _Candy(
                          onTap: _showBook,
                          a: _C.pink,
                          b: const Color(0xFFFF4F90),
                          edge: _C.pinkDk,
                          radius: 24,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Text('📖 ${GameProgress.collection.length}',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white)),
                        ),
                        const SizedBox(width: 8),
                        _Candy(
                          onTap: _showSettings,
                          a: _C.purple,
                          b: const Color(0xFF8A63F0),
                          edge: _C.purpleDk,
                          radius: 24,
                          padding: const EdgeInsets.all(10),
                          child: const Icon(Icons.settings_rounded, color: Colors.white, size: 26),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ]),
      ),
      ),
    );
  }
}

/// วาดทางเดินคดเคี้ยวของแผนที่ (ส่วนที่ผ่านแล้วเป็นสีชมพูเข้ม)
class _MapPathPainter extends CustomPainter {
  final List<Offset> pts; // index 0 = ด่าน 1
  final int reached;
  _MapPathPainter(this.pts, this.reached);

  Path _path(int a, int b) {
    final p = Path();
    if (b <= a || a < 1 || b > pts.length) return p;
    final s = pts.sublist(a - 1, b);
    p.moveTo(s[0].dx, s[0].dy);
    for (int i = 1; i < s.length - 1; i++) {
      final mid = Offset((s[i].dx + s[i + 1].dx) / 2, (s[i].dy + s[i + 1].dy) / 2);
      p.quadraticBezierTo(s[i].dx, s[i].dy, mid.dx, mid.dy);
    }
    p.lineTo(s.last.dx, s.last.dy);
    return p;
  }

  Paint _stroke(Color c, double w) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = w
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    // ทางเดินเป็นสะพานไม้: ขอบขาว + ไม้สีอ่อน + แผ่นไม้พาดขวาง
    final full = _path(1, pts.length);
    canvas.drawPath(full, _stroke(Colors.white, 56));
    canvas.drawPath(full, _stroke(const Color(0xFFC98A4B), 48));
    canvas.drawPath(full, _stroke(const Color(0xFFFFDDA8), 40));
    _planks(canvas, full, const Color(0xFFD9A05F));
    // ส่วนที่ผ่านแล้วเป็นไม้ทอง
    final done = _path(1, reached.clamp(1, pts.length).toInt());
    canvas.drawPath(done, _stroke(const Color(0xFFFFC53D), 40));
    _planks(canvas, done, const Color(0xFFE59A1F));
  }

  void _planks(Canvas canvas, Path p, Color c) {
    final paint = Paint()
      ..color = c
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (final m in p.computeMetrics()) {
      for (double d = 12; d < m.length; d += 20) {
        final t = m.getTangentForOffset(d);
        if (t == null) continue;
        final n = Offset(-t.vector.dy, t.vector.dx);
        canvas.drawLine(t.position + n * 17, t.position - n * 17, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MapPathPainter old) => old.reached != reached || old.pts.length != pts.length;
}

// ==========================================
// 6. หน้าจอหลักเกม (Main Game Screen)
// ==========================================
class GrammarBridgeGame extends StatefulWidget {
  /// ถ้าไม่ระบุ startLevel (เช่นถูกเรียกเป็นหน้าแรกจากที่อื่น) จะแสดง "หน้าเลือกด่าน" แทน
  /// ถ้าระบุเลขด่าน จึงจะเข้าเล่นเกมด่านนั้นทันที
  final int? startLevel;
  const GrammarBridgeGame({super.key, this.startLevel});

  @override
  State<GrammarBridgeGame> createState() => _GrammarBridgeGameState();
}

class _GrammarBridgeGameState extends State<GrammarBridgeGame> with TickerProviderStateMixin {
  int _lastTickSec = -1;

  int _level = 1;
  int _maxHp = 3;
  int _hp = 3;
  int _score = 0;
  int _combo = 0;
  int _bestCombo = 0;
  int _wrongCount = 0;

  List<Question> _questions = [];
  int _currentQuestionIndex = 0;

  int _characterStep = 0;
  int _hops = 2;

  List<int> _slotTier = [];
  final Set<String> _removed = {};
  List<String?> _filled = [];
  bool _locked = false;
  bool _finished = false;
  bool _paused = false;
  bool _chestOpen = false;
  bool _pandaFell = false;
  String? _mood;
  String? _banner;
  int _tipKind = 0;
  String _tipText = '';
  int _starsEarned = 0;

  bool _confetti = false;
  int _confettiKey = 0;
  String? _speech;
  Timer? _speechTimer;
  List<String> _opts = [];
  final Set<String> _seenQuestions = {};
  String _bonusSticker = '';
  String _newSticker = '';
  bool _stickerIsNew = false;

  int _hints = 3;
  int _nets = 2;
  bool _isHintUsed = false;
  bool _isSafetyNetActive = false;

  Timer? _tick;
  Timer? _bannerTimer;
  double _stability = 1.0;
  int _secondsPerQuestion = 0;

  final List<_Fx> _fx = [];
  final List<_Fx> _falls = [];
  int _fxSeq = 0;
  int _run = 0;

  late final AnimationController _bgCtrl;
  late final AnimationController _hopCtrl;
  late final AnimationController _shakeCtrl;

  Question get _q => _questions[_currentQuestionIndex];
  bool get _hasTimer => _secondsPerQuestion > 0;
  int _tierFor(int combo) => combo >= 6 ? 2 : (combo >= 3 ? 1 : 0);

  static const List<_SceneTheme> _themes = [
    _SceneTheme(
      name: 'ป่าสดใส', icon: '🌲', sun: '☀️', floater: '☁️', bird: '🐦', fish: '🐟', deco: '🌲',
      skyTop: Color(0xFF6EC6FF), skyBottom: Color(0xFFD9F2FF), pageBottom: Color(0xFFF1FFE9),
      hill1: Color(0xFF7BE495), hill2: Color(0xFF4FD37A),
      waterTop: Color(0xFF3FC8FF), waterBottom: Color(0xFF0B78D1),
      grass: Color(0xFF4FD37A), rock: Color(0xFFB98562), rockLine: Color(0xFF9A6A49),
      accent: Color(0xFF3DC96B), accentDk: Color(0xFF1B9A47),
    ),
    _SceneTheme(
      name: 'เมืองหิมะ', icon: '⛄', sun: '☀️', floater: '❄️', bird: '🕊️', fish: '🐟', deco: '⛄',
      skyTop: Color(0xFF8FD3FF), skyBottom: Color(0xFFE8F6FF), pageBottom: Color(0xFFF7FBFF),
      hill1: Color(0xFFE6F7FF), hill2: Color(0xFFBFE8FF),
      waterTop: Color(0xFF52DDF0), waterBottom: Color(0xFF0A7C9E),
      grass: Color(0xFFFFFFFF), rock: Color(0xFFA9C0D0), rockLine: Color(0xFF8CA7BA),
      accent: Color(0xFF4DB8FF), accentDk: Color(0xFF1F86D6),
    ),
    _SceneTheme(
      name: 'แดนขนมหวาน', icon: '🍭', sun: '🌞', floater: '🎈', bird: '🦋', fish: '🐠', deco: '🍭',
      skyTop: Color(0xFFFFB3D1), skyBottom: Color(0xFFFFE3EF), pageBottom: Color(0xFFFFF4FA),
      hill1: Color(0xFFFF9EC4), hill2: Color(0xFFD9A6FF),
      waterTop: Color(0xFFC77DFF), waterBottom: Color(0xFF7B2CBF),
      grass: Color(0xFFFFB38A), rock: Color(0xFF9A6B55), rockLine: Color(0xFF7C4F3B),
      accent: Color(0xFFFF6FA5), accentDk: Color(0xFFD93A78),
    ),
    _SceneTheme(
      name: 'โอเอซิสทะเลทราย', icon: '🌵', sun: '☀️', floater: '☁️', bird: '🦅', fish: '🐠', deco: '🌵',
      skyTop: Color(0xFFFFD27A), skyBottom: Color(0xFFFFF1CF), pageBottom: Color(0xFFFFF9EA),
      hill1: Color(0xFFFFBE5C), hill2: Color(0xFFFFA93A),
      waterTop: Color(0xFF3DDDC8), waterBottom: Color(0xFF058C7B),
      grass: Color(0xFFA6E36B), rock: Color(0xFFE2B687), rockLine: Color(0xFFC79568),
      accent: Color(0xFFFFA72E), accentDk: Color(0xFFD97800),
    ),
    _SceneTheme(
      name: 'ล่องอวกาศ', icon: '🚀', sun: '🌙', floater: '⭐', bird: '🛸', fish: '🐙', deco: '🚀',
      skyTop: Color(0xFF8E9CFF), skyBottom: Color(0xFFD6DBFF), pageBottom: Color(0xFFEFF0FF),
      hill1: Color(0xFFAE9BFF), hill2: Color(0xFF8A72F5),
      waterTop: Color(0xFF7B5CF0), waterBottom: Color(0xFF2A2A9E),
      grass: Color(0xFFC7B8FF), rock: Color(0xFF5D6B9A), rockLine: Color(0xFF47537D),
      accent: Color(0xFF9B6BFF), accentDk: Color(0xFF6A3FDB),
    ),
  ];

  static const List<String> _praise = ['เก่งมาก!', 'ยอดเยี่ยม!', 'Great job!', 'Awesome!', 'ถูกต้องเลย!', 'Wow!'];
  static const List<String> _cheers = ['เก่งมาก! 🌟', 'ยอดเยี่ยม! 👏', 'Great job! 🎉', 'Awesome! 😎', 'เย้! ถูกต้อง! 🥳', 'Wow! 🤩'];
  static const List<String> _comboCheers = ['สุดยอด! 🔥', 'Amazing! ✨', 'คอมโบมาแล้ว! 🔥', 'เก่งที่สุดเลย! 💪'];
  static const List<String> _oops = ['ลองอีกที นะ 💪', 'ไม่เป็นไร! 🐼', 'สู้ๆ นะ! 🌈', 'เกือบแล้ว! 😉'];
  static const List<String> _giggles = ['จั๊กจี้~ 😆', 'หิวไผ่จัง 🎋', 'ฮี่ฮี่ 🤭', 'Hello! 👋', 'เล่นกันเถอะ! 🎈'];

  _SceneTheme get _theme => _themes[GameProgress.stageOf(_level) % _themes.length];

  @override
  void initState() {
    super.initState();
    AvatarProfile.instance.load(); // โหลดอวาตาร์ที่ผู้ใช้ตกแต่งไว้ในหน้าโปรไฟล์
    _bgCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
    _hopCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    final start = widget.startLevel;
    if (start == null) return; // โหมดแสดงหน้าเลือกด่าน ไม่ต้องโหลดเกม
    AudioHub.playBgm('bgm_game.wav');
    _loadLevel(start, first: true);
  }

  @override
  void dispose() {
    _tick?.cancel();
    _bannerTimer?.cancel();
    _speechTimer?.cancel();
    _bgCtrl.dispose();
    _hopCtrl.dispose();
    _shakeCtrl.dispose();
    AudioHub.duck(false);
    VoiceHub.stop();
    super.dispose();
  }

  /// อ่านประโยคโจทย์ (ช่องว่างอ่านว่า "blank")
  void _speakQuestion({int delayMs = 0}) {
    if (_questions.isEmpty) return;
    final text = _q.sentence;
    if (delayMs <= 0) {
      VoiceHub.speak(text);
    } else {
      _after(delayMs, () => VoiceHub.speak(text));
    }
  }

  void _playSound(String name) => AudioHub.sfx(name);

  void _playRewardSounds() {
    for (int i = 0; i < _starsEarned; i++) {
      Future.delayed(Duration(milliseconds: 500 + i * 450), () => AudioHub.sfx('star${i + 1}.mp3'));
    }
    final t = 500 + _starsEarned * 450;
    Future.delayed(Duration(milliseconds: t), () => AudioHub.sfx('coin.mp3'));
    if (_stickerIsNew || _bonusSticker.isNotEmpty) {
      Future.delayed(Duration(milliseconds: t + 450), () => AudioHub.sfx('sticker.mp3'));
    }
  }

  void _after(int ms, VoidCallback cb) {
    final run = _run;
    Future.delayed(Duration(milliseconds: ms), () {
      if (!mounted || run != _run) return;
      cb();
    });
  }

  void _loadLevel(int level, {bool first = false}) {
    _run++;
    _tick?.cancel();
    _level = level;
    _questions = QuestionBank.getQuestionsForLevel(level, _seenQuestions);
    _seenQuestions.addAll(_questions.map((q) => q.sentence));
    _currentQuestionIndex = 0;
    _characterStep = 0;
    _maxHp = level <= 10 ? 5 : 4;
    _hp = _maxHp;
    _combo = 0;
    _bestCombo = 0;
    _wrongCount = 0;
    _locked = false;
    _finished = false;
    _paused = false;
    _chestOpen = false;
    _pandaFell = false;
    _mood = null;
    _confetti = false;
    _speech = null;
    _speechTimer?.cancel();
    _isSafetyNetActive = false;
    _slotTier = List<int>.filled(_questions.length, -1);
    _fx.clear();
    _falls.clear();
    // จับเวลาตั้งแต่ด่าน 6 และค่อยๆ เร็วขึ้น (ต่ำสุด 12 วินาที)
    _secondsPerQuestion = level >= 6 ? max(12, 34 - level ~/ 2) : 0;
    _beginQuestion();
    _showBanner('${_theme.icon} ด่าน $level · ${_theme.name}  ${GameProgress.flames(level)}');
    _say('ไปกันเลย! 🚀');
    AudioHub.duck(false);
    AudioHub.sfx('level_start.mp3');
    if (!first) setState(() {});
  }

  void _beginQuestion() {
    _filled = List<String?>.filled(_q.blankCount, null);
    _opts = List<String>.from(_q.options)..shuffle(_rng);
    _removed.clear();
    _isHintUsed = false;
    _locked = false;
    _mood = null;
    _stability = 1.0;
    _tipKind = 0;
    _tipText = '';
    _startTimer();
    // อ่านโจทย์ให้ฟังอัตโนมัติเมื่อขึ้นข้อใหม่ (รอให้เสียงเริ่มด่านจบก่อน)
    _speakQuestion(delayMs: _currentQuestionIndex == 0 ? 1500 : 500);
  }

  void _startTimer() {
    _tick?.cancel();
    _lastTickSec = -1;
    if (!_hasTimer) return;
    _tick = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_locked || _finished || _paused) return;
      setState(() => _stability = max(0.0, _stability - 0.1 / _secondsPerQuestion));
      final left = (_stability * _secondsPerQuestion).ceil();
      if (left <= 5 && left > 0 && left != _lastTickSec) {
        _lastTickSec = left;
        AudioHub.sfx('tick.mp3', volume: 0.7);
      }
      if (_stability <= 0) _handleWrong(null);
    });
  }

  void _addFx(double x, double y, List<String> emojis) {
    _fx.add(_Fx(_fxSeq++, x, y, emojis));
  }

  void _say(String text, {int ms = 1600}) {
    _speech = text;
    _speechTimer?.cancel();
    _speechTimer = Timer(Duration(milliseconds: ms), () {
      if (mounted) setState(() => _speech = null);
    });
  }

  void _tapPanda() {
    if (_locked || _finished || _hopCtrl.isAnimating) return;
    HapticFeedback.lightImpact();
    AudioHub.sfx('giggle.mp3');
    setState(() {
      _hops = 2;
      _say(_pick(_giggles));
    });
    _hopCtrl.forward(from: 0);
  }

  void _showBanner(String text) {
    _banner = text;
    _bannerTimer?.cancel();
    _bannerTimer = Timer(const Duration(milliseconds: 1700), () {
      if (mounted) setState(() => _banner = null);
    });
  }

  void _handleAnswer(String option) {
    if (_locked || _finished || _removed.contains(option)) return;
    if (option == _q.correctAnswer) {
      _onCorrect();
    } else {
      _handleWrong(option);
      // อ่านคำที่เลือกผิดให้ฟัง เพื่อให้เด็กได้ยินเสียงคำนั้น
      _after(350, () => VoiceHub.speak(option));
    }
  }

  void _onCorrect() {
    final q = _q;
    final slot = _currentQuestionIndex;
    final oldTier = _tierFor(_combo);
    _tick?.cancel();
    _combo++;
    _bestCombo = max(_bestCombo, _combo);
    final tier = _tierFor(_combo);
    _score += 10 + _combo * 2 + (_stability * 10).round();

    setState(() {
      _locked = true;
      _slotTier[slot] = tier;
      _filled = List<String?>.from(q.answerParts);
      _mood = '😄';
      _say(_combo >= 3 ? _pick(_comboCheers) : _pick(_cheers));
      _tipKind = 1;
      _tipText = '${_pick(_praise)}  ${q.fullSentence}';
      if (tier > oldTier) {
        _showBanner(tier == 2 ? '✨ MAGIC BRIDGE! ✨' : '⭐ GOLD BRIDGE! ⭐');
      }
    });

    HapticFeedback.mediumImpact();
    _playSound('wood_hammer.mp3');
    AudioHub.sfx('correct.mp3', volume: 0.8);
    if (_combo >= 6) {
      AudioHub.sfx('combo3.mp3');
    } else if (_combo >= 3) {
      AudioHub.sfx('combo2.mp3');
    } else if (_combo >= 2) {
      AudioHub.sfx('combo1.mp3');
    }
    // อ่านประโยคเต็มที่ถูกต้องให้ฟัง
    _after(500, () => VoiceHub.speak(q.fullSentence));
    _after(180, () {
      setState(() => _addFx(-1 - slot.toDouble(), 0, tier == 2 ? ['✨', '💎', '⭐'] : (tier == 1 ? ['⭐', '✨', '🪙'] : ['✨', '🔨', '⭐'])));
    });
    _after(420, () {
      AudioHub.sfx('hop.mp3');
      setState(() {
        _characterStep = slot + 1;
        _hops = 2;
      });
      _hopCtrl.forward(from: 0);
    });

    _after(1900, () {
      if (slot >= _questions.length - 1) {
        _onLevelClear();
      } else {
        setState(() {
          _currentQuestionIndex++;
          _beginQuestion();
        });
      }
    });
  }

  void _handleWrong(String? option) {
    if (_locked || _finished) return;
    final q = _q;
    final slot = _currentQuestionIndex;
    _tick?.cancel();

    if (option == null) {
      AudioHub.sfx('timeout.mp3');
      setState(() {
        _locked = true;
        _tipKind = 3;
        _tipText = '⏰ หมดเวลาแล้ว ไม่เป็นไรนะ ลองอีกครั้ง! ${q.grammarRule}';
        _mood = '😅';
        _say('ใจเย็นๆ นะ 😊');
      });
      _after(1600, () {
        setState(() {
          _locked = false;
          _mood = null;
          _stability = 1.0;
        });
        _startTimer();
      });
      return;
    }

    _wrongCount++;
    final saved = _isSafetyNetActive;
    HapticFeedback.heavyImpact();

    setState(() {
      _locked = true;
      _tipKind = 2;
      _removed.add(option);
      if (saved) {
        _isSafetyNetActive = false;
        _mood = '🛡️';
        _say('ตาข่ายช่วยไว้! 🛡️');
        _tipText = '🛡️ ตาข่ายนิรภัยช่วยไว้! ${q.grammarRule}';
      } else {
        _hp--;
        _combo = 0;
        _mood = '😱';
        _say(_pick(_oops));
        _tipText = q.grammarRule;
        _falls.add(_Fx(_fxSeq++, slot.toDouble(), 0, const []));
      }
    });

    if (saved) {
      AudioHub.sfx('shield.mp3');
    } else {
      _playSound('wood_break.mp3');
      AudioHub.sfx('oops.mp3', volume: 0.8);
    }
    if (saved) {
      setState(() => _addFx(-1 - slot.toDouble(), 0, ['🛡️', '✨']));
    } else {
      _shakeCtrl.forward(from: 0);
    }

    _after(1400, () {
      if (_hp <= 0) {
        _onGameOver();
      } else {
        setState(() {
          _locked = false;
          _mood = null;
          _stability = 1.0;
        });
        _startTimer();
      }
    });
  }

  void _useHint() {
    if (_locked || _finished || _isHintUsed || _hints <= 0) return;
    AudioHub.sfx('hint.mp3');
    setState(() {
      _hints--;
      _isHintUsed = true;
      _tipKind = 3;
      _tipText = _q.grammarRule;
    });
  }

  void _useNet() {
    if (_locked || _finished || _isSafetyNetActive || _nets <= 0) return;
    AudioHub.sfx('shield.mp3');
    setState(() {
      _nets--;
      _isSafetyNetActive = true;
      _tipKind = 3;
      _tipText = '🛡️ Bamboo มีตาข่ายนิรภัยแล้ว! ตอบผิดได้ 1 ครั้งโดยไม่ตกเหว';
    });
  }

  void _onLevelClear() {
    _finished = true;
    _tick?.cancel();
    _starsEarned = _wrongCount == 0 ? 3 : (_wrongCount <= 2 ? 2 : 1);
    _score += _starsEarned * 20;
    GameProgress.record(_level, _starsEarned);
    _hints++;
    if (_starsEarned == 3) _nets++;
    final idx = (_level - 1).clamp(0, GameProgress.bonusStart - 1).toInt();
    _newSticker = GameProgress.stickers[idx];
    _stickerIsNew = GameProgress.collection.add(idx);
    _bonusSticker = '';
    if (_starsEarned == 3 && _level.isEven) {
      final b = GameProgress.bonusStart + _level ~/ 2 - 1;
      if (b < GameProgress.stickers.length && GameProgress.collection.add(b)) {
        _bonusSticker = GameProgress.stickers[b];
      }
    }
    GameProgress.save();
    HapticFeedback.heavyImpact();

    setState(() {
      _characterStep = _questions.length + 1;
      _hops = 5;
      _mood = '🎉';
      _chestOpen = true;
      _confetti = true;
      _confettiKey++;
      _say('เราทำได้แล้ว! 🎉', ms: 2400);
      _showBanner('🎉 สร้างสะพานสำเร็จ! 🎉');
      _addFx(-1000, 0, ['🎉', '⭐', '✨', '🎊']);
    });
    _hopCtrl.forward(from: 0);
    AudioHub.duck(true);
    _playSound('victory_fanfare.mp3');
    _after(2300, _showStageClearDialog);
  }

  void _onGameOver() {
    _finished = true;
    _tick?.cancel();
    AudioHub.duck(true);
    AudioHub.sfx('splash.mp3');
    Future.delayed(const Duration(milliseconds: 700), () => AudioHub.sfx('wahwah.mp3'));
    setState(() {
      _pandaFell = true;
      _mood = '😵';
    });
    _after(1500, _showGameOverDialog);
  }

  Widget _dialogShell({required Color border, required Widget child, bool lockBack = true}) {
    final dialog = Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(38),
          border: Border.all(color: border, width: 7),
          boxShadow: const [BoxShadow(color: Color(0x44000000), blurRadius: 20, offset: Offset(0, 10))],
        ),
        child: SingleChildScrollView(child: child),
      ),
    );
    // ป้องกันปุ่ม Back ของเครื่องปิดหน้าต่างผลลัพธ์โดยไม่ได้เลือกปุ่ม
    return lockBack ? PopScope(canPop: false, child: dialog) : dialog;
  }

  void _showStageClearDialog() {
    _playRewardSounds();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _dialogShell(
        border: _C.yellow,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('LEVEL $_level CLEAR! 🎉',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: _C.blueDk)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: i < _starsEarned ? 1.0 : 0.0),
                  duration: Duration(milliseconds: 600 + i * 350),
                  curve: Curves.elasticOut,
                  builder: (context, v, _) => Transform.rotate(
                    angle: (1 - v) * -0.8,
                    child: Transform.scale(
                      scale: i < _starsEarned ? v.clamp(0.0, 1.4) : 1.0,
                      child: Icon(
                        Icons.star_rounded,
                        size: i == 1 ? 68 : 54,
                        color: i < _starsEarned ? const Color(0xFFFFB800) : const Color(0xFFDDE1EE),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                _chip('🏅 $_score คะแนน', const Color(0xFFFFF4D6), _C.orangeDk),
                _chip('🔥 คอมโบสูงสุด x$_bestCombo', const Color(0xFFFFE6EE), _C.pinkDk),
                _chip('💡 ช่วยคิด +1', const Color(0xFFE2FBEE), _C.greenDk),
                if (_starsEarned == 3) _chip('🛡️ ตาข่าย +1', const Color(0xFFDDFAFB), _C.tealDk),
              ],
            ),
            const SizedBox(height: 12),
            _stickerCard(),
            const SizedBox(height: 12),
            _ruleCard(),
            const SizedBox(height: 16),
            if (_level < GameProgress.totalLevels) ...[
              SizedBox(
                width: double.infinity,
                child: _bigButton(
                  label: 'ด่านถัดไป ➔',
                  a: _C.green,
                  b: const Color(0xFF2DCB7F),
                  shadow: _C.greenDk,
                  onTap: () {
                    Navigator.pop(ctx);
                    _loadLevel(_level + 1);
                  },
                ),
              ),
              const SizedBox(height: 10),
            ] else ...[
              _chip('🏆 ผ่านครบทั้ง 50 ด่านแล้ว! เก่งที่สุดเลย', const Color(0xFFFFF4D6), _C.orangeDk),
              const SizedBox(height: 10),
            ],
            SizedBox(
              width: double.infinity,
              child: _bigButton(
                label: 'เล่นด่านนี้อีกครั้ง',
                a: _C.blue,
                b: const Color(0xFF3F9BFF),
                shadow: _C.blueDk,
                small: true,
                onTap: () {
                  Navigator.pop(ctx);
                  _loadLevel(_level);
                },
              ),
            ),
            _levelMenuButton(ctx),
          ],
        ),
      ),
    );
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _dialogShell(
        border: _C.blue,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('💦 Bamboo ตกน้ำแล้ว!',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: _C.blueDk)),
            const SizedBox(height: 6),
            const Text('ปลาน้อยช่วยพา Bamboo ขึ้นฝั่งแล้ว 🐟 ลองสร้างสะพานอีกครั้งนะ! 💪',
                textAlign: TextAlign.center, style: TextStyle(color: _C.ink, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            _chip('🏅 $_score คะแนน', const Color(0xFFE3F2FF), _C.blueDk),
            const SizedBox(height: 12),
            _ruleCard(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: _bigButton(
                label: 'ลองใหม่ 🔄',
                a: _C.green,
                b: const Color(0xFF2DCB7F),
                shadow: _C.greenDk,
                onTap: () {
                  Navigator.pop(ctx);
                  _loadLevel(_level);
                },
              ),
            ),
            _levelMenuButton(ctx),
          ],
        ),
      ),
    );
  }

  Widget _levelMenuButton(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: double.infinity,
        child: _bigButton(
          label: '🗺️ เลือกด่าน',
          a: _C.orange,
          b: const Color(0xFFFF9330),
          shadow: _C.orangeDk,
          small: true,
          onTap: () {
            Navigator.pop(ctx);
            if (mounted) Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _stickerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6EBFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD9B8FF), width: 2),
      ),
      child: Column(
        children: [
          Text((_stickerIsNew || _bonusSticker.isNotEmpty) ? '🎁 ได้เพื่อนใหม่แล้ว!' : '🧸 เพื่อนๆ ของ Bamboo',
              style: const TextStyle(fontWeight: FontWeight.w900, color: _C.purpleDk, fontSize: 14)),
          const SizedBox(height: 6),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 900),
            curve: Curves.elasticOut,
            builder: (context, v, child) => Transform.scale(scale: v, child: child),
            child: Text(_newSticker + (_bonusSticker.isEmpty ? '' : '  $_bonusSticker'), style: const TextStyle(fontSize: 52)),
          ),
          const SizedBox(height: 4),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            children: [
              for (final i in (GameProgress.collection.toList()..sort()))
                Text(GameProgress.stickers[i], style: const TextStyle(fontSize: 22)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ruleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F4FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF9ED2FF), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('📖 จำไว้นะ', style: TextStyle(fontWeight: FontWeight.w900, color: _C.blueDk, fontSize: 14)),
          const SizedBox(height: 4),
          Text(_q.grammarRule,
              style: const TextStyle(fontSize: 13, height: 1.4, color: _C.ink, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _chip(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Text(text, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: fg)),
    );
  }

  Widget _bigButton({
    required String label,
    required Color a,
    required Color b,
    required Color shadow,
    required VoidCallback onTap,
    bool small = false,
  }) {
    return _Candy(
      full: true,
      a: a,
      b: b,
      edge: shadow,
      radius: 20,
      padding: EdgeInsets.symmetric(vertical: small ? 10 : 14),
      onTap: () {
        AudioHub.sfx('click.mp3');
        onTap();
      },
      child: Text(label,
          style: TextStyle(
            fontSize: small ? 15 : 18,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            shadows: const [Shadow(color: Color(0x44000000), offset: Offset(0, 2), blurRadius: 2)],
          )),
    );
  }

  Future<void> _confirmExit() async {
    if (_paused) return; // กันเปิดหน้าต่างซ้อนกัน
    _paused = true;
    final leave = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _dialogShell(
        border: _C.orange,
        lockBack: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('ออกจากเกม?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _C.orangeDk)),
            const SizedBox(height: 6),
            const Text('Bamboo ยังข้ามสะพานไม่เสร็จนะ 🐼',
                textAlign: TextAlign.center, style: TextStyle(color: _C.ink, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: _bigButton(
                label: 'เล่นต่อ',
                a: _C.green,
                b: const Color(0xFF2DCB7F),
                shadow: _C.greenDk,
                onTap: () => Navigator.pop(ctx, false),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: _bigButton(
                label: 'ออก',
                a: _C.orange,
                b: const Color(0xFFFF9330),
                shadow: _C.orangeDk,
                small: true,
                onTap: () => Navigator.pop(ctx, true),
              ),
            ),
          ],
        ),
      ),
    );
    if (!mounted) return;
    if (leave == true) {
      Navigator.of(context).pop(); // กลับไปหน้าเลือกด่าน
    } else {
      _paused = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.startLevel == null) return const LevelSelectScreen();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_finished) {
          Navigator.of(context).pop();
        } else {
          _confirmExit();
        }
      },
      child: _buildStack(),
    );
  }

  Widget _buildStack() {
    return Stack(
      children: [
        _buildGame(),
        if (_confetti)
          Positioned.fill(
            child: IgnorePointer(
              child: Material(
                type: MaterialType.transparency,
                child: _ConfettiRain(
                  key: ValueKey('conf$_confettiKey'),
                  onDone: () {
                    if (mounted) setState(() => _confetti = false);
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// ตัวคูณขนาด UI (คำนวณจากความสูงจอ) ให้ทั้งหน้าพอดีจอเดียว
  double _s = 1.0;

  Widget _buildGame() {
    final th = _theme;
    return Scaffold(
      body: _GameScaffoldBody(
        title: 'สร้างสะพาน',
        color: const Color(0xFF2F6FE0),
        onBack: _confirmExit,
        child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [th.skyTop, th.skyBottom, th.pageBottom],
          ),
        ),
        child: Stack(children: [
          const Positioned.fill(child: _FloatingBackdrop()),
          SafeArea(
          child: LayoutBuilder(
            builder: (context, c) {
              // ย่อขนาดส่วนต่างๆ ตามความสูงจอ เพื่อให้ทุกอย่างพอดีโดยไม่ต้องเลื่อน
              _s = (c.maxHeight / 640).clamp(0.74, 1.0).toDouble();
              return Column(
                children: [
                  _buildTopBar(),
                  _buildProgressDots(),
                  // ฉากสะพานกินพื้นที่ที่เหลือทั้งหมด
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, b) {
                        final h = (b.maxHeight - 16).clamp(90.0, 320.0).toDouble();
                        return Align(alignment: Alignment.center, child: _buildScene(h));
                      },
                    ),
                  ),
                  _buildSentenceBoard(),
                  _buildTip(),
                  _buildChoices(),
                  _buildHelperBar(),
                  SizedBox(height: 8 * _s),
                ],
              );
            },
          ),
        ),
        ]),
      ),
      ),
    );
  }

  Widget _buildTopBar() {
    return _buildTopBarRow();
  }

  Widget _buildTopBarRow() {
    final th = _theme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LEVEL $_level',
                    style: TextStyle(fontSize: 18 * _s, fontWeight: FontWeight.w900, color: th.accentDk, height: 1.1)),
                Text('${th.icon} ${th.name}',
                    style: TextStyle(fontSize: 12 * _s, fontWeight: FontWeight.w800, color: _C.ink)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFFB3C6), width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                _maxHp,
                (i) => Padding(
                  padding: const EdgeInsets.only(left: 1),
                  child: AnimatedScale(
                    scale: i < _hp ? 1.0 : 0.8,
                    duration: const Duration(milliseconds: 200),
                    child: Text(i < _hp ? '❤️' : '🤍', style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _whitePill('🏅 $_score', _C.orangeDk),
          const SizedBox(width: 6),
          const _CoinPill(fontSize: 12),
        ],
      ),
    );
  }

  /// แถบความคืบหน้าของด่าน (จุดต่อข้อ)
  Widget _buildProgressDots() {
    final th = _theme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 0),
      child: Row(
        children: List.generate(_questions.length, (i) {
          final done = i < _slotTier.length && _slotTier[i] >= 0;
          final cur = i == _currentQuestionIndex && !_finished;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 9,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: done ? _C.green : (cur ? th.accent : Colors.white.withAlpha(190)),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildScene(double h) {
    return Container(
      height: h,
      margin: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: const [BoxShadow(color: Color(0x33000000), offset: Offset(0, 5), blurRadius: 10)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: LayoutBuilder(
          builder: (context, c) {
            final g = _SceneGeo(c.maxWidth, c.maxHeight, _questions.length);
            return AnimatedBuilder(
              animation: Listenable.merge([_bgCtrl, _hopCtrl, _shakeCtrl]),
              builder: (context, _) => _sceneStack(g),
            );
          },
        ),
      ),
    );
  }

  Widget _sceneStack(_SceneGeo g) {
    final th = _theme;
    final bg = _bgCtrl.value;
    final tier = _tierFor(_combo);
    final shaky = _hasTimer && !_finished && _stability < 0.35;
    final wobble = shaky ? sin(bg * pi * 2 * 14) * (1 - _stability / 0.35) * 3.0 : 0.0;
    final hopDy = -sin(_hopCtrl.value * pi * _hops).abs() * 14;
    final shakeDx = sin(_shakeCtrl.value * pi * 10) * 7 * (1 - _shakeCtrl.value);

    double pandaX;
    if (_characterStep <= 0) {
      pandaX = 20;
    } else if (_characterStep > g.slots) {
      pandaX = g.bridgeRight - 14;
    } else {
      pandaX = g.slotCenter(_characterStep - 1) - 24;
    }
    final pandaTop = _pandaFell ? g.h * 0.8 : g.deckY - 44;

    final kids = <Widget>[];

    kids.add(Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [th.skyTop, th.skyBottom],
          ),
        ),
      ),
    ));
    // แสงอาทิตย์เรืองๆ
    kids.add(Positioned(
      right: 4,
      top: -6,
      child: IgnorePointer(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [Colors.white.withAlpha(190), Colors.white.withAlpha(0)]),
          ),
        ),
      ),
    ));
    kids.add(Positioned(
      right: 16,
      top: 8,
      child: Transform.rotate(angle: bg * pi * 2, child: Text(th.sun, style: const TextStyle(fontSize: 34))),
    ));
    for (int k = 0; k < 3; k++) {
      final x = ((bg + k * 0.34) % 1.0) * (g.w + 90) - 60;
      kids.add(Positioned(
        left: x,
        top: 22.0 + k * 20,
        child: Opacity(opacity: 0.92, child: Text(th.floater, style: TextStyle(fontSize: 28.0 + k * 6))),
      ));
    }
    final bx = ((bg * 1.5) % 1.0) * (g.w + 60) - 30;
    kids.add(Positioned(
      left: g.w - bx,
      top: g.h * 0.26 + sin(bg * pi * 6) * 5,
      child: Text(th.bird, style: const TextStyle(fontSize: 18)),
    ));

    kids.add(Positioned.fill(
      child: CustomPaint(painter: _ScenePainter(t: bg, wobble: wobble, tier: tier, g: g, th: th)),
    ));

    final fp = (bg * 2) % 1.0;
    if (fp < 0.32) {
      final u = fp / 0.32;
      kids.add(Positioned(
        left: g.w * 0.36 + u * 56,
        top: g.waterTop + 6 - sin(u * pi) * 34,
        child: Transform.rotate(angle: (u - 0.5) * 1.6, child: Text(th.fish, style: const TextStyle(fontSize: 18))),
      ));
    }

    kids.add(Positioned(left: 0, top: g.deckY - 38, child: Text(th.deco, style: const TextStyle(fontSize: 32))));
    kids.add(Positioned(
      right: 2,
      top: g.deckY - 34,
      child: AnimatedScale(
        scale: _chestOpen ? 1.35 : 1.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        child: Text(_chestOpen ? '🏆' : '🎁', style: const TextStyle(fontSize: 30)),
      ),
    ));

    for (int i = 0; i < g.slots; i++) {
      final placed = _slotTier[i] >= 0;
      Widget child;
      if (placed) {
        child = _placedPlank(i, _slotTier[i]);
      } else {
        final next = i == _currentQuestionIndex && !_finished;
        final pulse = next ? 0.4 + 0.25 * sin(bg * pi * 2 * 8) : 0.25;
        child = Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((pulse * 255).round().clamp(0, 255)),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white.withAlpha(210), width: 1.5),
          ),
        );
      }
      kids.add(Positioned(
        left: g.slotLeft(i) + 1,
        top: g.deckY + wobble,
        width: g.slotW - 2,
        height: 16,
        child: child,
      ));
    }

    for (final f in _falls) {
      kids.add(Positioned(
        left: g.slotLeft(f.x.toInt()) + 1,
        top: g.deckY + wobble,
        width: g.slotW - 2,
        height: 16,
        child: _FallingPlank(
          key: ValueKey('fall${f.id}'),
          drop: g.h - g.deckY - 10,
          onDone: () {
            if (mounted) setState(() => _falls.removeWhere((e) => e.id == f.id));
          },
        ),
      ));
    }

    kids.add(AnimatedPositioned(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      left: pandaX,
      top: pandaTop,
      child: Transform.translate(
        offset: Offset(shakeDx, hopDy + (shaky && !_pandaFell ? wobble : 0.0)),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              if (_isSafetyNetActive)
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF26C6DA).withAlpha(70),
                    border: Border.all(color: const Color(0xFF26C6DA), width: 2),
                  ),
                ),
              Opacity(opacity: _pandaFell ? 0.75 : 1.0, child: _UserAvatarToken(accent: th.accent)),
              if (tier > 0 && !_pandaFell)
                const Positioned(top: -12, left: 10, child: Text('👑', style: TextStyle(fontSize: 20))),
              if (_mood != null)
                Positioned(top: -16, right: -6, child: Text(_mood!, style: const TextStyle(fontSize: 22))),
              Positioned.fill(
                child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: _tapPanda),
              ),
            ],
          ),
        ),
      ),
    ));

    if (_speech != null && !_pandaFell) {
      kids.add(AnimatedPositioned(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
        left: (pandaX - 36).clamp(2.0, max(2.0, g.w - 150)).toDouble(),
        top: pandaTop - 34,
        child: IgnorePointer(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: th.accent, width: 2),
            ),
            child: Text(_speech!,
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: _C.ink)),
          ),
        ),
      ));
    }

    for (final e in _fx) {
      double fx;
      double fy;
      if (e.x <= -1000) {
        fx = g.w - 40;
        fy = g.deckY - 20;
      } else {
        final slot = (-e.x - 1).round();
        fx = g.slotCenter(slot);
        fy = g.deckY - 10;
      }
      kids.add(Positioned(
        left: fx - 70,
        top: fy - 70,
        child: IgnorePointer(
          child: _BurstFx(
            key: ValueKey('fx${e.id}'),
            emojis: e.emojis,
            onDone: () {
              if (mounted) setState(() => _fx.removeWhere((x) => x.id == e.id));
            },
          ),
        ),
      ));
    }

    if (_hasTimer) {
      kids.add(Positioned(
        left: 10,
        top: 8,
        width: g.w * 0.5,
        child: Row(
          children: [
            Text(_stability < 0.35 ? '⚠️' : '⏱️', style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 4),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _stability,
                  minHeight: 11,
                  backgroundColor: Colors.white.withAlpha(200),
                  color: _stability > 0.5 ? _C.green : (_stability > 0.25 ? _C.orange : const Color(0xFFFF5C7A)),
                ),
              ),
            ),
          ],
        ),
      ));
    }

    if (_combo >= 2) {
      final pc = tier == 2 ? const Color(0xFF26C6DA) : (tier == 1 ? const Color(0xFFFFB800) : _C.pink);
      kids.add(Positioned(
        left: 10,
        top: _hasTimer ? 30 : 8,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: pc,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Text('🔥 x$_combo',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white)),
        ),
      ));
    }
    if (tier == 2) {
      for (int k = 0; k < 3; k++) {
        final ph = (bg * 3 + k * 0.33) % 1.0;
        kids.add(Positioned(
          left: g.bridgeLeft + (g.bridgeRight - g.bridgeLeft) * ((k + 0.5) / 3),
          top: g.deckY - 30 - ph * 18,
          child: Opacity(opacity: (1 - ph).clamp(0.0, 1.0), child: const Text('✨', style: TextStyle(fontSize: 14))),
        ));
      }
    }

    kids.add(Positioned(
      left: 0,
      right: 0,
      top: g.h * 0.2,
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: _banner == null ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 250),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [th.accentDk, _C.purpleDk]),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFFFE066), width: 2.5),
              ),
              child: Text(_banner ?? '',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFFFFE066))),
            ),
          ),
        ),
      ),
    ));

    return Stack(children: kids);
  }

  Widget _placedPlank(int index, int tier) {
    final colors = tier == 2
        ? const [Color(0xFF9CF0FF), Color(0xFF3FA9FF)]
        : tier == 1
            ? const [Color(0xFFFFEB99), Color(0xFFFFB300)]
            : const [Color(0xFFFFC98B), Color(0xFFE08A3C)];
    final border = tier == 2
        ? const Color(0xFF0277BD)
        : tier == 1
            ? const Color(0xFFE65100)
            : const Color(0xFF8A4E1F);
    return TweenAnimationBuilder<double>(
      key: ValueKey('placed$_run-$index'),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutBack,
      builder: (context, v, child) => Transform.translate(
        offset: Offset(0, (1 - v) * -34),
        child: Opacity(opacity: v.clamp(0.0, 1.0), child: child),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: colors),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: border, width: 1.5),
          boxShadow: tier > 0 ? [BoxShadow(color: colors[0].withAlpha(160), blurRadius: 8)] : null,
        ),
      ),
    );
  }

  List<InlineSpan> _textSpans(String text) {
    final kw = _q.keyWord;
    if (!_isHintUsed || kw.isEmpty || !text.contains(kw)) return [TextSpan(text: text)];
    final pieces = text.split(kw);
    final out = <InlineSpan>[];
    for (int i = 0; i < pieces.length; i++) {
      out.add(TextSpan(text: pieces[i]));
      if (i < pieces.length - 1) {
        out.add(TextSpan(
          text: kw,
          style: const TextStyle(backgroundColor: Color(0xFFFFE066), fontWeight: FontWeight.w900, color: _C.pinkDk),
        ));
      }
    }
    return out;
  }

  Widget _blank(int i) {
    final v = i < _filled.length ? _filled[i] : null;
    final done = v != null;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      constraints: const BoxConstraints(minWidth: 56),
      decoration: BoxDecoration(
        color: done ? const Color(0xFFD5FBE6) : const Color(0xFFE6F4FF),
        borderRadius: BorderRadius.circular(10),
        border: Border(bottom: BorderSide(color: done ? _C.greenDk : _C.blueDk, width: 3)),
      ),
      child: Text(
        v ?? ' ? ',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: done ? _C.greenDk : _C.blueDk,
        ),
      ),
    );
  }

  Widget _buildSentenceBoard() {
    final q = _q;
    final th = _theme;
    final parts = q.sentence.split(RegExp(r'_{3,}'));
    final spans = <InlineSpan>[];
    for (int i = 0; i < parts.length; i++) {
      spans.addAll(_textSpans(parts[i]));
      if (i < parts.length - 1) {
        spans.add(WidgetSpan(alignment: PlaceholderAlignment.middle, child: _blank(i)));
      }
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 6),
      padding: const EdgeInsets.all(3.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [th.accent, _C.pink, _C.yellow]),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [BoxShadow(color: th.accentDk.withAlpha(150), offset: const Offset(0, 4))],
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 8 * _s, 12, 8 * _s),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(23)),
        child: Row(
          children: [
            TweenAnimationBuilder<double>(
              key: ValueKey('emo$_run-$_currentQuestionIndex'),
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, v, child) => Transform.scale(scale: v, child: child),
              child: Container(
                width: 54 * _s,
                height: 54 * _s,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [th.skyBottom, th.skyTop],
                  ),
                ),
                child: Text(q.emoji, style: TextStyle(fontSize: 31 * _s)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      style: TextStyle(fontSize: 24 * _s, fontWeight: FontWeight.w800, color: _C.ink, height: 1.35),
                      children: spans,
                    ),
                  ),
                  if (q.thai.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text('💬 ${q.thai}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13.5 * _s, fontWeight: FontWeight.w700, color: _C.inkSoft, height: 1.25)),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            // ปุ่มลำโพง: แตะเพื่อฟังประโยคซ้ำ
            _Candy(
              onTap: () {
                AudioHub.sfx('click.mp3');
                _speakQuestion();
              },
              a: th.accent,
              b: th.accentDk,
              edge: th.accentDk,
              radius: 16,
              padding: EdgeInsets.all(8 * _s),
              child: Icon(Icons.volume_up_rounded, color: Colors.white, size: 24 * _s),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip() {
    Color bg;
    Color border;
    Color fg;
    String text;
    switch (_tipKind) {
      case 1:
        bg = const Color(0xFFE2FBEE);
        border = const Color(0xFF7BE0AA);
        fg = _C.greenDk;
        text = '✅ $_tipText';
        break;
      case 2:
        bg = const Color(0xFFFFF0DC);
        border = const Color(0xFFFFC272);
        fg = _C.orangeDk;
        text = '🐼 ไม่เป็นไร ลองใหม่นะ! 💡 $_tipText';
        break;
      case 3:
        bg = const Color(0xFFFFFBD9);
        border = const Color(0xFFFFE066);
        fg = const Color(0xFF8D6E00);
        text = '💡 $_tipText';
        break;
      default:
        bg = Colors.white.withAlpha(225);
        border = const Color(0xFF9ED2FF);
        fg = _C.blueDk;
        text = '👇 เลือกแผ่นไม้ที่ใช่ เพื่อสร้างสะพานให้ Bamboo!';
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 34 * _s),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 6),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6 * _s),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border, width: 2),
      ),
      child: Text(text,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13.5 * _s, fontWeight: FontWeight.w900, color: fg, height: 1.3)),
    );
  }

  Widget _buildChoices() {
    final q = _q;
    final pair = q.blankCount > 1;
    final placed = _slotTier[_currentQuestionIndex] >= 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LayoutBuilder(
        builder: (context, c) {
          final itemW = (c.maxWidth - 10) / 2;
          return Wrap(
            spacing: 10,
            runSpacing: 8 * _s,
            alignment: WrapAlignment.center,
            children: List.generate(_opts.length, (i) {
              final option = _opts[i];
              final gone = _removed.contains(option) || placed;
              return SizedBox(
                width: itemW,
                height: 64 * _s,
                child: AnimatedOpacity(
                  opacity: gone ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  child: IgnorePointer(
                    ignoring: gone,
                    child: TweenAnimationBuilder<double>(
                      key: ValueKey('c$_run-$_currentQuestionIndex-$i'),
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 350 + i * 90),
                      curve: Curves.easeOutBack,
                      builder: (context, v, child) => Transform.translate(
                        offset: Offset(0, (1 - v) * 40),
                        child: Opacity(opacity: v.clamp(0.0, 1.0), child: child),
                      ),
                      child: _PlankButton(
                        text: option,
                        colorIndex: i,
                        fontSize: (pair ? 19 : 28) * _s,
                        onTap: () => _handleAnswer(option),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _itemButton({
    required String emoji,
    required String label,
    required int count,
    required bool active,
    required VoidCallback onTap,
  }) {
    final usable = !_locked && !_finished && count > 0 && !active;
    return GestureDetector(
      onTap: usable ? onTap : null,
      child: Opacity(
        opacity: (usable || active) ? 1.0 : 0.5,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8 * _s),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFFFF6CC) : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: active ? _C.yellowDk : const Color(0xFF9ED2FF), width: 3),
            boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 5, offset: Offset(0, 3))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: TextStyle(fontSize: 20 * _s)),
              const SizedBox(width: 6),
              Text(active ? 'พร้อมใช้!' : label,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: _C.ink)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [_C.blue, _C.purple]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('x$count',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelperBar() {
    return Padding(
      padding: EdgeInsets.only(top: 8 * _s),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _itemButton(emoji: '💡', label: 'ช่วยคิด', count: _hints, active: _isHintUsed, onTap: _useHint),
          const SizedBox(width: 12),
          _itemButton(emoji: '🛡️', label: 'ตาข่ายกันตก', count: _nets, active: _isSafetyNetActive, onTap: _useNet),
        ],
      ),
    );
  }
}

// ==========================================
// แผ่นไม้ตัวเลือก (สีลูกกวาด)
// ==========================================
class _PlankButton extends StatefulWidget {
  final String text;
  final double fontSize;
  final int colorIndex;
  final VoidCallback onTap;
  const _PlankButton({required this.text, required this.fontSize, required this.colorIndex, required this.onTap});

  @override
  State<_PlankButton> createState() => _PlankButtonState();
}

class _PlankButtonState extends State<_PlankButton> {
  bool _down = false;

  static const List<List<Color>> _sets = [
    [Color(0xFFFF9EC4), Color(0xFFFF5C98), Color(0xFFD93A78)], // ชมพู
    [Color(0xFFFFD36B), Color(0xFFFFA52E), Color(0xFFD97800)], // ส้ม
    [Color(0xFF8BEFB8), Color(0xFF3DD68C), Color(0xFF1FAE6B)], // เขียว
    [Color(0xFF9AD3FF), Color(0xFF4DA3FF), Color(0xFF2B7FE0)], // ฟ้า
  ];

  @override
  Widget build(BuildContext context) {
    final c = _sets[widget.colorIndex % _sets.length];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _down = true),
      onTapUp: (_) => setState(() => _down = false),
      onTapCancel: () => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 90),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [c[0], c[1]]),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white, width: 3.5),
            boxShadow: [
              BoxShadow(color: c[2], offset: const Offset(0, 6)),
              const BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 8)),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // แสงเงาด้านบนให้ดูมันๆ
              Positioned(
                top: 4,
                left: 14,
                right: 14,
                child: Container(
                  height: 9,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(70),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Positioned(left: 9, child: _nail()),
              Positioned(right: 9, child: _nail()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.text.replaceAll(' / ', '  +  '),
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: [Shadow(color: c[2], offset: const Offset(0, 2), blurRadius: 1)],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nail() => Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(color: Colors.white.withAlpha(190), shape: BoxShape.circle),
      );
}

/// ตัวละครที่เดินข้ามสะพาน = อวาตาร์ที่ผู้ใช้ตกแต่งไว้ในหน้าโปรไฟล์
/// ฟัง AvatarProfile โดยตรง ถ้าไปเปลี่ยนชุด/ทรงผมแล้วกลับมาเล่นต่อ จะอัปเดตทันที
class _UserAvatarToken extends StatelessWidget {
  final Color accent;
  const _UserAvatarToken({required this.accent});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AvatarProfile.instance,
      builder: (context, _) {
        final p = AvatarProfile.instance;
        final outfits = p.gender == 'male' ? kMaleOutfits : kFemaleOutfits;
        final outfit = outfits[p.outfitIndex.clamp(0, outfits.length - 1)];
        final skin = kSkinTones[p.skinIndex.clamp(0, kSkinTones.length - 1)];
        final hair = kHairColors[p.hairColorIndex.clamp(0, kHairColors.length - 1)];
        return Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withAlpha(235),
            border: Border.all(color: accent, width: 2.5),
            boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: ClipOval(
            child: CustomPaint(
              painter: AvatarPainter(
                gender: p.gender,
                skinColor: skin,
                hairStyle: p.hairStyle,
                hairColor: hair,
                outfit: outfit,
                glassesStyle: p.glasses,
                hatStyle: p.hat,
                clipStyle: p.clip,
                earringStyle: p.earring,
                neckStyle: p.neck,
                extraStyle: p.extra,
              ),
            ),
          ),
        );
      },
    );
  }
}


// ---------------------------------------------------------------
// ป้ายแสดงเหรียญ (UI อย่างเดียว ไม่มีระบบเก็บเหรียญ)
// ---------------------------------------------------------------
class _CoinPill extends StatelessWidget {
  final int coins;
  final Color color;
  final double fontSize;

  const _CoinPill({
    // ignore: unused_element_parameter
    this.coins = 0,
    // ignore: unused_element_parameter
    this.color = const Color(0xFFB45309),
    this.fontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    final double fs = fontSize;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: fs * 0.7, vertical: fs * 0.3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(fs * 1.6),
        border: Border.all(color: const Color(0xFFFFD43B), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.monetization_on_rounded,
            color: const Color(0xFFFFB627),
            size: fs * 1.45,
          ),
          SizedBox(width: fs * 0.35),
          Text(
            '$coins',
            style: TextStyle(
              fontSize: fs,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: unused_element
class _CoinPillBar extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final double fontSize;

  const _CoinPillBar({
    // ignore: unused_element_parameter
    this.padding = const EdgeInsets.only(bottom: 8),
    // ignore: unused_element_parameter
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: padding,
        child: _CoinPill(fontSize: fontSize),
      ),
    );
  }
}


// ---------------------------------------------------------------
// แถบหัวเรื่องด้านบนของเกม (ปุ่มย้อนกลับ + ชื่อเกม บนพื้นสีประจำเกม)
// ---------------------------------------------------------------
class _GameHeaderBar extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback? onBack;
  final bool showBack;

  const _GameHeaderBar({
    required this.title,
    required this.color,
    this.onBack,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            children: [
              if (showBack)
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onBack ?? () => Navigator.maybePop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                )
              else
                const SizedBox(width: 34),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 44),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameScaffoldBody extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback? onBack;
  final bool showBack;
  final Widget child;

  const _GameScaffoldBody({
    required this.title,
    required this.color,
    required this.child,
    this.onBack,
    // ignore: unused_element_parameter
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GameHeaderBar(
          title: title,
          color: color,
          onBack: onBack,
          showBack: showBack,
        ),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: child,
          ),
        ),
      ],
    );
  }
}