import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// -------------------------------------------------------------
// 1. Data Models
// -------------------------------------------------------------
class LyricLine {
  final String text;
  final String translation;
  final Color dotColor;

  const LyricLine({
    required this.text,
    required this.translation,
    required this.dotColor,
  });
}

class SongItem {
  final String id;
  final String letter;
  final String imageAsset;
  final List<Color> gradientColors;
  final Color shadowColor;
  final Color buttonColor;
  final Color buttonShadowColor;
  final Color badgeTextColor;
  final String titleEn;
  final String titleTh;
  final String difficulty;
  final String duration;
  final List<LyricLine> lyrics;

  const SongItem({
    required this.id,
    required this.letter,
    required this.imageAsset,
    required this.gradientColors,
    required this.shadowColor,
    required this.buttonColor,
    required this.buttonShadowColor,
    required this.badgeTextColor,
    required this.titleEn,
    required this.titleTh,
    required this.difficulty,
    required this.duration,
    required this.lyrics,
  });
}

// -------------------------------------------------------------
// 2. หน้าเลือกเพลงคาราโอเกะ (Song Selection Screen)
// -------------------------------------------------------------
class KaraokeRecordScreen extends StatelessWidget {
  const KaraokeRecordScreen({Key? key}) : super(key: key);

  List<SongItem> _getSongs() {
    return const [
      // 1. Twinkle Twinkle Little Star (ชมพูพีช)
      SongItem(
        id: 'twinkle',
        letter: 'T',
        imageAsset: 'assets/images/Background/Star.png',
        gradientColors: [Color(0xFFFF9EB5), Color(0xFFFF85A1)],
        shadowColor: Color(0xFFE85D7F),
        buttonColor: Color(0xFFE11D48),
        buttonShadowColor: Color(0xFF9F1239),
        badgeTextColor: Color(0xFF059669),
        titleEn: 'Twinkle Twinkle Little ...',
        titleTh: 'ดาวระยิบระยับ',
        difficulty: 'ง่าย',
        duration: '0:45',
        lyrics: [
          LyricLine(text: 'Twinkle, twinkle, little star,', translation: 'ดวงดาวส่องประกายระยิบระยับ', dotColor: Color(0xFFFF8DA1)),
          LyricLine(text: 'How I wonder what you are!', translation: 'ฉันสงสัยจังว่าเธอคืออะไร', dotColor: Color(0xFFFFCA28)),
          LyricLine(text: 'Up above the world so high,', translation: 'ลอยเหนือโลกสูงลิบ', dotColor: Color(0xFF42A5F5)),
          LyricLine(text: 'Like a diamond in the sky.', translation: 'ราวกับเพชรเม็ดงามบนฟากฟ้า', dotColor: Color(0xFF66BB6A)),
        ],
      ),

      // 2. Row, Row, Row Your Boat (เหลืองอบอุ่น)
      SongItem(
        id: 'row_boat',
        letter: 'R',
        imageAsset: 'assets/images/Background/RowBoat.png',
        gradientColors: [Color(0xFFFFD15C), Color(0xFFFFBF29)],
        shadowColor: Color(0xFFE59E00),
        buttonColor: Color(0xFFD97706),
        buttonShadowColor: Color(0xFF92400E),
        badgeTextColor: Color(0xFF059669),
        titleEn: 'Row, Row, Row Your Bo...',
        titleTh: 'พายเรือเบาๆ',
        difficulty: 'ง่าย',
        duration: '0:30',
        lyrics: [
          LyricLine(text: 'Row, row, row your boat,', translation: 'พายเรือของเธอไปข้างหน้า', dotColor: Color(0xFFFF8DA1)),
          LyricLine(text: 'Gently down the stream,', translation: 'ล่องลอยเบาๆ ไปตามลำธาร', dotColor: Color(0xFFFFCA28)),
          LyricLine(text: 'Merrily, merrily, merrily, merrily,', translation: 'อย่างเบิกบานและสดใส', dotColor: Color(0xFF42A5F5)),
          LyricLine(text: 'Life is but a dream.', translation: 'ชีวิตเปรียบดั่งความฝันอันงดงาม', dotColor: Color(0xFF66BB6A)),
        ],
      ),

      // 3. The Wheels on the Bus (ฟ้าสดใส)
      SongItem(
        id: 'wheels_bus',
        letter: 'W',
        imageAsset: 'assets/images/Background/SchoolBus.png',
        gradientColors: [Color(0xFF5ED1FF), Color(0xFF38BDF8)],
        shadowColor: Color(0xFF0284C7),
        buttonColor: Color(0xFF0284C7),
        buttonShadowColor: Color(0xFF075985),
        badgeTextColor: Color(0xFFD97706),
        titleEn: 'The Wheels on the Bus',
        titleTh: 'ล้อรถบัสหมุนไป',
        difficulty: 'ปานกลาง',
        duration: '1:10',
        lyrics: [
          LyricLine(text: 'The wheels on the bus go round and round,', translation: 'ล้อของรถบัสหมุนวนไปรอบๆ', dotColor: Color(0xFFFF8DA1)),
          LyricLine(text: 'Round and round, round and round,', translation: 'หมุนวนไปและหมุนวนไป', dotColor: Color(0xFFFFCA28)),
          LyricLine(text: 'The wheels on the bus go round and round,', translation: 'ล้อของรถบัสหมุนวนไปรอบๆ', dotColor: Color(0xFF42A5F5)),
          LyricLine(text: 'All through the town.', translation: 'แล่นผ่านไปทั่วทั้งเมือง', dotColor: Color(0xFF66BB6A)),
        ],
      ),

      // 4. Head, Shoulders, Knees and Toes (เขียวมิ้นต์)
      SongItem(
        id: 'head_shoulders',
        letter: 'H',
        imageAsset: 'assets/images/Background/Dancing.png',
        gradientColors: [Color(0xFF6EE7B7), Color(0xFF4ADE80)],
        shadowColor: Color(0xFF16A34A),
        buttonColor: Color(0xFF16A34A),
        buttonShadowColor: Color(0xFF14532D),
        badgeTextColor: Color(0xFFD97706),
        titleEn: 'Head, Shoulders, Knee...',
        titleTh: 'หัว ไหล่ เข่า เท้า',
        difficulty: 'ปานกลาง',
        duration: '0:50',
        lyrics: [
          LyricLine(text: 'Head, shoulders, knees and toes,', translation: 'หัว ไหล่ เข่า และนิ้วเท้า', dotColor: Color(0xFFFF8DA1)),
          LyricLine(text: 'Knees and toes, knees and toes,', translation: 'เข่าและนิ้วเท้า', dotColor: Color(0xFFFFCA28)),
          LyricLine(text: 'And eyes, and ears, and mouth, and nose,', translation: 'ดวงตา หู ปาก และจมูก', dotColor: Color(0xFF42A5F5)),
          LyricLine(text: 'Head, shoulders, knees and toes.', translation: 'หัว ไหล่ เข่า และนิ้วเท้า', dotColor: Color(0xFF66BB6A)),
        ],
      ),

      // 5. Old MacDonald Had a Farm (ส้มสดใส)
      SongItem(
        id: 'old_macdonald',
        letter: 'O',
        imageAsset: 'assets/images/Background/Farm.png',
        gradientColors: [Color(0xFFFFA654), Color(0xFFFB923C)],
        shadowColor: Color(0xFFEA580C),
        buttonColor: Color(0xFFEA580C),
        buttonShadowColor: Color(0xFF9A3412),
        badgeTextColor: Color(0xFFE11D48),
        titleEn: 'Old MacDonald Had a ...',
        titleTh: 'ลุงแมคโดนัลด์มีฟาร์ม',
        difficulty: 'ยาก',
        duration: '1:20',
        lyrics: [
          LyricLine(text: 'Old MacDonald had a farm,', translation: 'คุณลุงแมคโดนัลด์มีฟาร์มแห่งหนึ่ง', dotColor: Color(0xFFFF8DA1)),
          LyricLine(text: 'E-I-E-I-O,', translation: 'อี-ไอ-อี-ไอ-โอ', dotColor: Color(0xFFFFCA28)),
          LyricLine(text: 'And on his farm he had a cow,', translation: 'และในฟาร์มของเขามีแม่วัวตัวหนึ่ง', dotColor: Color(0xFF42A5F5)),
          LyricLine(text: 'With a moo-moo here and moo-moo there.', translation: 'ส่งเสียง มอมอ ตรงนี้และ มอมอ ตรงนั้น', dotColor: Color(0xFF66BB6A)),
        ],
      ),

      // 6. Baa, Baa, Black Sheep (ม่วงลาเวนเดอร์)
      SongItem(
        id: 'baa_black_sheep',
        letter: 'B',
        imageAsset: 'assets/images/Background/sheep.png',
        gradientColors: [Color(0xFFBFA6FF), Color(0xFFA78BFA)],
        shadowColor: Color(0xFF7C3AED),
        buttonColor: Color(0xFF7C3AED),
        buttonShadowColor: Color(0xFF5B21B6),
        badgeTextColor: Color(0xFF059669),
        titleEn: 'Baa, Baa, Black Sheep',
        titleTh: 'แกะดำขนฟู',
        difficulty: 'ง่าย',
        duration: '0:35',
        lyrics: [
          LyricLine(text: 'Baa, baa, black sheep,', translation: 'แบะ แบะ เจ้าแกะดำตัวน้อย', dotColor: Color(0xFFFF8DA1)),
          LyricLine(text: 'Have you any wool?', translation: 'เธอมีขนแกะนุ่มๆ บ้างไหม', dotColor: Color(0xFFFFCA28)),
          LyricLine(text: 'Yes, sir, yes, sir, three bags full,', translation: 'มีครับ มีครับ เต็มสามถุงเลย', dotColor: Color(0xFF42A5F5)),
          LyricLine(text: 'One for the master, one for the dame.', translation: 'หนึ่งถุงให้เจ้านาย หนึ่งถุงให้คุณนาย', dotColor: Color(0xFF66BB6A)),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final songs = _getSongs();
    const purpleHeader = Color(0xFF8B5CF6);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F2FF),
      body: Column(
        children: [
          // 1. Header สีม่วงสดใส
          Container(
            color: purpleHeader,
            width: double.infinity,
            child: SafeArea(
              bottom: false,
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'คาราโอเกะเพลง',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          // 2. ส่วนหัวคำอธิบาย
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'พร้อมร้องเพลงกันหรือยัง?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2E1065),
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'แตะเพลงที่อยากร้องได้เลย',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. รายการการ์ดเพลงสไตล์ 3D
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              itemCount: songs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final song = songs[index];
                return _buildSampleSongCard(context, song);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleSongCard(BuildContext context, SongItem song) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KaraokeDetailScreen(song: song),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: song.shadowColor,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: song.shadowColor.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.only(bottom: 5.5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: song.gradientColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.55),
              width: 1.8,
            ),
          ),
          child: Row(
            children: [
              // 1. รูปภาพไอคอน
              SizedBox(
                width: 52,
                height: 52,
                child: Image.asset(
                  song.imageAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Center(
                    child: Text(
                      song.letter,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // 2. ข้อมูลเพลงตรงกลาง
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.titleEn,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B),
                        letterSpacing: 0.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      song.titleTh,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // ป้ายระดับความยาก
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            song.difficulty,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: song.badgeTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // เวลาความยาว
                        Text(
                          song.duration,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.black.withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // 3. ปุ่ม "ร้อง" 3D (ปรับสีเข้มชัดเจนตามหมวดเพลง)[cite: 19]
              Container(
                decoration: BoxDecoration(
                  color: song.buttonShadowColor, // ฐานขอบล่าง 3D สีเข้ม
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 6,
                      offset: const Offset(0, 3.5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(bottom: 3.5),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7.5),
                  decoration: BoxDecoration(
                    color: song.buttonColor, // สีปุ่มเข้มสดใส
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.65), // ขอบแสงไฮไลต์สีขาว
                      width: 1.4,
                    ),
                  ),
                  child: const Text(
                    'ร้อง',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                      shadows: [
                        Shadow(color: Colors.black38, offset: Offset(0, 1), blurRadius: 2),
                      ],
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

// -------------------------------------------------------------
// 3. หน้าร้องเพลงและบันทึกเสียง (Detail Screen)
// -------------------------------------------------------------
class KaraokeDetailScreen extends StatefulWidget {
  final SongItem song;

  const KaraokeDetailScreen({Key? key, required this.song}) : super(key: key);

  @override
  State<KaraokeDetailScreen> createState() => _KaraokeDetailScreenState();
}

class _KaraokeDetailScreenState extends State<KaraokeDetailScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isDemoPlaying = false;
  bool _hasDemoFinished = false;
  bool _isRecording = false;
  bool _isPlayingRecord = false;
  String? _recordedFilePath;

  int _recordingSeconds = 0;
  Timer? _recordingTimer;
  int currentLyricIndex = -1;

  static const Color purplePrimary = Color(0xFF8B5CF6);

  @override
  void initState() {
    super.initState();
    _initTts();
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlayingRecord = false);
    });
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.33);
    await _flutterTts.setPitch(1.22);
  }

  Future<void> _togglePlayDemo() async {
    if (_isDemoPlaying) {
      await _flutterTts.stop();
      setState(() {
        _isDemoPlaying = false;
        currentLyricIndex = -1;
      });
    } else {
      if (_isPlayingRecord) {
        await _audioPlayer.stop();
        setState(() => _isPlayingRecord = false);
      }

      setState(() {
        _isDemoPlaying = true;
        currentLyricIndex = 0;
      });

      for (int i = 0; i < widget.song.lyrics.length; i++) {
        if (!_isDemoPlaying || !mounted) break;

        setState(() {
          currentLyricIndex = i;
        });

        final Completer<void> lineCompleter = Completer<void>();
        _flutterTts.setCompletionHandler(() {
          if (!lineCompleter.isCompleted) {
            lineCompleter.complete();
          }
        });

        await _flutterTts.speak(widget.song.lyrics[i].text);
        await lineCompleter.future;

        await Future.delayed(const Duration(milliseconds: 300));
      }

      if (mounted) {
        setState(() {
          _isDemoPlaying = false;
          _hasDemoFinished = true;
          currentLyricIndex = -1;
        });
      }
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/sing_${widget.song.id}_${DateTime.now().millisecondsSinceEpoch}.m4a';

        if (_isDemoPlaying) {
          await _flutterTts.stop();
          setState(() {
            _isDemoPlaying = false;
            currentLyricIndex = -1;
          });
        }

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );

        _recordingSeconds = 0;
        _recordingTimer?.cancel();
        _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() => _recordingSeconds++);
        });

        setState(() {
          _isRecording = true;
          _recordedFilePath = null;
        });
      }
    } catch (e) {
      debugPrint('Error starting record: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      _recordingTimer?.cancel();
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _recordedFilePath = path;
      });
    } catch (e) {
      debugPrint('Error stopping record: $e');
    }
  }

  Future<void> _togglePlayRecordedAudio() async {
    if (_recordedFilePath == null) return;

    if (_isDemoPlaying) {
      await _flutterTts.stop();
      setState(() {
        _isDemoPlaying = false;
        currentLyricIndex = -1;
      });
    }

    if (_isPlayingRecord) {
      await _audioPlayer.stop();
      setState(() => _isPlayingRecord = false);
    } else {
      await _audioPlayer.play(DeviceFileSource(_recordedFilePath!));
      setState(() => _isPlayingRecord = true);
    }
  }

  void _shareRecordedFile() {
    if (_recordedFilePath != null && File(_recordedFilePath!).existsSync()) {
      Share.shareXFiles(
        [XFile(_recordedFilePath!)],
        text: 'ฟังเสียงร้องเพลงภาษาอังกฤษ "${widget.song.titleTh}" ของหนูสิคะ! 🎶💖',
      );
    }
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(1, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _flutterTts.stop();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F2FF),
      body: Column(
        children: [
          // 1. Header สีม่วง
          Container(
            color: purplePrimary,
            width: double.infinity,
            child: SafeArea(
              bottom: false,
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'คาราโอเกะเพลง',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          // 2. ส่วนหัวชื่อเพลง
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.song.titleEn.replaceAll('...', ''),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E293B),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.song.titleTh,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. กรอบเนื้อเพลงคาราโอเกะสีขาว ตัวอักษรใหญ่
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFEDE9FE), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(color: Color(0xFFFF8DA1), shape: BoxShape.circle),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      right: 14,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(color: Color(0xFFFFCA28), shape: BoxShape.circle),
                      ),
                    ),
                    Positioned(
                      bottom: 14,
                      left: 14,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(color: Color(0xFF42A5F5), shape: BoxShape.circle),
                      ),
                    ),
                    Positioned(
                      bottom: 14,
                      right: 14,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(color: Color(0xFF66BB6A), shape: BoxShape.circle),
                      ),
                    ),

                    Center(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        itemCount: widget.song.lyrics.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 18),
                        itemBuilder: (context, index) {
                          final line = widget.song.lyrics[index];
                          final bool isCurrent = (index == currentLyricIndex);

                          if (isCurrent) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF0F3),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: const Color(0xFFFFB3C1), width: 2.0),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    line.text,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFFFF407D),
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    line.translation,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(color: line.dotColor, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  line.text,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 21.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1E293B),
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // 4. แผงควบคุมด้านล่าง (สลับตามสถานะ)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: _recordedFilePath != null && !_isRecording
                ? _buildCompletedBottomPanel()
                : _buildStepControlBottomPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepControlBottomPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEDE9FE), width: 2),
      ),
      child: Column(
        children: [
          // ขั้นที่ 1: ฟังเสียงตัวอย่างก่อน
          GestureDetector(
            onTap: _togglePlayDemo,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF5FF),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFDDD6FE), width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFF7C3AED),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isDemoPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ขั้นที่ 1',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF7C3AED)),
                        ),
                        Text(
                          _isDemoPlaying ? 'กำลังเปิดเสียงตัวอย่าง...' : 'ฟังเสียงตัวอย่างก่อน',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '0:00 / ${widget.song.duration}',
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ขั้นที่ 2: อัดเสียงร้องของหนู
          GestureDetector(
            onTap: () {
              if (!_hasDemoFinished && !_isDemoPlaying) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('กดฟังเสียงตัวอย่างในขั้นที่ 1 ให้จบก่อนนะจ๊ะ! 🎵'),
                    backgroundColor: const Color(0xFF7C3AED),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                );
                return;
              }
              _isRecording ? _stopRecording() : _startRecording();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _isRecording ? const Color(0xFFFEF2F2) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _isRecording
                      ? const Color(0xFFEF4444)
                      : (_hasDemoFinished ? const Color(0xFFDDD6FE) : const Color(0xFFE2E8F0)),
                  width: 1.5,
                  style: _hasDemoFinished ? BorderStyle.solid : BorderStyle.none,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _isRecording
                          ? const Color(0xFFEF4444)
                          : (_hasDemoFinished ? const Color(0xFF8B5CF6) : const Color(0xFFE2E8F0)),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ขั้นที่ 2',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _isRecording ? Colors.red : const Color(0xFF7C3AED),
                          ),
                        ),
                        Text(
                          _isRecording
                              ? 'กำลังบันทึกเสียง... ${_formatDuration(_recordingSeconds)}'
                              : 'อัดเสียงร้องของหนู',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: _hasDemoFinished || _isRecording ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
                          ),
                        ),
                        if (!_hasDemoFinished && !_isRecording)
                          const Text(
                            'ฟังเสียงตัวอย่างจบก่อน ปุ่มอัดจึงจะเปิด',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF94A3B8)),
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
    );
  }

  Widget _buildCompletedBottomPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEDE9FE), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFFFF8DA1), shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(
                'อัดเสียงเสร็จแล้ว ความยาว ${_formatDuration(_recordingSeconds)}',
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(width: 6),
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFFFFCA28), shape: BoxShape.circle)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _recordedFilePath = null;
                      _isPlayingRecord = false;
                    });
                    _startRecording();
                  },
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDA4AF),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFDA4AF).withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE4E6),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFFDA4AF), width: 1.4),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'อัดใหม่',
                        style: TextStyle(
                          color: Color(0xFFE11D48),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: _togglePlayRecordedAudio,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7DD3FC),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7DD3FC).withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF7DD3FC), width: 1.4),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isPlayingRecord ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: const Color(0xFF0284C7),
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isPlayingRecord ? 'หยุดฟัง' : 'ฟังเสียงที่อัด',
                            style: const TextStyle(
                              color: Color(0xFF0284C7),
                              fontSize: 15.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _shareRecordedFile,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFF6D28D9),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(bottom: 3.5),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.6),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'ส่งให้ผู้ปกครอง',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}