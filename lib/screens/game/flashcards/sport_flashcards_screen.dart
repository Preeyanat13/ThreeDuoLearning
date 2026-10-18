import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_tts/flutter_tts.dart';

// ============================================================================
// 1. หน้าเรียนรู้แฟลชการ์ดหมวดกีฬา (SportsFlashcardsScreen)
// ============================================================================
class SportsFlashcardsScreen extends StatefulWidget {
  const SportsFlashcardsScreen({super.key});

  @override
  State<SportsFlashcardsScreen> createState() =>
      _SportsFlashcardsScreenState();
}

class _SportsFlashcardsScreenState extends State<SportsFlashcardsScreen>
    with SingleTickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();

  int currentCard = 0;
  bool isFlipped = false;
  bool isSpeaking = false;
  bool _ttsReady = false;

  late AnimationController _speakerPulseController;

  // รายการคำศัพท์แฟลชการ์ด
  late List<Map<String, String>> flashcards;

  final List<Map<String, String>> initialFlashcards = const [
    {
      'word': 'Badminton',
      'meaning': 'แบดมินตัน',
      'image': 'assets/images/Sport/Badminton.png',
    },
    {
      'word': 'Baseball',
      'meaning': 'เบสบอล',
      'image': 'assets/images/Sport/Baseball.png',
    },
    {
      'word': 'Basketball',
      'meaning': 'บาสเกตบอล',
      'image': 'assets/images/Sport/Basketball.jpg',
    },
    {
      'word': 'Cycling',
      'meaning': 'ปั่นจักรยาน',
      'image': 'assets/images/Sport/Cycling.jpg',
    },
    {
      'word': 'Running',
      'meaning': 'วิ่ง',
      'image': 'assets/images/Sport/Running.jpg',
    },
    {
      'word': 'Soccer',
      'meaning': 'ฟุตบอล',
      'image': 'assets/images/Sport/Soccer.png',
    },
    {
      'word': 'Swimming',
      'meaning': 'ว่ายน้ำ',
      'image': 'assets/images/Sport/Swimming.jpg',
    },
    {
      'word': 'Table Tennis',
      'meaning': 'ปิงปอง',
      'image': 'assets/images/Sport/Table Tennis.png',
    },
    {
      'word': 'Tennis',
      'meaning': 'เทนนิส',
      'image': 'assets/images/Sport/Tennis.jpg',
    },
    {
      'word': 'Volleyball',
      'meaning': 'วอลเลย์บอล',
      'image': 'assets/images/Sport/Volleyball.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    flashcards = List.from(initialFlashcards);
    _speakerPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      flutterTts.setStartHandler(() {
        if (!mounted) return;
        setState(() => isSpeaking = true);
      });

      flutterTts.setCompletionHandler(() {
        if (!mounted) return;
        setState(() => isSpeaking = false);
      });

      flutterTts.setCancelHandler(() {
        if (!mounted) return;
        setState(() => isSpeaking = false);
      });

      flutterTts.setErrorHandler((message) {
        if (!mounted) return;
        setState(() => isSpeaking = false);
        debugPrint('TTS Error: $message');
      });

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await flutterTts.setSharedInstance(true);
        await flutterTts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
            IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
          ],
          IosTextToSpeechAudioMode.defaultMode,
        );
      }

      final available =
          await flutterTts.isLanguageAvailable('en-US') as bool? ?? true;

      await flutterTts.setLanguage(available ? 'en-US' : 'en-GB');
      await flutterTts.setSpeechRate(0.40);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.1);
      await flutterTts.setQueueMode(0);

      _ttsReady = true;
    } catch (e) {
      debugPrint('TTS initialization error: $e');
      _ttsReady = false;
    }
  }

  @override
  void dispose() {
    _speakerPulseController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> speakWord() async {
    final word = flashcards[currentCard]['word']!;
    try {
      if (isSpeaking) {
        await flutterTts.stop();
        if (mounted) setState(() => isSpeaking = false);
        return;
      }
      if (!_ttsReady) await _initTts();

      await flutterTts.stop();
      await flutterTts.setLanguage('en-US');
      await flutterTts.setSpeechRate(0.40);
      await flutterTts.setPitch(1.1);
      await flutterTts.speak(word);
    } catch (e) {
      debugPrint('Speak word error: $e');
      if (mounted) setState(() => isSpeaking = false);
    }
  }

  Future<void> speakThaiWord() async {
    final meaning = flashcards[currentCard]['meaning']!;
    try {
      if (isSpeaking) {
        await flutterTts.stop();
        if (mounted) setState(() => isSpeaking = false);
        return;
      }
      if (!_ttsReady) await _initTts();

      await flutterTts.stop();
      final available =
          await flutterTts.isLanguageAvailable('th-TH') as bool? ?? false;

      if (!available) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFFE91E63),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              content: const Text(
                'เครื่องนี้ยังไม่มีระบบเสียงภาษาไทย',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
        return;
      }

      await flutterTts.setLanguage('th-TH');
      await flutterTts.setSpeechRate(0.40);
      await flutterTts.setPitch(1.1);
      await flutterTts.speak(meaning);
    } catch (e) {
      debugPrint('Speak Thai error: $e');
      if (mounted) setState(() => isSpeaking = false);
    }
  }

  // ฟังก์ชันย้อนกลับไปคำศัพท์ก่อนหน้า
  Future<void> previousCard() async {
    await flutterTts.stop();
    if (currentCard > 0) {
      setState(() {
        currentCard--;
        isFlipped = false;
        isSpeaking = false;
      });
      speakWord();
    }
  }

  // ฟังก์ชันถัดไป
  Future<void> handleNextOrFinish() async {
    await flutterTts.stop();
    if (currentCard < flashcards.length - 1) {
      setState(() {
        currentCard++;
        isFlipped = false;
        isSpeaking = false;
      });
      speakWord();
    } else {
      if (context.mounted) {
        _showCompletionDialog();
      }
    }
  }

  // ฟังก์ชันสุ่มการ์ด (Shuffle)
  void shuffleCards() {
    flutterTts.stop();
    setState(() {
      flashcards.shuffle();
      currentCard = 0;
      isFlipped = false;
      isSpeaking = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFE91E63),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Text(
          '🎲 สุ่มคำศัพท์เรียบร้อยแล้ว!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
    speakWord();
  }

  void flipCard() {
    setState(() {
      isFlipped = !isFlipped;
    });
    if (isFlipped) {
      speakThaiWord();
    } else {
      speakWord();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        backgroundColor: const Color(0xFFFFFBEB),
        title: const Column(
          children: [
            Text('⚽🎉', style: TextStyle(fontSize: 52)),
            SizedBox(height: 8),
            Text(
              'เก่งมากเลยเด็กๆ!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFFE91E63),
              ),
            ),
          ],
        ),
        content: const Text(
          'น้อง ๆ เรียนรู้คำศัพท์หมวดกีฬาครบแล้ว!\nไปลุยทำแบบฝึกหัดกันเลยน้า 🏀🏆✨',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF475569),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                elevation: 6,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SportsListeningQuizScreen(
                      flashcards: flashcards,
                    ),
                  ),
                );
              },
              child: const Text(
                'เริ่มแบบฝึกหัด 🚀',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final card = flashcards[currentCard];
    final bool isLastCard = currentCard == flashcards.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC), // พื้นหลังชมพูครีมพาสเทล
      body: _GameScaffoldBody(
        title: 'กีฬาสุดสนุก',
        color: const Color(0xFFE91E63),
        onBack: () async {
          await flutterTts.stop();
          if (context.mounted) Navigator.pop(context);
        },
        child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              // แถวบน: ปุ่มสุ่ม + เหรียญ (รวมเป็นแถวเดียวเพื่อประหยัดพื้นที่)
              Row(
                children: [
                  const Spacer(),
                  // ปุ่มสุ่มคำศัพท์ (Shuffle)
                  GestureDetector(
                    onTap: shuffleCards,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFFFB74D), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6D00).withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shuffle_rounded,
                        color: Color(0xFFFF6D00),
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const _CoinPill(fontSize: 14),
                ],
              ),

              const SizedBox(height: 10),

              // Progress Bar + ตัวเลขบอกตำแหน่ง
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 14,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFF8BBD0), width: 1.5),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final progressWidth = (constraints.maxWidth *
                              ((currentCard + 1) / flashcards.length));
                          return Stack(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: progressWidth,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF00E676), Color(0xFF00C853)],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE91E63),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${currentCard + 1}/${flashcards.length}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Main Interactive Flashcard
              Expanded(
                child: GestureDetector(
                  onTap: flipCard,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: Tween<double>(begin: 0.90, end: 1.0)
                            .animate(animation),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      key: ValueKey('${currentCard}_$isFlipped'),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(
                          color: isFlipped
                              ? const Color(0xFF00C853)
                              : const Color(0xFFE91E63),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (isFlipped
                                    ? const Color(0xFF00C853)
                                    : const Color(0xFFE91E63))
                                .withOpacity(0.22),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: isFlipped
                              ? _buildBackCard(card)
                              : _buildFrontCard(card),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 3D Control Navigation Buttons (ย้อนกลับ & คำถัดไป)
              Row(
                children: [
                  // 👈 ปุ่มย้อนกลับไปคำก่อนหน้า
                  if (currentCard > 0) ...[
                    GestureDetector(
                      onTap: previousCard,
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                              color: const Color(0xFFE91E63).withOpacity(0.4),
                              width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE91E63).withOpacity(0.18),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.arrow_back_rounded,
                              color: Color(0xFFE91E63),
                              size: 26,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'ก่อนหน้า',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFE91E63),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],

                  // 👉 ปุ่มคำถัดไป / เริ่มแบบฝึกหัด
                  Expanded(
                    child: GestureDetector(
                      onTap: handleNextOrFinish,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            colors: isLastCard
                                ? [
                                    const Color(0xFF00E676),
                                    const Color(0xFF00C853)
                                  ]
                                : [
                                    const Color(0xFFEC407A),
                                    const Color(0xFFD81B60)
                                  ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (isLastCard
                                      ? const Color(0xFF00C853)
                                      : const Color(0xFFE91E63))
                                  .withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLastCard ? 'เริ่มแบบฝึกหัด 🧩' : 'คำถัดไป ➡️',
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

  Widget _buildFrontCard(Map<String, String> card) {
    return Column(
      children: [
        // กรอบกระดาษรูปภาพสีขาวล้วน
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: const Color(0xFFF1F5F9),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      card['image']!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.sports_soccer_rounded,
                          size: 80,
                          color: Color(0xFFE91E63),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFB74D), width: 1.5),
                    ),
                    child: const Text(
                      '⭐ English',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFF57C00),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // ศัพท์อังกฤษ + ปุ่มลำโพง
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                card['word']!,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
                textAlign: TextAlign.center,
              ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: speakWord,
              child: AnimatedBuilder(
                animation: _speakerPulseController,
                builder: (context, child) {
                  final scale = isSpeaking
                      ? 1.0 + (_speakerPulseController.value * 0.15)
                      : 1.0;
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEC407A), Color(0xFFD81B60)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE91E63).withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        isSpeaking
                            ? Icons.volume_up_rounded
                            : Icons.volume_up_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // แถบสัมผัสเพื่อดูคำแปล
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFFFB74D), width: 1.5),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.touch_app_rounded, color: Color(0xFFF57C00), size: 18),
              SizedBox(width: 6),
              Text(
                'แตะการ์ดเพื่อดูคำแปล 💡',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFF57C00),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackCard(Map<String, String> card) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: const Color(0xFFF1F5F9),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      card['image']!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.sports_soccer_rounded,
                          size: 80,
                          color: Color(0xFF00C853),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF81C784), width: 1.5),
                    ),
                    child: const Text(
                      '🇹🇭 ภาษาไทย',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // คำแปลไทย
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                card['meaning']!,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF00C853),
                ),
                textAlign: TextAlign.center,
              ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: speakThaiWord,
              child: AnimatedBuilder(
                animation: _speakerPulseController,
                builder: (context, child) {
                  final scale = isSpeaking
                      ? 1.0 + (_speakerPulseController.value * 0.15)
                      : 1.0;
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00E676), Color(0xFF00C853)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00C853).withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        isSpeaking
                            ? Icons.volume_up_rounded
                            : Icons.volume_up_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF81C784), width: 1.5),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.sync_rounded, color: Color(0xFF00C853), size: 18),
              SizedBox(width: 6),
              Text(
                'แตะเพื่อพลิกกลับ 🔄',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF00C853),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// 2. หน้าแบบฝึกหัดหมวดกีฬา (SportsListeningQuizScreen)
// ============================================================================
class SportsListeningQuizScreen extends StatefulWidget {
  final List<Map<String, String>> flashcards;

  const SportsListeningQuizScreen({super.key, required this.flashcards});

  @override
  State<SportsListeningQuizScreen> createState() =>
      _SportsListeningQuizScreenState();
}

class _SportsListeningQuizScreenState extends State<SportsListeningQuizScreen>
    with SingleTickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();

  int currentQuestionIndex = 0;
  int score = 0;
  bool isSpeaking = false;
  bool _ttsReady = false;

  late AnimationController _speakerPulseController;

  List<Map<String, String>> currentOptions = [];
  Map<String, String>? currentCorrectAnswer;

  @override
  void initState() {
    super.initState();
    _speakerPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _initTts().then((_) {
      _loadQuestion();
    });
  }

  Future<void> _initTts() async {
    try {
      flutterTts.setStartHandler(() {
        if (!mounted) return;
        setState(() => isSpeaking = true);
      });

      flutterTts.setCompletionHandler(() {
        if (!mounted) return;
        setState(() => isSpeaking = false);
      });

      flutterTts.setCancelHandler(() {
        if (!mounted) return;
        setState(() => isSpeaking = false);
      });

      flutterTts.setErrorHandler((message) {
        if (!mounted) return;
        setState(() => isSpeaking = false);
        debugPrint('TTS Error: $message');
      });

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await flutterTts.setSharedInstance(true);
        await flutterTts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
            IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
          ],
          IosTextToSpeechAudioMode.defaultMode,
        );
      }

      final isAvailable =
          await flutterTts.isLanguageAvailable('en-US') as bool? ?? true;

      await flutterTts.setLanguage(isAvailable ? 'en-US' : 'en-GB');
      await flutterTts.setSpeechRate(0.40);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.1);
      await flutterTts.setQueueMode(0);

      _ttsReady = true;
    } catch (e) {
      debugPrint('TTS initialization error: $e');
      _ttsReady = false;
    }
  }

  void _loadQuestion() {
    currentCorrectAnswer = widget.flashcards[currentQuestionIndex];

    List<Map<String, String>> wrongOptions = List.from(widget.flashcards)
      ..removeAt(currentQuestionIndex);
    wrongOptions.shuffle();

    List<Map<String, String>> options = [
      currentCorrectAnswer!,
      wrongOptions[0],
      wrongOptions[1],
      wrongOptions[2],
    ];
    options.shuffle();

    setState(() {
      currentOptions = options;
    });

    speakWord();
  }

  @override
  void dispose() {
    _speakerPulseController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  Future<void> speakWord() async {
    if (currentCorrectAnswer == null) return;
    final word = currentCorrectAnswer!['word']!;
    try {
      if (isSpeaking) {
        await flutterTts.stop();
        if (mounted) setState(() => isSpeaking = false);
      }
      if (!_ttsReady) await _initTts();

      await flutterTts.stop();
      await flutterTts.setLanguage('en-US');
      await flutterTts.setSpeechRate(0.40);
      await flutterTts.setPitch(1.1);
      await flutterTts.speak(word);
    } catch (e) {
      debugPrint('Speak word error: $e');
      if (mounted) setState(() => isSpeaking = false);
    }
  }

  void _checkAnswer(Map<String, String> selected) {
    flutterTts.stop();
    final bool isCorrect = selected['word'] == currentCorrectAnswer!['word'];

    if (isCorrect) {
      score++;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        backgroundColor: const Color(0xFFFFFBEB),
        title: Column(
          children: [
            Text(
              isCorrect ? '🎉 ถูกต้องครับ!' : '❌ ตอบผิดน้า...',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: isCorrect
                    ? const Color(0xFF00C853)
                    : const Color(0xFFFF5252),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 110,
              width: 110,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isCorrect
                      ? const Color(0xFF00C853)
                      : const Color(0xFFFF5252),
                  width: 3,
                ),
              ),
              child: Image.asset(
                currentCorrectAnswer!['image']!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.sports_soccer_rounded,
                  size: 60,
                  color: Color(0xFFE91E63),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              currentCorrectAnswer!['word']!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              currentCorrectAnswer!['meaning']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 4,
              ),
              onPressed: () {
                Navigator.pop(context);
                _nextQuestion();
              },
              child: const Text(
                'ข้อถัดไป ➡️',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextQuestion() {
    if (currentQuestionIndex < widget.flashcards.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
      _loadQuestion();
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        backgroundColor: const Color(0xFFFFFBEB),
        title: const Column(
          children: [
            Text('🏆✨', style: TextStyle(fontSize: 56)),
            SizedBox(height: 8),
            Text(
              'แบบฝึกหัดเสร็จสิ้น!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFFE91E63),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'น้อง ๆ ตอบถูกทั้งหมด $score จาก ${widget.flashcards.length} ข้อครับ! ⚽🏆✨',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 4,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'กลับหน้าหลัก 🏠',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      body: _GameScaffoldBody(
        title: 'แบบฝึกหัด',
        color: const Color(0xFFE91E63),
        onBack: () async {
          await flutterTts.stop();
          if (context.mounted) Navigator.pop(context);
        },
        child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              // แถวบน: คะแนน + เหรียญ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C853),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00C853).withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      '$score/${widget.flashcards.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const _CoinPill(fontSize: 14),
                ],
              ),
              const SizedBox(height: 10),

              // Progress Bar
              Container(
                height: 12,
                width: double.infinity,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFF8BBD0), width: 1.5),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final progressWidth = (constraints.maxWidth *
                        ((currentQuestionIndex + 1) /
                            widget.flashcards.length));
                    return Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: progressWidth,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE91E63), Color(0xFF00C853)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Speaker Sound Play Button
              GestureDetector(
                onTap: speakWord,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFE91E63),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE91E63).withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _speakerPulseController,
                        builder: (context, child) {
                          final scale = isSpeaking
                              ? 1.0 + (_speakerPulseController.value * 0.2)
                              : 1.0;
                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFEC407A),
                                    Color(0xFFD81B60),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFE91E63)
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(
                                isSpeaking
                                    ? Icons.volume_up_rounded
                                    : Icons.volume_up_outlined,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 14),
                      Flexible(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'แตะเพื่อฟังเสียงอีกครั้ง 🔊',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFE91E63),
                            ),
                          ),
                          Text(
                            'เลือกภาพที่ตรงกับเสียงคำศัพท์ด้านล่าง',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 4-Image Grid Selection
              Expanded(
                child: currentOptions.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : LayoutBuilder(builder: (context, box) {
                        const gap = 12.0;
                        final itemW = (box.maxWidth - gap) / 2;
                        final itemH = (box.maxHeight - gap) / 2;
                        final ratio =
                            (itemW / itemH).clamp(0.75, 1.4).toDouble();
                        return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: gap,
                          mainAxisSpacing: gap,
                          childAspectRatio: ratio,
                        ),
                        itemCount: currentOptions.length,
                        itemBuilder: (context, index) {
                          final option = currentOptions[index];
                          return GestureDetector(
                            onTap: () => _checkAnswer(option),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(26),
                                border: Border.all(
                                  color: const Color(0xFFE91E63).withOpacity(0.25),
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFE91E63)
                                        .withOpacity(0.12),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Image.asset(
                                  option['image']!,
                                  fit: BoxFit.contain,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                    Icons.sports_soccer_rounded,
                                    size: 50,
                                    color: Color(0xFFE91E63),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                      }),
              ),
            ],
          ),
        ),
      ),
      ),
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