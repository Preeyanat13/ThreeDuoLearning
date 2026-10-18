import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AnimalSound extends StatefulWidget {
  const AnimalSound({super.key});

  @override
  State<AnimalSound> createState() => _AnimalSoundState();
}

class _AnimalSoundState extends State<AnimalSound>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int combo = 0;
  int currentIndex = 0;
  bool isPlaying = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  late AnimationController _animationController;

  // ============================================================
  // COLOR PALETTE (พาสเทลน่ารัก สดใสสำหรับเด็ก)
  // ============================================================
  static const Color primarySky = Color(0xFFF59A1B);
  static const Color softSkyBackground = Color(0xFFFFEBCF);
  static const Color containerBg = Color(0xFFFFF1DC);
  static const Color borderSky = Color(0xFFFFD39A);
  static const Color darkSkyText = Color(0xFFC2650A);

  final Map<String, String> animalEmojis = {
    'BEE': '🐝',
    'BIRD': '🐦',
    'CAT': '🐱',
    'CHICKEN': '🐔',
    'DOG': '🐶',
    'DUCK': '🦆',
    'ELEPHANT': '🐘',
    'FROG': '🐸',
    'GECKO': '🦎',
    'LION': '🦁',
    'MONKEY': '🐒',
    'MOUSE': '🐭',
    'SHEEP': '🐑',
    'SNAKE': '🐍',
  };

  late List<Map<String, dynamic>> questions;

  final List<Map<String, dynamic>> rawQuestions = [
    {'soundPath': 'sounds/animal/bee.mp3', 'correctAnswer': 'BEE', 'options': ['BEE', 'BIRD', 'FROG']},
    {'soundPath': 'sounds/animal/bird.mp3', 'correctAnswer': 'BIRD', 'options': ['DUCK', 'BIRD', 'CHICKEN']},
    {'soundPath': 'sounds/animal/cat.mp3', 'correctAnswer': 'CAT', 'options': ['LION', 'CAT', 'DOG']},
    {'soundPath': 'sounds/animal/chicken.mp3', 'correctAnswer': 'CHICKEN', 'options': ['CHICKEN', 'DUCK', 'SHEEP']},
    {'soundPath': 'sounds/animal/dog.mp3', 'correctAnswer': 'DOG', 'options': ['DOG', 'CAT', 'MONKEY']},
    {'soundPath': 'sounds/animal/duck.mp3', 'correctAnswer': 'DUCK', 'options': ['BIRD', 'DUCK', 'FROG']},
    {'soundPath': 'sounds/animal/elephant.mp3', 'correctAnswer': 'ELEPHANT', 'options': ['ELEPHANT', 'LION', 'SHEEP']},
    {'soundPath': 'sounds/animal/frog.mp3', 'correctAnswer': 'FROG', 'options': ['GECKO', 'FROG', 'SNAKE']},
    {'soundPath': 'sounds/animal/gecko.mp3', 'correctAnswer': 'GECKO', 'options': ['SNAKE', 'MOUSE', 'GECKO']},
    {'soundPath': 'sounds/animal/lion.mp3', 'correctAnswer': 'LION', 'options': ['LION', 'CAT', 'DOG']},
    {'soundPath': 'sounds/animal/monkey.mp3', 'correctAnswer': 'MONKEY', 'options': ['ELEPHANT', 'MONKEY', 'BEE']},
    {'soundPath': 'sounds/animal/mouse.mp3', 'correctAnswer': 'MOUSE', 'options': ['MOUSE', 'GECKO', 'CAT']},
    {'soundPath': 'sounds/animal/sheep.mp3', 'correctAnswer': 'SHEEP', 'options': ['CHICKEN', 'SHEEP', 'DUCK']},
    {'soundPath': 'sounds/animal/snake.mp3', 'correctAnswer': 'SNAKE', 'options': ['SNAKE', 'GECKO', 'FROG']},
  ];

  @override
  void initState() {
    super.initState();
    _initGameData();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
      _animationController.stop();
    });
  }

  void _initGameData() {
    final random = Random();
    questions = List.from(rawQuestions)..shuffle(random);

    const allAnimals = [
      'BEE', 'BIRD', 'CAT', 'CHICKEN', 'DOG', 'DUCK',
      'ELEPHANT', 'FROG', 'GECKO', 'LION', 'MONKEY', 'MOUSE', 'SHEEP', 'SNAKE'
    ];

    for (var q in questions) {
      final options = List<String>.from(q['options']);
      while (options.length < 3) {
        final candidates = allAnimals.where((animal) => !options.contains(animal)).toList();
        options.add(candidates[random.nextInt(candidates.length)]);
      }
      if (options.length > 3) {
        final correctAnswer = q['correctAnswer'];
        options.removeWhere((item) => item != correctAnswer);
        options.shuffle(random);
        final selectedOptions = options.take(2).toList();
        selectedOptions.add(correctAnswer);
        q['options'] = selectedOptions..shuffle(random);
      } else {
        options.shuffle(random);
        q['options'] = options;
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _sfxPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    final String soundPath = questions[currentIndex]['soundPath'];

    try {
      await _audioPlayer.stop();
      if (!mounted) return;

      setState(() {
        isPlaying = true;
      });

      _animationController.repeat(reverse: true);
      await _audioPlayer.play(AssetSource(soundPath));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isPlaying = false;
      });
      _animationController.stop();
      debugPrint('Audio Error: $e');
    }
  }

  Future<void> _playSfx(bool isCorrect) async {
    try {
      await _sfxPlayer.stop();
      final soundFile = isCorrect ? 'sounds/correct.mp3' : 'sounds/wrong.mp3';
      await _sfxPlayer.play(AssetSource(soundFile));
    } catch (_) {}
  }

  Future<void> _checkAnswer(String selected) async {
    await _audioPlayer.stop();

    if (!mounted) return;

    setState(() {
      isPlaying = false;
    });

    _animationController.stop();

    final String correctAnswer = questions[currentIndex]['correctAnswer'];
    final bool isCorrect = selected == correctAnswer;

    if (isCorrect) {
      _playSfx(true);
      setState(() {
        combo += 1;
        int earned = 10 + (combo > 1 ? (combo - 1) * 2 : 0);
        score += earned;
      });
    } else {
      _playSfx(false);
      setState(() {
        combo = 0;
      });
    }

    final String correctEmoji = animalEmojis[correctAnswer] ?? '🐾';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: isCorrect ? const Color(0xFF86EFAC) : const Color(0xFFFECDD3),
              width: 4,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: isCorrect ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isCorrect ? Colors.green : Colors.red).withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    isCorrect ? correctEmoji : '❌',
                    style: const TextStyle(fontSize: 52),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isCorrect
                    ? (combo > 1 ? "เก่งมาก! 🔥 คอมโบ x$combo" : "ถูกต้องแล้วครับ! 🎉")
                    : "ว้า... ยังไม่ถูกน้า 🥺",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: isCorrect ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isCorrect
                    ? "ตัวนี้คือ $correctAnswer ($correctEmoji)"
                    : "คำตอบที่ถูกคือ $correctAnswer ($correctEmoji)\nลองใหม่ข้อต่อไปนะ!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primarySky,
                    elevation: 3,
                    shadowColor: const Color(0xFFC2650A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if (currentIndex < questions.length - 1) {
                      setState(() {
                        currentIndex++;
                      });
                    } else {
                      _showCompletionDialog();
                    }
                  },
                  child: Text(
                    currentIndex < questions.length - 1 ? "ข้อต่อไป ➔" : "ดูผลลัพธ์ 🏆",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  void _showCompletionDialog() {
    final int maxBaseScore = questions.length * 10;
    final double percentage = score / maxBaseScore;

    final bool passedGame = percentage >= 0.5;
    String feedbackText = "พยายามได้ดีมาก ลองเล่นอีกครั้งนะ! 💪";
    if (percentage >= 0.8) {
      feedbackText = "สุดยอดไปเลย! หนูเก่งมากๆ 👑🎉";
    } else if (percentage >= 0.5) {
      feedbackText = "เก่งจังเลย! อีกนิดเดียวจะเต็มแล้ว 🌟";
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  passedGame ? '🏆' : '💪',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 60),
                ),
                const SizedBox(height: 12),
                const Text(
                  "จบเกมแล้ว!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: darkSkyText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  feedbackText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: containerBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderSky, width: 2),
                  ),
                  child: Text(
                    "คะแนนรวม: $score คะแนน 🏅",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: darkSkyText,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primarySky,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _initGameData();
                        currentIndex = 0;
                        score = 0;
                        combo = 0;
                        isPlaying = false;
                      });
                    },
                    icon: const Icon(Icons.replay_rounded, color: Colors.white),
                    label: const Text(
                      "เล่นอีกครั้ง 🔄",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: primarySky, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.home_rounded, color: primarySky),
                    label: const Text(
                      "กลับหน้าหลัก",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primarySky,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = questions[currentIndex];
    final double progress = (currentIndex + 1) / questions.length;
    final List<String> options = List<String>.from(currentQ['options']);

    return Scaffold(
      backgroundColor: softSkyBackground,
      body: _GameScaffoldBody(
        title: 'เสียงสัตว์',
        color: const Color(0xFFF59A1B),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFDDB8), Color(0xFFFFEBD6), Color(0xFFFFF5EA)],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: ClipRect(
            child: SafeArea(
              child: Stack(
                children: [
                  // วงกลมสว่างจางๆ มุมขวาบน (หลังป้ายเหรียญ)
                  Positioned(
                    top: -50,
                    right: -50,
                    child: _bubble(Colors.white.withValues(alpha: 0.35), 190),
                  ),
                  LayoutBuilder(
                    builder: (context, box) {
                      // พอดีจอ: ถ้าจอเล็กมากจริงๆ ค่อยให้เลื่อนได้
                      final double contentH = max(box.maxHeight, 560.0);
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: SizedBox(
                          height: contentH,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Column(
                              children: [
                                _buildHeaderRow(),
                                const SizedBox(height: 8),
                                _buildProgressCard(progress),
                                const SizedBox(height: 10),
                                Expanded(flex: 4, child: _buildSoundCard()),
                                const SizedBox(height: 10),
                                _buildQuestionSign(),
                                const SizedBox(height: 10),
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    children: List.generate(
                                      options.length,
                                      (i) => Expanded(child: _buildOptionCard(i, options[i])),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- หัวเรื่อง Animal Sounds + ป้ายเหรียญ/ดาว ----------
  Widget _buildHeaderRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (rect) => const LinearGradient(
                      colors: [
                        Color(0xFFF0508C),
                        Color(0xFFFF8A3D),
                        Color(0xFFF5C400),
                        Color(0xFF3DBE6A),
                        Color(0xFF2D9CDB),
                        Color(0xFF8E5CF0),
                      ],
                    ).createShader(rect),
                    child: const Text(
                      'Animal Sounds',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Transform.rotate(
                    angle: 0.35,
                    child: const Icon(Icons.pets_rounded, color: Color(0xFF7C5CFF), size: 24),
                  ),
                ],
              ),
              const Text(
                'ทายเสียงสัตว์สนุกๆ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6B4A33),
                ),
              ),
            ],
          ),
        ),
        _buildScorePill(),
      ],
    );
  }

  Widget _buildScorePill() {
    return SizedBox(
      height: 48,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 24),
            padding: const EdgeInsets.fromLTRB(34, 6, 18, 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF9B6B4B), Color(0xFF7A4E32)],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFF6A4128), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5E3512).withValues(alpha: 0.35),
                  offset: const Offset(0, 3),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, size: 22, color: Color(0xFFFFC83D)),
                const SizedBox(width: 4),
                Text(
                  '$score',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ],
            ),
          ),
          const Positioned(left: 0, top: 1, child: _BigGoldCoin(size: 46)),
        ],
      ),
    );
  }

  // ---------- การ์ดความคืบหน้า ----------
  Widget _buildProgressCard(double progress) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F0),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFFE3C2), width: 2.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC2650A).withValues(alpha: 0.14),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'ข้อที่ ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF8A4B14)),
              ),
              const Text('⭐', style: TextStyle(fontSize: 16)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9D2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '${currentIndex + 1} / ${questions.length}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF8A4B14)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 13,
            decoration: BoxDecoration(
              color: const Color(0xFFDCEBF3),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFB9D3E2), width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: progress.clamp(0.0, 1.0)),
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOutCubic,
                builder: (context, v, _) => Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: v,
                    heightFactor: 1,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF6A4D), Color(0xFF3DD6A6), Color(0xFF46CF8B)],
                          stops: [0.0, 0.25, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- การ์ดป่า + ปุ่มลำโพง (ยืดหดตามความสูงที่เหลือ) ----------
  Widget _buildSoundCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D5B).withValues(alpha: 0.2),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: LayoutBuilder(
          builder: (context, box) {
            final double ch = box.maxHeight;
            final double s = (ch / 172).clamp(0.6, 1.1);
            final double btn = (ch - 46).clamp(60.0, 112.0);
            final double btnTop = min(ch - btn - 3, 32.0);
            return Stack(
              children: [
                const Positioned.fill(child: CustomPaint(painter: _JunglePainter())),
                Positioned(left: 2, top: 4, child: Text('🌴', style: TextStyle(fontSize: 34 * s))),
                Positioned(right: 4, top: 2, child: Text('🌿', style: TextStyle(fontSize: 30 * s))),
                Positioned(left: 64 * s, top: 52 * s, child: Text('🐦', style: TextStyle(fontSize: 26 * s))),
                Positioned(right: 58 * s, top: 44 * s, child: Text('🦜', style: TextStyle(fontSize: 26 * s))),
                Positioned(left: 8, bottom: 6, child: Text('🦁', style: TextStyle(fontSize: 66 * s))),
                Positioned(right: 6, bottom: 4, child: Text('🐘', style: TextStyle(fontSize: 70 * s))),
                Positioned(
                  top: 6,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E2).withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFFDDB5), width: 1.5),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🎧 ', style: TextStyle(fontSize: 13)),
                          Text(
                            'แตะเพื่อฟังเสียงสัตว์',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF8A4B14)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: btnTop,
                  left: 0,
                  right: 0,
                  child: Center(child: _buildSpeakerButton(btn)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSpeakerButton(double size) {
    final Color glow = isPlaying ? const Color(0xFFFF5252) : const Color(0xFFFF7A2F);
    return GestureDetector(
      onTap: _playSound,
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 1.08).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
        ),
        child: Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(size * 0.055),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.85),
            boxShadow: [
              BoxShadow(
                color: glow.withValues(alpha: 0.4),
                blurRadius: 18,
                spreadRadius: isPlaying ? 4 : 1,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-0.3, -0.4),
                radius: 1.0,
                colors: isPlaying
                    ? const [Color(0xFFFF8A8A), Color(0xFFE53935)]
                    : const [Color(0xFFFF9A52), Color(0xFFE8412A)],
              ),
              border: Border.all(color: const Color(0xFFFFC9A6), width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isPlaying ? Icons.graphic_eq_rounded : Icons.volume_up_rounded,
                  size: size * 0.38,
                  color: Colors.white,
                ),
                Text(
                  isPlaying ? 'กำลังเล่น...' : 'กดตรงนี้',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: (size * 0.115).clamp(10.0, 13.0),
                    fontWeight: FontWeight.w900,
                    shadows: const [Shadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0x66000000))],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- ป้ายไม้คำถาม (+ combo) ----------
  Widget _buildQuestionSign() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFB98154), Color(0xFF9A6338)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF6B4020), width: 2.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5E3512).withValues(alpha: 0.5),
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🤔 ', style: TextStyle(fontSize: 20)),
              Text(
                'Which animal is it?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFFFF3D0),
                  shadows: [Shadow(offset: Offset(0, 1.5), blurRadius: 1, color: Color(0xFF5E3512))],
                ),
              ),
            ],
          ),
        ),
        if (combo > 1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE082),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFFB300), width: 2),
            ),
            child: Text(
              '🔥 x$combo',
              style: const TextStyle(color: Color(0xFFBF360C), fontSize: 14, fontWeight: FontWeight.w900),
            ),
          ),
      ],
    );
  }

  // ---------- การ์ดตัวเลือก (ลายขน / ขนฟู / เกล็ด) ยืดหดตามพื้นที่ ----------
  Widget _buildOptionCard(int index, String title) {
    final pal = _optionPalettes[index % _optionPalettes.length];
    final String emoji = animalEmojis[title] ?? '🐾';

    return LayoutBuilder(
      builder: (context, box) {
        final double cardH = max(box.maxHeight - 8, 40.0); // เผื่อที่ให้เงาด้านล่าง
        final double tile = (cardH - 6 - 16).clamp(32.0, 58.0);
        final double btn = (tile * 0.84).clamp(30.0, 48.0);
        final double titleSize = (tile * 0.42).clamp(15.0, 24.0);

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(26),
              onTap: () => _checkAnswer(title),
              child: Container(
                width: double.infinity,
                height: cardH,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: pal.border, width: 3),
                  gradient: LinearGradient(colors: [pal.bgLeft, pal.bgRight]),
                  boxShadow: [
                    BoxShadow(color: pal.shadow, offset: const Offset(0, 6)),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(23),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(painter: _TexturePainter(pal.kind, pal.texBase, pal.texAccent)),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Container(
                                width: tile,
                                height: tile,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: pal.border.withValues(alpha: 0.55), width: 2.5),
                                ),
                                child: Text(emoji, style: TextStyle(fontSize: tile * 0.58)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: titleSize,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                    color: pal.text,
                                  ),
                                ),
                              ),
                              Container(
                                width: btn,
                                height: btn,
                                padding: const EdgeInsets.all(3.5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: SweepGradient(colors: pal.ring),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: pal.btn,
                                    ),
                                  ),
                                  child: Icon(Icons.touch_app_rounded, color: Colors.white, size: btn * 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bubble(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  // ignore: unused_element
  Widget _roundIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderSky, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 0,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 24),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// ป้ายแสดงเหรียญ
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
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 0,
            offset: Offset(0, 3),
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
    // ignore: unused_element_parameter
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

// ---------------------------------------------------------------
// ชุดสีของการ์ดตัวเลือกแต่ละใบ
// ---------------------------------------------------------------
enum _TexKind { fur, fluff, scales }

class _OptionPalette {
  final Color border;
  final Color shadow;
  final Color bgLeft;
  final Color bgRight;
  final Color text;
  final _TexKind kind;
  final Color texBase;
  final Color texAccent;
  final List<Color> ring;
  final List<Color> btn;

  const _OptionPalette({
    required this.border,
    required this.shadow,
    required this.bgLeft,
    required this.bgRight,
    required this.text,
    required this.kind,
    required this.texBase,
    required this.texAccent,
    required this.ring,
    required this.btn,
  });
}

const List<_OptionPalette> _optionPalettes = [
  _OptionPalette(
    border: Color(0xFFF5A524),
    shadow: Color(0xFFE08A0B),
    bgLeft: Color(0xFFFFF3DC),
    bgRight: Color(0xFFF3DDB8),
    text: Color(0xFF7A3B12),
    kind: _TexKind.fur,
    texBase: Color(0xFFC99A68),
    texAccent: Color(0xFF8E6338),
    ring: [Color(0xFFFFB347), Color(0xFFB66DFF), Color(0xFFFF7A59), Color(0xFFFFB347)],
    btn: [Color(0xFFFFB05A), Color(0xFFE8700F)],
  ),
  _OptionPalette(
    border: Color(0xFFF06FA6),
    shadow: Color(0xFFDB4585),
    bgLeft: Color(0xFFFFE6F0),
    bgRight: Color(0xFFFFC4DB),
    text: Color(0xFF8E1F4F),
    kind: _TexKind.fluff,
    texBase: Color(0xFFF7A8C8),
    texAccent: Color(0xFFFFFFFF),
    ring: [Color(0xFFFF6FA8), Color(0xFF4FC3F7), Color(0xFFB66DFF), Color(0xFFFF6FA8)],
    btn: [Color(0xFFFF7FB0), Color(0xFF3BA8E0)],
  ),
  _OptionPalette(
    border: Color(0xFF3DBE6A),
    shadow: Color(0xFF2A9A52),
    bgLeft: Color(0xFFE6FAE4),
    bgRight: Color(0xFFBFE8A8),
    text: Color(0xFF14532D),
    kind: _TexKind.scales,
    texBase: Color(0xFF6DBA3B),
    texAccent: Color(0xFFD4EC6B),
    ring: [Color(0xFF3DBE6A), Color(0xFFF5A524), Color(0xFF4FC3F7), Color(0xFF3DBE6A)],
    btn: [Color(0xFF5ED08A), Color(0xFF2A9A52)],
  ),
];

// ---------------------------------------------------------------
// เหรียญทองใหญ่ (ป้ายคะแนน)
// ---------------------------------------------------------------
class _BigGoldCoin extends StatelessWidget {
  final double size;
  const _BigGoldCoin({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFEB8A), Color(0xFFF5B000)],
        ),
        border: Border.all(color: const Color(0xFFD98E00), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        width: size * 0.72,
        height: size * 0.72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE5A100), width: 2),
        ),
        child: Text(
          '\$',
          style: TextStyle(
            fontSize: size * 0.5,
            fontWeight: FontWeight.w900,
            color: const Color(0xFFC77700),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// ฉากป่าในการ์ดลำโพง
// ---------------------------------------------------------------
class _JunglePainter extends CustomPainter {
  const _JunglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final full = Offset.zero & size;

    // ท้องฟ้า
    canvas.drawRect(
      full,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFBDE8F0), Color(0xFFDDF3E4), Color(0xFFD5EDB8)],
          stops: [0.0, 0.55, 1.0],
        ).createShader(full),
    );

    // ต้นไม้ไกลๆ
    final far = Paint()..color = const Color(0xFF9ED08A).withValues(alpha: 0.55);
    for (final c in [
      Offset(w * 0.18, h * 0.5),
      Offset(w * 0.3, h * 0.46),
      Offset(w * 0.72, h * 0.48),
      Offset(w * 0.86, h * 0.44),
    ]) {
      canvas.drawCircle(c, h * 0.2, far);
    }

    // ลำต้นข้างๆ
    final trunk = Paint()..color = const Color(0xFF8A6A4A).withValues(alpha: 0.45);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.04, 0, w * 0.035, h * 0.75), const Radius.circular(6)),
      trunk,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.93, 0, w * 0.035, h * 0.7), const Radius.circular(6)),
      trunk,
    );

    // พื้นหญ้า
    final hill = Path()
      ..moveTo(0, h * 0.78)
      ..quadraticBezierTo(w * 0.3, h * 0.66, w * 0.55, h * 0.76)
      ..quadraticBezierTo(w * 0.8, h * 0.86, w, h * 0.72)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      hill,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB5E07C), Color(0xFF8CC85A)],
        ).createShader(Rect.fromLTWH(0, h * 0.65, w, h * 0.35)),
    );

    // ใบไม้มุมล่าง
    void leaf(double x, double y, double len, double angle, Color c) {
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: len, height: len * 0.38), Paint()..color = c);
      canvas.restore();
    }

    leaf(w * 0.02, h * 0.95, 70, -0.7, const Color(0xFF5FAE4A).withValues(alpha: 0.9));
    leaf(w * 0.1, h * 1.0, 60, -1.1, const Color(0xFF7CC35B).withValues(alpha: 0.9));
    leaf(w * 0.98, h * 0.95, 76, 0.7, const Color(0xFF5FAE4A).withValues(alpha: 0.9));
    leaf(w * 0.9, h * 1.0, 62, 1.1, const Color(0xFF7CC35B).withValues(alpha: 0.9));
    leaf(w * 0.0, h * 0.62, 54, 0.5, const Color(0xFFD98BC5).withValues(alpha: 0.8));

    // แสงจากด้านบน
    final glow = Offset(w * 0.5, 0);
    canvas.drawCircle(
      glow,
      w * 0.45,
      Paint()
        ..shader = RadialGradient(
          colors: [Colors.white.withValues(alpha: 0.5), Colors.white.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: glow, radius: w * 0.45)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------
// ลายพื้นผิวฝั่งขวาของการ์ดตัวเลือก (ขน / ขนฟู / เกล็ด)
// ---------------------------------------------------------------
class _TexturePainter extends CustomPainter {
  final _TexKind kind;
  final Color base;
  final Color accent;

  const _TexturePainter(this.kind, this.base, this.accent);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final start = w * 0.42;
    final region = Rect.fromLTWH(start, 0, w - start, h);

    // โทนสีไล่เข้าจากกลางการ์ดไปขวา
    canvas.drawRect(
      region,
      Paint()
        ..shader = LinearGradient(
          colors: [base.withValues(alpha: 0.0), base.withValues(alpha: 0.6)],
        ).createShader(region),
    );

    double ramp(double x) => ((x - start) / (w * 0.3)).clamp(0.0, 1.0);
    final rnd = Random(3);

    switch (kind) {
      case _TexKind.fur:
        final p = Paint()
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round;
        for (int i = 0; i < 260; i++) {
          final x = start + rnd.nextDouble() * (w - start);
          final y = rnd.nextDouble() * h;
          final a = ramp(x);
          final len = 6 + rnd.nextDouble() * 7;
          p.color = (rnd.nextBool() ? base : accent).withValues(alpha: 0.55 * a);
          canvas.drawLine(Offset(x, y), Offset(x + len * 0.5, y + len), p);
        }
        break;
      case _TexKind.fluff:
        final p = Paint();
        for (int i = 0; i < 90; i++) {
          final x = start + rnd.nextDouble() * (w - start);
          final y = rnd.nextDouble() * h;
          final a = ramp(x);
          final r = 3 + rnd.nextDouble() * 4;
          p.color = (rnd.nextBool() ? accent : base).withValues(alpha: 0.45 * a);
          canvas.drawCircle(Offset(x, y), r, p);
        }
        break;
      case _TexKind.scales:
        final p = Paint();
        int row = 0;
        for (double y = 4; y < h; y += 9) {
          final shift = (row % 2) * 5.0;
          for (double x = start + shift; x < w; x += 10) {
            final a = ramp(x);
            if (a <= 0) continue;
            p.color = base.withValues(alpha: 0.85 * a);
            canvas.drawCircle(Offset(x, y), 5.2, p);
            p.color = accent.withValues(alpha: 0.7 * a);
            canvas.drawCircle(Offset(x - 1.4, y - 1.4), 1.8, p);
          }
          row++;
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _TexturePainter old) =>
      old.kind != kind || old.base != base || old.accent != accent;
}