import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class StoryDetailScreen extends StatefulWidget {
  final String title;

  const StoryDetailScreen({Key? key, this.title = 'Little Red Riding Hood'})
      : super(key: key);

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  late AudioPlayer _audioPlayer;
  bool _isPlayingAudio = false;

  late stt.SpeechToText _speech;
  bool _speechAvailable = false;
  bool _isListening = false;
  String _lastSpokenWords = '';

  bool isTranslated = false;

  bool _isRewinding = false;
  bool _isForwarding = false;

  int currentStoryIndex = 0;
  late List<Map<String, String>> storySteps;
  late String videoAssetPath;

  // ประกาศตัวแปรเก็บสถานะการตรวจคำและผลลัพธ์
  List<Map<String, dynamic>> spokenWords = [];
  List<String> incorrectWords = [];
  bool hasEvaluated = false;

  // ฐานข้อมูลวิดีโอและเนื้อเรื่องนิทานครบทั้ง 10 เรื่อง
  static final Map<String, Map<String, dynamic>> storyDatabase = {
    'Little Red Riding Hood': {
      'video': 'assets/videos/red_riding_hood.mp4',
      'steps': [
        {
          'en': 'Once upon a time, there was a kind girl.',
          'th': 'กาลครั้งหนึ่งนานมาแล้ว มีเด็กหญิงใจดีคนหนึ่ง',
        },
        {
          'en': 'She wore a bright red hood.',
          'th': 'เธอสวมหมวกคลุมสีแดงสดใส',
        },
        {
          'en': 'Everyone called her Little Red Riding Hood.',
          'th': 'ทุกคนเรียกเธอว่า หนูน้อยหมวกแดง',
        },
        {
          'en': 'Her mother gave her a basket of cakes.',
          'th': 'คุณแม่มอบตะกร้าขนมเค้กให้เธอ',
        },
        {
          'en': 'Please visit your grandma in the forest.',
          'th': 'ช่วยไปเยี่ยมคุณยายในป่าหน่อยนะจ๊ะ',
        },
        {
          'en': 'Do not talk to strangers on the way.',
          'th': 'อย่าคุยกับคนแปลกหน้าระหว่างทางเด็ดขาด',
        },
        {
          'en': 'A hungry wolf was watching her closely.',
          'th': 'หมาป่าตัวร้ายแอบมองเธออยู่อย่างใกล้ชิด',
        },
        {
          'en': 'The brave girl reached home safely.',
          'th': 'เด็กหญิงผู้กล้าหาญเดินทางถึงบ้านอย่างปลอดภัย',
        },
      ],
    },
    'The Ant and the Grasshopper': {
      'video': 'assets/videos/TheAnt_and_theGrasshopper.mp4',
      'steps': [
        {
          'en': 'A little ant worked hard all summer.',
          'th': 'มดตัวน้อยทำงานหนักตลอดฤดูร้อน',
        },
        {
          'en': 'He gathered plenty of food for winter.',
          'th': 'เขาเก็บสะสมอาหารไว้มากมายสำหรับฤดูหนาว',
        },
        {
          'en': 'The playful grasshopper was only singing.',
          'th': 'ตั๊กแตนผู้รักความสนุกเอาแต่ร้องเพลง',
        },
        {
          'en': 'Winter came and snow covered the ground.',
          'th': 'ฤดูหนาวมาถึงและหิมะปกคลุมพื้นดิน',
        },
        {
          'en': 'The grasshopper had nothing to eat.',
          'th': 'ตั๊กแตนไม่มีอาหารกินแม้แต่น้อย',
        },
        {
          'en': 'He asked the kind ant for help.',
          'th': 'เขาจึงไปขอความช่วยเหลือจากมดใจดี',
        },
        {
          'en': 'The ant shared his food generously.',
          'th': 'มดแบ่งปันอาหารให้ด้วยความเอื้อเฟื้อ',
        },
        {
          'en': 'Work hard today to enjoy tomorrow.',
          'th': 'จงขยันทำงานในวันนี้เพื่อความสุขในวันข้างหน้า',
        },
      ],
    },
    'The Boy Who Cried Wolf': {
      'video': 'assets/videos/TheBoy_WhoCriedWolf.mp4',
      'steps': [
        {
          'en': 'A shepherd boy watched his sheep near a village.',
          'th': 'เด็กเลี้ยงแกะดูแลฝูงแกะอยู่ใกล้กับหมู่บ้าน',
        },
        {
          'en': 'He felt bored and decided to play a trick.',
          'th': 'เขารู้สึกเบื่อจึงคิดจะเล่นตลกแกล้งคนอื่น',
        },
        {
          'en': 'Wolf, wolf, please help me!',
          'th': 'หมาป่ามาแล้ว ช่วยด้วยครับ!',
        },
        {
          'en': 'The villagers ran quickly to help him.',
          'th': 'ชาวบ้านต่างรีบวิ่งมาช่วยเหลือเขา',
        },
        {
          'en': 'The boy laughed because there was no wolf.',
          'th': 'เด็กชายหัวเราะชอบใจเพราะไม่มีหมาป่าจริงๆ',
        },
        {
          'en': 'One day, a real wolf attacked the flock.',
          'th': 'วันหนึ่ง หมาป่าตัวจริงได้บุกเข้ามาทำร้ายฝูงแกะ',
        },
        {
          'en': 'Nobody believed his cries for help.',
          'th': 'ไม่มีใครเชื่อเสียงร้องขอความช่วยเหลือของเขาอีกต่อไป',
        },
        {
          'en': 'Always tell the truth to build trust.',
          'th': 'จงพูดความจริงเสมอเพื่อสร้างความไว้วางใจ',
        },
      ],
    },
    'The Fox and the Stork': {
      'video': 'assets/videos/TheFox_and_theStork.mp4',
      'steps': [
        {
          'en': 'A sly fox invited a stork for dinner.',
          'th': 'สุนัขจิ้งจอกเจ้าเล่ห์เชิญนกกระสามากินอาหารเย็น',
        },
        {
          'en': 'He served delicious soup in a shallow dish.',
          'th': 'เขาเสิร์ฟซุปแสนอร่อยในจานก้นแบน',
        },
        {
          'en': 'The stork could not eat with her long beak.',
          'th': 'นกกระสาไม่สามารถกินได้เพราะมีจะงอยปากยาว',
        },
        {
          'en': 'Next day, the stork invited the fox over.',
          'th': 'วันต่อมา นกกระสาจึงเชิญสุนัขจิ้งจอกมาที่บ้านบ้าง',
        },
        {
          'en': 'She served soup in a tall, narrow jar.',
          'th': 'เธอเสิร์ฟซุปในเหยือกทรงสูงและแคบ',
        },
        {
          'en': 'The fox could not reach the food.',
          'th': 'สุนัขจิ้งจอกไม่สามารถกินอาหารได้เลย',
        },
        {
          'en': 'Treat others the way you want to be treated.',
          'th': 'จงปฏิบัติต่อผู้อื่นเช่นเดียวกับที่คุณอยากให้เขาปฏิบัติต่อคุณ',
        },
      ],
    },
    'The Goose That Laid the Golden Eggs': {
      'video': 'assets/videos/TheGoose_ThatLaid_theGoldenEggs.mp4',
      'steps': [
        {
          'en': 'A poor countryman owned a wonderful goose.',
          'th': 'ชาวชนบทผู้ยากจนเป็นเจ้าของห่านวิเศษตัวหนึ่ง',
        },
        {
          'en': 'Every morning, she laid a shining golden egg.',
          'th': 'ทุกๆ เช้า มันจะออกไข่เป็นทองคำสุกปลั่ง',
        },
        {
          'en': 'The man became rich very quickly.',
          'th': 'ชายคนนั้นร่ำรวยขึ้นมาอย่างรวดเร็ว',
        },
        {
          'en': 'He grew greedy and wanted all the gold at once.',
          'th': 'เขาเกิดความโลภและอยากได้ทองคำทั้งหมดในคราวเดียว',
        },
        {
          'en': 'He cut the goose open to find more gold.',
          'th': 'เขาจึงผ่าท้องห่านเพื่อหาทองคำเพิ่มเติม',
        },
        {
          'en': 'There was no gold inside the poor goose.',
          'th': 'แต่กลับไม่มีทองคำใดๆ อยู่ข้างในเลย',
        },
        {
          'en': 'Greed often leads to great loss.',
          'th': 'ความโลภมากมักนำมาซึ่งความสูญเสีย',
        },
      ],
    },
    'The Lion and the Fox': {
      'video': 'assets/videos/TheLion_and_theFox.mp4',
      'steps': [
        {
          'en': 'An old lion pretended to be very sick.',
          'th': 'สิงโตชราแกล้งทำเป็นป่วยหนัก',
        },
        {
          'en': 'He stayed inside his dark, deep cave.',
          'th': 'มันนอนนิ่งอยู่ภายในถ้ำที่มืดและลึก',
        },
        {
          'en': 'Many animals visited him and got eaten.',
          'th': 'สัตว์หลายตัวเข้าไปเยี่ยมและถูกจับกิน',
        },
        {
          'en': 'A clever fox stood outside the cave.',
          'th': 'สุนัขจิ้งจอกผู้ฉลาดหลักแหลมยืนดูอยู่หน้าถ้ำ',
        },
        {
          'en': 'I see many footprints going in.',
          'th': 'ฉันเห็นรอยเท้าสัตว์มากมายเดินเข้าไป',
        },
        {
          'en': 'None of the footprints are coming back out.',
          'th': 'แต่ไม่มีรอยเท้าใดเดินกลับออกมาเลย',
        },
        {
          'en': 'Wisdom and careful observation keep us safe.',
          'th': 'ความรอบคอบและช่างสังเกตช่วยให้เราปลอดภัย',
        },
      ],
    },
    'The Lion and the Mouse': {
      'video': 'assets/videos/TheLion_and_theMouse.mp4',
      'steps': [
        {
          'en': 'A giant lion was sleeping under a tree.',
          'th': 'สิงโตตัวใหญ่กำลังนอนหลับอยู่ใต้ต้นไม้',
        },
        {
          'en': 'A tiny mouse ran across his big nose.',
          'th': 'หนูตัวจิ๋ววิ่งซุกซนข้ามจมูกโตของมัน',
        },
        {
          'en': 'The lion caught the mouse with his paw.',
          'th': 'สิงโตตะปบจับหนูตัวนั้นไว้ได้ทันควัน',
        },
        {
          'en': 'Please spare me and I will help you one day.',
          'th': 'โปรดไว้ชีวิตข้าเถิด แล้วข้าจะตอบแทนท่านในวันหนึ่ง',
        },
        {
          'en': 'Later, the lion was trapped in a hunter net.',
          'th': 'ต่อมา สิงโตติดกับดักตาข่ายของนายพราน',
        },
        {
          'en': 'The little mouse chewed the ropes quickly.',
          'th': 'เจ้าหนูน้อยรีบวิ่งมากัดแทะเชือกจนขาด',
        },
        {
          'en': 'Even the smallest friend can be of great help.',
          'th': 'แม้แต่เพื่อนตัวเล็กที่สุดก็สามารถช่วยเหลือเราได้อย่างยิ่งใหญ่',
        },
      ],
    },
    'The Three Little Pigs': {
      'video': 'assets/videos/ThreeLittlePigs.mp4',
      'steps': [
        {
          'en': 'Three little pigs built their own houses.',
          'th': 'ลูกหมูสามตัวสร้างบ้านของตัวเอง',
        },
        {
          'en': 'The first pig built a house of straw.',
          'th': 'ลูกหมูตัวแรกสร้างบ้านด้วยฟางข้าว',
        },
        {
          'en': 'The second pig built a house of sticks.',
          'th': 'ลูกหมูตัวที่สองสร้างบ้านด้วยเศษไม้',
        },
        {
          'en': 'The third pig built a strong brick house.',
          'th': 'ลูกหมูตัวที่สามสร้างบ้านอิฐอันแข็งแรง',
        },
        {
          'en': 'The big bad wolf blew the weak houses down.',
          'th': 'หมาป่าตัวร้ายเป่าบ้านที่ไม่แข็งแรงจนพังทลาย',
        },
        {
          'en': 'He could not blow down the solid brick house.',
          'th': 'แต่มันไม่สามารถเป่าบ้านอิฐที่มั่นคงให้พังได้',
        },
        {
          'en': 'Hard work and patience ensure safety.',
          'th': 'ความพยายามและความอดทนนำมาซึ่งความปลอดภัย',
        },
      ],
    },
    'The Tortoise and the Hare': {
      'video': 'assets/videos/TheTortoise_and_theHare.mp4',
      'steps': [
        {
          'en': 'A speedy hare laughed at a slow tortoise.',
          'th': 'กระต่ายผู้วิ่งเร็วหัวเราะเยาะเต่าที่เดินชักช้า',
        },
        {
          'en': 'They decided to have a running race.',
          'th': 'พวกมันจึงตกลงที่จะแข่งวิ่งกัน',
        },
        {
          'en': 'The hare ran fast and took a nap.',
          'th': 'กระต่ายวิ่งนำไปไกลแล้วแวะนอนหลับพักผ่อน',
        },
        {
          'en': 'The tortoise walked slowly but never stopped.',
          'th': 'เจ้าเต่าเดินอย่างช้าๆ แต่ไม่เคยหยุดพักเลย',
        },
        {
          'en': 'The tortoise crossed the finish line first.',
          'th': 'ในที่สุด เจ้าเต่าก็เดินเข้าเส้นชัยเป็นตัวแรก',
        },
        {
          'en': 'Slow and steady always wins the race.',
          'th': 'ความสม่ำเสมอและความพยายามนำไปสู่ชัยชนะเสมอ',
        },
      ],
    },
    'The Ugly Duckling': {
      'video': 'assets/videos/The_Ugly_Duckling.mp4',
      'steps': [
        {
          'en': 'A little bird looked different from the others.',
          'th': 'ลูกนกตัวน้อยมีรูปร่างหน้าตาแตกต่างจากพี่น้อง',
        },
        {
          'en': 'Everyone called him an ugly duckling.',
          'th': 'ทุกคนต่างพากันเรียกเขาว่าลูกเป็ดขี้เหร่',
        },
        {
          'en': 'He felt sad and walked away alone.',
          'th': 'เขารู้สึกเศร้าใจจึงเดินจากไปตามลำพัง',
        },
        {
          'en': 'He survived the cold and harsh winter.',
          'th': 'เขาอดทนผ่านพ้นฤดูหนาวอันหนาวเหน็บมาได้',
        },
        {
          'en': 'In spring, he saw his reflection in the water.',
          'th': 'ในฤดูใบไม้ผลิ เขามองเห็นเงาสะท้อนของตัวเองในน้ำ',
        },
        {
          'en': 'He had grown into a beautiful white swan.',
          'th': 'เขาได้เติบโตกลายเป็นหงส์ขาวที่สง่างาม',
        },
        {
          'en': 'True beauty shines from within.',
          'th': 'ความงดงามที่แท้จริงจะเปล่งประกายจากข้างใน',
        },
      ],
    },
  };

  @override
  void initState() {
    super.initState();

    final storyData = storyDatabase[widget.title] ??
        storyDatabase['Little Red Riding Hood']!;

    videoAssetPath = storyData['video'] as String;
    storySteps = (storyData['steps'] as List)
        .map((item) => Map<String, String>.from(item as Map))
        .toList();

    _controller = VideoPlayerController.asset(
      videoAssetPath,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      });

    _controller.addListener(_videoListener);

    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
        });
      }
    });

    _speech = stt.SpeechToText();
    _initSpeech();
  }

  void _initSpeech() async {
    try {
      _speechAvailable = await _speech.initialize(
        onError: (val) {
          debugPrint('Speech Error: $val');
          if (mounted) {
            setState(() => _isListening = false);
            _evaluateSpeech(_lastSpokenWords);
          }
        },
        onStatus: (status) {
          debugPrint('Speech Status: $status');
          if (status == 'done' || status == 'notListening') {
            if (mounted) {
              setState(() => _isListening = false);
              _evaluateSpeech(_lastSpokenWords);
            }
          }
        },
      );
    } catch (e) {
      debugPrint("STT Init Exception: $e");
    }
  }

  Future<void> _speakSingleWord(String word) async {
    if (_isInitialized && _controller.value.isPlaying) {
      await _controller.pause();
    }
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }

    try {
      String cleanWord = word.replaceAll(RegExp(r'[^\w\s]'), '').trim();
      String audioUrl =
          "https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=en&q=${Uri.encodeComponent(cleanWord)}";

      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(audioUrl));
    } catch (e) {
      debugPrint("Single Word Audio Error: $e");
    }
  }

  void _toggleListening() async {
    if (_isInitialized && _controller.value.isPlaying) {
      await _controller.pause();
    }
    if (_isPlayingAudio) {
      await _audioPlayer.stop();
      setState(() => _isPlayingAudio = false);
    }

    if (!_isListening) {
      bool available = _speechAvailable;
      if (!available) {
        available = await _speech.initialize();
      }

      if (available) {
        setState(() {
          _isListening = true;
          _lastSpokenWords = '';
          spokenWords.clear();
          incorrectWords.clear();
          hasEvaluated = false;
        });

        _speech.listen(
          onResult: (val) {
            setState(() {
              _lastSpokenWords = val.recognizedWords;
            });
          },
          localeId: 'en_US',
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 5),
          partialResults: true,
          cancelOnError: false,
          listenMode: stt.ListenMode.dictation,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('กรุณาอนุญาตสิทธิ์การใช้งานไมโครโฟนเพื่อฝึกพูด'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      setState(() => _isListening = false);
      await _speech.stop();
      _evaluateSpeech(_lastSpokenWords);
    }
  }

  void _evaluateSpeech(String recognizedText) {
    String currentTarget = storySteps[currentStoryIndex]['en']!;

    List<String> targetWords = currentTarget
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .trim()
        .split(RegExp(r'\s+'));

    List<String> spokenWordsList = recognizedText
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .trim()
        .split(RegExp(r'\s+'));

    List<Map<String, dynamic>> evaluated = [];
    List<String> wrong = [];

    for (int i = 0; i < targetWords.length; i++) {
      String rawTarget = targetWords[i];
      String cleanTarget = rawTarget.toLowerCase();

      bool isMatch = false;

      if (i < spokenWordsList.length && spokenWordsList[i] == cleanTarget) {
        isMatch = true;
      } else if (spokenWordsList.contains(cleanTarget)) {
        isMatch = true;
      }

      if (!isMatch) {
        wrong.add(rawTarget);
      }

      evaluated.add({
        'word': rawTarget,
        'isCorrect': isMatch,
      });
    }

    setState(() {
      spokenWords = evaluated;
      incorrectWords = wrong;
      hasEvaluated = true;
    });
  }

  Future<void> _speakCurrentSentence() async {
    if (_isPlayingAudio) {
      await _audioPlayer.stop();
      if (mounted) setState(() => _isPlayingAudio = false);
      return;
    }

    if (_isInitialized && _controller.value.isPlaying) {
      await _controller.pause();
    }
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }

    try {
      setState(() => _isPlayingAudio = true);

      String text = storySteps[currentStoryIndex]['en']!;
      String audioUrl =
          "https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=en&q=${Uri.encodeComponent(text)}";

      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(audioUrl));
    } catch (e) {
      debugPrint("Audio Play Error: $e");
      if (mounted) setState(() => _isPlayingAudio = false);
    }
  }

  void _videoListener() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _speech.stop();
    _audioPlayer.dispose();
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  void toggleTranslation() {
    setState(() => isTranslated = !isTranslated);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void prevStoryStep() {
    _audioPlayer.stop();
    if (_isListening) _speech.stop();

    if (currentStoryIndex > 0) {
      setState(() {
        currentStoryIndex--;
        spokenWords.clear();
        incorrectWords.clear();
        _lastSpokenWords = '';
        hasEvaluated = false;
        isTranslated = false;
        _isListening = false;
        _isPlayingAudio = false;
      });
    }
  }

  void nextStoryStep() {
    _audioPlayer.stop();
    if (_isListening) _speech.stop();

    if (currentStoryIndex < storySteps.length - 1) {
      setState(() {
        currentStoryIndex++;
        spokenWords.clear();
        incorrectWords.clear();
        _lastSpokenWords = '';
        hasEvaluated = false;
        isTranslated = false;
        _isListening = false;
        _isPlayingAudio = false;
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 16,
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F7FF),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0077C8).withOpacity(0.10),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/tale/bravo.png',
                      width: 110,
                      height: 110,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.emoji_events_rounded,
                          color: Color(0xFF0077C8),
                          size: 56,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'ยินดีด้วย! คุณเรียนจบเรื่องนี้แล้ว',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0077C8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'คุณได้ฝึกอ่านและออกเสียงครบทั้ง ${storySteps.length} ประโยค',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            currentStoryIndex = 0;
                            spokenWords.clear();
                            incorrectWords.clear();
                            _lastSpokenWords = '';
                            hasEvaluated = false;
                            isTranslated = false;
                          });
                        },
                        icon: const Icon(Icons.replay_rounded, size: 18),
                        label: const Text('ฝึกอีกครั้ง'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF475569),
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text('สำเร็จ'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0077C8),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _rewind5Seconds() {
    if (_isInitialized) {
      setState(() => _isRewinding = true);
      final current = _controller.value.position;
      final target = current - const Duration(seconds: 5);
      _controller.seekTo(target < Duration.zero ? Duration.zero : target);

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => _isRewinding = false);
      });
    }
  }

  void _forward5Seconds() {
    if (_isInitialized) {
      setState(() => _isForwarding = true);
      final current = _controller.value.position;
      final total = _controller.value.duration;
      final target = current + const Duration(seconds: 5);
      _controller.seekTo(target > total ? total : target);

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => _isForwarding = false);
      });
    }
  }

  void _openFullScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(controller: _controller),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final position =
        _isInitialized ? _controller.value.position : Duration.zero;
    final duration =
        _isInitialized ? _controller.value.duration : Duration.zero;
    final currentStory = storySteps[currentStoryIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF00569E), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Color(0xFF00569E),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: _isInitialized
                              ? AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                        if (_isInitialized)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 18,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.fullscreen,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                onPressed: _openFullScreen,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  if (_isInitialized) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: const Color(0xFF0077C8),
                              inactiveTrackColor: Colors.grey.shade300,
                              thumbColor: const Color(0xFF0077C8),
                              trackHeight: 3.5,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 12,
                              ),
                            ),
                            child: Slider(
                              value: position.inMilliseconds
                                  .toDouble()
                                  .clamp(
                                      0.0, duration.inMilliseconds.toDouble()),
                              max: duration.inMilliseconds.toDouble() > 0
                                  ? duration.inMilliseconds.toDouble()
                                  : 1.0,
                              onChanged: (value) {
                                _controller.seekTo(
                                  Duration(milliseconds: value.toInt()),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(position),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  _formatDuration(duration),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _rewind5Seconds,
                          icon: Icon(
                            Icons.skip_previous,
                            size: 38,
                            color: _isRewinding
                                ? const Color(0xFFFF9800)
                                : const Color(0xFF0077C8),
                          ),
                        ),
                        const SizedBox(width: 24),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: _controller.value.isPlaying
                                ? const Color(0xFF0077C8)
                                : const Color(0xFF084B83),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              if (_isInitialized) {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                              }
                            },
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 34,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        IconButton(
                          onPressed: _forward5Seconds,
                          icon: Icon(
                            Icons.skip_next,
                            size: 38,
                            color: _isForwarding
                                ? const Color(0xFFFF9800)
                                : const Color(0xFF0077C8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF0066CC),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0066CC).withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  spokenWords.isEmpty
                      ? Text(
                          currentStory['en']!,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        )
                      : Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: spokenWords.map((item) {
                            return GestureDetector(
                              onTap: () {
                                if (!item['isCorrect']) {
                                  _speakSingleWord(item['word']);
                                }
                              },
                              child: Text(
                                "${item['word']} ",
                                style: TextStyle(
                                  fontSize: 18,
                                  height: 1.5,
                                  fontWeight: FontWeight.bold,
                                  color: item['isCorrect']
                                      ? Colors.green.shade600
                                      : Colors.red.shade600,
                                  decoration: !item['isCorrect']
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                  if (_isListening && _lastSpokenWords.isNotEmpty) ...[
                    const Divider(height: 24),
                    Row(
                      children: [
                        const Icon(Icons.graphic_eq,
                            size: 18, color: Colors.red),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'ได้ยิน: "$_lastSpokenWords"',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (hasEvaluated && !_isListening) ...[
                    const SizedBox(height: 16),
                    if (incorrectWords.isEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green.shade300),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.green.shade700, size: 22),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'ยอดเยี่ยมมาก! คุณออกเสียงถูกต้องครบทุกคำ 🎉',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.highlight_off,
                                    color: Colors.red.shade700, size: 20),
                                const SizedBox(width: 6),
                                Text(
                                  'คำที่ออกเสียงไม่ชัด (แตะที่คำเพื่อฟังเสียง):',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: incorrectWords.map((word) {
                                return ActionChip(
                                  avatar: const Icon(
                                    Icons.volume_up,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  label: Text(
                                    word,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  backgroundColor: Colors.red.shade600,
                                  onPressed: () => _speakSingleWord(word),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _toggleListening,
                                icon: const Icon(Icons.refresh, size: 18),
                                label: const Text(
                                  'กดตรงนี้เพื่อลองพูดใหม่อีกครั้ง',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red.shade700,
                                  side: BorderSide(
                                      color: Colors.red.shade400, width: 1.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _speakCurrentSentence,
                    icon: Icon(
                      _isPlayingAudio ? Icons.volume_off : Icons.volume_up,
                      size: 18,
                    ),
                    label: Text(
                      _isPlayingAudio ? 'หยุดพูด' : 'ฟังตัวอย่าง',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isPlayingAudio
                          ? const Color(0xFFFF9800)
                          : const Color(0xFF0088FF),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: toggleTranslation,
                    icon: const Icon(Icons.translate, size: 18),
                    label: Text(
                      isTranslated ? 'ซ่อนแปล' : 'แปลภาษา',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isTranslated
                          ? const Color(0xFF084B83)
                          : const Color(0xFF0088FF),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _toggleListening,
                    icon: Icon(_isListening ? Icons.stop : Icons.mic, size: 18),
                    label: Text(
                      _isListening ? 'หยุดฟัง' : 'ลองพูดเลย',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isListening ? Colors.red : const Color(0xFF0088FF),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (isTranslated)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  currentStory['th']!,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.white,
                  ),
                ),
              ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentStoryIndex > 0)
                  ElevatedButton.icon(
                    onPressed: prevStoryStep,
                    icon: const Icon(Icons.arrow_back_ios,
                        size: 16, color: Color(0xFF00569E)),
                    label: const Text(
                      'ย้อนกลับ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00569E),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                          color: Color(0xFF00569E), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  )
                else
                  const SizedBox(),

                ElevatedButton(
                  onPressed: nextStoryStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00569E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentStoryIndex == storySteps.length - 1
                            ? 'จบเรื่อง'
                            : 'อ่านต่อ (${currentStoryIndex + 1}/${storySteps.length})',
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({Key? key, required this.controller})
      : super(key: key);

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    widget.controller.addListener(_videoListener);
  }

  void _videoListener() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_videoListener);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final position = controller.value.position;
    final duration = controller.value.duration;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),
            if (_showControls) ...[
              Container(color: Colors.black45),
              Positioned(
                top: 20,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.fullscreen_exit,
                      color: Colors.white, size: 32),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 48,
                    icon: const Icon(Icons.replay_5_rounded,
                        color: Colors.white),
                    onPressed: () {
                      final target = position - const Duration(seconds: 5);
                      controller.seekTo(
                          target < Duration.zero ? Duration.zero : target);
                    },
                  ),
                  const SizedBox(width: 32),
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white24,
                    child: IconButton(
                      iconSize: 48,
                      icon: Icon(
                        controller.value.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          controller.value.isPlaying
                              ? controller.pause()
                              : controller.play();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 32),
                  IconButton(
                    iconSize: 48,
                    icon: const Icon(Icons.forward_5_rounded,
                        color: Colors.white),
                    onPressed: () {
                      final target = position + const Duration(seconds: 5);
                      controller.seekTo(
                          target > duration ? duration : target);
                    },
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                left: 24,
                right: 24,
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF0088FF),
                        inactiveTrackColor: Colors.white30,
                        thumbColor: const Color(0xFF0088FF),
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6),
                      ),
                      child: Slider(
                        value: position.inMilliseconds
                            .toDouble()
                            .clamp(0.0, duration.inMilliseconds.toDouble()),
                        max: duration.inMilliseconds.toDouble() > 0
                            ? duration.inMilliseconds.toDouble()
                            : 1.0,
                        onChanged: (value) {
                          controller.seekTo(
                            Duration(milliseconds: value.toInt()),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(position),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                          Text(
                            _formatDuration(duration),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}