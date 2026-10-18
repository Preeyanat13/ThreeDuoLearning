import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'word_riddle_screen.dart';

class RiddleQuestion {
  final String clue;
  final String thaiClue;
  final String answer;
  final String categoryKey;
  final String imagePath;

  const RiddleQuestion({
    required this.clue,
    required this.thaiClue,
    required this.answer,
    required this.categoryKey,
    required this.imagePath,
  });
}

class PlacedLetter {
  final String char;
  final int originalKeyIndex;

  PlacedLetter({required this.char, required this.originalKeyIndex});
}

class RiddleGamePlayScreen extends StatefulWidget {
  final RiddleCategoryItem category;

  const RiddleGamePlayScreen({super.key, required this.category});

  @override
  State<RiddleGamePlayScreen> createState() => _RiddleGamePlayScreenState();
}

class _RiddleGamePlayScreenState extends State<RiddleGamePlayScreen>
    with TickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();

  final List<RiddleQuestion> _masterQuestions = const [
    // ----------------------------------------------------
    // หมวดสัตว์ (animal)
    // ----------------------------------------------------
    RiddleQuestion(
      clue: "A large furry animal with big paws that loves fish and honey!",
      thaiClue: "สัตว์ตัวใหญ่ขนหนา ชอบกินปลาและน้ำผึ้ง",
      answer: "BEAR",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Bear.png",
    ),
    RiddleQuestion(
      clue: "A creature with feathers and wings that flies in the sky!",
      thaiClue: "สัตว์ปีกตัวเล็ก มีขนนุ่ม บินอยู่บนท้องฟ้า",
      answer: "BIRD",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Bird.png",
    ),
    RiddleQuestion(
      clue: "A beautiful insect with colorful wings that drinks flower nectar!",
      thaiClue: "แมลงปีกสวยหลากสีสัน ชอบบินตอมดูดน้ำหวานจากดอกไม้",
      answer: "BUTTERFLY",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Butterfly.png",
    ),
    RiddleQuestion(
      clue: "A cute pet with whiskers that loves fish and says 'Meow!'",
      thaiClue: "สัตว์เลี้ยงน่ารัก มีหนวด ร้องเหมียวๆ ชอบกินปลา",
      answer: "CAT",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Cat.png",
    ),
    RiddleQuestion(
      clue: "A farm bird that clucks and gives us fresh eggs!",
      thaiClue: "สัตว์ปีกในฟาร์ม ส่งเสียงกระต๊ากและออกไข่ให้เรากิน",
      answer: "CHICKEN",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Chicken.png",
    ),
    RiddleQuestion(
      clue: "A farm animal with spots that gives us fresh white milk!",
      thaiClue: "สัตว์เลี้ยงในฟาร์มตัวใหญ่ ให้น้ำนมสีขาวแสนอร่อย",
      answer: "COW",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Cow.png",
    ),
    RiddleQuestion(
      clue: "A big green reptile with sharp teeth living near rivers!",
      thaiClue: "สัตว์เลื้อยคลานตัวใหญ่ ผิวขรุขระ ฟันแหลมคม อาศัยริมน้ำ",
      answer: "CROCODILE",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Crocodile.png",
    ),
    RiddleQuestion(
      clue:
          "Man's best friend with 4 legs that wags its tail and barks 'Woof!'",
      thaiClue: "เพื่อนซี้แสนรู้ มี 4 ขา ชอบกระดิกหางและเห่าโฮ่งๆ",
      answer: "DOG",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Dog.png",
    ),
    RiddleQuestion(
      clue: "A very smart and friendly sea creature that loves jumping!",
      thaiClue: "สัตว์น้ำแสนฉลาด ขี้เล่น ชอบกระโดดเหนือน้ำ",
      answer: "DOLPHIN",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Dolphin.png",
    ),
    RiddleQuestion(
      clue: "A water bird with webbed feet that quacks loudly!",
      thaiClue: "สัตว์ปีกชอบว่ายน้ำ ปากแบน ส่งเสียงร้องก้าบๆ",
      answer: "DUCK",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Duck.png",
    ),
    RiddleQuestion(
      clue: "The biggest land mammal with a very long trunk and big ears!",
      thaiClue: "สัตว์บกตัวใหญ่ที่สุดในโลก มีงวงยาวและใบหูใหญ่",
      answer: "ELEPHANT",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Elephant.png",
    ),
    RiddleQuestion(
      clue:
          "An animal that lives underwater, breathes with gills, and swims with fins!",
      thaiClue: "สัตว์ที่อาศัยอยู่ในน้ำ ว่ายน้ำไว หายใจด้วยเหงือก",
      answer: "FISH",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Fish.png",
    ),
    RiddleQuestion(
      clue: "A small green animal with long back legs that hops and croaks!",
      thaiClue: "สัตว์ตัวเขียว กระโดดไกล ร้องอ๊บๆ ชอบอยู่ใกล้หนองน้ำ",
      answer: "FROG",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Frog.png",
    ),
    RiddleQuestion(
      clue: "The tallest animal on Earth with an extraordinarily long neck!",
      thaiClue: "สัตว์ที่สูงที่สุดในโลก มีคอยาวไว้กินใบไม้บนยอดไม้",
      answer: "GIRAFFE",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Giraffe.png",
    ),
    RiddleQuestion(
      clue:
          "A fast animal with hooves and a flowing mane that people can ride!",
      thaiClue: "สัตว์แข็งแรง วิ่งเร็ว มีแผงคอสง่างาม คนนิยมขี่",
      answer: "HORSE",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Horse.png",
    ),
    RiddleQuestion(
      clue: "A fluffy Australian tree animal that loves eucalyptus leaves!",
      thaiClue: "สัตว์ขนฟูน่ารักจากออสเตรเลีย ชอบกินใบยูคาลิปตัส",
      answer: "KOALA",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Koala.png",
    ),
    RiddleQuestion(
      clue:
          "The brave king of the beasts with a huge golden mane and mighty roar!",
      thaiClue: "ราชาแห่งป่าขนฟู มีเสียงคำรามกึกก้องน่าเกรงขาม",
      answer: "LION",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Lion.png",
    ),
    RiddleQuestion(
      clue: "A tiny buzzing insect that bites and feeds on blood!",
      thaiClue: "แมลงตัวเล็กมีปีก ส่งเสียงหึ่งๆ ชอบดูดเลือด",
      answer: "MOSQUITO",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Mosquito.png",
    ),
    RiddleQuestion(
      clue:
          "A nocturnal bird with big round eyes that turns its head all round!",
      thaiClue: "นกตาโต ตื่นหากินในเวลากลางคืน หมุนคอได้รอบทิศ",
      answer: "OWL",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Owl.png",
    ),
    RiddleQuestion(
      clue:
          "A magnificent bird famous for fanning out its colorful patterned feathers!",
      thaiClue: "นกสวยงามตัวใหญ่ ชอบรำแพนหางสีสันสดใสอวดสายตา",
      answer: "PEACOCK",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Peacock.png",
    ),
    RiddleQuestion(
      clue:
          "A tuxedo-colored bird that cannot fly but swims swiftly in freezing ice!",
      thaiClue: "นกสีขาวดำ บินไม่ได้แต่ว่ายน้ำเก่งมาก อาศัยในแถบขั้วโลก",
      answer: "PENGUIN",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Penguin.png",
    ),
    RiddleQuestion(
      clue:
          "A chubby pink animal with a curly tail and snout that says 'Oink oink'!",
      thaiClue: "สัตว์ตัวอ้วนสีชมพู มีหางขดม้วน จมูกกลม ร้องอู๊ดๆ",
      answer: "PIG",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Pig.png",
    ),
    RiddleQuestion(
      clue:
          "A cute furry creature with long ears and a fluffy tail that loves carrots!",
      thaiClue: "สัตว์หูยาว กระโดดไว ขนปุกปุย ชอบแทะกินแคร์รอต",
      answer: "RABBIT",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Rabbit.png",
    ),
    RiddleQuestion(
      clue: "A fluffy farm animal covered in warm wool that says 'Baa baa'!",
      thaiClue: "สัตว์ขนปุกปุยสีขาวหนานุ่ม นำขนมาทำเสื้อกันหนาวได้",
      answer: "SHEEP",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Sheep.webp",
    ),
    RiddleQuestion(
      clue: "A small curved sea animal with many legs and a tail shell!",
      thaiClue: "สัตว์น้ำตัวงอ มีหนวดและเปลือกบางๆ เนื้ออร่อย",
      answer: "SHRIMP",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Shrimp.png",
    ),
    RiddleQuestion(
      clue: "A long scaly reptile with no legs that slithers quietly!",
      thaiClue: "สัตว์เลื้อยคลานลำตัวยาว ไม่มีขา เลื้อยเงียบเชียบ",
      answer: "SNAKE",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Snake.png",
    ),
    RiddleQuestion(
      clue: "An eight-legged creature that weaves sticky webs to catch bugs!",
      thaiClue: "สัตว์ตัวเล็ก 8 ขา ชอบชักใยดักจับแมลง",
      answer: "SPIDER",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Spider.png",
    ),
    RiddleQuestion(
      clue: "A fierce wild cat with bold black and orange stripes!",
      thaiClue: "สัตว์นักล่าตระกูลแมว ลายพาดกลอนสีส้มดำ ว่องไว",
      answer: "TIGER",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Tiger.png",
    ),
    RiddleQuestion(
      clue:
          "A gentle creature with a hard protective shell that moves very slowly!",
      thaiClue: "สัตว์มีกระดองแข็ง เดินต้วมเตี้ยมเชื่องช้า อายุยืนยาว",
      answer: "TURTLE",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Turtle.webp",
    ),
    RiddleQuestion(
      clue:
          "A wild horse-like animal with striking black and white striped coats!",
      thaiClue: "สัตว์ตระกูลม้าในทุ่งหญ้า มีลวดลายทางขาวดำโดดเด่น",
      answer: "ZEBRA",
      categoryKey: "animal",
      imagePath: "assets/images/guess/animal/Zebra.png",
    ),

    // ----------------------------------------------------
    // หมวดอาชีพ (career) 25 อาชีพ
    // ----------------------------------------------------
    RiddleQuestion(
      clue: "A creative person who paints beautiful pictures and drawings!",
      thaiClue: "ผู้สร้างสรรค์งานศิลปะ วาดภาพระบายสีด้วยจินตนาการ",
      answer: "ARTIST",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Artist.png",
    ),
    RiddleQuestion(
      clue: "A strong person trained to compete in sports and fitness!",
      thaiClue: "ผู้ฝึกฝนร่างกายอย่างแข็งแกร่ง ลงแข่งขันกีฬาประเภทต่างๆ",
      answer: "ATHLETE",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Athlete.png",
    ),
    RiddleQuestion(
      clue:
          "A skilled person who makes and repairs wooden objects and furniture!",
      thaiClue: "ช่างฝีมือผู้สร้างและซ่อมแซมสิ่งของต่างๆ จากเนื้อไม้",
      answer: "CARPENTER",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Carpenter.png",
    ),
    RiddleQuestion(
      clue:
          "A professional cook who prepares delicious food in a kitchen!",
      thaiClue: "ผู้เชี่ยวชาญการทำอาหาร ปรุงจานอร่อยในห้องครัว",
      answer: "CHEF",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Chef.png",
    ),
    RiddleQuestion(
      clue:
          "A person who performs rhythmic movements and dance on stage!",
      thaiClue: "ผู้แสดงลีลาท่าทาง เคลื่อนไหวร่างกายเข้ากับจังหวะดนตรี",
      answer: "DANCER",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Dancer.png",
    ),
    RiddleQuestion(
      clue:
          "A doctor who takes care of people's teeth, gums, and smiles!",
      thaiClue: "คุณหมอผู้ดูแลสุขภาพช่องปากและรักษาฟันให้แข็งแรง",
      answer: "DENTIST",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Dentist.png",
    ),
    RiddleQuestion(
      clue:
          "A medical specialist who treats sick people and heals illnesses!",
      thaiClue: "แพทย์ผู้ตรวจรักษาและดูแลผู้ป่วยให้หายจากโรคภัย",
      answer: "DOCTOR",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Doctor.png",
    ),
    RiddleQuestion(
      clue:
          "A person who operates vehicles like cars, buses, and taxis!",
      thaiClue: "ผู้ควบคุมยานพาหนะ ขับรถส่งผู้โดยสารสู่จุดหมายปลอดภัย",
      answer: "DRIVER",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Driver.png",
    ),
    RiddleQuestion(
      clue:
          "A technician who installs and repairs electric wires and power!",
      thaiClue: "ช่างผู้เชี่ยวชาญระบบไฟฟ้า ติดตั้งและซ่อมแซมอุปกรณ์ไฟ",
      answer: "ELECTRICIAN",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Electrician.png",
    ),
    RiddleQuestion(
      clue:
          "A specialist who designs, builds, and designs machines and bridges!",
      thaiClue:
          "ผู้ออกแบบ วางแผน และควบคุมการก่อสร้างสิ่งก่อสร้างหรือเครื่องจักร",
      answer: "ENGINEER",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Engineer.png",
    ),
    RiddleQuestion(
      clue:
          "A hardworking person who grows rice, crops, and raises farm animals!",
      thaiClue: "ผู้ปลูกข้าว พืชผักผลไม้ และเลี้ยงสัตว์ในฟาร์ม",
      answer: "FARMER",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Farmer.png",
    ),
    RiddleQuestion(
      clue: "A brave hero who extinguishes fires and rescues people!",
      thaiClue: "ผู้กล้าหาญดับเปลวเพลิงและเข้าช่วยเหลือผู้ประสบภัย",
      answer: "FIREFIGHTER",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Firefighter.png",
    ),
    RiddleQuestion(
      clue: "A person who catches fish and seafood from the ocean!",
      thaiClue: "ผู้ออกเรือหาปลาและสัตว์น้ำจากท้องทะเลมาจำหน่าย",
      answer: "FISHERMAN",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Fisherman.png",
    ),
    RiddleQuestion(
      clue:
          "A reporter who writes news articles and broadcasts daily stories!",
      thaiClue: "นักข่าวผู้ค้นหาความจริงและรายงานข่าวสารให้ประชาชนทราบ",
      answer: "JOURNALIST",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Journalist.png",
    ),
    RiddleQuestion(
      clue:
          "A legal expert who advises people on the law and speaks in court!",
      thaiClue: "ผู้เชี่ยวชาญด้านกฎหมาย ว่าความและให้คำปรึกษาในศาล",
      answer: "LAWYER",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Lawyer.png",
    ),
    RiddleQuestion(
      clue:
          "A talented person who plays musical instruments like guitar and piano!",
      thaiClue: "ผู้บรรเลงเครื่องดนตรี สร้างสรรค์เสียงเพลงไพเราะ",
      answer: "MUSICIAN",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Musician.png",
    ),
    RiddleQuestion(
      clue:
          "A caring healthcare worker who assists doctors and looks after patients!",
      thaiClue: "พยาบาลผู้ดูแลเอาใจใส่ผู้ป่วยในโรงพยาบาลด้วยความเมตตา",
      answer: "NURSE",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Nurse.png",
    ),
    RiddleQuestion(
      clue:
          "An expert who prepares and dispenses medicine at a pharmacy!",
      thaiClue: "เภสัชกรผู้มีความรู้ด้านยา จ่ายยาตามใบสั่งแพทย์",
      answer: "PHARMACIST",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Pharmacist.png",
    ),
    RiddleQuestion(
      clue: "A person who captures moments and photos with a camera!",
      thaiClue: "ช่างภาพผู้บันทึกภาพความทรงจำด้วยกล้องถ่ายรูป",
      answer: "PHOTOGRAPHER",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Photographer.png",
    ),
    RiddleQuestion(
      clue:
          "A trained professional who flies aircraft through the sky!",
      thaiClue: "นักบินผู้บังคับเครื่องบินพาทุกคนเดินทางข้ามฟ้า",
      answer: "PILOT",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Pilot.png",
    ),
    RiddleQuestion(
      clue:
          "An officer in uniform who protects citizens and catches criminals!",
      thaiClue: "เจ้าหน้าที่ตำรวจดูแลความสงบเรียบร้อยและพิทักษ์ความปลอดภัย",
      answer: "POLICE",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Policeofficer.png",
    ),
    RiddleQuestion(
      clue:
          "A mail carrier who delivers letters and packages to homes!",
      thaiClue: "บุรุษไปรษณีย์ผู้นำส่งจดหมายและพัสดุถึงหน้าบ้าน",
      answer: "POSTMAN",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Postman.png",
    ),
    RiddleQuestion(
      clue: "A performer who sings songs with a melodious voice!",
      thaiClue: "นักร้องผู้ขับขานบทเพลงด้วยน้ำเสียงไพเราะ",
      answer: "SINGER",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Singer.png",
    ),
    RiddleQuestion(
      clue:
          "A brave person in uniform who serves in the army and defends the nation!",
      thaiClue: "ทหารกล้าผู้ปกป้องอธิปไตยและความมั่นคงของประเทศ",
      answer: "SOLDIER",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Soldier.png",
    ),
    RiddleQuestion(
      clue:
          "An educator who teaches knowledge and inspires students in school!",
      thaiClue: "คุณครูผู้ถ่ายทอดความรู้และคอยอบรมสั่งสอนเด็กๆ",
      answer: "TEACHER",
      categoryKey: "career",
      imagePath: "assets/images/guess/jobs/Teacher.png",
    ),
    // ----------------------------------------------------
    // คำใบ้หมวดเสื้อผ้า (clothing)
    // ----------------------------------------------------
    RiddleQuestion(
      clue: "Something you wear on your back to carry books and things!",
      thaiClue: "กระเป๋าสำหรับสะพายหลัง ไว้ใส่หนังสือหรือของใช้ต่างๆ",
      answer: "BACKPACK",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Backpack.png",
    ),
    RiddleQuestion(
      clue:
          "A container made of cloth or leather, with handles, to hold objects!",
      thaiClue: "ภาชนะสำหรับใส่ของ ทำจากผ้าหรือหนัง มีหูหิ้ว",
      answer: "BAG",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Bag.png",
    ),
    RiddleQuestion(
      clue: "A flexible strap worn around the waist to support clothes!",
      thaiClue: "สายคาดเอว สำหรับรัดกางเกงหรือกระโปรงให้กระชับ",
      answer: "BELT",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Belt.png",
    ),
    RiddleQuestion(
      clue: "Footwear that covers the foot and part of the leg!",
      thaiClue: "รองเท้าที่หุ้มข้อเท้าหรือหน้าแข้ง",
      answer: "BOOTS",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Boots.png",
    ),
    RiddleQuestion(
      clue: "A types of hat with a peak to shade the eyes!",
      thaiClue: "หมวกแก๊ป มีปีกยื่นด้านหน้าเพื่อกันแดดส่องตา",
      answer: "CAP",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Cap.png",
    ),
    RiddleQuestion(
      clue: "A one-piece garment for a woman, typically with a skirt!",
      thaiClue: "ชุดสำหรับผู้หญิง ที่เสื้อและกระโปรงติดกัน",
      answer: "DRESS",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Dress.png",
    ),
    RiddleQuestion(
      clue: "Jewelry worn through the earlobe!",
      thaiClue: "เครื่องประดับสำหรับใส่หู",
      answer: "EARRINGS",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Earrings.png",
    ),
    RiddleQuestion(
      clue: "Lenses in a frame resting on the nose and ears, to aid vision!",
      thaiClue: "แว่นสายตา มีเลนส์ช่วยการมองเห็น",
      answer: "GLASSES",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Glasses.png",
    ),
    RiddleQuestion(
      clue: "Headwear worn for warmth, protection, or decoration!",
      thaiClue: "หมวกสำหรับใส่สวมศีรษะ เพื่อป้องกันหรือประดับ",
      answer: "HAT",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Hat.png",
    ),
    RiddleQuestion(
      clue: "A sweatshirt with an attached hood!",
      thaiClue: "เสื้อสเวตเตอร์ มีหมวกคลุมศีรษะติดมาด้วย",
      answer: "HOODIE",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Hoodie.png",
    ),
    RiddleQuestion(
      clue: "A short coat worn for warmth or decoration!",
      thaiClue: "เสื้อนอกแขนยาว ใส่คลุมเพื่อป้องกันความหนาว",
      answer: "JACKET",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Jacket.png",
    ),
    RiddleQuestion(
      clue: "Trousers made from durable cotton fabric, often blue denim!",
      thaiClue: "กางเกงขายาวทำจากผ้าฝ้ายเนื้อหนา มักเป็นสีฟ้า",
      answer: "JEANS",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Jeans.png",
    ),
    RiddleQuestion(
      clue: "A types of jewelry worn around the neck!",
      thaiClue: "สร้อยสำหรับคล้องคอ",
      answer: "NECKLACE",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Necklace.png",
    ),
    RiddleQuestion(
      clue: "A types of clothes worn for sleeping, often with loose trousers!",
      thaiClue: "ชุดสำหรับใส่สวมเวลานอน มักเป็นเสื้อกับกางเกงขายาวหลวมๆ",
      answer: "PAJAMAS",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Pajamas.png",
    ),
    RiddleQuestion(
      clue: "Outerwear garment covering each leg separately from the waist!",
      thaiClue: "กางเกงสำหรับใส่สวม ตั้งแต่เอวลงมา",
      answer: "PANTS",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Pants.png",
    ),
    RiddleQuestion(
      clue: "A water-resistant types of coat for wearing in the rain!",
      thaiClue: "เสื้อนอกกันน้ำ สำหรับใส่สวมเวลากันฝน",
      answer: "RAINCOAT",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Raincoat.png",
    ),
    RiddleQuestion(
      clue: "A simple circle, made of precious metal, worn on a finger!",
      thaiClue: "เครื่องประดับทรงกลม ทำจากโลหะมีค่า ใส่สวมที่นิ้ว",
      answer: "RING",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Ring.png",
    ),
    RiddleQuestion(
      clue: "A types of cloth worn around the neck for warmth or style!",
      thaiClue: "ผ้าสำหรับพันรอบคอ เพื่อป้องกันความหนาวหรือประดับ",
      answer: "SCARF",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Scarf.png",
    ),
    RiddleQuestion(
      clue:
          "A garment for the upper body, typically with a collar and buttons!",
      thaiClue: "เสื้อสำหรับใส่สวมท่อนบน มักมีปกและกระดุม",
      answer: "SHIRT",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Shirt.png",
    ),
    RiddleQuestion(
      clue: "Footwear for everyday wear, typically having a distinct sole!",
      thaiClue: "รองเท้าสำหรับใส่สวม มักมีพื้นรองเท้าชัดเจน",
      answer: "SHOES",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Shoes.png",
    ),
    RiddleQuestion(
      clue: "Short trousers covering each leg separately up to the knee!",
      thaiClue: "กางเกงสำหรับใส่สวมท่อนล่าง ที่สั้นประมาณเข่า",
      answer: "SHORTS",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Shorts.png",
    ),
    RiddleQuestion(
      clue: "A types of garment hanging from the waist, typical for women!",
      thaiClue: "กระโปรงสำหรับใส่สวมท่อนล่าง ที่ห้อยตั้งแต่เอว",
      answer: "SKIRT",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Skirt.png",
    ),
    RiddleQuestion(
      clue:
          "A types of garment for the foot, typically extending up to the ankle!",
      thaiClue: "ถุงเท้าสำหรับใส่สวมท่อนล่าง ที่หุ้มถึงข้อเท้า",
      answer: "SOCKS",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Socks.png",
    ),
    RiddleQuestion(
      clue: "Glasses that block out the sun and have darkened lenses!",
      thaiClue: "แว่นกันแดด มีเลนส์ทึบเพื่อป้องกันแสงแดด",
      answer: "SUNGLASSES",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Sunglasses.png",
    ),
    RiddleQuestion(
      clue: "A heavy shirt, typically worn for warmth, with no collar!",
      thaiClue:
          "เสื้อสเวตเตอร์ มีเนื้อหนา ใส่สวมเพื่อป้องกันความหนาว มักไม่มีปก",
      answer: "SWEATER",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Sweater.png",
    ),
    RiddleQuestion(
      clue: "A specialized suit for swimming in!",
      thaiClue: "ชุดสำหรับใส่สวมเวลาว่ายน้ำ",
      answer: "SWIMSUIT",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Swimsuit.png",
    ),
    RiddleQuestion(
      clue: "A types of garment with two equal ends, tied around the neck!",
      thaiClue: "เนคไท มีปลายสองข้างเท่ากัน พันรอบคอ",
      answer: "TIE",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Tie.png",
    ),
    RiddleQuestion(
      clue: "A casual tops garment made of cotton, with short sleeves!",
      thaiClue: "เสื้อยืดคอกลม แขนสั้น ทำจากผ้าฝ้าย",
      answer: "TSHIRT",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/T-shirt.png",
    ),
    RiddleQuestion(
      clue:
          "A standardized set of clothing worn by members of an organization!",
      thaiClue: "ชุดแบบเดียวกัน ใส่สวมโดยสมาชิกขององค์กร",
      answer: "UNIFORM",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Uniform.png",
    ),
    RiddleQuestion(
      clue: "A small types of clock that is typically worn on the wrist!",
      thaiClue: "นาฬิกาสำหรับใส่สวมที่ข้อมือ",
      answer: "WATCH",
      categoryKey: "clothing",
      imagePath: "assets/images/guess/Clothes/Watch.png",
    ),

    // ----------------------------------------------------
    // คำใบ้หมวดกิจวัตรประจำวัน
    // ----------------------------------------------------
    RiddleQuestion(
      clue: "To use a toothbrush to clean your teeth!",
      thaiClue: "ใช้แปรงสีฟันทำความสะอาดฟัน",
      answer: "BRUSHMYTEETH",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Brushmyteeth.png",
    ),
    RiddleQuestion(
      clue: "To tidy and put things away in your own room!",
      thaiClue: "จัดของให้เป็นระเบียบและเก็บของในห้องนอน",
      answer: "CLEANMYROOM",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Cleanmyroom.png",
    ),
    RiddleQuestion(
      clue: "To use a comb to make your hair neat!",
      thaiClue: "ใช้หวีจัดทรงผมให้เรียบร้อย",
      answer: "COMBMYHAIR",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Combmyhair.png",
    ),
    RiddleQuestion(
      clue: "Work that teachers give to students to do at home!",
      thaiClue: "งานที่คุณครูให้ไปทำที่บ้าน",
      answer: "DOHOMEWORK",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Dohomework.png",
    ),
    RiddleQuestion(
      clue: "Pictures and stories that happen in your mind when you sleep!",
      thaiClue: "ภาพและเรื่องราวที่เกิดขึ้นในหัวตอนหลับ",
      answer: "DREAM",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Dream.png",
    ),
    RiddleQuestion(
      clue: "To swallow water!",
      thaiClue: "กลืนน้ำลงคอ",
      answer: "DRINKWATER",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Drinkwater.png",
    ),
    RiddleQuestion(
      clue: "To move your body to get fit and strong!",
      thaiClue: "เคลื่อนไหวร่างกายเพื่อให้แข็งแรง",
      answer: "EXERCISE",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Exercise.png",
    ),
    RiddleQuestion(
      clue: "To put on your clothes in the morning!",
      thaiClue: "ใส่เสื้อผ้าตอนเช้า",
      answer: "GETDRESSED",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Getdressed.png",
    ),
    RiddleQuestion(
      clue: "To move out of your bed after sleeping!",
      thaiClue: "ลุกออกจากเตียงหลังตื่นนอน",
      answer: "GETUP",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Getup.png",
    ),
    RiddleQuestion(
      clue: "To return to the place where you live!",
      thaiClue: "กลับไปยังที่พักอาศัย",
      answer: "GOHOME",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Gohome.png",
    ),
    RiddleQuestion(
      clue: "To visit stores to buy things like food or clothes!",
      thaiClue: "ไปที่ร้านค้าเพื่อซื้อของ",
      answer: "GOSHOPPING",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Goshopping.png",
    ),
    RiddleQuestion(
      clue: "To travel to the place where you learn with teachers!",
      thaiClue: "เดินทางไปยังสถานที่เรียนหนังสือ",
      answer: "GOTOSCHOOL",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Gotoschool.png",
    ),
    RiddleQuestion(
      clue: "To eat the first meal of the day in the morning!",
      thaiClue: "กินอาหารมื้อแรกของวันในตอนเช้า",
      answer: "HAVEBREAKFAST",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Havebreakfast.png",
    ),
    RiddleQuestion(
      clue: "To use your ears to hear sound or music!",
      thaiClue: "ใช้หูฟังเสียงหรือเพลง",
      answer: "LISTEN",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Listen.png",
    ),
    RiddleQuestion(
      clue: "To neat the sheets and blankets on your bed after you get up!",
      thaiClue: "จัดผ้าปูที่นอนและผ้าห่มให้เรียบร้อยหลังตื่นนอน",
      answer: "MAKEMYBED",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Makemybed.png",
    ),
    RiddleQuestion(
      clue: "To spend time with other people you like and know!",
      thaiClue: "ใช้เวลาร่วมกับคนอื่นที่เรารู้จักและชอบ",
      answer: "MEETMYFRIENDS",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Meetmyfriends.png",
    ),
    RiddleQuestion(
      clue: "To put things like books and pencils into your school bag!",
      thaiClue: "เก็บของใส่กระเป๋านักเรียน",
      answer: "PACKMYBAG",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Packmybag.png",
    ),
    RiddleQuestion(
      clue: "To have fun by using games on a computer, phone, or console!",
      thaiClue: "เล่นเกมเพื่อความสนุก",
      answer: "PLAYGAMES",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Playgames.png",
    ),
    RiddleQuestion(
      clue: "To look at words and understand what they mean!",
      thaiClue: "มองตัวหนังสือและเข้าใจความหมาย",
      answer: "READ",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Read.png",
    ),
    RiddleQuestion(
      clue: "To spend time reading words written in a book!",
      thaiClue: "ใช้เวลากับการอ่านหนังสือ",
      answer: "READABOOK",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Readabook.png",
    ),
    RiddleQuestion(
      clue: "To sit on and move a bicycle!",
      thaiClue: "นั่งและเคลื่อนย้ายจักรยาน",
      answer: "RIDEABIKE",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Rideabike.png",
    ),
    RiddleQuestion(
      clue: "To close your eyes and rest your body at night!",
      thaiClue: "หลับตาและพักผ่อนร่างกายในตอนกลางคืน",
      answer: "SLEEP",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Sleep.png",
    ),
    RiddleQuestion(
      clue: "To spend time learning about a subject at home or school!",
      thaiClue: "ใช้เวลาเรียนรู้เกี่ยวกับวิชา",
      answer: "STUDY",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Study.png",
    ),
    RiddleQuestion(
      clue: "To clean your body by sitting in a bathtub full of water!",
      thaiClue: "ทำความสะอาดร่างกายโดยนั่งในอ่างอาบน้ำ",
      answer: "TAKEABATH",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Takeabath.png",
    ),
    RiddleQuestion(
      clue: "To clean your body by standing under water!",
      thaiClue: "ทำความสะอาดร่างกายโดยยืนใต้น้ำ",
      answer: "TAKEASHOWER",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Takeashower.png",
    ),
    RiddleQuestion(
      clue: "To open your eyes and stop sleeping in the morning!",
      thaiClue: "ลืมตาและหยุดนอนในตอนเช้า",
      answer: "WAKEUP",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Wakeup.png",
    ),
    RiddleQuestion(
      clue: "To use water and soap to clean your face!",
      thaiClue: "ใช้น้ำและสบู่ทำความสะอาดใบหน้า",
      answer: "WASHMYFACE",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Washmyface.png",
    ),
    RiddleQuestion(
      clue: "To use water and soap to clean plates, cups, and forks!",
      thaiClue: "ใช้น้ำและสบู่ทำความสะอาดจานและอุปกรณ์กินข้าว",
      answer: "WASHTHEDISHES",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Washthedishes.png",
    ),
    RiddleQuestion(
      clue: "To look at pictures and sound on a television set!",
      thaiClue: "ดูภาพและเสียงบนทีวี",
      answer: "WATCHTV",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/WatchTV.png",
    ),
    RiddleQuestion(
      clue: "To use a pen or pencil to make words or marks on paper!",
      thaiClue: "ใช้ปากกาหรือดินสอเขียนคำหรือเครื่องหมายบนกระดาษ",
      answer: "WRITE",
      categoryKey: "daily_routine",
      imagePath: "assets/images/guess/dailyroutine/Write.png",
    ),

    // ----------------------------------------------------
    // คำใบ้หมวดอาหาร (food)
    // ----------------------------------------------------
    RiddleQuestion(
      clue: "A baked food made from flour and yeast, great for making toast!",
      thaiClue: "อาหารทำจากแป้งอบ กลิ่นหอม นิยมนำมาปิ้งกินตอนเช้า",
      answer: "BREAD",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Bread.png",
    ),
    RiddleQuestion(
      clue: "A sandwich with a cooked beef patty inside a round sliced bun!",
      thaiClue: "ขนมปังกลมประกบเนื้อย่าง ผัก และซอสแสนอร่อย",
      answer: "BURGER",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Burger.png",
    ),
    RiddleQuestion(
      clue: "A sweet baked dessert often decorated with frosting for birthdays!",
      thaiClue: "ขนมหวานเนื้อนุ่ม แต่งหน้าด้วยครีม นิยมในงานวันเกิด",
      answer: "CAKE",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Cake.png",
    ),
    RiddleQuestion(
      clue: "A sweet treat made of sugar and flavorings that kids love!",
      thaiClue: "ขนมรสหวานหลากสีสัน ทำจากน้ำตาล เด็กๆ ชอบกิน",
      answer: "CANDY",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Candy.png",
    ),
    RiddleQuestion(
      clue: "A yellow dairy food made from milk that melts on pizza!",
      thaiClue: "อาหารสีเหลืองทำจากน้ำนม เข้มข้น ยืดได้เวลาร้อน",
      answer: "CHEESE",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Cheese.png",
    ),
    RiddleQuestion(
      clue: "Popular poultry meat often fried, roasted, or grilled crispy!",
      thaiClue: "เนื้อสัตว์ปีกยอดนิยม นำมาทอดกรอบหรือย่างหอมๆ",
      answer: "CHICKEN",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Chicken.png",
    ),
    RiddleQuestion(
      clue: "A sweet brown treat made from roasted cacao seeds!",
      thaiClue: "ขนมหวานสีน้ำตาล ทำจากเมล็ดโกโก้ รสชาติหวานมัน",
      answer: "CHOCOLATE",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Chocolate.png",
    ),
    RiddleQuestion(
      clue: "A small sweet, flat and crispy baked biscuit with chocolate chips!",
      thaiClue: "ขนมอบชิ้นกลมกรอบ หอมเนยและช็อกโกแลตชิป",
      answer: "COOKIE",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Cookie.png",
    ),
    RiddleQuestion(
      clue: "A tall cereal plant with rows of sweet yellow kernels on a cob!",
      thaiClue: "พืชฝักสีเหลือง เมล็ดหวาน นำมาต้มหรือทำป๊อปคอร์น",
      answer: "CORN",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Corn.png",
    ),
    RiddleQuestion(
      clue: "A small fried sweet dough cake with a hole in the middle!",
      thaiClue: "ขนมแป้งทอดทรงกลม มีรูตรงกลาง เคลือบน้ำตาลหวานฉ่ำ",
      answer: "DONUT",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Donut.png",
    ),
    RiddleQuestion(
      clue: "An oval food with an eggshell laid by birds, rich in protein!",
      thaiClue: "อาหารรูปวงรี มีเปลือกห่อหุ้ม มีไข่แดงและไข่ขาว",
      answer: "EGG",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Egg.png",
    ),
    RiddleQuestion(
      clue: "Seafood that swims in water, healthy and rich in omega-3!",
      thaiClue: "เนื้อสัตว์น้ำมีเกล็ด มีประโยชน์ ทอดหรือนึ่งก็อร่อย",
      answer: "FISH",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Fish.png",
    ),
    RiddleQuestion(
      clue: "Deep-fried long strips of potatoes served hot with ketchup!",
      thaiClue: "มันฝรั่งหั่นเส้นทอดกรอบสีเหลืองทอง จิ้มซอสมะเขือเทศ",
      answer: "FRENCHFRIES",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Frenchfries.png",
    ),
    RiddleQuestion(
      clue: "A cold and sweet frozen dessert served in a bowl or crispy cone!",
      thaiClue: "ของหวานเย็นชื่นใจ รสหวานมัน ใส่ในถ้วยหรือโคนกรอบ",
      answer: "ICECREAM",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Icecream.png",
    ),
    RiddleQuestion(
      clue: "A refreshing drink made by squeezing fresh fruits like oranges!",
      thaiClue: "เครื่องดื่มรสสดชื่น ทำจากผลไม้คั้นสด",
      answer: "JUICE",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Juice.png",
    ),
    RiddleQuestion(
      clue: "The flesh of an animal used as food, high in protein!",
      thaiClue: "เนื้อสัตว์ เช่น เนื้อหมู หรือเนื้อวัว ให้โปรตีนสูง",
      answer: "MEAT",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Meat.png",
    ),
    RiddleQuestion(
      clue: "A white healthy drink produced by cows, rich in calcium!",
      thaiClue: "เครื่องดื่มสีขาวจากแม่โค ช่วยให้กระดูกและฟันแข็งแรง",
      answer: "MILK",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Milk.png",
    ),
    RiddleQuestion(
      clue: "Long thin strips of dough cooked in hot soup or stir-fried in a bowl!",
      thaiClue: "เส้นแป้งยาวเรียว ต้มในน้ำซุปร้อนๆ หรือนำมาผัด",
      answer: "NOODLE",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Noodle.png",
    ),
    RiddleQuestion(
      clue: "Italian flat round bread topped with tomato sauce, cheese, and meats!",
      thaiClue: "แป้งกลมแบนอบร้อน โรยหน้าด้วยซอส ชีสเยิ้มๆ และเนื้อสัตว์",
      answer: "PIZZA",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Pizza.png",
    ),
    RiddleQuestion(
      clue: "A round root vegetable that grows underground, used for making chips!",
      thaiClue: "พืชหัวใต้ดิน นำมาต้ม บด หรือทอดเป็นมันฝรั่งทอด",
      answer: "POTATO",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Potato.png",
    ),
    RiddleQuestion(
      clue: "White grains cooked by steaming, the staple food across Asia!",
      thaiClue: "เมล็ดธัญพืชสีขาวหุงสุก อาหารหลักของคนไทย",
      answer: "RICE",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Rice.png",
    ),
    RiddleQuestion(
      clue: "A dish of mixed raw vegetables like lettuce, tomatoes, and dressing!",
      thaiClue: "จานผักสดหลากชนิด คลุกเคล้ากับน้ำสลัดแสนอร่อย",
      answer: "SALAD",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Salad.png",
    ),
    RiddleQuestion(
      clue: "White mineral crystals used in cooking to give food a salty taste!",
      thaiClue: "เม็ดผลึกสีขาว ให้รสเค็ม ใช้ปรุงรสอาหารทุกชนิด",
      answer: "SALT",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Salt.png",
    ),
    RiddleQuestion(
      clue: "Food made of slices of bread with meat, cheese, or vegetables inside!",
      thaiClue: "ขนมปังสองแผ่นประกบไส้เนื้อสัตว์ ชีส หรือผักตรงกลาง",
      answer: "SANDWICH",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Sandwich.png",
    ),
    RiddleQuestion(
      clue: "Minced meat seasoned and packed into a long cylindrical skin casing!",
      thaiClue: "เนื้อบดปรุงรส บรรจุในไส้ทรงกระบอกยาว นำไปนึ่งหรือย่าง",
      answer: "SAUSAGE",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Sausage.png",
    ),
    RiddleQuestion(
      clue: "A warm liquid food made by boiling meat, vegetables, and seasoning in a bowl!",
      thaiClue: "อาหารน้ำต้มร้อนๆ ปรุงรสกลมกล่อม มีเนื้อและผัก ซดคล่องคอ",
      answer: "SOUP",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Soup.png",
    ),
    RiddleQuestion(
      clue: "A sweet crystalline substance obtained from sugarcane!",
      thaiClue: "ผลึกสีขาวรสหวานจัด ได้จากต้นอ้อย ใช้เพิ่มความหวาน",
      answer: "SUGAR",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Sugar.png",
    ),
    RiddleQuestion(
      clue: "A glossy red juicy fruit with seeds, often cooked as a vegetable!",
      thaiClue: "ผลสีแดงสด ผิวเรียบ รสเปรี้ยวอมหวาน ใช้ทำซอสหรือใส่สลัด",
      answer: "TOMATO",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Tomato.png",
    ),
    RiddleQuestion(
      clue: "Healthy plants like carrots, broccoli, and spinach eaten as food!",
      thaiClue: "พืชผักใบเขียวและพืชสวนครัว มีวิตามินและกากใยสูง",
      answer: "VEGETABLE",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Vegetable.png",
    ),
    RiddleQuestion(
      clue: "A clear, transparent liquid essential for all life that quenches thirst!",
      thaiClue: "ของเหลวใสสะอาด ไม่มีสี ไม่มีกลิ่น จำเป็นต่อร่างกาย ดื่มแก้กระหาย",
      answer: "WATER",
      categoryKey: "food",
      imagePath: "assets/images/guess/food/Water.png",
    ),

    // ----------------------------------------------------
    // หมวดผลไม้ (fruit)
    // ----------------------------------------------------
    RiddleQuestion(
      clue: "A round red or green fruit that is sweet, crisp, and keeps the doctor away!",
      thaiClue: "ผลไม้ทรงกลมสีแดงหรือเขียว รสชาติหวานกรอบ อร่อยชื่นใจ",
      answer: "APPLE",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Apple.png",
    ),
    RiddleQuestion(
      clue: "A small, golden-orange fruit with velvety skin and a large stone pit inside!",
      thaiClue: "ผลไม้สีส้มทอง ผิวเรียบนุ่ม รสหวานอมเปรี้ยว มีเมล็ดเดี่ยว",
      answer: "APRICOT",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Apricot.png",
    ),
    RiddleQuestion(
      clue: "A pear-shaped fruit with bumpy dark green skin and creamy, healthy flesh!",
      thaiClue: "ผลไม้เนื้อเนียนนุ่มสีเขียวครีม เปลือกสีเขียวเข้ม มีไขมันดีสูง",
      answer: "AVOCADO",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Avocado.png",
    ),
    RiddleQuestion(
      clue: "A long curved yellow fruit that you peel to eat, loved by monkeys!",
      thaiClue: "ผลไม้ผลยาวโค้งสีเหลือง ปอกเปลือกง่าย ลิงชอบกินที่สุด",
      answer: "BANANA",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Banana.png",
    ),
    RiddleQuestion(
      clue: "A small, juicy, dark purple-black berry made of tiny rounded segments!",
      thaiClue: "ผลไม้ตระกูลเบอร์รีสีม่วงดำ ผิวเป็นปุ่มเล็กๆ รสหวานอมเปรี้ยว",
      answer: "BLACKBERRY",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Blackberry.png",
    ),
    RiddleQuestion(
      clue: "A small sweet round berry that is blue or purple, great for pancakes and muffins!",
      thaiClue: "ผลเบอร์รีกลมสีน้ำเงินอมม่วง นิยมนำมาทำแยมหรือใส่ขนม",
      answer: "BLUEBERRY",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Blueberry.png",
    ),
    RiddleQuestion(
      clue: "A round melon with netted skin and sweet, juicy orange flesh inside!",
      thaiClue: "แตงผลกลม เปลือกลายร่างแห เนื้อด้านในสีส้มหวานหอมฉ่ำน้ำ",
      answer: "CANTALOUPE",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Cantaloupe.png",
    ),
    RiddleQuestion(
      clue: "A small, round, bright red fruit with a long green stem and a stone pit!",
      thaiClue: "ผลไม้กลมเล็กสีแดงสด มีก้านยาว รสหวานฉ่ำ นิยมตกแต่งบนหน้าเค้ก",
      answer: "CHERRY",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Cherry.png",
    ),
    RiddleQuestion(
      clue: "A large tropical fruit with a hard brown hairy shell and sweet water inside!",
      thaiClue: "ผลไม้เปลือกแข็ง มีน้ำหวานหอมและเนื้อมะพร้าวสีขาวอยู่ข้างใน",
      answer: "COCONUT",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Coconut.png",
    ),
    RiddleQuestion(
      clue: "Known as the King of Fruits with spiky rind, strong smell, and creamy yellow flesh!",
      thaiClue: "ราชาแห่งผลไม้ เปลือกมีหนามแหลมคม กลิ่นหอมแรง เนื้อสีเหลืองทอง",
      answer: "DURIAN",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Durian.png",
    ),
    RiddleQuestion(
      clue: "A small green or purple fruit growing in bunches, used to make wine or juice!",
      thaiClue: "ผลไม้เป็นพวงสีเขียวหรือม่วง เม็ดกลม รสหวานฉ่ำ",
      answer: "GRAPE",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Grape.png",
    ),
    RiddleQuestion(
      clue: "A tropical fruit with green skin, white or pink crunchy flesh, and tiny seeds!",
      thaiClue: "ผลไม้เปลือกเขียว เนื้อกรอบสีขาวหรือชมพู วิตามินซีสูงมาก",
      answer: "GUAVA",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Guava.png",
    ),
    RiddleQuestion(
      clue: "A small oval fruit with fuzzy brown skin and bright green flesh with black seeds!",
      thaiClue: "ผลรูปไข่เปลือกสีน้ำตาลมีขน เนื้อสีเขียวสดใสและมีเมล็ดดำจิ๋ว",
      answer: "KIWI",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Kiwi.png",
    ),
    RiddleQuestion(
      clue: "A bright oval yellow citrus fruit famous for its very sour juice!",
      thaiClue: "ผลไม้ตระกูลส้มสีเหลืองสด ผลรียาว รสชาติเปรี้ยวจี๊ด",
      answer: "LEMON",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Lemon.png",
    ),
    RiddleQuestion(
      clue: "A small round green citrus fruit with sour juice used in Thai cooking!",
      thaiClue: "ผลไม้รสเปรี้ยวผลกลมสีเขียว นิยมใช้ปรุงรสต้มยำและส้มตำ",
      answer: "LIME",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Lime.png",
    ),
    RiddleQuestion(
      clue: "A small round fruit with thin brown bark, juicy translucent flesh, and black seed!",
      thaiClue: "ผลไม้เปลือกบางสีน้ำตาล เนื้อใสหวานฉ่ำ มีเมล็ดกลมดำอยู่ตรงกลาง",
      answer: "LONGAN",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Longan.png",
    ),
    RiddleQuestion(
      clue: "A sweet tropical fruit with bumpy red skin and fragrant translucent white flesh!",
      thaiClue: "ผลไม้เปลือกสีแดง ผิวขรุขระ เนื้อสีขาวใส หวานหอมชื่นใจ",
      answer: "LYCHEE",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Lychee.png",
    ),
    RiddleQuestion(
      clue: "A juicy tropical fruit with sweet golden yellow flesh and a large flat stone!",
      thaiClue: "ผลไม้หน้าร้อนยอดนิยม เมื่อสุกจะมีสีเหลืองทอง กินคู่กับข้าวเหนียวมูน",
      answer: "MANGO",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Mango.png",
    ),
    RiddleQuestion(
      clue: "Known as the Queen of Fruits with a thick purple rind and sweet white segments!",
      thaiClue: "ราชินีแห่งผลไม้ เปลือกหนาสีม่วงเข้ม เนื้อในเป็นกลีบขาวหวานเย็น",
      answer: "MANGOSTEEN",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Mangosteen.png",
    ),
    RiddleQuestion(
      clue: "A round citrus fruit with bright orange skin that is easy to peel into segments!",
      thaiClue: "ผลไม้ทรงกลมสีส้มสด แกะกลีบง่าย อุดมไปด้วยวิตามินซี",
      answer: "ORANGE",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Orange.png",
    ),
    RiddleQuestion(
      clue: "An elongated tropical fruit with orange sweet flesh and clusters of small black seeds!",
      thaiClue: "ผลไม้ผลยาว เนื้อสุกสีส้มแดง รสหวาน เมล็ดกลมดำเม็ดเล็กๆ",
      answer: "PAPAYA",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Papaya.png",
    ),
    RiddleQuestion(
      clue: "A round purple fruit with a tough rind filled with juicy aromatic yellow pulp and seeds!",
      thaiClue: "ผลไม้เปลือกสีม่วง ผ่าออกมามีเมล็ดและน้ำสีส้ม รสเปรี้ยวอมหวานหอม",
      answer: "PASSIONFRUIT",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Passionfruit.png",
    ),
    RiddleQuestion(
      clue: "A large tropical fruit with spiky yellow skin and a tuft of spiky green leaves!",
      thaiClue: "ผลไม้มีตามรอบตัว มีมงกุฎใบสีเขียว รสหวานฉ่ำอมเปรี้ยว",
      answer: "PINEAPPLE",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Pineapple.png",
    ),
    RiddleQuestion(
      clue: "A round red fruit with a thick rind filled with sparkling jewel-like red seeds!",
      thaiClue: "ผลไม้ผลกลมสีแดง ข้างในมีเมล็ดสีแดงทับทิมแวววาว รสหวานสดชื่น",
      answer: "POMEGRANATE",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Pomegranate.png",
    ),
    RiddleQuestion(
      clue: "A red tropical fruit covered in soft hairy spines, with sweet translucent flesh!",
      thaiClue: "ผลไม้สีแดงที่มีขนยาวรอบตัว เนื้อข้างในสีขาวหวานกรอบ",
      answer: "RAMBUTAN",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Rambutan.png",
    ),
    RiddleQuestion(
      clue: "A delicate, soft red aggregate berry with a hollow center when picked!",
      thaiClue: "ผลไม้ตระกูลเบอร์รีสีแดงสด รสเปรี้ยวอมหวาน ตรงกลางกลวง",
      answer: "RASPBERRY",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Raspberry.png",
    ),
    RiddleQuestion(
      clue: "A bell-shaped tropical fruit with glossy red or green skin, crunchy and watery!",
      thaiClue: "ผลไม้รูปกระดิ่ง ผิวเรียบมันสีแดง เนื้อกรอบฉ่ำน้ำ กินง่าย",
      answer: "ROSEAPPLE",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Roseapple.png",
    ),
    RiddleQuestion(
      clue: "A yellow-green fruit that looks like a 5-pointed star when sliced crosswise!",
      thaiClue: "ผลไม้ที่มีแฉก หั่นขวางแล้วจะเห็นเป็นรูปดาว 5 แฉกพอดิบพอดี",
      answer: "STARFRUIT",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Starfruit.png",
    ),
    RiddleQuestion(
      clue: "A sweet heart-shaped red berry with tiny seeds studded all over its skin!",
      thaiClue: "ผลไม้สีแดงสดรูปหัวใจ มีเมล็ดเล็กๆ อยู่รอบผิว รสหวานหอมอมเปรี้ยว",
      answer: "STRAWBERRY",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Strawberry.png",
    ),
    RiddleQuestion(
      clue: "A large heavy green melon with juicy red flesh, dark seeds, and sweet cool juice!",
      thaiClue: "ผลไม้ผลใหญ่เปลือกเขียวลาย เนื้อสีแดงสดฉ่ำน้ำ กินแล้วแก้กระหายน้ำ",
      answer: "WATERMELON",
      categoryKey: "fruit",
      imagePath: "assets/images/guess/fruit/Watermelon.png",
    ),

    // ----------------------------------------------------
    // หมวดบ้าน (home)
    // ----------------------------------------------------
    RiddleQuestion(
      clue: "A room where you take a bath, brush your teeth, and wash your face!",
      thaiClue: "ห้องสำหรับอาบน้ำ ชำระล้างร่างกาย และแปรงฟัน",
      answer: "BATHROOM",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Bathroom.png",
    ),
    RiddleQuestion(
      clue: "A soft piece of furniture with a mattress that you sleep on at night!",
      thaiClue: "เฟอร์นิเจอร์นุ่มๆ มีเบาะหนาสำหรับนอนหลับพักผ่อน",
      answer: "BED",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Bed.png",
    ),
    RiddleQuestion(
      clue: "A private room in the house where your bed is located for sleeping!",
      thaiClue: "ห้องส่วนตัวที่มีเตียงนอนไว้สำหรับนอนพักผ่อน",
      answer: "BEDROOM",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Bedroom.png",
    ),
    RiddleQuestion(
      clue: "A large warm cover made of fabric used on a bed to keep you warm!",
      thaiClue: "ผ้าผืนใหญ่หนานุ่ม ใช้ห่มคลุมร่างกายให้อบอุ่นเวลานอน",
      answer: "BLANKET",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Blanket.png",
    ),
    RiddleQuestion(
      clue: "A piece of furniture with four legs and a backrest designed for one person to sit on!",
      thaiClue: "เครื่องเรือนมีขาและพนักพิง สำหรับนั่งคนเดียว",
      answer: "CHAIR",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Chair.png",
    ),
    RiddleQuestion(
      clue: "An instrument with hands on its face that hangs on the wall to tell the time!",
      thaiClue: "เครื่องมือบอกเวลา มีหน้าปัดและเข็ม แขวนอยู่บนผนัง",
      answer: "CLOCK",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Clock.png",
    ),
    RiddleQuestion(
      clue: "A tall cabinet or wardrobe where clothes, jackets, and shirts are hung neatly!",
      thaiClue: "ตู้ขนาดใหญ่สำหรับแขวนและเก็บเสื้อผ้าให้เป็นระเบียบ",
      answer: "CLOSET",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Closet.png",
    ),
    RiddleQuestion(
      clue: "A room in the house where family members sit together to eat meals!",
      thaiClue: "ห้องที่มีโต๊ะอาหาร สำหรับครอบครัวนั่งรับประทานอาหารร่วมกัน",
      answer: "DININGROOM",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Diningroom.png",
    ),
    RiddleQuestion(
      clue: "A hinged movable barrier used to open and enter a room or a house!",
      thaiClue: "บานเปิดปิดสำหรับเข้าและออกจากตัวบ้านหรือห้องต่างๆ",
      answer: "DOOR",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Door.png",
    ),
    RiddleQuestion(
      clue: "An electric machine with rotating blades that blows cool air around the room!",
      thaiClue: "เครื่องใช้ไฟฟ้ามีใบพัดหมุน ช่วยเป่าลมให้เย็นสบาย",
      answer: "FAN",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Fan.png",
    ),
    RiddleQuestion(
      clue: "The flat lower surface of a room that you walk on with tiles or wood!",
      thaiClue: "พื้นผิวด้านล่างของห้อง ปูด้วยกระเบื้องหรือไม้ไว้เดิน",
      answer: "FLOOR",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Floor.png",
    ),
    RiddleQuestion(
      clue: "An eating utensil with three or four sharp points used for picking up food!",
      thaiClue: "อุปกรณ์รับประทานอาหาร มีซี่แหลม ใช้จิ้มอาหารคู่กับช้อน",
      answer: "FORK",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Fork.png",
    ),
    RiddleQuestion(
      clue: "A piece of ground outdoors next to a house where grass and flowers grow!",
      thaiClue: "พื้นที่สีเขียวรอบบ้าน ปลูกต้นไม้ ดอกไม้ และมีสนามหญ้า",
      answer: "GARDEN",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Garden.png",
    ),
    RiddleQuestion(
      clue: "A building for human habitation where families live together safely!",
      thaiClue: "สิ่งปลูกสร้างที่อยู่อาศัยของคนในครอบครัว",
      answer: "HOUSE",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/House.png",
    ),
    RiddleQuestion(
      clue: "A room equipped with a stove and oven where delicious meals are prepared!",
      thaiClue: "ห้องที่มีเตาไฟและเครื่องครัว ไว้สำหรับทำอาหาร",
      answer: "KITCHEN",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Kitchen.png",
    ),
    RiddleQuestion(
      clue: "A device that produces light using an electric bulb to brighten the desk or room!",
      thaiClue: "อุปกรณ์ให้แสงสว่าง มีหลอดไฟช่วยส่องสว่างบนโต๊ะหรือในห้อง",
      answer: "LAMP",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Lamp.png",
    ),
    RiddleQuestion(
      clue: "A comfortable common room where family and guests relax, talk, and watch television!",
      thaiClue: "ห้องนั่งเล่นพักผ่อน มีโซฟาสำหรับพูดคุยและดูทีวีร่วมกัน",
      answer: "LIVINGROOM",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Livingroom.png",
    ),
    RiddleQuestion(
      clue: "A smooth glass surface with a reflective coating that reflects your face!",
      thaiClue: "แผ่นกระจกเงาสะท้อนภาพ สำหรับส่องดูใบหน้าและสำรวจการแต่งตัว",
      answer: "MIRROR",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Mirror.png",
    ),
    RiddleQuestion(
      clue: "A soft cushion used to support your head comfortably while sleeping on a bed!",
      thaiClue: "เครื่องนอนใบหนานุ่ม ใช้หนุนศีรษะตอนนอนหลับ",
      answer: "PILLOW",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Pillow.png",
    ),
    RiddleQuestion(
      clue: "A flat round dish from which food is eaten or served at the table!",
      thaiClue: "ภาชนะทรงแบนกลม สำหรับใส่อาหารรับประทาน",
      answer: "PLATE",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Plate.png",
    ),
    RiddleQuestion(
      clue: "A large cool appliance used to store fresh food, milk, and drinks cold!",
      thaiClue: "ตู้เย็นขนาดใหญ่ รักษาความเย็นเพื่อถนอมอาหารและเครื่องดื่ม",
      answer: "REFRIGERATOR",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Refrigerator.png",
    ),
    RiddleQuestion(
      clue: "The top covering of a house that protects the building from rain and sunlight!",
      thaiClue: "โครงสร้างส่วนบนสุดของบ้าน ช่วยป้องกันแดดและกันฝน",
      answer: "ROOF",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Roof.png",
    ),
    RiddleQuestion(
      clue: "A partitioned space inside a house enclosed by walls, floor, and ceiling!",
      thaiClue: "พื้นที่กั้นเป็นสัดส่วนภายในบ้าน มีผนังและประตู",
      answer: "ROOM",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Room.png",
    ),
    RiddleQuestion(
      clue: "An apparatus that sprays water from an overhead nozzle to wash your body clean!",
      thaiClue: "ฝักบัวอาบน้ำ มีหัวฉีดพ่นละอองน้ำลงมาทำความสะอาดตัว",
      answer: "SHOWER",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Shower.png",
    ),
    RiddleQuestion(
      clue: "A bubbly cleansing substance used with water to wash dirt off your hands and skin!",
      thaiClue: "ก้อนฟองหอมใช้ฟอกตัวและล้างมือให้สะอาดปราศจากเชื้อโรค",
      answer: "SOAP",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Soap.png",
    ),
    RiddleQuestion(
      clue: "A long comfortable upholstered seat with arms and back for several people!",
      thaiClue: "เก้าอี้นวมตัวยาวบุฟองน้ำนุ่ม สำหรับนั่งพักผ่อนหลายคน",
      answer: "SOFA",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Sofa.png",
    ),
    RiddleQuestion(
      clue: "An eating tool consisting of a small shallow bowl with a handle for soup or rice!",
      thaiClue: "เครื่องใช้กินข้าว มีหลุมตื้นและด้ามจับ ใช้ตักข้าวหรือซดแกง",
      answer: "SPOON",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Spoon.png",
    ),
    RiddleQuestion(
      clue: "A series of steps leading from one floor of a building to another higher floor!",
      thaiClue: "ขั้นบันไดสำหรับเดินขึ้นลงเชื่อมระหว่างชั้นล่างกับชั้นบน",
      answer: "STAIRS",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Stairs.png",
    ),
    RiddleQuestion(
      clue: "A piece of furniture with a flat top and four legs used for working or eating!",
      thaiClue: "โต๊ะมีพื้นผิวเรียบแบนและมีขา ใช้สำหรับวางสิ่งของหรือทานข้าว",
      answer: "TABLE",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Table.png",
    ),
    RiddleQuestion(
      clue: "An electronic device with a screen that broadcasts movies, cartoons, and shows!",
      thaiClue: "โทรทัศน์จอภาพ แสดงรายการบันเทิงและการ์ตูนพร้อมเสียง",
      answer: "TELEVISION",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Television.png",
    ),
    RiddleQuestion(
      clue: "A bowl fixture with a seat and flush mechanism in the bathroom for waste!",
      thaiClue: "โถสุขภัณฑ์ในห้องน้ำ มีฝารองนั่งและที่กดชักโครก",
      answer: "TOILET",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Toilet.png",
    ),
    RiddleQuestion(
      clue: "An absorbent piece of cloth used for drying the body after washing or bathing!",
      thaiClue: "ผ้าขนหนูเนื้อนุ่ม ซับน้ำได้ดี ใช้เช็ดตัวให้แห้งหลังอาบน้ำ",
      answer: "TOWEL",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Towel.png",
    ),
    RiddleQuestion(
      clue: "A continuous vertical solid brick or concrete structure that encloses a room!",
      thaiClue: "ผนังกำแพงอิฐหรือปูน กั้นแบ่งห้องและรองรับตัวบ้าน",
      answer: "WALL",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Wall.png",
    ),
    RiddleQuestion(
      clue: "A home electrical appliance used to automatically wash dirty laundry and shirts!",
      thaiClue: "เครื่องซักผ้าไฟฟ้า ซักและปั่นผ้าเปื้อนให้สะอาดอัตโนมัติ",
      answer: "WASHINGMACHINE",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Washingmachine.png",
    ),
    RiddleQuestion(
      clue: "An opening in a wall fitted with glass to let in fresh air and bright sunlight!",
      thaiClue: "ช่องหน้าต่างติดกระจก เปิดรับแสงแดดและลมเย็นจากภายนอก",
      answer: "WINDOW",
      categoryKey: "home",
      imagePath: "assets/images/guess/house/Window.png",
    ),

    // ----------------------------------------------------
    // หมวดสถานที่ (location)
    // ----------------------------------------------------
    RiddleQuestion(
      clue: "A place with runways where airplanes take off and land with passengers!",
      thaiClue: "สถานที่สำหรับขึ้นและลงของเครื่องบิน มีรันเวย์ขนาดใหญ่",
      answer: "AIRPORT",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Airport.png",
    ),
    RiddleQuestion(
      clue: "A shop where fresh bread, cakes, cookies, and pastries are baked and sold!",
      thaiClue: "ร้านอบและขายขนมปัง เค้ก และเบเกอรีหอมกรุ่น",
      answer: "BAKERY",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Bakery.png",
    ),
    RiddleQuestion(
      clue: "A secure financial building where people deposit, save, and withdraw money!",
      thaiClue: "อาคารการเงินสำหรับฝาก ถอน และออมเงินอย่างปลอดภัย",
      answer: "BANK",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Bank.png",
    ),
    RiddleQuestion(
      clue: "A designated roadside sign where passengers wait to catch the bus!",
      thaiClue: "จุดจอดริมถนนสำหรับผู้โดยสารยืนรอขึ้นรถประจำทาง",
      answer: "BUSSTOP",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Busstop.png",
    ),
    RiddleQuestion(
      clue: "A religious building with a cross where Christians gather to pray and worship!",
      thaiClue: "ศาสนสถานที่มีไม้กางเขน สำหรับชาวคริสต์ประกอบพิธีกรรม",
      answer: "CHURCH",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Church.png",
    ),
    RiddleQuestion(
      clue: "A dark entertainment hall with a giant screen and sound to watch movies!",
      thaiClue: "โรงฉายภาพยนตร์ที่มีจอขนาดยักษ์และเก้าอี้นั่งชม",
      answer: "CINEMA",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Cinema.png",
    ),
    RiddleQuestion(
      clue: "The base station where firefighters and red emergency fire trucks stay ready!",
      thaiClue: "สถานีดับเพลิง ที่จอดรถดับเพลิงสีแดงและที่พักของนักดับเพลิง",
      answer: "FIRESTATION",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Firestation.png",
    ),
    RiddleQuestion(
      clue: "A roadside facility with pumps where motor vehicles are refueled with petrol!",
      thaiClue: "สถานีบริการน้ำมัน มีหัวจ่ายน้ำมันสำหรับเติมเชื้อเพลิงให้รถ",
      answer: "GASSTATION",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Gasstation.png",
    ),
    RiddleQuestion(
      clue: "A fitness club equipped with weights and exercise machines for working out!",
      thaiClue: "สถานที่ออกกำลังกาย มีเครื่องเล่นและอุปกรณ์เสริมสร้างกล้ามเนื้อ",
      answer: "GYM",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Gym.png",
    ),
    RiddleQuestion(
      clue: "The warm residence where you and your family live together comfortably!",
      thaiClue: "ที่อยู่อาศัยอันอบอุ่นที่ครอบครัวอยู่ร่วมกันอย่างมีความสุข",
      answer: "HOME",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Home.png",
    ),
    RiddleQuestion(
      clue: "A medical facility where doctors and nurses care for sick and injured patients!",
      thaiClue: "สถานพยาบาลที่มีแพทย์และพยาบาลคอยตรวจรักษาผู้ป่วย",
      answer: "HOSPITAL",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Hospital.png",
    ),
    RiddleQuestion(
      clue: "An establishment that provides paid rooms and lodging for travelers and tourists!",
      thaiClue: "ที่พักแรมสำหรับนักท่องเที่ยวและผู้เดินทางมาพักผ่อนค้างคืน",
      answer: "HOTEL",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Hotel.png",
    ),
    RiddleQuestion(
      clue: "A quiet building with bookshelves where people read, study, and borrow books!",
      thaiClue: "ห้องสมุดสถานที่เงียบสงบ มีหนังสือมากมายให้อ่านและยืม",
      answer: "LIBRARY",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Library.png",
    ),
    RiddleQuestion(
      clue: "A lively bustling open area or hall with stalls selling fresh food and goods!",
      thaiClue: "ตลาดสดศูนย์รวมแผงค้าขายของสด ผัก ผลไม้ และอาหาร",
      answer: "MARKET",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Market.png",
    ),
    RiddleQuestion(
      clue: "A sacred place of worship with minarets where Muslims gather for prayer!",
      thaiClue: "มัสยิดศาสนสถานอันศักดิ์สิทธิ์ของชาวมุสลิมในการละหมาด",
      answer: "MOSQUE",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Mosque.png",
    ),
    RiddleQuestion(
      clue: "A public building where ancient artifacts, art, and historical treasures are displayed!",
      thaiClue: "พิพิธภัณฑ์จัดแสดงโบราณวัตถุ สิ่งของทางประวัติศาสตร์ และศิลปะ",
      answer: "MUSEUM",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Museum.png",
    ),
    RiddleQuestion(
      clue: "A public green recreational area with trees, lawns, and playgrounds for relaxing!",
      thaiClue: "สวนสาธารณะร่มรื่น มีสนามหญ้าและเครื่องเล่นสำหรับพักผ่อน",
      answer: "PARK",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Park.png",
    ),
    RiddleQuestion(
      clue: "A retail shop where prescribed medicines and healthcare goods are prepared and sold!",
      thaiClue: "ร้านขายยาที่มีเภสัชกรคอยจ่ายยาและให้คำแนะนำสุขภาพ",
      answer: "PHARMACY",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Pharmacy.png",
    ),
    RiddleQuestion(
      clue: "The headquarters where police officers work to protect the town and uphold the law!",
      thaiClue: "สถานีตำรวจ ที่ทำงานของผู้พิทักษ์สันติราษฎร์ดูแลความสงบ",
      answer: "POLICESTATION",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Policestation.png",
    ),
    RiddleQuestion(
      clue: "A government office where letters, parcels, and mail are handled and sent out!",
      thaiClue: "ที่ทำการไปรษณีย์ สำหรับส่งจดหมาย พัสดุ และสิ่งของ",
      answer: "POSTOFFICE",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Postoffice.png",
    ),
    RiddleQuestion(
      clue: "A dining business where cooked meals and drinks are prepared and served to customers!",
      thaiClue: "ร้านอาหารที่ปรุงเมนูจานอร่อยเสิร์ฟให้ลูกค้านั่งรับประทาน",
      answer: "RESTAURANT",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Restaurant.png",
    ),
    RiddleQuestion(
      clue: "An educational institution where students learn subjects in classrooms from teachers!",
      thaiClue: "โรงเรียนสถานที่ที่คุณครูสอนหนังสือและเด็กๆ เรียนรู้ร่วมกัน",
      answer: "SCHOOL",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/School.png",
    ),
    RiddleQuestion(
      clue: "A Buddhist sacred sanctuary with golden pagodas where monks pray and meditate!",
      thaiClue: "วัดวาอารามศาสนสถานของชาวพุทธ มีพระสงฆ์จำพรรษาและทำบุญ",
      answer: "TEMPLE",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Temple.png",
    ),
    RiddleQuestion(
      clue: "A terminal station beside railways where passengers get on and off passenger trains!",
      thaiClue: "สถานีรถไฟ มีชานชาลาและรางรถไฟสำหรับขึ้นขบวนรถ",
      answer: "TRAINSTATION",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Trainstation.png",
    ),
    RiddleQuestion(
      clue: "A large public park where many different wild animals are kept for visitors to see!",
      thaiClue: "สวนสัตว์ที่รวบรวมสัตว์ป่านานาชนิดไว้ให้เด็กๆ เข้าชมและเรียนรู้",
      answer: "ZOO",
      categoryKey: "location",
      imagePath: "assets/images/guess/Places/Zoo.png",
    ),

    // ----------------------------------------------------
    // หมวดกีฬา (sport)
    // ----------------------------------------------------
    RiddleQuestion(
      clue: "A sport of shooting arrows with a bow at a target!",
      thaiClue: "กีฬาการยิงธนูด้วยคันธนูเล็งไปยังเป้าหมาย",
      answer: "ARCHERY",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Archery.png",
    ),
    RiddleQuestion(
      clue: "A game played with lightweight rackets hitting a shuttlecock across a net!",
      thaiClue: "กีฬาตีลูกขนไก่ข้ามตาข่ายด้วยไม้แร็กเกตน้ำหนักเบา",
      answer: "BADMINTON",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Badminton.png",
    ),
    RiddleQuestion(
      clue: "A bat-and-ball game played between two teams running around four bases!",
      thaiClue: "กีฬาใช้ไม้ตีลูกบอลแล้ววิ่งวนรอบเบสทั้งสี่",
      answer: "BASEBALL",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Baseball.png",
    ),
    RiddleQuestion(
      clue: "A game played by bouncing and shooting a ball through a raised hoop and net!",
      thaiClue: "กีฬาเลี้ยงลูกบอลส้มแล้วกระโดดชู้ตลงห่วงตาข่าย",
      answer: "BASKETBALL",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Basketball.png",
    ),
    RiddleQuestion(
      clue: "A game where players roll a heavy ball down a lane to knock down pins!",
      thaiClue: "กีฬาโยนลูกบอลกลมหนักๆ กลิ้งไปชนพินให้ล้มทั้งหมด",
      answer: "BOWLING",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Bowling.png",
    ),
    RiddleQuestion(
      clue: "A combat sport in which two fighters throw punches with padded gloves!",
      thaiClue: "กีฬาการต่อสู้ด้วยหมัด สวมนวมนุ่มบนเวทีผ้าใบ",
      answer: "BOXING",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Boxing.png",
    ),
    RiddleQuestion(
      clue: "The activity or sport of riding bicycles on tracks or roads!",
      thaiClue: "กีฬาการปั่นสองล้อจักรยานแข่งขันความเร็วหรือออกกำลังกาย",
      answer: "CYCLING",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Cycling.png",
    ),
    RiddleQuestion(
      clue: "A sport where players use clubs to hit a small ball into a series of holes!",
      thaiClue: "กีฬาใช้ไม้กอล์ฟตีลูกสีขาวขนาดเล็กลงหลุมในสนามหญ้า",
      answer: "GOLF",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Golf.png",
    ),
    RiddleQuestion(
      clue: "A sport involving acrobatics, balance, flexibility, and flips on mats!",
      thaiClue: "กีฬากายกรรมที่ต้องใช้ความยืดหยุ่น การทรงตัว และความอ่อนตัว",
      answer: "GYMNASTICS",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Gymnastics.png",
    ),
    RiddleQuestion(
      clue: "A team sport played on ice or turf driving a puck or ball with curved sticks!",
      thaiClue: "กีฬาใช้ไม้ตีปลายโค้งเลี้ยงลูกพัคหรือบอลเข้าประตูฝ่ายตรงข้าม",
      answer: "HOCKEY",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Hockey.png",
    ),
    RiddleQuestion(
      clue: "A rough ball game played with an oval ball that players run with and kick!",
      thaiClue: "กีฬาใช้ลูกบอลทรงไข่ วิ่งกอดลูกส่งต่อและวางรักบี้ทำคะแนน",
      answer: "RUGBY",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Rugby.png",
    ),
    RiddleQuestion(
      clue: "The activity of moving fast on foot for speed, racing, and exercise!",
      thaiClue: "การเคลื่อนที่วิ่งด้วยเท้าอย่างรวดเร็วเพื่อความแข็งแรงและแข่งความเร็ว",
      answer: "RUNNING",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Running.png",
    ),
    RiddleQuestion(
      clue: "The action of riding on a short board with small wheels and doing tricks!",
      thaiClue: "กีฬาการทรงตัวและไถแผ่นสเก็ตบอร์ดติดล้อทำท่าผาดโผน",
      answer: "SKATEBOARDING",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Skateboarding.png",
    ),
    RiddleQuestion(
      clue: "Physical activities involving skill and fitness such as ball games and races!",
      thaiClue: "กิจกรรมการออกกำลังกาย เล่นเกม และแข่งขันกีฬาประเภทต่างๆ",
      answer: "SPORTS",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Sports.png",
    ),
    RiddleQuestion(
      clue: "The sport of riding on ocean waves standing up on a surfboard!",
      thaiClue: "กีฬาโต้คลื่น ยืนทรงตัวบนกระดานเหนือน้ำทะเล",
      answer: "SURFING",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Surfing.png",
    ),
    RiddleQuestion(
      clue: "The sport or activity of propelling oneself through water using arms and legs!",
      thaiClue: "กีฬาว่ายน้ำ ใช้แขนและขาพยุงและเคลื่อนที่ในสระน้ำ",
      answer: "SWIMMING",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Swimming.png",
    ),
    RiddleQuestion(
      clue: "A game played on a table using small paddles and a lightweight plastic ball!",
      thaiClue: "กีฬาปิงปอง ตีลูกพลาสติกเล็กข้ามเน็ตบนโต๊ะด้วยไม้แบน",
      answer: "TABLETENNIS",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Tabletennis.png",
    ),
    RiddleQuestion(
      clue: "A Korean martial art sport characterized by powerful kicks and punches!",
      thaiClue: "ศิลปะการต่อสู้จากเกาหลี โดดเด่นด้วยทักษะการเตะว่องไว",
      answer: "TAEKWONDO",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Taekwondo.png",
    ),
    RiddleQuestion(
      clue: "A game in which two or four players strike a ball with rackets over a net!",
      thaiClue: "กีฬาหวดลูกเทนนิสข้ามตาข่ายในสนามด้วยไม้แร็กเกตขนาดใหญ่",
      answer: "TENNIS",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Tennis.png",
    ),
    RiddleQuestion(
      clue: "A game in which two teams hit a large ball back and forth over a high net using hands!",
      thaiClue: "กีฬาใช้สองมือตบและเซตลูกบอลข้ามตาข่ายสูงไม่ให้ตกพื้น",
      answer: "VOLLEYBALL",
      categoryKey: "sport",
      imagePath: "assets/images/guess/Sports/Volleyball.png",
    ),

    // ----------------------------------------------------
    // หมวดยานพาหนะ (vehicle)
    // ----------------------------------------------------
    RiddleQuestion(
      clue: "A large vehicle with wings that flies high up in the sky!",
      thaiClue: "ยานพาหนะติดปีก บินได้สูงบนท้องฟ้าข้ามประเทศ",
      answer: "AIRPLANE",
      categoryKey: "vehicle",
      imagePath: "assets/images/guess/Vehicles/Airplane.png",
    ),
    RiddleQuestion(
      clue: "A special medical vehicle with sirens that rushes sick people to hospital!",
      thaiClue: "รถพยาบาลเปิดไซเรนฉุกเฉิน รับส่งผู้ป่วยอย่างรวดเร็ว",
      answer: "AMBULANCE",
      categoryKey: "vehicle",
      imagePath: "assets/images/guess/Vehicles/Ambulance.png",
    ),
    RiddleQuestion(
      clue: "A two-wheeled vehicle that you ride by pushing pedals with your feet!",
      thaiClue: "ยานพาหนะสองล้อ ใช้แรงขาปั่นบันไดเพื่อเคลื่อนที่",
      answer: "BICYCLE",
      categoryKey: "vehicle",
      imagePath: "assets/images/guess/Vehicles/Bicycle.png",
    ),
    RiddleQuestion(
      clue: "A small water vessel that floats and travels across rivers and seas!",
      thaiClue: "ยานพาหนะลอยน้ำขนาดเล็ก แล่นบนแม่น้ำและทะเล",
      answer: "BOAT",
      categoryKey: "vehicle",
      imagePath: "assets/images/guess/Vehicles/Boat.png",
    ),
    RiddleQuestion(
      clue: "A large motor vehicle with many seats designed to carry public passengers!",
      thaiClue: "รถประจำทางคันใหญ่ รับส่งผู้โดยสารตามป้ายรถเมล์",
      answer: "BUS",
      categoryKey: "vehicle",
      imagePath: "assets/images/guess/Vehicles/Bus.png",
    ),
    RiddleQuestion(
      clue: "A common road vehicle with four wheels powered by an engine for families!",
      thaiClue: "รถยนต์สี่ล้อสำหรับเดินทางบนท้องถนน",
      answer: "CAR",
      categoryKey: "vehicle",
      imagePath: "assets/images/guess/Vehicles/Car.png",
    ),
    RiddleQuestion(
      clue: "A large red emergency vehicle equipped with ladders and hoses for fires!",
      thaiClue: "รถดับเพลิงสีแดง มีบันไดยาวและสายฉีดน้ำแรงดันสูง",
      answer: "FIRETRUCK",
      categoryKey: "vehicle",
      imagePath: "assets/images/guess/Vehicles/Firetruck.png",
    ),
    RiddleQuestion(
      clue: "An aircraft with spinning rotor blades on top that can hover and land anywhere!",
      thaiClue: "อากาศยานมีใบพัดหมุนด้านบน สามารถลอยนิ่งกลางอากาศได้",
      answer: "HELICOPTER",
      categoryKey: "vehicle",
      imagePath: "assets/images/guess/Vehicles/Helicopter.png",
    ),
    RiddleQuestion(
      clue: "A two-wheeled motor vehicle that is faster than a bicycle!",
      thaiClue: "รถจักรยานยนต์สองล้อ ขับเคลื่อนด้วยเครื่องยนต์",
      answer: "MOTORCYCLE",
      categoryKey: "vehicle",
      imagePath: "assets/images/guess/Vehicles/Motorcycle.png",
    ),
    RiddleQuestion(
      clue: "A powerful spacecraft that blasts off through space and stars!",
      thaiClue: "ยานอวกาศทรงพลัง พุ่งทะยานขึ้นสู่อวกาศด้วยไอพ่น",
      answer: "ROCKET",
      categoryKey: "vehicle",
      imagePath: "assets/images/guess/Vehicles/Rocket.png",
    ),
    RiddleQuestion(
      clue: "A yellow vehicle that safely picks up students and drives them to school!",
      thaiClue: "รถรับส่งนักเรียนคันสีเหลือง พาเด็กๆ ไปโรงเรียนปลอดภัย",
      answer: "SCHOOLBUS",
      categoryKey: "vehicle",
      imagePath: "assets/images/guess/Vehicles/Schoolbus.png",
    ),
    RiddleQuestion(
      clue: "A huge sea vessel that transports containers across deep oceans!",
      thaiClue: "เรือเดินสมุทรขนาดใหญ่ แล่นข้ามมหาสมุทรบรรทุกสินค้า",
      answer: "SHIP",
      categoryKey: "vehicle",
      imagePath: "assets/images/guess/Vehicles/Ship.png",
    ),
    RiddleQuestion(
      clue: "An electric passenger train that runs on elevated tracks above city roads!",
      thaiClue: "รถไฟฟ้าแล่นบนรางยกระดับเหนือท้องถนนในเมือง",
      answer: "SKYTRAIN",
      categoryKey: "vehicle",
      imagePath: "assets/images/guess/Vehicles/Skytrain.png",
    ),
    RiddleQuestion(
      clue: "A naval vessel capable of operating underwater beneath the ocean surface!",
      thaiClue: "เรือดำน้ำที่สามารถดำดิ่งปฏิบัติภารกิจใต้ท้องทะเลลึก",
      answer: "SUBMARINE",
      categoryKey: "vehicle",
      imagePath: "assets/images/guess/Vehicles/Submarine.png",
    ),
    RiddleQuestion(
      clue: "A car with a sign and meter that takes passengers anywhere for a fare!",
      thaiClue: "รถยนต์รับจ้างสาธารณะ มีมิเตอร์และป้ายไฟบนหลังคา",
      answer: "TAXI",
      categoryKey: "vehicle",
      imagePath: "assets/images/guess/Vehicles/Taxi.png",
    ),
    RiddleQuestion(
      clue: "A connected line of carriages pulled by an engine running on metal rails!",
      thaiClue: "ขบวนตู้โบกี้พ่วงยาว แล่นไปตามรางรถไฟส่งเสียงฉึกฉัก",
      answer: "TRAIN",
      categoryKey: "vehicle",
      imagePath: "assets/images/guess/Vehicles/Train.png",
    ),
    RiddleQuestion(
      clue: "A large heavy-duty motor vehicle designed to transport heavy cargo and goods!",
      thaiClue: "รถบรรทุกคันใหญ่ แข็งแกร่ง ใช้ขนส่งสิ่งของน้ำหนักมาก",
      answer: "TRUCK",
      categoryKey: "vehicle",
      imagePath: "assets/images/guess/Vehicles/Truck.png",
    ),
    RiddleQuestion(
      clue: "A medium-sized boxy vehicle with sliding doors for carrying groups of people!",
      thaiClue: "รถตู้ทรงสี่เหลี่ยม มีประตูด้านข้างสำหรับเดินทางเป็นกลุ่ม",
      answer: "VAN",
      categoryKey: "vehicle",
      imagePath: "assets/images/guess/Vehicles/Van.png",
    ),
  ];

  late List<RiddleQuestion> _categoryQuestions;
  int _score = 0;
  int _totalInRound = 0;
  int _completedCount = 0;

  int _hintsUsedInCurrentQuestion = 0;

  int get _maxHintsForCurrentQuestion {
    final len = _currentQ.answer.length;
    if (len <= 4) return 1;
    if (len <= 6) return 2;
    return 3;
  }

  int get _remainingHints =>
      math.max(0, _maxHintsForCurrentQuestion - _hintsUsedInCurrentQuestion);

  RiddleQuestion get _currentQ => _categoryQuestions.first;

  late List<String> _shuffledLetters;
  late List<bool> _usedLetters;
  final List<PlacedLetter> _userAnswers = [];

  bool _isRevealed = false;
  bool _isAnswerCorrect = false;
  bool _hasError = false;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _initTts();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _startCategorySession();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.38);
    await _flutterTts.setPitch(1.30);
  }

  void _startCategorySession() {
    final matched =
        _masterQuestions
            .where((q) => q.categoryKey == widget.category.key)
            .toList();
    if (matched.isEmpty) {
      matched.add(
        RiddleQuestion(
          clue:
              "The name of this category is ${widget.category.key.toUpperCase()}",
          thaiClue: "คำศัพท์ประจำหมวด ${widget.category.titleTh}",
          answer: widget.category.key.toUpperCase(),
          categoryKey: widget.category.key,
          imagePath: widget.category.cardImagePath,
        ),
      );
    }

    matched.sort((a, b) => a.answer.length.compareTo(b.answer.length));

    _categoryQuestions = List<RiddleQuestion>.from(matched);
    _totalInRound = _categoryQuestions.length;
    _completedCount = 0;
    _score = 0;

    _setupQuestion();
  }

  void _setupQuestion() {
    _userAnswers.clear();
    _isAnswerCorrect = false;
    _hasError = false;
    _isRevealed = false;
    _hintsUsedInCurrentQuestion = 0;

    final letters = _currentQ.answer.split('');
    final random = math.Random();
    do {
      letters.shuffle(random);
    } while (letters.join('') == _currentQ.answer && letters.length > 1);

    _shuffledLetters = letters;
    _usedLetters = List<bool>.filled(_shuffledLetters.length, false);

    setState(() {});
  }

  Future<void> _speakClue() async {
    await _flutterTts.stop();
    await _flutterTts.setLanguage("th-TH");
    await _flutterTts.speak(_currentQ.thaiClue);
    await _flutterTts.setLanguage("en-US");
  }

  Future<void> _speakWord(String word) async {
    await _flutterTts.stop();
    await _flutterTts.speak(word);
  }

  void _onLetterTap(int index) async {
    if (_usedLetters[index] || _isAnswerCorrect || _isRevealed) return;

    setState(() {
      _usedLetters[index] = true;
      _userAnswers.add(
        PlacedLetter(char: _shuffledLetters[index], originalKeyIndex: index),
      );
      _hasError = false;
    });

    if (_userAnswers.length == _currentQ.answer.length) {
      String fullAttempt = _userAnswers.map((e) => e.char).join('');
      if (fullAttempt == _currentQ.answer) {
        _bounceController.forward(from: 0.0);
        setState(() {
          _isAnswerCorrect = true;
          _score += 10;
          _completedCount++;
        });

        await _speakWord(_currentQ.answer);
        if (!mounted) return;

        _showAnswerFeedbackSheet(isCorrect: true);
      } else {
        setState(() {
          _hasError = true;
        });

        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;

        _showAnswerFeedbackSheet(isCorrect: false);
      }
    }
  }

  void _showAnswerFeedbackSheet({required bool isCorrect}) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(
              color:
                  isCorrect ? const Color(0xFF10B981) : const Color(0xFFF87171),
              width: 3.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 110,
                child: Image.asset(
                  isCorrect
                      ? 'assets/images/character/bravo.png'
                      : 'assets/images/character/sad.png',
                  fit: BoxFit.contain,
                  errorBuilder:
                      (_, __, ___) => Icon(
                        isCorrect
                            ? Icons.celebration_rounded
                            : Icons.sentiment_dissatisfied_rounded,
                        size: 80,
                        color:
                            isCorrect
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                      ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isCorrect ? 'ถูกต้อง เก่งมาก!' : 'ยังไม่ถูกน้าา ลองดูอีกทีนะ!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color:
                      isCorrect
                          ? const Color(0xFF047857)
                          : const Color(0xFFB91C1C),
                ),
              ),
              const SizedBox(height: 6),
              if (isCorrect)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF6EE7B7),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.stars_rounded,
                        color: Color(0xFFF59E0B),
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '+10 คะแนน (สะสม: $_score)',
                        style: const TextStyle(
                          color: Color(0xFF065F46),
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  'อย่าเพิ่งยอมแพ้นะ จะลองสะกดใหม่ หรือข้ามข้อนี้ไปก่อนก็ได้จ้า',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              const SizedBox(height: 18),
              if (isCorrect)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _removeCurrentAndNext();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F766E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'ไปข้อต่อไป',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(sheetContext);
                          _resetLetters();
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD97706),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.only(bottom: 3.5),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFB703), Color(0xFFF59E0B)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'ลองอีกครั้ง',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(sheetContext);
                          _skipQuestion();
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F766E),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.only(bottom: 3.5),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2DD4BF), Color(0xFF0D9488)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.fast_forward_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'ข้ามข้อนี้',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
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
            ],
          ),
        );
      },
    );
  }

  void _useHint() {
    if (_isAnswerCorrect || _isRevealed) return;

    if (_hintsUsedInCurrentQuestion >= _maxHintsForCurrentQuestion) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'ข้อนี้ใช้ตัวช่วยครบโควตา (${_maxHintsForCurrentQuestion} ตัว) แล้วนะ ลองสะกดดูนะค้าบ! 😊',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFD97706),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
      return;
    }

    int nextIndex = _userAnswers.length;
    if (nextIndex < _currentQ.answer.length) {
      String correctChar = _currentQ.answer[nextIndex];

      int keyIndex = -1;
      for (int i = 0; i < _shuffledLetters.length; i++) {
        if (!_usedLetters[i] && _shuffledLetters[i] == correctChar) {
          keyIndex = i;
          break;
        }
      }

      if (keyIndex != -1) {
        setState(() {
          _hintsUsedInCurrentQuestion++;
        });
        _onLetterTap(keyIndex);
      }
    }
  }

  void _skipQuestion() {
    if (_categoryQuestions.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ข้อนี้เป็นข้อสุดท้ายแล้ว ลองเล่นดูนะ!'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    setState(() {
      final skipped = _categoryQuestions.removeAt(0);
      _categoryQuestions.add(skipped);
      _setupQuestion();
    });
  }

  void _removeLetterAt(int index) {
    if (_isAnswerCorrect || _isRevealed || index >= _userAnswers.length) return;

    setState(() {
      final removed = _userAnswers.removeAt(index);
      if (removed.originalKeyIndex != -1) {
        _usedLetters[removed.originalKeyIndex] = false;
      }
      _hasError = false;
    });
  }

  void _removeLastLetter() {
    if (_userAnswers.isNotEmpty && !_isAnswerCorrect && !_isRevealed) {
      _removeLetterAt(_userAnswers.length - 1);
    }
  }

  void _removeCurrentAndNext() {
    if (_categoryQuestions.isNotEmpty) {
      _categoryQuestions.removeAt(0);
    }

    if (_categoryQuestions.isNotEmpty) {
      _setupQuestion();
    } else {
      _showVictoryDialog();
    }
  }

  void _resetLetters() {
    setState(() {
      _userAnswers.clear();
      _usedLetters = List<bool>.filled(_shuffledLetters.length, false);
      _hasError = false;
    });
  }

  // ================= POPUP จบเกม: โทนสีเขียวเต็มจอตามรูปตัวอย่าง =================
  void _showVictoryDialog() {
    const Color victoryPrimaryGreen = Color(0xFF10B981);
    const Color victoryDarkGreen = Color(0xFF047857);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                victoryPrimaryGreen,
                victoryDarkGreen,
              ],
            ),
          ),
          child: Stack(
            children: [
              // วงแสง Spotlight ด้านหลังตัวมาสคอต
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
                          Colors.white.withOpacity(0.28),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // แถบโค้งมนมิติมืดด้านล่าง
              Positioned(
                bottom: 0,
                left: -40,
                right: -40,
                height: 360,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.12),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.elliptical(260, 90),
                    ),
                  ),
                ),
              ),

              // อนุภาค Confetti ตกแต่งรอบจอ
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _ConfettiParticlesPainter(),
                  ),
                ),
              ),

              // เนื้อหาหน้าต่างชัยชนะ
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      // รูปตัวการ์ตูนนกฮูก Bravo
                      Center(
                        child: SizedBox(
                          width: 270,
                          height: 270,
                          child: Image.asset(
                            'assets/images/character/bravo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.emoji_events_rounded,
                              size: 150,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ดาว 3 ดวง (★★★)
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

                      // ข้อความ "เก่งมาก ยอดเยี่ยม"
                      const Text(
                        'เก่งมาก ยอดเยี่ยม',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: victoryDarkGreen,
                              offset: Offset(0, 4),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ป้าย "คุณเล่นเกมหมวด ... เสร็จแล้ว!"
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          'คุณเล่นเกมหมวด "${widget.category.titleTh}" เสร็จแล้ว!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // การ์ดเหรียญที่ได้รับ และ ความแม่นยำ
                      Row(
                        children: [
                          // เหรียญที่ได้รับ
                          Expanded(
                            child: Container(
                              height: 125,
                              decoration: BoxDecoration(
                                color: const Color(0xFFA78BFA),
                                borderRadius: BorderRadius.circular(26),
                                border: Border.all(color: Colors.white, width: 2.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.18),
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
                                    child: const Icon(
                                      Icons.monetization_on_rounded,
                                      color: Color(0xFFF59E0B),
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '+$_score',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    'เหรียญที่ได้รับ',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // ความแม่นยำ
                          Expanded(
                            child: Container(
                              height: 125,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF472B6),
                                borderRadius: BorderRadius.circular(26),
                                border: Border.all(color: Colors.white, width: 2.2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.18),
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
                                    child: const Icon(
                                      Icons.check_circle_rounded,
                                      color: Color(0xFF10B981),
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    '100%',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    'ความแม่นยำ',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // ปุ่มรับคะแนน & กลับหน้าหลัก
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
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
                              BoxShadow(
                                color: Color(0xFFB45309),
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.home_rounded, color: Colors.white, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'รับคะแนน & กลับหน้าหลัก',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
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
      ),
    );
  }

  Widget _buildStarIcon(double size) {
    return Icon(
      Icons.star_rounded,
      color: const Color(0xFFFBBF24),
      size: size,
      shadows: const [
        Shadow(
          color: Color(0xFFD97706),
          offset: Offset(0, 3.5),
          blurRadius: 0,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress =
        _totalInRound > 0 ? math.min(1.0, _completedCount / _totalInRound) : 0;
    const topBarColor = Color(0xFF008466);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF43D9D0), Color(0xFFBDF4E9), Color(0xFFF0FFF8)],
          ),
        ),
        child: Column(
          children: [
            // 1. แถบด้านบน
            Container(
              color: topBarColor,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.category.titleTh,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
            ),

            // 2. ส่วนเนื้อหาเกม
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 6.0,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // แถบนับข้อ + ป้ายคะแนน + แถบความคืบหน้า
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFF0D9488),
                                width: 1.6,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF08796F,
                                  ).withOpacity(0.10),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              'ข้อที่ ${_completedCount + 1}/$_totalInRound',
                              style: const TextStyle(
                                color: Color(0xFF0D9488),
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFC000), Color(0xFFFFA500)],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFD97706,
                                  ).withOpacity(0.20),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.stars_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$_score คะแนน',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 9,
                                backgroundColor: Colors.white.withOpacity(0.85),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFFFFB703),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // กล่องคำใบ้สีขาว
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: const Color(0xFF0D9488),
                          width: 2.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF08796F).withOpacity(0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  _currentQ.thaiClue,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF0F172A),
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  _currentQ.clue,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
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
                          const SizedBox(width: 8),
                          Material(
                            color: const Color(0xFFFFF7ED),
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: _speakClue,
                              child: const Padding(
                                padding: EdgeInsets.all(7),
                                child: Icon(
                                  Icons.volume_up_rounded,
                                  color: Color(0xFFEA580C),
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ภาพประกอบ
                    Container(
                      height: 205,
                      width: 265,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF0D9488),
                          width: 3.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF08796F).withOpacity(0.16),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          _currentQ.imagePath,
                          fit: BoxFit.contain,
                          errorBuilder:
                              (_, __, ___) => const Icon(
                                Icons.image_search_rounded,
                                size: 50,
                                color: Color(0xFFCBD5E1),
                              ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ช่องใส่ตัวอักษรคำตอบ (Answer Slots) - ป้องกัน Overflow
                    ScaleTransition(
                      scale: _bounceAnimation,
                      child: Container(
                        width: double.infinity,
                        height: 54,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF18B89F), Color(0xFF079486)],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF08796F).withOpacity(0.18),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final int slotCount = _currentQ.answer.length;
                            final double horizontalGap = slotCount > 8 ? 2.0 : 3.5;
                            final double availableWidth = constraints.maxWidth - (slotCount * horizontalGap * 2);
                            final double slotWidth = math.max(
                              18.0,
                              math.min(44.0, availableWidth / slotCount),
                            );

                            return Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(slotCount, (index) {
                                    final bool hasLetter =
                                        index < _userAnswers.length;
                                    final String letter =
                                        hasLetter ? _userAnswers[index].char : '';
                                    final Color tileColor =
                                        !hasLetter
                                            ? const Color(0xFF087D73)
                                            : (_hasError
                                                ? const Color(0xFFFFE4E6)
                                                : (_isRevealed
                                                    ? const Color(0xFFFFE08A)
                                                    : Colors.white));
                                    final Color letterColor =
                                        _hasError
                                            ? const Color(0xFFE11D48)
                                            : (_isRevealed
                                                ? const Color(0xFF9A6400)
                                                : const Color(0xFF08796F));

                                    return GestureDetector(
                                      onTap: () => _removeLetterAt(index),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 150),
                                        width: slotWidth,
                                        height: 40,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: horizontalGap,
                                        ),
                                        decoration: BoxDecoration(
                                          color: tileColor,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow:
                                              hasLetter
                                                  ? const [
                                                    BoxShadow(
                                                      color: Color(0x22004F49),
                                                      blurRadius: 3,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ]
                                                  : null,
                                        ),
                                        child: Center(
                                          child:
                                              hasLetter
                                                  ? Text(
                                                    letter,
                                                    style: TextStyle(
                                                      fontSize:
                                                          math
                                                              .min(
                                                                22.0,
                                                                slotWidth * 0.65,
                                                              )
                                                              .toDouble(),
                                                      fontWeight: FontWeight.w900,
                                                      color: letterColor,
                                                    ),
                                                  )
                                                  : null,
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // แถบลบตัวท้าย / เริ่มใหม่
                    SizedBox(
                      height: 24,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isRevealed)
                            const Text(
                              'เฉลยคำตอบให้แล้วนะ!',
                              style: TextStyle(
                                color: Color(0xFF9A6400),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            )
                          else if (_userAnswers.isNotEmpty &&
                              !_isAnswerCorrect) ...[
                            GestureDetector(
                              onTap: _removeLastLetter,
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.backspace_outlined,
                                    color: Color(0xFF08796F),
                                    size: 15,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'ลบตัวท้าย',
                                    style: TextStyle(
                                      color: Color(0xFF08796F),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            GestureDetector(
                              onTap: _resetLetters,
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.refresh_rounded,
                                    color: Color(0xFFEF4444),
                                    size: 15,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'เริ่มใหม่',
                                    style: TextStyle(
                                      color: Color(0xFFCC4456),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // แป้นพิมพ์ตัวเลือกตัวอักษร
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.black, width: 2.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(_shuffledLetters.length, (
                          index,
                        ) {
                          final isUsed = _usedLetters[index];
                          final letter = _shuffledLetters[index];
                          double keySize =
                              _shuffledLetters.length > 7 ? 44 : 48;

                          return GestureDetector(
                            onTap: () => _onLetterTap(index),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 180),
                              opacity: isUsed ? 0.35 : 1.0,
                              child: Container(
                                width: keySize,
                                height: keySize,
                                decoration: BoxDecoration(
                                  gradient:
                                      isUsed
                                          ? null
                                          : const LinearGradient(
                                            colors: [
                                              Color(0xFFFFD94D),
                                              Color(0xFFFFB900),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                  color:
                                      isUsed ? const Color(0xFFE2E8F0) : null,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow:
                                      isUsed
                                          ? null
                                          : [
                                            BoxShadow(
                                              color: const Color(
                                                0xFFD18A00,
                                              ).withOpacity(0.28),
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                ),
                                child: Center(
                                  child: Text(
                                    letter,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF705000),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ปุ่มขอตัวช่วย (แสดงโควตาที่เหลือ) และ ข้ามข้อ
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _useHint,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: _remainingHints > 0 ? 1.0 : 0.65,
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color:
                                    _remainingHints > 0
                                        ? const Color(0xFFD97706)
                                        : Colors.grey.shade600,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.only(bottom: 3.5),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  gradient:
                                      _remainingHints > 0
                                          ? const LinearGradient(
                                            colors: [
                                              Color(0xFFFFC000),
                                              Color(0xFFFFA500),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          )
                                          : LinearGradient(
                                            colors: [
                                              Colors.grey.shade400,
                                              Colors.grey.shade500,
                                            ],
                                          ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFFFA500,
                                      ).withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.lightbulb_rounded,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'ขอตัวช่วย ($_remainingHints)',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        GestureDetector(
                          onTap: _skipQuestion,
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F766E),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding: const EdgeInsets.only(bottom: 3.5),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF2DD4BF),
                                    Color(0xFF0D9488),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.fast_forward_rounded,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'ข้ามข้อนี้ไปก่อน',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Particle Painter สำหรับ Confetti เฉลิมฉลอง
class _ConfettiParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(12345);
    final paint = Paint()..style = PaintingStyle.fill;

    final colors = [
      const Color(0xFFFBBF24),
      const Color(0xFFF472B6),
      const Color(0xFF34D399),
      const Color(0xFF60A5FA),
      const Color(0xFFC084FC),
      const Color(0xFFFB923C),
    ];

    for (int i = 0; i < 65; i++) {
      paint.color = colors[random.nextInt(colors.length)];
      final double x = random.nextDouble() * size.width;
      final double y = random.nextDouble() * size.height * 0.78;
      final double radius = random.nextDouble() * 4 + 3;

      if (random.nextBool()) {
        canvas.drawRect(
          Rect.fromLTWH(x, y, radius * 2.2, radius),
          paint,
        );
      } else {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}