import 'dart:math';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'Sukhumvit Set', // หรือฟอนต์กลมๆ น่ารักที่ใช้อยู่ในโปรเจกต์
    ),
    home: const CategorySelectionScreen(),
  ));
}

// ============================================================
// 1. หน้าเลือกหมวดหมู่ (CategorySelectionScreen) - Human-crafted Game UI
// ============================================================
class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  static const List<Map<String, dynamic>> categories = [
    {
      'title': 'สัตว์น่ารัก',
      'subtitle': 'เพื่อนตัวน้อยรอบตัวเรา',
      'tag': '🐶 30 คำศัพท์',
      'primaryColor': Color(0xFF6C5CE7),
      'accentColor': Color(0xFF5142CA),
      'cardBg': Color(0xFFF3F0FF),
      'image': 'assets/images/flashcards/dog.jpg',
      'icon': Icons.pets_rounded,
      'folder': 'Animal',
      'words': [
        'BEAR', 'BEE', 'BIRD', 'BUTTERFLY', 'CAT', 'CHICKEN', 'COW', 'DOG',
        'DOLPHIN', 'DUCK', 'ELEPHANT', 'FISH', 'FROG', 'GIRAFFE', 'HIPPO',
        'HORSE', 'KANGAROO', 'LION', 'MONKEY', 'OCTOPUS', 'OWL', 'PANDA',
        'PENGUIN', 'PIG', 'RABBIT', 'SHEEP', 'TIGER', 'TURTLE', 'WHALE', 'ZEBRA'
      ],
    },
    {
      'title': 'ผลไม้แสนอร่อย',
      'subtitle': 'ผลไม้หวานฉ่ำ สีสันสดใส',
      'tag': '🍎 28 คำศัพท์',
      'primaryColor': Color(0xFFFF5252),
      'accentColor': Color(0xFFE03838),
      'cardBg': Color(0xFFFFF0F0),
      'image': 'assets/images/flashcards/fruit.jpg',
      'icon': Icons.apple_rounded,
      'folder': 'Fruit',
      'words': [
        'APPLE', 'AVOCADO', 'BANANA', 'BLACKBERRY', 'BLUEBERRY', 'CHERRY',
        'COCONUT', 'DURIAN', 'GRAPES', 'GUAVA', 'JACKFRUIT', 'KIWI', 'LEMON',
        'LIME', 'LONGAN', 'LYCHEE', 'MANGO', 'MANGOSTEEN', 'ORANGE', 'PAPAYA',
        'PEACH', 'PEAR', 'PINEAPPLE', 'POMEGRANATE', 'RAMBUTAN', 'RASPBERRY',
        'STRAWBERRY', 'WATERMELON'
      ],
    },
    {
      'title': 'อาชีพในฝัน',
      'subtitle': 'โตขึ้นน้องๆ อยากเป็นอะไรนะ?',
      'tag': '👨‍⚕️ 28 คำศัพท์',
      'primaryColor': Color(0xFFFF9F43),
      'accentColor': Color(0xFFE08328),
      'cardBg': Color(0xFFFFF7ED),
      'image': 'assets/images/flashcards/occupation.jpg',
      'icon': Icons.work_rounded,
      'folder': 'Career',
      'words': [
        'ACCOUNTANT', 'ARCHITECT', 'ARTIST', 'CARPENTER', 'CASHIER', 'CHEF',
        'DENTIST', 'DOCTOR', 'ELECTRICIAN', 'ENGINEER', 'FARMER', 'FIREFIGHTER',
        'JOURNALIST', 'LAWYER', 'MECHANIC', 'MUSICIAN', 'NURSE', 'PHARMACIST',
        'PHOTOGRAPHER', 'PILOT', 'PLUMBER', 'PROGRAMMER', 'SCIENTIST', 'SOLDIER',
        'TEACHER', 'VETERINARIAN', 'WAITER', 'WAITRESS'
      ],
    },
    {
      'title': 'กีฬาสุดสนุก',
      'subtitle': 'ออกกำลังกายให้แข็งแรง',
      'tag': '⚽ 10 คำศัพท์',
      'primaryColor': Color(0xFFFF4081),
      'accentColor': Color(0xFFD81B60),
      'cardBg': Color(0xFFFFF0F5),
      'image': 'assets/images/flashcards/sport.jpg',
      'icon': Icons.sports_soccer_rounded,
      'folder': 'Sport',
      'words': [
        'BADMINTON', 'BASEBALL', 'BASKETBALL', 'CYCLING', 'RUNNING',
        'SOCCER', 'SWIMMING', 'TABLE TENNIS', 'TENNIS', 'VOLLEYBALL'
      ],
    },
    {
      'title': 'ยานพาหนะ',
      'subtitle': 'ออกเดินทางไปท่องโลกกว้าง',
      'tag': '🚗 10 คำศัพท์',
      'primaryColor': Color(0xFF10AC84),
      'accentColor': Color(0xFF0E8E6D),
      'cardBg': Color(0xFFE8F8F5),
      'image': 'assets/images/flashcards/car.jpg',
      'icon': Icons.directions_car_rounded,
      'folder': 'Vehicle',
      'words': [
        'AIRPLANE', 'BICYCLE', 'BOAT', 'BUS', 'CAR', 'MOTORCYCLE',
        'TAXI', 'TRAIN', 'TRUCK', 'VAN'
      ],
    },
    {
      'title': 'สถานที่น่ารู้',
      'subtitle': 'รอบๆ ตัวเรามีที่ไหนบ้างนะ?',
      'tag': '🏫 20 คำศัพท์',
      'primaryColor': Color(0xFFFECA57),
      'accentColor': Color(0xFFE1AF3C),
      'cardBg': Color(0xFFFFFBF0),
      'image': 'assets/images/flashcards/location.jpg',
      'icon': Icons.storefront_rounded,
      'folder': 'Place',
      'words': [
        'AIRPORT', 'BANK', 'BAKERY', 'BEACH' , 'CAFE', 'CINEMA', 'FACTORY',
        'GYM', 'HOSPITAL', 'HOTEL', 'LIBRARY', 'MOUNTAIN', 'OFFICE', 'PARK', 'PHARMACY', 
        'RESTAURANT', 'SCHOOL', 'SUPERMARKET', 'TEMPLE', 'ZOO'
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: const Color(0xFFDFF3FC),
      body: _GameScaffoldBody(
        title: 'พยัญชนะต้น',
        color: const Color(0xFF29ABE2),
        showBack: canPop,
        child: _SkyBackground(
          child: SafeArea(
        child: Column(
          children: [
            // Top Navigation & Stat Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48),

                  const _CoinPill(fontSize: 15),
                ],
              ),
            ),

            // Page Title Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'เลือกหมวดหมู่ 🎈',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0B4F7A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'เลือกบทเรียนที่ต้องการฝึกทายคำศัพท์เลย!',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3B7CA6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Category Cards List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final Color primaryColor = cat['primaryColor'] as Color;
                  final Color accentColor = cat['accentColor'] as Color;
                  final Color cardBg = cat['cardBg'] as Color;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: BouncyTap(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LevelSelectScreen(categoryData: cat),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: cardBg, width: 2),
                          boxShadow: [
                            // 3D Bottom Edge Layer
                            BoxShadow(
                              color: primaryColor.withOpacity(0.25),
                              blurRadius: 0,
                              offset: const Offset(0, 6),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Background Accent Shape
                            Positioned(
                              right: -20,
                              bottom: -20,
                              child: Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // Squircle Thumbnail Wrapper
                                  Container(
                                    width: 82,
                                    height: 82,
                                    decoration: BoxDecoration(
                                      color: cardBg,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white, width: 3),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryColor.withOpacity(0.12),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(17),
                                      child: Image.asset(
                                        cat['image'] as String,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(
                                            cat['icon'] as IconData,
                                            size: 40,
                                            color: primaryColor,
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  // Details Section
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Tag Badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: primaryColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            cat['tag'],
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              color: primaryColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          cat['title'],
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF1E293B),
                                            height: 1.1,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          cat['subtitle'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 3D Tactile Play Button
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: accentColor,
                                          blurRadius: 0,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                ],
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
      ),
    );
  }
}


// ---------------------------------------------------------------
// พื้นหลังโทนฟ้า เข้ากับแถบด้านบน (#29ABE2) พร้อมวงกลม/เมฆตกแต่งจางๆ
// ---------------------------------------------------------------
class _SkyBackground extends StatelessWidget {
  final Widget child;
  const _SkyBackground({required this.child});

  Widget _bubble(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8ED8F5), // ฟ้าสดต่อเนื่องจากแถบด้านบน
            Color(0xFFBFE8FA),
            Color(0xFFE3F5FD),
            Color(0xFFF4FBFF),
          ],
          stops: [0.0, 0.28, 0.62, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            left: -50,
            child: _bubble(170, Colors.white.withOpacity(0.18)),
          ),
          Positioned(
            top: 120,
            right: -60,
            child: _bubble(150, Colors.white.withOpacity(0.16)),
          ),
          Positioned(
            top: 330,
            left: -70,
            child: _bubble(140, const Color(0xFF29ABE2).withOpacity(0.07)),
          ),
          Positioned(
            bottom: 90,
            right: -40,
            child: _bubble(120, const Color(0xFF29ABE2).withOpacity(0.07)),
          ),
          Positioned(
            bottom: -50,
            left: 40,
            child: _bubble(150, Colors.white.withOpacity(0.35)),
          ),
          child,
        ],
      ),
    );
  }
}

// ============================================================
// Shared Custom Components
// ============================================================
const Color kInk = Color(0xFF0B2A4A);
const Color kMuted = Color(0xFF5B7A99);
const Color kGreen = Color(0xFF22C55E);
const Color kCoral = Color(0xFFFF7A59);

Color darken(Color c, [double amount = 0.15]) {
  final hsl = HSLColor.fromColor(c);
  return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
}

class DynamicCategoryBackground extends StatelessWidget {
  final List<Color> bgGradient;
  final Widget child;

  const DynamicCategoryBackground({
    super.key,
    required this.bgGradient,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            bgGradient.first,
            Colors.white,
          ],
        ),
      ),
      child: child,
    );
  }
}

class BouncyTap extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  const BouncyTap({super.key, required this.onTap, required this.child});

  @override
  State<BouncyTap> createState() => _BouncyTapState();
}

class _BouncyTapState extends State<BouncyTap> {
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
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}

class ChunkyButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool filled;
  final IconData? icon;

  const ChunkyButton({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
    this.filled = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final fg = filled ? Colors.white : color;
    return BouncyTap(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        decoration: BoxDecoration(
          color: filled ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: filled ? null : Border.all(color: color, width: 2.5),
          boxShadow: filled
              ? [BoxShadow(color: darken(color), offset: const Offset(0, 4))]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: fg, size: 24),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800, color: fg),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PopIn extends StatelessWidget {
  final Widget child;
  const PopIn({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.7, end: 1.0),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutBack,
      builder: (context, v, ch) => Transform.scale(scale: v, child: ch),
      child: child,
    );
  }
}

// ============================================================
// ระบบด่าน: เก็บดาวของแต่ละหมวด (หมวดละ 20 ด่าน)
// ============================================================
class LetterLevelStore {
  static const int levelCount = 20;
  static final Map<String, List<int>> _cache = {};

  static String _key(String folder) => 'letter_game_stars_$folder';

  /// คืนค่าดาวของแต่ละด่าน (0-3) ความยาว 20 ช่อง
  static Future<List<int>> load(String folder) async {
    final List<int> result = List<int>.filled(levelCount, 0);
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? raw = prefs.getString(_key(folder));
      if (raw != null && raw.isNotEmpty) {
        final parts = raw.split(',');
        for (int i = 0; i < levelCount && i < parts.length; i++) {
          result[i] = (int.tryParse(parts[i]) ?? 0).clamp(0, 3).toInt();
        }
      }
    } catch (e) {
      final cached = _cache[folder];
      if (cached != null) return List<int>.from(cached);
    }
    _cache[folder] = List<int>.from(result);
    return result;
  }

  /// บันทึกดาวของด่าน (เก็บเฉพาะค่าที่ดีกว่าเดิม)
  static Future<void> record(String folder, int level, int stars) async {
    final List<int> list = await load(folder);
    if (stars <= list[level - 1]) return;
    list[level - 1] = stars;
    _cache[folder] = List<int>.from(list);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key(folder), list.join(','));
    } catch (e) {
      debugPrint('Save stars error: $e');
    }
  }
}

// ============================================================
// 1.5 หน้าเลือกด่าน (LevelSelectScreen) - หมวดละ 20 ด่าน ง่าย -> ยาก
// ============================================================
class LevelSelectScreen extends StatefulWidget {
  final Map<String, dynamic> categoryData;
  const LevelSelectScreen({super.key, required this.categoryData});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen>
    with SingleTickerProviderStateMixin {
  // ---------- ค่าคงที่ของแผนที่ ----------
  static const double _rowH = 112; // ระยะห่างแนวตั้งระหว่างด่าน
  static const double _bannerH = 64; // ความสูงป้ายหัวข้อแต่ละช่วง
  static const double _topPad = 8;
  static const double _bottomPad = 100;
  static const double _nodeSize = 76;
  static const double _bossSize = 88;

  static const List<String> _tierEmoji = ['🌱', '🌼', '🔥', '👑'];
  static const List<String> _tierName = [
    'เริ่มต้นง่ายๆ',
    'เริ่มสนุกแล้ว',
    'ท้าทายขึ้นอีกนิด',
    'สุดยอดนักอ่าน',
  ];
  static const List<Color> _tierColor = [
    Color(0xFF2ECC71),
    Color(0xFFFFA726),
    Color(0xFFFF6B9D),
    Color(0xFF8E6CF0),
  ];
  static const Color _sunny = Color(0xFFFFB300);

  List<int> _stars = List<int>.filled(LetterLevelStore.levelCount, 0);
  final ScrollController _scroll = ScrollController();
  // ตัวจับเวลาสำหรับแอนิเมชันลอย/เด้งของตกแต่งและมาสคอต
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  double _viewportH = 0;

  Color get _primary => widget.categoryData['primaryColor'] as Color;
  Color get _accent => widget.categoryData['accentColor'] as Color;
  // อีโมจิประจำหมวด (ตัวแรกของ tag เช่น 🐶 / 🍎 / ⚽)
  String get _emoji =>
      (widget.categoryData['tag'] as String).split(' ').first;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _float.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final s =
        await LetterLevelStore.load(widget.categoryData['folder'] as String);
    if (!mounted) return;
    setState(() => _stars = s);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
  }

  bool _isUnlocked(int level) => level == 1 || _stars[level - 2] > 0;

  int get _current {
    final i = _stars.indexWhere((s) => s == 0);
    return i == -1 ? 0 : i + 1; // 0 = ผ่านครบแล้ว
  }

  // ---------- ตำแหน่งของด่านบนแผนที่ ----------
  double _levelY(int level) {
    final i = level - 1;
    final tier = i ~/ 5;
    return _topPad +
        tier * (_bannerH + 5 * _rowH) +
        _bannerH +
        (i % 5) * _rowH +
        _rowH / 2;
  }

  double _levelX(int level, double w) =>
      w / 2 + w * 0.27 * sin((level - 1) * pi / 2);

  double get _totalH => _topPad + 4 * (_bannerH + 5 * _rowH) + _bottomPad;

  void _scrollToCurrent() {
    if (!_scroll.hasClients || _viewportH == 0) return;
    final int cur = _current;
    final double targetY =
        cur == 0 ? _totalH : _levelY(cur) - _viewportH * 0.45;
    final double max = _scroll.position.maxScrollExtent;
    _scroll.animateTo(
      targetY.clamp(0.0, max).toDouble(),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _openLevel(int level) async {
    HapticFeedback.lightImpact();
    if (!_isUnlocked(level)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: _accent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          content: Text(
            'ผ่านด่าน ${level - 1} ก่อน แล้วมาเจอกันนะ 🔒✨',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          duration: const Duration(milliseconds: 1400),
        ));
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            FirstLetterGame(categoryData: widget.categoryData, level: level),
      ),
    );
    _load();
  }

  // ============================================================
  // พื้นหลังสดใส + ของตกแต่งลอยไปมา
  // ============================================================
  Widget _buildBackground() {
    final List<Color> colors = [
      Color.lerp(_primary, Colors.white, 0.62)!,
      Color.lerp(_primary, Colors.white, 0.86)!,
      const Color(0xFFFFFBEF),
    ];
    final List<List<dynamic>> decos = [
      ['☁️', 54.0, 0.78, 0.17, 0.0],
      ['🎈', 34.0, 0.04, 0.30, 0.25],
      ['⭐', 26.0, 0.88, 0.42, 0.5],
      [_emoji, 40.0, 0.06, 0.58, 0.75],
      ['🌈', 38.0, 0.80, 0.68, 0.1],
      ['✨', 24.0, 0.10, 0.80, 0.6],
      ['☁️', 44.0, 0.70, 0.88, 0.4],
    ];
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: colors,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: LayoutBuilder(builder: (context, box) {
              return AnimatedBuilder(
                animation: _float,
                builder: (context, _) {
                  return Stack(
                    children: [
                      for (final d in decos)
                        Positioned(
                          left: box.maxWidth * (d[2] as double),
                          top: box.maxHeight * (d[3] as double) +
                              8 *
                                  sin((_float.value + (d[4] as double)) *
                                      2 *
                                      pi),
                          child: Opacity(
                            opacity: 0.55,
                            child: Text(d[0] as String,
                                style: TextStyle(fontSize: d[1] as double)),
                          ),
                        ),
                    ],
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ส่วนหัว: มาสคอตโยกไปมา + ชื่อหมวด + เหรียญ
  // ============================================================
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _float,
            builder: (context, child) => Transform.rotate(
              angle: 0.14 * sin(_float.value * 2 * pi * 2),
              child: child,
            ),
            child: Container(
              width: 58,
              height: 58,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Color(0xFFFFF3C4)],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: _primary.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Text(_emoji, style: const TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.categoryData['title'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: _accent,
                    height: 1.1,
                    shadows: const [
                      Shadow(color: Colors.white, blurRadius: 6),
                      Shadow(color: Colors.white, offset: Offset(0, 2)),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'เลือกด่านที่อยากเล่นเลย! ✨',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: _accent.withOpacity(0.85)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const _CoinPill(fontSize: 14),
        ],
      ),
    );
  }

  // ============================================================
  // การ์ดความคืบหน้า: มาสคอตวิ่งไปตามหลอด
  // ============================================================
  Widget _buildProgressCard(int passed, int totalStars) {
    final int total = LetterLevelStore.levelCount;
    final String msg = passed == 0
        ? 'เริ่มผจญภัยกันเลย! 🚀'
        : passed >= total
            ? 'เก่งที่สุดเลย! ผ่านครบทุกด่านแล้ว 🎉'
            : 'อีก ${total - passed} ด่านก็ถึงเส้นชัย 🏁';
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 6),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _primary.withOpacity(0.2), width: 2.5),
        boxShadow: [
          BoxShadow(color: _primary.withOpacity(0.18), offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  msg,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                      color: darken(_accent, 0.05)),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4CC),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: _sunny, size: 20),
                    const SizedBox(width: 2),
                    Text('$totalStars/${total * 3}',
                        style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFB45309))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LayoutBuilder(builder: (context, box) {
            final double trackW = box.maxWidth;
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: passed / total),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutBack,
              builder: (context, v, _) {
                final double vv = v.clamp(0.0, 1.0).toDouble();
                return SizedBox(
                  height: 34,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 16,
                        child: Container(
                          height: 14,
                          decoration: BoxDecoration(
                            color: _primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: max(vv, 0.04),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color.lerp(_primary, Colors.white, 0.3)!,
                                    _primary,
                                  ]),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        right: 0,
                        top: 4,
                        child: Text('🏁', style: TextStyle(fontSize: 20)),
                      ),
                      Positioned(
                        left: (trackW - 30) * vv,
                        top: 0,
                        child: Text(_emoji,
                            style: const TextStyle(fontSize: 26)),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  // ============================================================
  // ป้ายหัวข้อแต่ละช่วงด่าน
  // ============================================================
  Widget _buildBanner(int tier, double w) {
    final Color c = _tierColor[tier];
    final double top = _topPad + tier * (_bannerH + 5 * _rowH);
    return Positioned(
      top: top + 10,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(color: darken(c, 0.15), offset: const Offset(0, 4)),
              BoxShadow(
                  color: c.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 6)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_tierEmoji[tier], style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Text(
                '${_tierName[tier]}  •  ด่าน ${tier * 5 + 1}-${tier * 5 + 5}',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black26, offset: Offset(0, 1))],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ปุ่มด่าน 1 ด่าน
  // ============================================================
  Widget _buildNode(int level, int current) {
    final bool unlocked = _isUnlocked(level);
    final int stars = _stars[level - 1];
    final bool isCurrent = level == current;
    final bool isBoss = level % 5 == 0;
    final double size = isBoss ? _bossSize : _nodeSize;
    final double starSize = isBoss ? 17 : 15;

    final List<Color> grad = isCurrent
        ? const [Color(0xFFFFE082), Color(0xFFFF9800)]
        : unlocked
            ? [Color.lerp(_primary, Colors.white, 0.3)!, _primary]
            : const [Color(0xFFF1F4F9), Color(0xFFD9E0EB)];
    final Color edge = isCurrent
        ? const Color(0xFFE65100)
        : unlocked
            ? darken(_accent, 0.05)
            : const Color(0xFFBFC9D8);

    final Widget circle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: grad,
        ),
        border: Border.all(color: Colors.white, width: size * 0.07),
        boxShadow: [
          BoxShadow(color: edge, offset: Offset(0, size * 0.09)),
          BoxShadow(
            color: (unlocked ? edge : Colors.black)
                .withOpacity(unlocked ? 0.35 : 0.08),
            blurRadius: 12,
            offset: Offset(0, size * 0.14),
          ),
          if (isCurrent)
            BoxShadow(
              color: const Color(0xFFFFC107).withOpacity(0.8),
              blurRadius: 22,
              spreadRadius: 4,
            ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (unlocked)
            Positioned(
              top: size * 0.09,
              left: size * 0.2,
              child: Container(
                width: size * 0.34,
                height: size * 0.14,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(size),
                ),
              ),
            ),
          unlocked
              ? Text(
                  '$level',
                  style: TextStyle(
                    fontSize: size * 0.46,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [
                      Shadow(color: edge, offset: const Offset(0, 2.5)),
                    ],
                  ),
                )
              : Icon(Icons.lock_rounded,
                  size: size * 0.4, color: const Color(0xFF9AA8BC)),
        ],
      ),
    );

    // ป้ายรางวัลมุมขวาบน (ด่านที่ 5, 10, 15 = กล่องของขวัญ, ด่าน 20 = ถ้วย)
    final Widget withBadge = isBoss
        ? SizedBox(
            width: size + 14,
            height: size + 6,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                circle,
                Positioned(
                  top: -6,
                  right: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Opacity(
                      opacity: unlocked ? 1 : 0.5,
                      child: Text(level == 20 ? '🏆' : '🎁',
                          style: const TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
              ],
            ),
          )
        : circle;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BouncyTap(
          onTap: () => _openLevel(level),
          child: _Pulse(active: isCurrent, child: withBadge),
        ),
        const SizedBox(height: 6),
        if (unlocked)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: _primary.withOpacity(0.18),
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < 3; i++)
                  Icon(
                    Icons.star_rounded,
                    size: starSize,
                    color: i < stars ? _sunny : const Color(0xFFDDE3EC),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  // ลูกโป่ง "เล่นเลย!" + มาสคอตที่เด้งอยู่ข้างด่านปัจจุบัน
  List<Widget> _buildCurrentMarkers(int current, double w) {
    if (current == 0) return const [];
    final double x = _levelX(current, w);
    final double y = _levelY(current);
    final double size = current % 5 == 0 ? _bossSize : _nodeSize;
    final bool mascotOnLeft = x > w / 2;
    final double mascotX =
        mascotOnLeft ? x - size / 2 - 52 : x + size / 2 + 14;
    return [
      Positioned(
        left: x - 45,
        top: y - size / 2 - 46,
        width: 90,
        child: AnimatedBuilder(
          animation: _float,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, -5 * sin(_float.value * 2 * pi * 2).abs()),
            child: child,
          ),
          child: IgnorePointer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7043),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3)),
                    ],
                  ),
                  child: const Text(
                    'เล่นเลย!',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                ),
                ClipPath(
                  clipper: _TriangleClipper(),
                  child: Container(
                      width: 12, height: 8, color: const Color(0xFFFF7043)),
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        left: mascotX.clamp(2.0, w - 50).toDouble(),
        top: y - 22,
        child: IgnorePointer(
          child: AnimatedBuilder(
            animation: _float,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, -10 * sin(_float.value * 2 * pi * 2).abs()),
              child: child,
            ),
            child: Text(_emoji, style: const TextStyle(fontSize: 38)),
          ),
        ),
      ),
    ];
  }

  // ============================================================
  // แผนที่เส้นทางผจญภัย (เลื่อนลงได้)
  // ============================================================
  Widget _buildMap(int current) {
    return LayoutBuilder(builder: (context, box) {
      final double w = box.maxWidth;
      _viewportH = box.maxHeight;
      final int total = LetterLevelStore.levelCount;

      final List<Offset> points = [
        for (int l = 1; l <= total; l++) Offset(_levelX(l, w), _levelY(l)),
      ];
      final List<bool> done = [
        for (int i = 0; i < total - 1; i++) _stars[i] > 0,
      ];

      // ของตกแต่งข้างทาง (ฝั่งตรงข้ามกับเส้นทาง)
      final List<String> sideDeco = [_emoji, '⭐', '🌸', '☁️', '🦋'];
      final List<Widget> sides = [
        for (int l = 2; l <= total; l += 3)
          Positioned(
            left: (w - _levelX(l, w)).clamp(4.0, w - 44).toDouble(),
            top: _levelY(l) + 24,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.5,
                child: Text(sideDeco[(l ~/ 3) % sideDeco.length],
                    style: const TextStyle(fontSize: 30)),
              ),
            ),
          ),
      ];

      return SingleChildScrollView(
        controller: _scroll,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: w,
          height: _totalH,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _LevelPathPainter(
                    points: points,
                    done: done,
                    color: _primary,
                  ),
                ),
              ),
              ...sides,
              for (int t = 0; t < 4; t++) _buildBanner(t, w),
              for (int l = 1; l <= total; l++)
                Positioned(
                  left: _levelX(l, w) - 50,
                  top: _levelY(l) - (l % 5 == 0 ? _bossSize : _nodeSize) / 2,
                  width: 100,
                  child: _buildNode(l, current),
                ),
              ..._buildCurrentMarkers(current, w),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final int passed = _stars.where((s) => s > 0).length;
    final int totalStars = _stars.fold<int>(0, (a, b) => a + b);
    final int current = _current;

    return Scaffold(
      body: _GameScaffoldBody(
        title: 'พยัญชนะต้น',
        color: _primary,
        child: Stack(
          children: [
            Positioned.fill(child: _buildBackground()),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildProgressCard(passed, totalStars),
                  Expanded(child: _buildMap(current)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// วาดเส้นทางคดเคี้ยวระหว่างด่าน (ช่วงที่ผ่านแล้วสีเข้มขึ้น)
class _LevelPathPainter extends CustomPainter {
  final List<Offset> points;
  final List<bool> done;
  final Color color;
  const _LevelPathPainter({
    required this.points,
    required this.done,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      final Offset a = points[i];
      final Offset b = points[i + 1];
      final double midY = (a.dy + b.dy) / 2;
      final Path path = Path()
        ..moveTo(a.dx, a.dy)
        ..cubicTo(a.dx, midY, b.dx, midY, b.dx, b.dy);

      final Paint band = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 32
        ..color = color.withOpacity(done[i] ? 0.32 : 0.13);
      canvas.drawPath(path, band);

      final Paint dash = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 5
        ..color = Colors.white.withOpacity(done[i] ? 0.95 : 0.75);
      for (final metric in path.computeMetrics()) {
        double d = 0;
        while (d < metric.length) {
          canvas.drawPath(
              metric.extractPath(d, min(d + 8, metric.length)), dash);
          d += 17;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LevelPathPainter old) =>
      old.points.length != points.length ||
      old.color != color ||
      !listEquals(old.done, done) ||
      (points.isNotEmpty && old.points.first != points.first);
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..moveTo(0, 0)
    ..lineTo(size.width, 0)
    ..lineTo(size.width / 2, size.height)
    ..close();

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// ปุ่มด่านปัจจุบันเต้นเบาๆ ให้รู้ว่าต้องกดตรงนี้
class _Pulse extends StatefulWidget {
  final bool active;
  final Widget child;
  const _Pulse({required this.active, required this.child});

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    if (widget.active) _c.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _Pulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_c.isAnimating) {
      _c.repeat(reverse: true);
    } else if (!widget.active) {
      _c.stop();
      _c.value = 0;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.1)
          .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut)),
      child: widget.child,
    );
  }
}

// ============================================================
// 2. หน้าเกมเล่นตามหมวดหมู่ (FirstLetterGame)
// ============================================================
class FirstLetterGame extends StatefulWidget {
  final Map<String, dynamic> categoryData;
  final int level; // 1-20
  const FirstLetterGame({super.key, required this.categoryData, this.level = 1});

  @override
  State<FirstLetterGame> createState() => _FirstLetterGameState();
}

class _FirstLetterGameState extends State<FirstLetterGame> {
  int score = 0;
  int currentIndex = 0;
  late int _level;
  late List<Map<String, dynamic>> questions;
  final Random _random = Random();

  static const List<Color> _optionColors = [
    Color(0xFF38BDF8),
    Color(0xFF2F80ED),
    Color(0xFF6C7CFF),
  ];

  static const Map<String, List<String>> _pngImages = {
    'Animal': [
      'Bear', 'Cat', 'Chicken', 'Cow', 'Dolphin', 'Duck',
      'Giraffe', 'Monkey', 'Pig', 'Turtle', 'Zebra'
    ],
    'Career': [
      'Artist', 'Carpenter', 'Electrician', 'Engineer', 'Journalist',
      'Lawyer', 'Pharmacist', 'Photographer', 'Pilot', 'Programmer',
      'Soldier', 'Veterinarian', 'Waitress'
    ],
    'Fruit': ['Apple', 'Coconut', 'Papaya', 'Strawberry'],
    'Sport': ['Badminton', 'Baseball', 'Soccer', 'Volleyball'],
    'Vehicle': ['Boat', 'Car', 'Train', 'Van'],
    'Place': [
      'Airport', 'Bank', 'Cafe', 'Cinema', 'Factory',
      'Fire station', 'Hotel', 'Park', 'Restaurant', 'School', 'Train station'
    ],
  };

  Color get _primaryColor =>
      widget.categoryData['primaryColor'] as Color? ?? const Color(0xFF7C4DFF);
  Color get _accentColor =>
      widget.categoryData['accentColor'] as Color? ?? const Color(0xFF651FFF);
  List<Color> get _bgGradient {
    final custom = widget.categoryData['bgGradient'] as List<Color>?;
    if (custom != null) return custom;
    // สร้างสีพื้นหลังอ่อนๆ จากสีประจำหมวดหมู่ (ไม่ใช่สีม่วงทุกหมวดอีกต่อไป)
    return [
      Color.lerp(_primaryColor, Colors.white, 0.78)!,
      Color.lerp(_primaryColor, Colors.white, 0.9)!,
    ];
  }

  @override
  void initState() {
    super.initState();
    _level = widget.level;
    _generateQuestions();
  }

  String _getImageExtension(String folder, String formattedWord) {
    final png = _pngImages[folder];
    if (png == null) return 'jpg';
    return png.contains(formattedWord) ? 'png' : 'jpg';
  }

  // จำนวนข้อต่อด่าน: ด่าน 1-5 = 5 ข้อ, 6-10 = 6 ข้อ, 11-15 = 7 ข้อ, 16-20 = 8 ข้อ
  int _questionCountFor(int level) => 5 + ((level - 1) ~/ 5);

  // เลือกตำแหน่งตัวอักษรที่จะซ่อน ตามระดับความยาก (tier 0-3)
  int _pickMissingIndex(String word, int tier) {
    final List<int> idx = [
      for (int i = 0; i < word.length; i++)
        if (word[i] != ' ') i
    ];
    switch (tier) {
      case 0: // ง่าย: ซ่อนตัวแรกเสมอ
        return idx.first;
      case 1: // ปานกลาง: ตัวแรกหรือตัวสุดท้าย
        return _random.nextBool() ? idx.first : idx.last;
      case 2: // ยาก: ตัวไหนก็ได้
        return idx[_random.nextInt(idx.length)];
      default: // ท้าทาย: ตัวกลางๆ
        final List<int> mid =
            idx.length > 2 ? idx.sublist(1, idx.length - 1) : idx;
        return mid[_random.nextInt(mid.length)];
    }
  }

  // ตัวเลือกหลอก: ด่านง่ายใช้ตัวที่ไม่อยู่ในคำ / ด่านยากใช้ตัวชนิดเดียวกัน (สระกับสระ) และตัวที่อยู่ในคำ
  List<String> _buildOptions(String word, String correct, int tier) {
    const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String vowels = 'AEIOU';
    final Set<String> inWord = word.replaceAll(' ', '').split('').toSet();
    final bool correctIsVowel = vowels.contains(correct);
    final List<String> letters = alphabet.split('')..remove(correct);

    List<String> candidates;
    if (tier <= 1) {
      candidates = letters.where((c) => !inWord.contains(c)).toList();
    } else {
      final List<String> sameType =
          letters.where((c) => vowels.contains(c) == correctIsVowel).toList();
      if (tier == 2) {
        candidates = sameType;
      } else {
        final List<String> inside =
            sameType.where((c) => inWord.contains(c)).toList()
              ..shuffle(_random);
        final List<String> outside =
            sameType.where((c) => !inWord.contains(c)).toList()
              ..shuffle(_random);
        candidates = [...inside, ...outside];
      }
    }
    if (tier != 3) candidates.shuffle(_random);

    final List<String> options = [correct, ...candidates.take(2)];
    letters.shuffle(_random);
    for (final String c in letters) {
      if (options.length >= 3) break;
      if (!options.contains(c)) options.add(c);
    }
    options.shuffle(_random);
    return options;
  }

  void _generateQuestions() {
    final int level = _level;
    final int tier = (level - 1) ~/ 5; // 0-3

    // เรียงคำจากสั้น (ง่าย) ไปยาว (ยาก)
    int len(String w) => w.replaceAll(' ', '').length;
    final List<String> all = List<String>.from(widget.categoryData['words']);
    all.sort((a, b) {
      final int c = len(a).compareTo(len(b));
      return c != 0 ? c : a.compareTo(b);
    });

    // เลื่อนหน้าต่างคำศัพท์จากคำสั้นไปคำยาวตามเลขด่าน
    final int n = all.length;
    final int count = min(_questionCountFor(level), n);
    final int window = min(n, max(count, (n * 0.4).ceil()));
    final double d = (level - 1) / (LetterLevelStore.levelCount - 1);
    final int start = ((n - window) * d).round();
    final List<String> pool = all.sublist(start, start + window)
      ..shuffle(_random);
    // ในด่านเดียวกัน เรียงจากคำสั้นไปยาวด้วย
    final List<String> picked = pool.take(count).toList()
      ..sort((a, b) => len(a).compareTo(len(b)));

    final String folder = widget.categoryData['folder'] as String;

    questions = picked.map((word) {
      final int missingIndex = _pickMissingIndex(word, tier);
      final String correctLetter = word[missingIndex];
      final String formattedWord = _capitalize(word);
      final String ext = _getImageExtension(folder, formattedWord);

      return {
        'fullWord': word,
        'missingIndex': missingIndex,
        'correctLetter': correctLetter,
        'options': _buildOptions(word, correctLetter, tier),
        'imagePath': 'assets/images/$folder/$formattedWord.$ext',
      };
    }).toList();
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  void _playAgain() {
    setState(() {
      score = 0;
      currentIndex = 0;
      _generateQuestions();
    });
  }

  void _goNextLevel() {
    setState(() {
      _level++;
      score = 0;
      currentIndex = 0;
      _generateQuestions();
    });
  }

  void _checkAnswer(String letter) {
    final q = questions[currentIndex];
    final bool isCorrect = letter == q['correctLetter'];
    final bool isLast = currentIndex >= questions.length - 1;
    final Color tone = isCorrect ? kGreen : kCoral;

    if (isCorrect) setState(() => score += 10);

    final String word = q['fullWord'];
    final int missing = q['missingIndex'];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => PopIn(
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                    color: tone.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 12))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: tone.withOpacity(0.15)),
                  child: Icon(
                    isCorrect
                        ? Icons.check_circle_rounded
                        : Icons.sentiment_dissatisfied_rounded,
                    size: 66,
                    color: tone,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isCorrect ? 'ถูกต้องครับ! 🎉' : 'เกือบถูกแล้ว ลองใหม่นะ!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w900, color: tone),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: _bgGradient.first.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text('คำเต็มคือ',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: kMuted)),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          children: [
                            for (int i = 0; i < word.length; i++)
                              TextSpan(
                                text: word[i],
                                style: TextStyle(
                                  fontSize: i == missing ? 32 : 26,
                                  fontWeight: FontWeight.w900,
                                  color: i == missing ? tone : kInk,
                                ),
                              ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(letterSpacing: 3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                ChunkyButton(
                  label: isLast ? 'ดูคะแนน 🏆' : 'ข้อถัดไป ➔',
                  color: _primaryColor,
                  onTap: () {
                    Navigator.pop(dialogCtx);
                    if (!isLast) {
                      setState(() => currentIndex++);
                    } else {
                      _showCompletionDialog();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 3 ดาว = ถูกหมด, 2 ดาว = ถูก >= 80%, 1 ดาว = ถูก >= 60% (ผ่านด่าน), 0 = ไม่ผ่าน
  int _starsFor(int correct, int total) {
    if (total == 0) return 0;
    final double r = correct / total;
    if (r >= 1.0) return 3;
    if (r >= 0.8) return 2;
    if (r >= 0.6) return 1;
    return 0;
  }

  Future<void> _showCompletionDialog() async {
    final int total = questions.length * 10;
    final int correct = score ~/ 10;
    final int stars = _starsFor(correct, questions.length);
    final bool passed = stars > 0;
    final bool hasNext = passed && _level < LetterLevelStore.levelCount;
    final bool finishedAll = passed && _level >= LetterLevelStore.levelCount;

    await LetterLevelStore.record(
        widget.categoryData['folder'] as String, _level, stars);
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => PopIn(
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                    color: _primaryColor.withOpacity(0.35),
                    blurRadius: 34,
                    offset: const Offset(0, 14))
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(passed ? '🎉' : '💪',
                      style: const TextStyle(fontSize: 52)),
                  const SizedBox(height: 4),
                  Text(
                    passed ? 'ผ่านด่าน $_level แล้ว!' : 'เกือบแล้ว ลองอีกครั้งนะ!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.w900, color: kInk),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 3; i++)
                        Icon(
                          Icons.star_rounded,
                          size: i == 1 ? 54 : 44,
                          color: i < stars
                              ? const Color(0xFFFFB300)
                              : const Color(0xFFE2E8F0),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      children: [
                        Text('ตอบถูก $correct จาก ${questions.length} ข้อ',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: kMuted)),
                        Text('$score',
                            style: TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w900,
                                color: darken(_primaryColor, 0.08),
                                height: 1.1)),
                        Text('จากเต็ม $total คะแนน',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: kMuted)),
                      ],
                    ),
                  ),
                  if (finishedAll) ...[
                    const SizedBox(height: 10),
                    const Text('🏆 ผ่านครบทุกด่านในหมวดนี้แล้ว!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: kInk)),
                  ],
                  const SizedBox(height: 18),
                  if (hasNext) ...[
                    ChunkyButton(
                      label: 'ด่านถัดไป ➔',
                      color: _primaryColor,
                      onTap: () {
                        Navigator.pop(dialogCtx);
                        _goNextLevel();
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                  ChunkyButton(
                    label: passed ? 'เล่นด่านนี้อีกครั้ง' : 'ลองอีกครั้ง',
                    icon: Icons.replay_rounded,
                    color: _primaryColor,
                    filled: !hasNext,
                    onTap: () {
                      Navigator.pop(dialogCtx);
                      _playAgain();
                    },
                  ),
                  const SizedBox(height: 12),
                  ChunkyButton(
                    label: 'กลับหน้าเลือกด่าน',
                    icon: Icons.grid_view_rounded,
                    color: kMuted,
                    filled: false,
                    onTap: () {
                      Navigator.pop(dialogCtx);
                      Navigator.pop(context);
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

  Widget _buildTopBar() {
    final int total = questions.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(widget.categoryData['icon'] as IconData,
                  color: _primaryColor, size: 26),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.categoryData['title'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: _accentColor),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [_primaryColor, _accentColor]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text('ด่าน $_level',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
              ),
              const SizedBox(width: 8),
              const _CoinPill(fontSize: 14),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _primaryColor.withOpacity(0.3), width: 1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: (currentIndex + 1) / total),
                      duration: const Duration(milliseconds: 450),
                      builder: (context, v, _) => LinearProgressIndicator(
                        value: v,
                        minHeight: 12,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation(_primaryColor),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('${currentIndex + 1}/$total',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImage(Map<String, dynamic> q) {
    return Container(
      width: 280,
      height: 280,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_primaryColor, _accentColor],
        ),
        boxShadow: [
          BoxShadow(
              color: _primaryColor.withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 10))
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration:
            const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: ClipOval(
          child: Image.asset(
            q['imagePath'],
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              widget.categoryData['icon'] as IconData,
              size: 90,
              color: _primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWordDisplay(Map<String, dynamic> q) {
    final String word = q['fullWord'];
    final int missing = q['missingIndex'];

    return LayoutBuilder(builder: (context, box) {
      final int n = word.length;
      final int spaces = ' '.allMatches(word).length;
      final int letters = n - spaces;
      const double gap = 6;
      const double spaceW = 12;
      final double avail = box.maxWidth - spaces * spaceW - (n - 1) * gap - 4;
      final double w = (avail / letters).clamp(22.0, 42.0).toDouble();
      final double h = (w * 1.4).clamp(34.0, 56.0).toDouble();

      final List<Widget> tiles = [];
      for (int i = 0; i < n; i++) {
        if (i > 0) tiles.add(const SizedBox(width: gap));
        if (word[i] == ' ') {
          tiles.add(const SizedBox(width: spaceW));
          continue;
        }
        final bool isMissing = i == missing;
        tiles.add(Container(
          width: isMissing ? w + 4 : w,
          height: h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isMissing ? _primaryColor.withOpacity(0.12) : Colors.white,
            borderRadius: BorderRadius.circular(h * 0.28),
            border: Border.all(
              color: isMissing ? _primaryColor : _primaryColor.withOpacity(0.25),
              width: isMissing ? 3 : 2,
            ),
            boxShadow: isMissing
                ? null
                : [
                    BoxShadow(
                        color: _primaryColor.withOpacity(0.15),
                        offset: const Offset(0, 4))
                  ],
          ),
          child: Text(
            isMissing ? '?' : word[i],
            style: TextStyle(
              fontSize: isMissing ? h * 0.58 : h * 0.5,
              fontWeight: FontWeight.w900,
              color: isMissing ? _primaryColor : kInk,
            ),
          ),
        ));
      }
      return Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(mainAxisSize: MainAxisSize.min, children: tiles),
        ),
      );
    });
  }

  Widget _buildQuestion(Map<String, dynamic> q) {
    final List<String> options = q['options'] as List<String>;
    return LayoutBuilder(builder: (context, box) {
      final double h = box.maxHeight;
      final double optSize = (h * 0.15).clamp(64.0, 92.0).toDouble();
      final double gap = (h * 0.025).clamp(8.0, 20.0).toDouble();
      return Column(
        children: [
          // รูปสัตว์/สิ่งของ: กินพื้นที่ที่เหลือ แล้วย่อให้พอดีเอง
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: _buildImage(q),
                ),
              ),
            ),
          ),
          SizedBox(height: gap),
          _buildWordDisplay(q),
          SizedBox(height: gap),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border:
                  Border.all(color: _primaryColor.withOpacity(0.2), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('💡 ', style: TextStyle(fontSize: 16)),
                Text(
                  'เลือกตัวอักษรที่หายไป',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: _accentColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: gap * 1.4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(options.length, (i) {
              final Color c = _optionColors[i % _optionColors.length];
              return BouncyTap(
                onTap: () => _checkAnswer(options[i]),
                child: Container(
                  width: optSize,
                  height: optSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: c,
                    borderRadius: BorderRadius.circular(optSize * 0.32),
                    boxShadow: [
                      BoxShadow(color: darken(c), offset: const Offset(0, 7)),
                      BoxShadow(
                          color: c.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 12)),
                    ],
                  ),
                  child: Text(
                    options[i],
                    style: TextStyle(
                        fontSize: optSize * 0.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = questions[currentIndex];

    return Scaffold(
      body: _GameScaffoldBody(
        title: 'พยัญชนะต้น',
        color: _primaryColor,
        child: DynamicCategoryBackground(
        bgGradient: _bgGradient,
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    layoutBuilder: (current, previous) => Stack(
                      fit: StackFit.expand,
                      children: [...previous, if (current != null) current],
                    ),
                    child: KeyedSubtree(
                      key: ValueKey(currentIndex),
                      child: _buildQuestion(currentQ),
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
    // ignore: unused_element_parameter
    this.onBack,
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