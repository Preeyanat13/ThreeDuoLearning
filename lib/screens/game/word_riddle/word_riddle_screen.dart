import 'package:flutter/material.dart';
import 'riddle_game_play_screen.dart';

// --- โมเดลข้อมูลหมวดหมู่ ---
class RiddleCategoryItem {
  final String key;
  final String titleTh;
  final String cardImagePath;
  final Color themeColor;
  final Color buttonColor;
  final Color shadowColor;

  const RiddleCategoryItem({
    required this.key,
    required this.titleTh,
    required this.cardImagePath,
    required this.themeColor,
    required this.buttonColor,
    required this.shadowColor,
  });
}

// ----------------------------------------------------
// หน้าเลือกหมวดหมู่ (Category Selection Screen)
// ----------------------------------------------------
class WordRiddleScreen extends StatelessWidget {
  const WordRiddleScreen({super.key});

  final List<RiddleCategoryItem> categories = const [
    // 1. สัตว์
    RiddleCategoryItem(
      key: 'animal',
      titleTh: 'สัตว์',
      cardImagePath: 'assets/images/Background/CardAnimal.png',
      themeColor: Color(0xFFE8F5E9),
      buttonColor: Color(0xFF2E7D32),
      shadowColor: Color(0xFF1B5E20),
    ),
    // 2. กีฬา
    RiddleCategoryItem(
      key: 'sport',
      titleTh: 'กีฬา',
      cardImagePath: 'assets/images/Background/CardSport.png',
      themeColor: Color(0xFFD1FAE5),
      buttonColor: Color(0xFF10B981),
      shadowColor: Color(0xFF047857),
    ),
    // 3. อาชีพ
    RiddleCategoryItem(
      key: 'career',
      titleTh: 'อาชีพ',
      cardImagePath: 'assets/images/Background/CardCareer.png',
      themeColor: Color(0xFFE3F2FD),
      buttonColor: Color(0xFF1565C0),
      shadowColor: Color(0xFF0D47A1),
    ),
    // 4. บ้าน
    RiddleCategoryItem(
      key: 'home',
      titleTh: 'บ้าน',
      cardImagePath: 'assets/images/Background/CardHome.png',
      themeColor: Color(0xFFE0F7FA),
      buttonColor: Color(0xFF00ACC1),
      shadowColor: Color(0xFF00838F),
    ),
    // 5. ยานพาหนะ
    RiddleCategoryItem(
      key: 'vehicle',
      titleTh: 'ยานพาหนะ',
      cardImagePath: 'assets/images/Background/CardVehicle.png',
      themeColor: Color(0xFFE1F5FE),
      buttonColor: Color(0xFF0288D1),
      shadowColor: Color(0xFF01579B),
    ),
    // 6. สถานที่
    RiddleCategoryItem(
      key: 'location',
      titleTh: 'สถานที่',
      cardImagePath: 'assets/images/Background/CardLocation.png',
      themeColor: Color(0xFFEDE7F6),
      buttonColor: Color(0xFF7E57C2),
      shadowColor: Color(0xFF512DA8),
    ),
    // 7. กิจวัตรประจำวัน
    RiddleCategoryItem(
      key: 'daily_routine',
      titleTh: 'กิจวัตรประจำวัน',
      cardImagePath: 'assets/images/Background/CardDailyRoutine.png',
      themeColor: Color(0xFFFCE4EC),
      buttonColor: Color(0xFFD81B60),
      shadowColor: Color(0xFF880E4F),
    ),
    // 8. เสื้อผ้า
    RiddleCategoryItem(
      key: 'clothing',
      titleTh: 'เสื้อผ้า',
      cardImagePath: 'assets/images/Background/CardClothing.png',
      themeColor: Color(0xFFFFEBEE),
      buttonColor: Color(0xFFE53935),
      shadowColor: Color(0xFFB71C1C),
    ),
    // 9. ผลไม้
    RiddleCategoryItem(
      key: 'fruit',
      titleTh: 'ผลไม้',
      cardImagePath: 'assets/images/Background/CardFruit.png',
      themeColor: Color(0xFFFFF3E0),
      buttonColor: Color(0xFFFB8C00),
      shadowColor: Color(0xFFEF6C00),
    ),
    // 10. อาหาร
    RiddleCategoryItem(
      key: 'food',
      titleTh: 'อาหาร',
      cardImagePath: 'assets/images/Background/CardFood.png',
      themeColor: Color(0xFFFEF3C7),
      buttonColor: Color(0xFFF59E0B),
      shadowColor: Color(0xFFB45309),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const topBarColor = Color(0xFF008466);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // 1. แถบ Header ด้านบน (ปรับขนาดเท่าหน้าค้นหาคำศัพท์)
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
                          size: 22, // ปรับขนาดเท่ากับหน้าค้นหาคำศัพท์
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'ปริศนาทายคำ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25, // ปรับขนาดตัวหนังสือเท่ากับหน้าค้นหาคำศัพท์
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

          // 2. ส่วนเนื้อหาที่เลื่อนได้ทั้งหมด (หัวข้อเลื่อนขึ้นไปด้วยกัน ไม่เด้งตอนเลื่อน)
          Expanded(
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(), // เลื่อนเรียบสนิท ชนขอบหยุดพอดี ไม่เด้ง
              slivers: [
                // หัวข้อ "ปริศนาทายคำแสนสนุก / เลือกหมวดหมู่"
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'ปริศนาทายคำแสนสนุก',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF008466),
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

                // รายการการ์ดแบนเนอร์หมวดหมู่
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final cat = categories[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RiddleGamePlayScreen(category: cat),
                                ),
                              );
                            },
                            child: Container(
                              height: 158,
                              decoration: BoxDecoration(
                                color: cat.shadowColor,
                                borderRadius: BorderRadius.circular(26),
                              ),
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: cat.buttonColor.withOpacity(0.4),
                                    width: 2.2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 122,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color: cat.themeColor,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(19),
                                          bottomLeft: Radius.circular(19),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(19),
                                        ),
                                        child: Image.asset(
                                          cat.cardImagePath,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Icon(
                                            Icons.image_rounded,
                                            size: 48,
                                            color: cat.buttonColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  cat.titleTh,
                                                  style: const TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w900,
                                                    color: Color(0xFF0F172A),
                                                    letterSpacing: -0.2,
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  'ฝึกทายคำศัพท์ภาษาอังกฤษ',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: 42,
                                              decoration: BoxDecoration(
                                                color: cat.shadowColor,
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              padding: const EdgeInsets.only(bottom: 3.5),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                                decoration: BoxDecoration(
                                                  color: cat.buttonColor,
                                                  borderRadius: BorderRadius.circular(14),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: const [
                                                    Text(
                                                      'เริ่มเล่นเลย',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w900,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    SizedBox(width: 6),
                                                    Icon(
                                                      Icons.play_arrow_rounded,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ],
                                                ),
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
                        );
                      },
                      childCount: categories.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}