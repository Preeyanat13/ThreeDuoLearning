import 'package:flutter/material.dart';
import 'shadow_match_screen.dart';

class ShadowMatchCategoryItem {
  final String key;
  final String titleTh;
  final String imagePath;
  final Color themeColor;
  final Color shadowColor;

  const ShadowMatchCategoryItem({
    required this.key,
    required this.titleTh,
    required this.imagePath,
    required this.themeColor,
    required this.shadowColor,
  });
}

class ShadowMatchCategoryScreen extends StatelessWidget {
  const ShadowMatchCategoryScreen({super.key});

  final List<ShadowMatchCategoryItem> categories = const [
    // 1. สัตว์
    ShadowMatchCategoryItem(
      key: 'animal',
      titleTh: 'สัตว์',
      imagePath: 'assets/images/Background/shadowanimal.png',
      themeColor: Color(0xFFC026D3),
      shadowColor: Color(0xFF6B1574),
    ),
    // 2. ร่างกาย
    ShadowMatchCategoryItem(
      key: 'body',
      titleTh: 'ร่างกาย',
      imagePath: 'assets/images/Background/shadowbody.png',
      themeColor: Color(0xFFF59E0B),
      shadowColor: Color(0xFF9E4700),
    ),
    // 3. เสื้อผ้า
    ShadowMatchCategoryItem(
      key: 'clothing',
      titleTh: 'เสื้อผ้า',
      imagePath: 'assets/images/Background/shadowclothes.png',
      themeColor: Color(0xFFEC4899),
      shadowColor: Color(0xFF93174E),
    ),
    // 4. กิจวัตรประจำวัน
    ShadowMatchCategoryItem(
      key: 'daily_routine',
      titleTh: 'กิจวัตรประจำวัน',
      imagePath: 'assets/images/Background/shadowroutine.png',
      themeColor: Color(0xFF8B5CF6),
      shadowColor: Color(0xFF551EB3),
    ),
    // 5. อาหาร
    ShadowMatchCategoryItem(
      key: 'food',
      titleTh: 'อาหาร',
      imagePath: 'assets/images/Background/shadowfood.png',
      themeColor: Color(0xFF10B981),
      shadowColor: Color(0xFF045E44),
    ),
    // 6. ผลไม้
    ShadowMatchCategoryItem(
      key: 'fruit',
      titleTh: 'ผลไม้',
      imagePath: 'assets/images/Background/shadowfruit.png',
      themeColor: Color(0xFFEF4444),
      shadowColor: Color(0xFF8D1818),
    ),
    // 7. บ้าน
    ShadowMatchCategoryItem(
      key: 'home',
      titleTh: 'บ้าน',
      imagePath: 'assets/images/Background/shadowhouse.png',
      themeColor: Color(0xFF06B6D4),
      shadowColor: Color(0xFF115569),
    ),
    // 8. กีฬา
    ShadowMatchCategoryItem(
      key: 'sport',
      titleTh: 'กีฬา',
      imagePath: 'assets/images/Background/shadowsport.png',
      themeColor: Color(0xFF3B82F6),
      shadowColor: Color(0xFF183B9E),
    ),
    // 9. ยานพาหนะ
    ShadowMatchCategoryItem(
      key: 'vehicle',
      titleTh: 'ยานพาหนะ',
      imagePath: 'assets/images/guess/Vehicles/Car.png',
      themeColor: Color(0xFFF97316),
      shadowColor: Color(0xFF8D310A),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const topBarColor = Color(0xFF6366F1);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0E7FF),
              Color(0xFFEEF2FF),
              Color(0xFFFFFFFF),
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: Column(
          children: [
            // 1. Header Bar ด้านบน
            Container(
              color: topBarColor,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => Navigator.maybePop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'จับคู่เงา',
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

            // 2. เนื้อหาเลื่อนแบบเรียบสนิท
            Expanded(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'จับคู่เงาแสนสนุก',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF6366F1),
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'เลือกหมวดหมู่',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ตารางแสดงการ์ดหมวดหมู่
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.88,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final cat = categories[index];
                          return _KidsLeafCard(
                            category: cat,
                            onTap: () {
                              // ✅ ส่ง categoryTitle: cat.titleTh ไปที่หน้าเกม (หายแดงทันที และเปิดตรงหมวดแน่นอน)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShadowMatchScreen(
                                    categoryTitle: cat.titleTh,
                                  ),
                                ),
                              );
                            },
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
      ),
    );
  }
}

class _KidsLeafCard extends StatelessWidget {
  final ShadowMatchCategoryItem category;
  final VoidCallback onTap;

  const _KidsLeafCard({
    required this.category,
    required this.onTap,
  });

  static const BorderRadius outerRadius = BorderRadius.only(
    topLeft: Radius.circular(38),
    topRight: Radius.circular(18),
    bottomLeft: Radius.circular(18),
    bottomRight: Radius.circular(18),
  );

  static const BorderRadius innerRadius = BorderRadius.only(
    topLeft: Radius.circular(34),
    topRight: Radius.circular(14),
    bottomLeft: Radius.circular(14),
    bottomRight: Radius.circular(14),
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: outerRadius,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: outerRadius,
          border: Border.all(color: Colors.white, width: 3.0),
          boxShadow: [
            BoxShadow(
              color: category.shadowColor,
              offset: const Offset(0, 5.5),
              blurRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: innerRadius,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(color: category.themeColor),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.55),
                        width: 1.6,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(26, 16, 26, 44),
                  child: Center(
                    child: Image.asset(
                      category.imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.category_rounded,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CustomPaint(
                  painter: _WaveBadgePainter(),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(6, 14, 6, 8),
                    alignment: Alignment.center,
                    child: Text(
                      category.titleTh,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w900,
                        color: category.themeColor,
                        letterSpacing: 0.2,
                      ),
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

class _WaveBadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 14);
    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.60, 8);
    path.quadraticBezierTo(size.width * 0.85, 14, size.width, 5);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}