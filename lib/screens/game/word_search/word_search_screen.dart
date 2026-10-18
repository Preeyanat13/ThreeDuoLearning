import 'package:flutter/material.dart';
import 'word_search_play_screen.dart';

// --- โมเดลข้อมูลหมวดหมู่ Word Search ---
class WordSearchCategoryItem {
  final String key;
  final String titleTh;
  final String titleEn;
  final String cardImagePath;
  final Color cardColor;
  final Color shadowColor;

  const WordSearchCategoryItem({
    required this.key,
    required this.titleTh,
    required this.titleEn,
    required this.cardImagePath,
    required this.cardColor,
    required this.shadowColor,
  });
}

// ----------------------------------------------------
// หน้าเลือกหมวดหมู่ (Category Selection Screen)
// ----------------------------------------------------
class WordSearchScreen extends StatelessWidget {
  const WordSearchScreen({super.key});

  final List<WordSearchCategoryItem> categories = const [
    // 1. สัตว์
    WordSearchCategoryItem(
      key: 'animal',
      titleTh: 'สัตว์',
      titleEn: 'ANIMAL SAFARI',
      cardImagePath: 'assets/images/Background/word_search_animal.png',
      cardColor: Color(0xFF26A69A),
      shadowColor: Color(0xFF00796B),
    ),
    // 2. กีฬา
    WordSearchCategoryItem(
      key: 'sport',
      titleTh: 'กีฬา',
      titleEn: 'ACTIVE SPORTS',
      cardImagePath: 'assets/images/Background/word_search_sport.png',
      cardColor: Color(0xFF29B6F6),
      shadowColor: Color(0xFF0288D1),
    ),
    // 3. อาชีพ
    WordSearchCategoryItem(
      key: 'career',
      titleTh: 'อาชีพ',
      titleEn: 'CAREER JOBS',
      cardImagePath: 'assets/images/Background/word_search_job.png',
      cardColor: Color(0xFFFFA726),
      shadowColor: Color(0xFFE65100),
    ),
    // 4. บ้าน
    WordSearchCategoryItem(
      key: 'home',
      titleTh: 'บ้าน',
      titleEn: 'SWEET HOME',
      cardImagePath: 'assets/images/Background/word_search_house.png',
      cardColor: Color(0xFFEC407A),
      shadowColor: Color(0xFFC2185B),
    ),
    // 5. ยานพาหนะ
    WordSearchCategoryItem(
      key: 'vehicle',
      titleTh: 'ยานพาหนะ',
      titleEn: 'VEHICLES TRIP',
      cardImagePath: 'assets/images/Background/word_search_vehicle.png',
      cardColor: Color(0xFFAB47BC),
      shadowColor: Color(0xFF7B1FA2),
    ),
    // 6. สถานที่
    WordSearchCategoryItem(
      key: 'location',
      titleTh: 'สถานที่',
      titleEn: 'AMAZING PLACES',
      cardImagePath: 'assets/images/Background/word_search_location.png',
      cardColor: Color(0xFFFF5722),
      shadowColor: Color(0xFFBF360C),
    ),
    // 7. เสื้อผ้า
    WordSearchCategoryItem(
      key: 'clothing',
      titleTh: 'เสื้อผ้า',
      titleEn: 'MY CLOTHES',
      cardImagePath: 'assets/images/Background/word_search_clothes.png',
      cardColor: Color(0xFF5C6BC0),
      shadowColor: Color(0xFF3949AB),
    ),
    // 8. ผลไม้
    WordSearchCategoryItem(
      key: 'fruit',
      titleTh: 'ผลไม้',
      titleEn: 'JUICY FRUITS',
      cardImagePath: 'assets/images/Background/word_search_fruit.png',
      cardColor: Color(0xFFFFCA28),
      shadowColor: Color(0xFFF57F17),
    ),
    // 9. อาหาร
    WordSearchCategoryItem(
      key: 'food',
      titleTh: 'อาหาร',
      titleEn: 'YUMMY FOOD',
      cardImagePath: 'assets/images/Background/word_search_food.png',
      cardColor: Color(0xFF66BB6A),
      shadowColor: Color(0xFF2E7D32),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const topBarColor = Color(0xFFE65100);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFCCBC),
              Color(0xFFFFF3E0),
              Color(0xFFFFFFFF),
            ],
            stops: [0.0, 0.4, 0.9],
          ),
        ),
        child: Column(
          children: [
            // 1. แถบ Header สีส้มด้านบน (ตรึงไว้เฉพาะส่วนนี้)
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
                          'ค้นหาคำศัพท์',
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

            // 2. ส่วนเนื้อหาทั้งหมดที่เลื่อนได้ (หัวข้อเลื่อนขึ้นไปด้วย ไม่ถูกบังการ์ด)
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(), // เลื่อนเรียบสนิท ชนขอบแล้วหยุด ไม่เด้ง
                slivers: [
                  // หัวข้อ "ค้นหาคำศัพท์แสนสนุก / เลือกหมวดหมู่" เลื่อนขึ้นไปพร้อมกับการ์ด
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 18, 24, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'ค้นหาคำศัพท์แสนสนุก',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFE65100),
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

                  // ตารางแสดงการ์ดหมวดหมู่ 2 คอลัมน์
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                        childAspectRatio: 0.95,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final cat = categories[index];
                          return _CategoryFilledCard(category: cat);
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
      ),
    );
  }
}

// การ์ดหมวดหมู่ 3D Squircle
class _CategoryFilledCard extends StatefulWidget {
  final WordSearchCategoryItem category;

  const _CategoryFilledCard({required this.category});

  @override
  State<_CategoryFilledCard> createState() => _CategoryFilledCardState();
}

class _CategoryFilledCardState extends State<_CategoryFilledCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WordSearchPlayScreen(
              category: cat,
            ),
          ),
        );
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: cat.shadowColor,
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.only(bottom: 6),
          child: Container(
            decoration: BoxDecoration(
              color: cat.cardColor,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -14,
                  right: -14,
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.14),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 86,
                          height: 86,
                          child: Image.asset(
                            cat.cardImagePath,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.extension_rounded,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cat.titleTh,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.3,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(0, 1.5),
                                blurRadius: 2.5,
                              ),
                            ],
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
  }
}