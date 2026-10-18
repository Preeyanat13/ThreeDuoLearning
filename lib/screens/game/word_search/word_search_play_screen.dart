import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'word_search_screen.dart';

class WordSearchTarget {
  final String word;
  final String thai;
  final String phonetic;
  final String categoryKey;
  final String imagePath;

  const WordSearchTarget({
    required this.word,
    required this.thai,
    required this.phonetic,
    required this.categoryKey,
    required this.imagePath,
  });
}

class PlacedWordLocation {
  final String word;
  final List<int> indices;

  const PlacedWordLocation({
    required this.word,
    required this.indices,
  });
}

class FoundWordItem {
  final String word;
  final List<int> cellIndices;
  final Color highlightColor;

  FoundWordItem({
    required this.word,
    required this.cellIndices,
    required this.highlightColor,
  });
}

enum WordDirection {
  horizontalForward,
  horizontalBackward,
  verticalDown,
  verticalUp,
  diagonalDownRight,
  diagonalDownLeft,
}

class WordSearchPlayScreen extends StatefulWidget {
  final WordSearchCategoryItem category;

  const WordSearchPlayScreen({super.key, required this.category});

  @override
  State<WordSearchPlayScreen> createState() => _WordSearchPlayScreenState();
}

class _WordSearchPlayScreenState extends State<WordSearchPlayScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  static const int gridSize = 9;
  static const int visibleTargetSlots = 4;

  final List<Color> _pastelColors = const [
    Color(0xFF81C784),
    Color(0xFFFFB74D),
    Color(0xFFF06292),
    Color(0xFF64B5F6),
    Color(0xFFBA68C8),
    Color(0xFF4DD0E1),
    Color(0xFFFFD54F),
    Color(0xFFFF8A80),
  ];

  // 1. หมวดสัตว์ (Animal)
  final List<WordSearchTarget> _animalWords = const [
    WordSearchTarget(word: "ALLIGATOR", thai: "จระเข้", phonetic: "แอลลิเกเตอร์", categoryKey: "animal", imagePath: "assets/images/guess/animal/Crocodile.png"),
    WordSearchTarget(word: "BEAR", thai: "หมี", phonetic: "แบร์", categoryKey: "animal", imagePath: "assets/images/guess/animal/Bear.png"),
    WordSearchTarget(word: "BIRD", thai: "นก", phonetic: "เบิร์ด", categoryKey: "animal", imagePath: "assets/images/guess/animal/Bird.png"),
    WordSearchTarget(word: "CAT", thai: "แมว", phonetic: "แคท", categoryKey: "animal", imagePath: "assets/images/guess/animal/Cat.png"),
    WordSearchTarget(word: "CHICKEN", thai: "ไก่", phonetic: "ชิคเก้น", categoryKey: "animal", imagePath: "assets/images/guess/animal/Chicken.png"),
    WordSearchTarget(word: "COW", thai: "วัว", phonetic: "คาว", categoryKey: "animal", imagePath: "assets/images/guess/animal/Cow.png"),
    WordSearchTarget(word: "DOG", thai: "สุนัข", phonetic: "ด็อก", categoryKey: "animal", imagePath: "assets/images/guess/animal/Dog.png"),
    WordSearchTarget(word: "DOLPHIN", thai: "โลมา", phonetic: "ดอลฟิน", categoryKey: "animal", imagePath: "assets/images/guess/animal/Dolphin.png"),
    WordSearchTarget(word: "DUCK", thai: "เป็ด", phonetic: "ดั๊ก", categoryKey: "animal", imagePath: "assets/images/guess/animal/Duck.png"),
    WordSearchTarget(word: "ELEPHANT", thai: "ช้าง", phonetic: "เอเลแฟนท์", categoryKey: "animal", imagePath: "assets/images/guess/animal/Elephant.png"),
    WordSearchTarget(word: "FISH", thai: "ปลา", phonetic: "ฟิช", categoryKey: "animal", imagePath: "assets/images/guess/animal/Fish.png"),
    WordSearchTarget(word: "FROG", thai: "กบ", phonetic: "ฟร็อก", categoryKey: "animal", imagePath: "assets/images/guess/animal/Frog.png"),
    WordSearchTarget(word: "GIRAFFE", thai: "ยีราฟ", phonetic: "จิราฟ", categoryKey: "animal", imagePath: "assets/images/guess/animal/Giraffe.png"),
    WordSearchTarget(word: "HORSE", thai: "ม้า", phonetic: "ฮอร์ส", categoryKey: "animal", imagePath: "assets/images/guess/animal/Horse.png"),
    WordSearchTarget(word: "KOALA", thai: "โคอาลา", phonetic: "โคอาล่า", categoryKey: "animal", imagePath: "assets/images/guess/animal/Koala.png"),
    WordSearchTarget(word: "LION", thai: "สิงโต", phonetic: "ไลออน", categoryKey: "animal", imagePath: "assets/images/guess/animal/Lion.png"),
    WordSearchTarget(word: "MOSQUITO", thai: "ยุง", phonetic: "มอสคีโต", categoryKey: "animal", imagePath: "assets/images/guess/animal/Mosquito.png"),
    WordSearchTarget(word: "OWL", thai: "นกฮูก", phonetic: "เอาล์", categoryKey: "animal", imagePath: "assets/images/guess/animal/Owl.png"),
    WordSearchTarget(word: "PEACOCK", thai: "นกยูง", phonetic: "พีค็อก", categoryKey: "animal", imagePath: "assets/images/guess/animal/Peacock.png"),
    WordSearchTarget(word: "PENGUIN", thai: "เพนกวิน", phonetic: "เพนกวิน", categoryKey: "animal", imagePath: "assets/images/guess/animal/Penguin.png"),
    WordSearchTarget(word: "PIG", thai: "หมู", phonetic: "พิก", categoryKey: "animal", imagePath: "assets/images/guess/animal/Pig.png"),
    WordSearchTarget(word: "RABBIT", thai: "กระต่าย", phonetic: "แรบบิท", categoryKey: "animal", imagePath: "assets/images/guess/animal/Rabbit.png"),
    WordSearchTarget(word: "SHEEP", thai: "แกะ", phonetic: "ชีพ", categoryKey: "animal", imagePath: "assets/images/guess/animal/Sheep.webp"),
    WordSearchTarget(word: "SHRIMP", thai: "กุ้ง", phonetic: "ชริมพ์", categoryKey: "animal", imagePath: "assets/images/guess/animal/Shrimp.png"),
    WordSearchTarget(word: "SNAKE", thai: "งู", phonetic: "สเนค", categoryKey: "animal", imagePath: "assets/images/guess/animal/Snake.png"),
    WordSearchTarget(word: "SPIDER", thai: "แมงมุม", phonetic: "สไปเดอร์", categoryKey: "animal", imagePath: "assets/images/guess/animal/Spider.png"),
    WordSearchTarget(word: "TIGER", thai: "เสือ", phonetic: "ไทเกอร์", categoryKey: "animal", imagePath: "assets/images/guess/animal/Tiger.png"),
    WordSearchTarget(word: "TURTLE", thai: "เต่า", phonetic: "เทอร์เทิล", categoryKey: "animal", imagePath: "assets/images/guess/animal/Turtle.webp"),
    WordSearchTarget(word: "ZEBRA", thai: "ม้าลาย", phonetic: "ซีบรา", categoryKey: "animal", imagePath: "assets/images/guess/animal/Zebra.png"),
  ];

  // 2. หมวดกีฬา (Sports)
  final List<WordSearchTarget> _sportWords = const [
    WordSearchTarget(word: "ARCHERY", thai: "ยิงธนู", phonetic: "อาร์เชอรี", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Archery.png"),
    WordSearchTarget(word: "BADMINTON", thai: "แบดมินตัน", phonetic: "แบดมินตัน", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Badminton.png"),
    WordSearchTarget(word: "BASEBALL", thai: "เบสบอล", phonetic: "เบสบอล", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Baseball.png"),
    WordSearchTarget(word: "BASKETBALL", thai: "บาสเกตบอล", phonetic: "บาสเกตบอล", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Basketball.png"),
    WordSearchTarget(word: "BOWLING", thai: "โบว์ลิ่ง", phonetic: "โบว์ลิง", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Bowling.png"),
    WordSearchTarget(word: "BOXING", thai: "มวย", phonetic: "บ็อกซิ่ง", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Boxing.png"),
    WordSearchTarget(word: "CYCLING", thai: "ปั่นจักรยาน", phonetic: "ไซคลิง", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Cycling.png"),
    WordSearchTarget(word: "GOLF", thai: "กอล์ฟ", phonetic: "กอล์ฟ", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Golf.png"),
    WordSearchTarget(word: "GYMNASTICS", thai: "ยิมนาสติก", phonetic: "ยิมนาสติกส์", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Gymnastics.png"),
    WordSearchTarget(word: "HOCKEY", thai: "ฮอกกี้", phonetic: "ฮอกกี", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Hockey.png"),
    WordSearchTarget(word: "RUGBY", thai: "รักบี้", phonetic: "รักบี", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Rugby.png"),
    WordSearchTarget(word: "RUNNING", thai: "วิ่ง", phonetic: "รันนิ่ง", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Running.png"),
    WordSearchTarget(word: "SKATE", thai: "สเกตบอร์ด", phonetic: "สเกต", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Skateboarding.png"),
    WordSearchTarget(word: "FOOTBALL", thai: "ฟุตบอล", phonetic: "ฟุตบอล", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Sports.png"),
    WordSearchTarget(word: "SURFING", thai: "โต้คลื่น", phonetic: "เซิร์ฟฟิง", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Surfing.png"),
    WordSearchTarget(word: "SWIMMING", thai: "ว่ายน้ำ", phonetic: "สวิมมิ่ง", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Swimming.png"),
    WordSearchTarget(word: "PINGPONG", thai: "ปิงปอง", phonetic: "ปิงปอง", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Tabletennis.png"),
    WordSearchTarget(word: "TAEKWONDO", thai: "เทควันโด", phonetic: "เทควันโด", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Taekwondo.png"),
    WordSearchTarget(word: "TENNIS", thai: "เทนนิส", phonetic: "เทนนิส", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Tennis.png"),
    WordSearchTarget(word: "VOLLEYBALL", thai: "วอลเลย์บอล", phonetic: "วอลเลย์บอล", categoryKey: "sport", imagePath: "assets/images/guess/Sports/Volleyball.png"),
  ];

  // 3. หมวดอาชีพ (Jobs / Career)
  final List<WordSearchTarget> _jobWords = const [
    WordSearchTarget(word: "ARTIST", thai: "ศิลปิน", phonetic: "อาร์ทิสต์", categoryKey: "career", imagePath: "assets/images/guess/jobs/Artist.png"),
    WordSearchTarget(word: "ATHLETE", thai: "นักกีฬา", phonetic: "แอธลีท", categoryKey: "career", imagePath: "assets/images/guess/jobs/Athlete.png"),
    WordSearchTarget(word: "CARPENTER", thai: "ช่างไม้", phonetic: "คาร์เพนเทอร์", categoryKey: "career", imagePath: "assets/images/guess/jobs/Carpenter.png"),
    WordSearchTarget(word: "CHEF", thai: "พ่อครัว", phonetic: "เชฟ", categoryKey: "career", imagePath: "assets/images/guess/jobs/Chef.png"),
    WordSearchTarget(word: "DANCER", thai: "นักเต้น", phonetic: "แดนเซอร์", categoryKey: "career", imagePath: "assets/images/guess/jobs/Dancer.png"),
    WordSearchTarget(word: "DENTIST", thai: "ทันตแพทย์", phonetic: "เดนทิสต์", categoryKey: "career", imagePath: "assets/images/guess/jobs/Dentist.png"),
    WordSearchTarget(word: "DOCTOR", thai: "คุณหมอ", phonetic: "ด็อกเตอร์", categoryKey: "career", imagePath: "assets/images/guess/jobs/Doctor.png"),
    WordSearchTarget(word: "DRIVER", thai: "คนขับรถ", phonetic: "ไดรเวอร์", categoryKey: "career", imagePath: "assets/images/guess/jobs/Driver.png"),
    WordSearchTarget(word: "ELECTRIC", thai: "ช่างไฟ", phonetic: "อิเล็กทริก", categoryKey: "career", imagePath: "assets/images/guess/jobs/Electrician.png"),
    WordSearchTarget(word: "ENGINEER", thai: "วิศวกร", phonetic: "เอนจิเนียร์", categoryKey: "career", imagePath: "assets/images/guess/jobs/Engineer.png"),
    WordSearchTarget(word: "FARMER", thai: "ชาวนา", phonetic: "ฟาร์มเมอร์", categoryKey: "career", imagePath: "assets/images/guess/jobs/Farmer.png"),
    WordSearchTarget(word: "FIREMAN", thai: "นักดับเพลิง", phonetic: "ไฟร์แมน", categoryKey: "career", imagePath: "assets/images/guess/jobs/Firefighter.png"),
    WordSearchTarget(word: "FISHERMAN", thai: "ชาวประมง", phonetic: "ฟิชเชอร์แมน", categoryKey: "career", imagePath: "assets/images/guess/jobs/Fisherman.png"),
    WordSearchTarget(word: "JOURNAL", thai: "นักข่าว", phonetic: "เจอร์นัล", categoryKey: "career", imagePath: "assets/images/guess/jobs/Journalist.png"),
    WordSearchTarget(word: "LAWYER", thai: "ทนายความ", phonetic: "ลอว์เยอร์", categoryKey: "career", imagePath: "assets/images/guess/jobs/Lawyer.png"),
    WordSearchTarget(word: "MUSICIAN", thai: "นักดนตรี", phonetic: "มิวสิเชียน", categoryKey: "career", imagePath: "assets/images/guess/jobs/Musician.png"),
    WordSearchTarget(word: "NURSE", thai: "พยาบาล", phonetic: "เนิร์ส", categoryKey: "career", imagePath: "assets/images/guess/jobs/Nurse.png"),
    WordSearchTarget(word: "PHARMACY", thai: "เภสัชกร", phonetic: "ฟาร์มาซี", categoryKey: "career", imagePath: "assets/images/guess/jobs/Pharmacist.png"),
    WordSearchTarget(word: "PHOTO", thai: "ช่างภาพ", phonetic: "โฟโต้", categoryKey: "career", imagePath: "assets/images/guess/jobs/Photographer.png"),
    WordSearchTarget(word: "PILOT", thai: "นักบิน", phonetic: "ไพลอต", categoryKey: "career", imagePath: "assets/images/guess/jobs/Pilot.png"),
    WordSearchTarget(word: "POLICE", thai: "ตำรวจ", phonetic: "โพลิส", categoryKey: "career", imagePath: "assets/images/guess/jobs/Policeofficer.png"),
    WordSearchTarget(word: "POSTMAN", thai: "บุรุษไปรษณีย์", phonetic: "โพสต์แมน", categoryKey: "career", imagePath: "assets/images/guess/jobs/Postman.png"),
    WordSearchTarget(word: "SINGER", thai: "นักร้อง", phonetic: "ซิงเกอร์", categoryKey: "career", imagePath: "assets/images/guess/jobs/Singer.png"),
    WordSearchTarget(word: "SOLDIER", thai: "ทหาร", phonetic: "โซลเจอร์", categoryKey: "career", imagePath: "assets/images/guess/jobs/Soldier.png"),
    WordSearchTarget(word: "TEACHER", thai: "คุณครู", phonetic: "ทีเชอร์", categoryKey: "career", imagePath: "assets/images/guess/jobs/Teacher.png"),
  ];

  // 4. หมวดบ้าน (House / Home)
  final List<WordSearchTarget> _houseWords = const [
    WordSearchTarget(word: "BATHROOM", thai: "ห้องน้ำ", phonetic: "บาธรูม", categoryKey: "home", imagePath: "assets/images/guess/house/Bathroom.png"),
    WordSearchTarget(word: "BED", thai: "เตียงนอน", phonetic: "เบด", categoryKey: "home", imagePath: "assets/images/guess/house/Bed.png"),
    WordSearchTarget(word: "BEDROOM", thai: "ห้องนอน", phonetic: "เบดรูม", categoryKey: "home", imagePath: "assets/images/guess/house/Bedroom.png"),
    WordSearchTarget(word: "BLANKET", thai: "ผ้าห่ม", phonetic: "แบล็งเค็ท", categoryKey: "home", imagePath: "assets/images/guess/house/Blanket.png"),
    WordSearchTarget(word: "CHAIR", thai: "เก้าอี้", phonetic: "แชร์", categoryKey: "home", imagePath: "assets/images/guess/house/Chair.png"),
    WordSearchTarget(word: "CLOCK", thai: "นาฬิกา", phonetic: "คล็อก", categoryKey: "home", imagePath: "assets/images/guess/house/Clock.png"),
    WordSearchTarget(word: "CLOSET", thai: "ตู้เสื้อผ้า", phonetic: "โคลสเซ็ท", categoryKey: "home", imagePath: "assets/images/guess/house/Closet.png"),
    WordSearchTarget(word: "DINING", thai: "ห้องอาหาร", phonetic: "ไดนิ่ง", categoryKey: "home", imagePath: "assets/images/guess/house/Diningroom.png"),
    WordSearchTarget(word: "DOOR", thai: "ประตู", phonetic: "ดอร์", categoryKey: "home", imagePath: "assets/images/guess/house/Door.png"),
    WordSearchTarget(word: "FAN", thai: "พัดลม", phonetic: "แฟน", categoryKey: "home", imagePath: "assets/images/guess/house/Fan.png"),
    WordSearchTarget(word: "FLOOR", thai: "พื้นห้อง", phonetic: "ฟลอร์", categoryKey: "home", imagePath: "assets/images/guess/house/Floor.png"),
    WordSearchTarget(word: "FORK", thai: "ส้อม", phonetic: "ฟอร์ค", categoryKey: "home", imagePath: "assets/images/guess/house/Fork.png"),
    WordSearchTarget(word: "GARDEN", thai: "สวน", phonetic: "การ์เดน", categoryKey: "home", imagePath: "assets/images/guess/house/Garden.png"),
    WordSearchTarget(word: "HOUSE", thai: "บ้าน", phonetic: "เฮาส์", categoryKey: "home", imagePath: "assets/images/guess/house/House.png"),
    WordSearchTarget(word: "KITCHEN", thai: "ห้องครัว", phonetic: "คิทเช่น", categoryKey: "home", imagePath: "assets/images/guess/house/Kitchen.png"),
    WordSearchTarget(word: "LAMP", thai: "โคมไฟ", phonetic: "แลมป์", categoryKey: "home", imagePath: "assets/images/guess/house/Lamp.png"),
    WordSearchTarget(word: "LOUNGE", thai: "ห้องนั่งเล่น", phonetic: "เลานจ์", categoryKey: "home", imagePath: "assets/images/guess/house/Livingroom.png"),
    WordSearchTarget(word: "MIRROR", thai: "กระจกเงา", phonetic: "มิเรอร์", categoryKey: "home", imagePath: "assets/images/guess/house/Mirror.png"),
    WordSearchTarget(word: "PILLOW", thai: "หมอน", phonetic: "พิลโลว์", categoryKey: "home", imagePath: "assets/images/guess/house/Pillow.png"),
    WordSearchTarget(word: "PLATE", thai: "จาน", phonetic: "เพลท", categoryKey: "home", imagePath: "assets/images/guess/house/Plate.png"),
    WordSearchTarget(word: "FRIDGE", thai: "ตู้เย็น", phonetic: "ฟริดจ์", categoryKey: "home", imagePath: "assets/images/guess/house/Refrigerator.png"),
    WordSearchTarget(word: "ROOF", thai: "หลังคา", phonetic: "รูฟ", categoryKey: "home", imagePath: "assets/images/guess/house/Roof.png"),
    WordSearchTarget(word: "ROOM", thai: "ห้อง", phonetic: "รูม", categoryKey: "home", imagePath: "assets/images/guess/house/Room.png"),
    WordSearchTarget(word: "SHOWER", thai: "ฝักบัว", phonetic: "ชาวเวอร์", categoryKey: "home", imagePath: "assets/images/guess/house/Shower.png"),
    WordSearchTarget(word: "SOAP", thai: "สบู่", phonetic: "โซพ", categoryKey: "home", imagePath: "assets/images/guess/house/Soap.png"),
    WordSearchTarget(word: "SOFA", thai: "โซฟา", phonetic: "โซฟา", categoryKey: "home", imagePath: "assets/images/guess/house/Sofa.png"),
    WordSearchTarget(word: "SPOON", thai: "ช้อน", phonetic: "สพูน", categoryKey: "home", imagePath: "assets/images/guess/house/Spoon.png"),
    WordSearchTarget(word: "STAIRS", thai: "บันได", phonetic: "สแตร์ส", categoryKey: "home", imagePath: "assets/images/guess/house/Stairs.png"),
    WordSearchTarget(word: "TABLE", thai: "โต๊ะ", phonetic: "เทเบิล", categoryKey: "home", imagePath: "assets/images/guess/house/Table.png"),
    WordSearchTarget(word: "TV", thai: "โทรทัศน์", phonetic: "ทีวี", categoryKey: "home", imagePath: "assets/images/guess/house/Television.png"),
    WordSearchTarget(word: "TOILET", thai: "ชักโครก", phonetic: "ทอยเล็ท", categoryKey: "home", imagePath: "assets/images/guess/house/Toilet.png"),
    WordSearchTarget(word: "TOWEL", thai: "ผ้าขนหนู", phonetic: "ทาวเวล", categoryKey: "home", imagePath: "assets/images/guess/house/Towel.png"),
    WordSearchTarget(word: "WALL", thai: "กำแพง", phonetic: "วอลล์", categoryKey: "home", imagePath: "assets/images/guess/house/Wall.png"),
    WordSearchTarget(word: "WASHER", thai: "เครื่องซักผ้า", phonetic: "วอชเชอร์", categoryKey: "home", imagePath: "assets/images/guess/house/Washingmachine.png"),
    WordSearchTarget(word: "WINDOW", thai: "หน้าต่าง", phonetic: "วินโดว์", categoryKey: "home", imagePath: "assets/images/guess/house/Window.png"),
  ];

  // 5. หมวดยานพาหนะ (Vehicles)
  final List<WordSearchTarget> _vehicleWords = const [
    WordSearchTarget(word: "BOAT", thai: "เรือ", phonetic: "โบ๊ท", categoryKey: "vehicle", imagePath: "assets/images/guess/Vehicles/Boat.png"),
    WordSearchTarget(word: "BUS", thai: "รถบัส", phonetic: "บัส", categoryKey: "vehicle", imagePath: "assets/images/guess/Vehicles/Bus.png"),
    WordSearchTarget(word: "CAR", thai: "รถยนต์", phonetic: "คาร์", categoryKey: "vehicle", imagePath: "assets/images/guess/Vehicles/Car.png"),
    WordSearchTarget(word: "FIRETRUCK", thai: "รถดับเพลิง", phonetic: "ไฟร์ทรัค", categoryKey: "vehicle", imagePath: "assets/images/guess/Vehicles/Firetruck.png"),
    WordSearchTarget(word: "CHOPPER", thai: "เฮลิคอปเตอร์", phonetic: "ชอปเปอร์", categoryKey: "vehicle", imagePath: "assets/images/guess/Vehicles/Helicopter.png"),
    WordSearchTarget(word: "MOTORBIKE", thai: "มอเตอร์ไซค์", phonetic: "มอเตอร์ไบค์", categoryKey: "vehicle", imagePath: "assets/images/guess/Vehicles/Motorcycle.png"),
    WordSearchTarget(word: "ROCKET", thai: "จรวด", phonetic: "ร็อกเก็ต", categoryKey: "vehicle", imagePath: "assets/images/guess/Vehicles/Rocket.png"),
    WordSearchTarget(word: "SCHOOLBUS", thai: "รถโรงเรียน", phonetic: "สคูลบัส", categoryKey: "vehicle", imagePath: "assets/images/guess/Vehicles/Schoolbus.png"),
    WordSearchTarget(word: "SHIP", thai: "เรือสำเภา", phonetic: "ชิป", categoryKey: "vehicle", imagePath: "assets/images/guess/Vehicles/Ship.png"),
    WordSearchTarget(word: "SKYTRAIN", thai: "รถไฟฟ้า", phonetic: "สกายเทรน", categoryKey: "vehicle", imagePath: "assets/images/guess/Vehicles/Skytrain.png"),
    WordSearchTarget(word: "SUBMARINE", thai: "เรือดำน้ำ", phonetic: "ซับมารีน", categoryKey: "vehicle", imagePath: "assets/images/guess/Vehicles/Submarine.png"),
    WordSearchTarget(word: "TAXI", thai: "แท็กซี่", phonetic: "แท็กซี่", categoryKey: "vehicle", imagePath: "assets/images/guess/Vehicles/Taxi.png"),
    WordSearchTarget(word: "TRAIN", thai: "รถไฟ", phonetic: "เทรน", categoryKey: "vehicle", imagePath: "assets/images/guess/Vehicles/Train.png"),
    WordSearchTarget(word: "TRUCK", thai: "รถบรรทุก", phonetic: "ทรัค", categoryKey: "vehicle", imagePath: "assets/images/guess/Vehicles/Truck.png"),
    WordSearchTarget(word: "VAN", thai: "รถตู้", phonetic: "แวน", categoryKey: "vehicle", imagePath: "assets/images/guess/Vehicles/Van.png"),
    WordSearchTarget(word: "AIRPLANE", thai: "เครื่องบิน", phonetic: "แอร์เพลน", categoryKey: "vehicle", imagePath: "assets/images/guess/Vehicles/Airplane.png"),
    WordSearchTarget(word: "AMBULANCE", thai: "รถพยาบาล", phonetic: "แอมบิวแลนซ์", categoryKey: "vehicle", imagePath: "assets/images/guess/Vehicles/Ambulance.png"),
    WordSearchTarget(word: "BICYCLE", thai: "จักรยาน", phonetic: "ไบซิเคิล", categoryKey: "vehicle", imagePath: "assets/images/guess/Vehicles/Bicycle.png"),
  ];

  // 6. หมวดสถานที่ (Places / Location)
  final List<WordSearchTarget> _placeWords = const [
    WordSearchTarget(word: "AIRPORT", thai: "สนามบิน", phonetic: "แอร์พอร์ต", categoryKey: "location", imagePath: "assets/images/guess/Places/Airport.png"),
    WordSearchTarget(word: "BAKERY", thai: "ร้านเบเกอรี่", phonetic: "เบเกอรี", categoryKey: "location", imagePath: "assets/images/guess/Places/Bakery.png"),
    WordSearchTarget(word: "BANK", thai: "ธนาคาร", phonetic: "แบงก์", categoryKey: "location", imagePath: "assets/images/guess/Places/Bank.png"),
    WordSearchTarget(word: "BUSSTOP", thai: "ป้ายรถเมล์", phonetic: "บัสสต็อป", categoryKey: "location", imagePath: "assets/images/guess/Places/Busstop.png"),
    WordSearchTarget(word: "CHURCH", thai: "โบสถ์", phonetic: "เชิร์ช", categoryKey: "location", imagePath: "assets/images/guess/Places/Church.png"),
    WordSearchTarget(word: "CINEMA", thai: "โรงภาพยนตร์", phonetic: "ซิเนมา", categoryKey: "location", imagePath: "assets/images/guess/Places/Cinema.png"),
    WordSearchTarget(word: "FIREHOUSE", thai: "สถานีดับเพลิง", phonetic: "ไฟร์เฮาส์", categoryKey: "location", imagePath: "assets/images/guess/Places/Firestation.png"),
    WordSearchTarget(word: "GAS", thai: "ปั๊มน้ำมัน", phonetic: "แก๊ส", categoryKey: "location", imagePath: "assets/images/guess/Places/Gasstation.png"),
    WordSearchTarget(word: "GYM", thai: "โรงยิม", phonetic: "ยิม", categoryKey: "location", imagePath: "assets/images/guess/Places/Gym.png"),
    WordSearchTarget(word: "HOME", thai: "บ้าน", phonetic: "โฮม", categoryKey: "location", imagePath: "assets/images/guess/Places/Home.png"),
    WordSearchTarget(word: "HOSPITAL", thai: "โรงพยาบาล", phonetic: "ฮอสพิทอล", categoryKey: "location", imagePath: "assets/images/guess/Places/Hospital.png"),
    WordSearchTarget(word: "HOTEL", thai: "โรงแรม", phonetic: "โฮเทล", categoryKey: "location", imagePath: "assets/images/guess/Places/Hotel.png"),
    WordSearchTarget(word: "LIBRARY", thai: "ห้องสมุด", phonetic: "ไลบรารี", categoryKey: "location", imagePath: "assets/images/guess/Places/Library.png"),
    WordSearchTarget(word: "MARKET", thai: "ตลาด", phonetic: "มาร์เก็ต", categoryKey: "location", imagePath: "assets/images/guess/Places/Market.png"),
    WordSearchTarget(word: "MOSQUE", thai: "มัสยิด", phonetic: "มอสก์", categoryKey: "location", imagePath: "assets/images/guess/Places/Mosque.png"),
    WordSearchTarget(word: "MUSEUM", thai: "พิพิธภัณฑ์", phonetic: "มิวเซียม", categoryKey: "location", imagePath: "assets/images/guess/Places/Museum.png"),
    WordSearchTarget(word: "PARK", thai: "สวนสาธารณะ", phonetic: "พาร์ค", categoryKey: "location", imagePath: "assets/images/guess/Places/Park.png"),
    WordSearchTarget(word: "PHARMACY", thai: "ร้านขายยา", phonetic: "ฟาร์มาซี", categoryKey: "location", imagePath: "assets/images/guess/Places/Pharmacy.png"),
    WordSearchTarget(word: "POLICE", thai: "สถานีตำรวจ", phonetic: "โพลิส", categoryKey: "location", imagePath: "assets/images/guess/Places/Policestation.png"),
    WordSearchTarget(word: "POST", thai: "ที่ทำการไปรษณีย์", phonetic: "โพสต์", categoryKey: "location", imagePath: "assets/images/guess/Places/Postoffice.png"),
    WordSearchTarget(word: "DINER", thai: "ร้านอาหาร", phonetic: "ไดเนอร์", categoryKey: "location", imagePath: "assets/images/guess/Places/Restaurant.png"),
    WordSearchTarget(word: "SCHOOL", thai: "โรงเรียน", phonetic: "สกูล", categoryKey: "location", imagePath: "assets/images/guess/Places/School.png"),
    WordSearchTarget(word: "TEMPLE", thai: "วัด", phonetic: "เทมเพิล", categoryKey: "location", imagePath: "assets/images/guess/Places/Temple.png"),
    WordSearchTarget(word: "STATION", thai: "สถานีรถไฟ", phonetic: "สเตชัน", categoryKey: "location", imagePath: "assets/images/guess/Places/Trainstation.png"),
    WordSearchTarget(word: "ZOO", thai: "สวนสัตว์", phonetic: "ซู", categoryKey: "location", imagePath: "assets/images/guess/Places/Zoo.png"),
  ];

  // 7. หมวดเสื้อผ้า (Clothes / Clothing)
  final List<WordSearchTarget> _clothesWords = const [
    WordSearchTarget(word: "BACKPACK", thai: "กระเป๋าเป้", phonetic: "แบ็คแพ็ค", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Backpack.png"),
    WordSearchTarget(word: "BAG", thai: "กระเป๋า", phonetic: "แบ็ก", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Bag.png"),
    WordSearchTarget(word: "BELT", thai: "เข็มขัด", phonetic: "เบลท์", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Belt.png"),
    WordSearchTarget(word: "BOOTS", thai: "รองเท้าบูท", phonetic: "บูทส์", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Boots.png"),
    WordSearchTarget(word: "CAP", thai: "หมวกแก๊ป", phonetic: "แค็ป", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Cap.png"),
    WordSearchTarget(word: "DRESS", thai: "ชุดกระโปรง", phonetic: "เดรส", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Dress.png"),
    WordSearchTarget(word: "EARRINGS", thai: "ต่างหู", phonetic: "เอียร์ริงส์", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Earrings.png"),
    WordSearchTarget(word: "GLASSES", thai: "แว่นตา", phonetic: "กลาสเซส", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Glasses.png"),
    WordSearchTarget(word: "HAT", thai: "หมวกปีก", phonetic: "แฮ็ท", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Hat.png"),
    WordSearchTarget(word: "HOODIE", thai: "เสื้อมีฮู้ด", phonetic: "ฮู้ดดี้", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Hoodie.png"),
    WordSearchTarget(word: "JACKET", thai: "เสื้อแจ็กเก็ต", phonetic: "แจ็กเก็ต", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Jacket.png"),
    WordSearchTarget(word: "JEANS", thai: "กางเกงยีนส์", phonetic: "ยีนส์", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Jeans.png"),
    WordSearchTarget(word: "NECKLACE", thai: "สร้อยคอ", phonetic: "เน็คเลส", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Necklace.png"),
    WordSearchTarget(word: "PAJAMAS", thai: "ชุดนอน", phonetic: "พาจามาส", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Pajamas.png"),
    WordSearchTarget(word: "PANTS", thai: "กางเกงขายาว", phonetic: "แพนทส์", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Pants.png"),
    WordSearchTarget(word: "RAINCOAT", thai: "เสื้อกันฝน", phonetic: "เรนโค้ท", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Raincoat.png"),
    WordSearchTarget(word: "RING", thai: "แหวน", phonetic: "ริง", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Ring.png"),
    WordSearchTarget(word: "SCARF", thai: "ผ้าพันคอ", phonetic: "สคาร์ฟ", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Scarf.png"),
    WordSearchTarget(word: "SHIRT", thai: "เสื้อเชิ้ต", phonetic: "เชิ้ต", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Shirt.png"),
    WordSearchTarget(word: "SHOES", thai: "รองเท้า", phonetic: "ชูส์", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Shoes.png"),
    WordSearchTarget(word: "SHORTS", thai: "กางเกงขาสั้น", phonetic: "ชอร์ตส์", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Shorts.png"),
    WordSearchTarget(word: "SKIRT", thai: "กระโปรง", phonetic: "สเกิร์ต", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Skirt.png"),
    WordSearchTarget(word: "SOCKS", thai: "ถุงเท้า", phonetic: "ซ็อคส์", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Socks.png"),
    WordSearchTarget(word: "SHADES", thai: "แว่นกันแดด", phonetic: "เฉดส์", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Sunglasses.png"),
    WordSearchTarget(word: "SWEATER", thai: "เสื้อกันหนาว", phonetic: "สเวตเตอร์", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Sweater.png"),
    WordSearchTarget(word: "SWIMSUIT", thai: "ชุดว่ายน้ำ", phonetic: "สวิมสูท", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Swimsuit.png"),
    WordSearchTarget(word: "TIE", thai: "เนคไท", phonetic: "ไท", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Tie.png"),
    WordSearchTarget(word: "TSHIRT", thai: "เสื้อยืด", phonetic: "ทีเชิ้ต", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/T-shirt.png"),
    WordSearchTarget(word: "UNIFORM", thai: "ชุดเครื่องแบบ", phonetic: "ยูนิฟอร์ม", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Uniform.png"),
    WordSearchTarget(word: "WATCH", thai: "นาฬิกาข้อมือ", phonetic: "วอทช์", categoryKey: "clothing", imagePath: "assets/images/guess/Clothes/Watch.png"),
  ];

  // 8. หมวดผลไม้ (Fruit / Juicy Fruits)
  final List<WordSearchTarget> _fruitWords = const [
    WordSearchTarget(word: "APPLE", thai: "แอปเปิ้ล", phonetic: "แอปเปิล", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Apple.png"),
    WordSearchTarget(word: "APRICOT", thai: "แอปริคอต", phonetic: "แอปริคอต", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Apricot.png"),
    WordSearchTarget(word: "AVOCADO", thai: "อะโวคาโด", phonetic: "อะโวคาโด", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Avocado.png"),
    WordSearchTarget(word: "BANANA", thai: "กล้วย", phonetic: "บานานา", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Banana.png"),
    WordSearchTarget(word: "BERRY", thai: "แบล็กเบอร์รี", phonetic: "เบอร์รี", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Blackberry.png"),
    WordSearchTarget(word: "BLUEBERRY", thai: "บลูเบอร์รี", phonetic: "บลูเบอร์รี", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Blueberry.png"),
    WordSearchTarget(word: "CANTALO", thai: "แคนตาลูป", phonetic: "แคนตาลูป", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Cantaloupe.png"),
    WordSearchTarget(word: "CHERRY", thai: "เชอร์รี่", phonetic: "เชอร์รี", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Cherry.png"),
    WordSearchTarget(word: "COCONUT", thai: "มะพร้าว", phonetic: "โคโคนัท", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Coconut.png"),
    WordSearchTarget(word: "DURIAN", thai: "ทุเรียน", phonetic: "ดูเรียน", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Durian.png"),
    WordSearchTarget(word: "GRAPE", thai: "องุ่น", phonetic: "เกรป", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Grape.png"),
    WordSearchTarget(word: "GUAVA", thai: "ฝรั่ง", phonetic: "กวาว่า", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Guava.png"),
    WordSearchTarget(word: "KIWI", thai: "กีวี่", phonetic: "กีวี", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Kiwi.png"),
    WordSearchTarget(word: "LEMON", thai: "เลมอน", phonetic: "เลมอน", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Lemon.png"),
    WordSearchTarget(word: "LIME", thai: "มะนาว", phonetic: "ไลม์", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Lime.png"),
    WordSearchTarget(word: "LONGAN", thai: "ลำไย", phonetic: "ลองแกน", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Longan.png"),
    WordSearchTarget(word: "LYCHEE", thai: "ลิ้นจี่", phonetic: "ลิ้นจี่", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Lychee.png"),
    WordSearchTarget(word: "MANGO", thai: "มะม่วง", phonetic: "แมงโก้", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Mango.png"),
    WordSearchTarget(word: "MANGOSTN", thai: "มังคุด", phonetic: "แมงโกสทีน", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Mangosteen.png"),
    WordSearchTarget(word: "ORANGE", thai: "ส้ม", phonetic: "ออเรนจ์", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Orange.png"),
    WordSearchTarget(word: "PAPAYA", thai: "มะละกอ", phonetic: "พาพายา", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Papaya.png"),
    WordSearchTarget(word: "PASSION", thai: "เสาวรส", phonetic: "แพชชัน", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Passionfruit.png"),
    WordSearchTarget(word: "PINEAPPLE", thai: "สับปะรด", phonetic: "พายแอปเปิล", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Pineapple.png"),
    WordSearchTarget(word: "POMELO", thai: "ทับทิม", phonetic: "โพเมโล", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Pomegranate.png"),
    WordSearchTarget(word: "RAMBUTAN", thai: "เงาะ", phonetic: "แรมบูแทน", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Rambutan.png"),
    WordSearchTarget(word: "RASPBERRY", thai: "ราสเบอร์รี", phonetic: "ราสเบอร์รี", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Raspberry.png"),
    WordSearchTarget(word: "ROSEAPPLE", thai: "ชมพู่", phonetic: "โรสแอปเปิล", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Roseapple.png"),
    WordSearchTarget(word: "STARFRUIT", thai: "มะเฟือง", phonetic: "สตาร์ฟรุต", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Starfruit.png"),
    WordSearchTarget(word: "STRAWBERY", thai: "สตรอว์เบอร์รี", phonetic: "สตรอว์เบอร์รี", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Strawberry.png"),
    WordSearchTarget(word: "MELON", thai: "แตงโม", phonetic: "เมลอน", categoryKey: "fruit", imagePath: "assets/images/guess/fruit/Watermelon.png"),
  ];

  // 9. หมวดอาหาร (Food / Yummy Food)
  final List<WordSearchTarget> _foodWords = const [
    WordSearchTarget(word: "BREAD", thai: "ขนมปัง", phonetic: "เบรด", categoryKey: "food", imagePath: "assets/images/guess/food/Bread.png"),
    WordSearchTarget(word: "BURGER", thai: "เบอร์เกอร์", phonetic: "เบอร์เกอร์", categoryKey: "food", imagePath: "assets/images/guess/food/Burger.png"),
    WordSearchTarget(word: "CAKE", thai: "เค้ก", phonetic: "เค้ก", categoryKey: "food", imagePath: "assets/images/guess/food/Cake.png"),
    WordSearchTarget(word: "CANDY", thai: "ลูกอม", phonetic: "แคนดี้", categoryKey: "food", imagePath: "assets/images/guess/food/Candy.png"),
    WordSearchTarget(word: "CHEESE", thai: "ชีส", phonetic: "ชีส", categoryKey: "food", imagePath: "assets/images/guess/food/Cheese.png"),
    WordSearchTarget(word: "CHICKEN", thai: "ไก่ทอด", phonetic: "ชิคเก้น", categoryKey: "food", imagePath: "assets/images/guess/food/Chicken.png"),
    WordSearchTarget(word: "CHOCOLATE", thai: "ช็อกโกแลต", phonetic: "ช็อกโกแลต", categoryKey: "food", imagePath: "assets/images/guess/food/Chocolate.png"),
    WordSearchTarget(word: "COOKIE", thai: "คุกกี้", phonetic: "คุกกี้", categoryKey: "food", imagePath: "assets/images/guess/food/Cookie.png"),
    WordSearchTarget(word: "CORN", thai: "ข้าวโพด", phonetic: "คอร์น", categoryKey: "food", imagePath: "assets/images/guess/food/Corn.png"),
    WordSearchTarget(word: "DONUT", thai: "โดนัท", phonetic: "โดนัท", categoryKey: "food", imagePath: "assets/images/guess/food/Donut.png"),
    WordSearchTarget(word: "EGG", thai: "ไข่ต้ม", phonetic: "เอ้ก", categoryKey: "food", imagePath: "assets/images/guess/food/Egg.png"),
    WordSearchTarget(word: "FISH", thai: "เนื้อปลา", phonetic: "ฟิช", categoryKey: "food", imagePath: "assets/images/guess/food/Fish.png"),
    WordSearchTarget(word: "FRIES", thai: "เฟรนช์ฟรายส์", phonetic: "ฟรายส์", categoryKey: "food", imagePath: "assets/images/guess/food/Frenchfries.png"),
    WordSearchTarget(word: "ICECREAM", thai: "ไอศกรีม", phonetic: "ไอศกรีม", categoryKey: "food", imagePath: "assets/images/guess/food/Icecream.png"),
    WordSearchTarget(word: "JUICE", thai: "น้ำผลไม้", phonetic: "จูซ", categoryKey: "food", imagePath: "assets/images/guess/food/Juice.png"),
    WordSearchTarget(word: "MEAT", thai: "เนื้อสัตว์", phonetic: "มีท", categoryKey: "food", imagePath: "assets/images/guess/food/Meat.png"),
    WordSearchTarget(word: "MILK", thai: "นมสด", phonetic: "มิลค์", categoryKey: "food", imagePath: "assets/images/guess/food/Milk.png"),
    WordSearchTarget(word: "NOODLE", thai: "ก๋วยเตี๋ยว", phonetic: "นูเดิล", categoryKey: "food", imagePath: "assets/images/guess/food/Noodle.png"),
    WordSearchTarget(word: "PIZZA", thai: "พิซซ่า", phonetic: "พิซซ่า", categoryKey: "food", imagePath: "assets/images/guess/food/Pizza.png"),
    WordSearchTarget(word: "POTATO", thai: "มันฝรั่ง", phonetic: "โพเทโท", categoryKey: "food", imagePath: "assets/images/guess/food/Potato.png"),
    WordSearchTarget(word: "RICE", thai: "ข้าวสวย", phonetic: "ไรซ์", categoryKey: "food", imagePath: "assets/images/guess/food/Rice.png"),
    WordSearchTarget(word: "SALAD", thai: "สลัด", phonetic: "สลัด", categoryKey: "food", imagePath: "assets/images/guess/food/Salad.png"),
    WordSearchTarget(word: "SALT", thai: "เกลือ", phonetic: "ซอลท์", categoryKey: "food", imagePath: "assets/images/guess/food/Salt.png"),
    WordSearchTarget(word: "SANDWICH", thai: "แซนด์วิช", phonetic: "แซนด์วิช", categoryKey: "food", imagePath: "assets/images/guess/food/Sandwich.png"),
    WordSearchTarget(word: "SAUSAGE", thai: "ไส้กรอก", phonetic: "ซอสเซจ", categoryKey: "food", imagePath: "assets/images/guess/food/Sausage.png"),
    WordSearchTarget(word: "SOUP", thai: "ซุป", phonetic: "ซุป", categoryKey: "food", imagePath: "assets/images/guess/food/Soup.png"),
    WordSearchTarget(word: "SUGAR", thai: "น้ำตาล", phonetic: "ชูการ์", categoryKey: "food", imagePath: "assets/images/guess/food/Sugar.png"),
    WordSearchTarget(word: "TOMATO", thai: "มะเขือเทศ", phonetic: "โทมาโท", categoryKey: "food", imagePath: "assets/images/guess/food/Tomato.png"),
    WordSearchTarget(word: "VEGETABLE", thai: "ผักสด", phonetic: "เว็จเจทาเบิล", categoryKey: "food", imagePath: "assets/images/guess/food/Vegetable.png"),
    WordSearchTarget(word: "WATER", thai: "น้ำดื่ม", phonetic: "วอเทอร์", categoryKey: "food", imagePath: "assets/images/guess/food/Water.png"),
  ];

  final List<WordSearchTarget> _roundWordQueue = [];
  final List<WordSearchTarget> _activeBoardTargets = [];
  late List<List<String>> _grid;
  final List<PlacedWordLocation> _placedLocations = [];

  final List<FoundWordItem> _foundWordsList = [];
  final List<int> _draggedIndices = [];
  final GlobalKey _gridKey = GlobalKey();

  int _hintsRemaining = 3;
  int? _hintedIndex;
  int _score = 0;
  int _totalWordsGoal = 30;

  // ==================== ระบบสีตามหมวดหมู่ ====================
  Color _getCategoryThemeColor() {
    switch (widget.category.key) {
      case 'animal':
        return const Color(0xFF26A69A); // เขียวอมฟ้า Teal
      case 'sport':
        return const Color(0xFF29B6F6); // ฟ้าสดใส Sky Blue
      case 'career':
        return const Color(0xFFFFA726); // ส้มสดใส Orange
      case 'home':
        return const Color(0xFFEC407A); // ชมพู Pink
      case 'vehicle':
        return const Color(0xFFAB47BC); // ม่วงลาเวนเดอร์ Purple
      case 'location':
        return const Color(0xFFFF5722); // ส้มอิฐ Deep Orange
      case 'clothing':
        return const Color(0xFF5C6BC0); // น้ำเงินคราม Indigo
      case 'fruit':
        return const Color(0xFFFFCA28); // เหลืองทอง Amber
      case 'food':
        return const Color(0xFF66BB6A); // เขียว Green
      default:
        return const Color(0xFFE65100);
    }
  }

  List<Color> _getCategoryBackgroundGradient() {
    switch (widget.category.key) {
      case 'animal':
        return [
          const Color(0xFF80CBC4),
          const Color(0xFFB2DFDB),
          const Color(0xFFE0F2F1),
          const Color(0xFFF2FBF9),
        ];
      case 'sport':
        return [
          const Color(0xFF81D4FA),
          const Color(0xFFB3E5FC),
          const Color(0xFFE1F5FE),
          const Color(0xFFF3FAFD),
        ];
      case 'career':
        return [
          const Color(0xFFFFCC80),
          const Color(0xFFFFE0B2),
          const Color(0xFFFFF3E0),
          const Color(0xFFFFFBF5),
        ];
      case 'home':
        return [
          const Color(0xFFF48FB1),
          const Color(0xFFF8BBD0),
          const Color(0xFFFCE4EC),
          const Color(0xFFFDF7F9),
        ];
      case 'vehicle':
        return [
          const Color(0xFFCE93D8),
          const Color(0xFFE1BEE7),
          const Color(0xFFF3E5F5),
          const Color(0xFFFAF5FB),
        ];
      case 'location':
        return [
          const Color(0xFFFFAB91),
          const Color(0xFFFFCCBC),
          const Color(0xFFFBE9E7),
          const Color(0xFFFDF5F4),
        ];
      case 'clothing':
        return [
          const Color(0xFF9FA8DA),
          const Color(0xFFC5CAE9),
          const Color(0xFFE8EAF6),
          const Color(0xFFF6F7FB),
        ];
      case 'fruit':
        return [
          const Color(0xFFFFE082),
          const Color(0xFFFFF176),
          const Color(0xFFFFF9C4),
          const Color(0xFFFFFDED),
        ];
      case 'food':
        return [
          const Color(0xFFA5D6A7),
          const Color(0xFFC8E6C9),
          const Color(0xFFE8F5E9),
          const Color(0xFFF5FAF6),
        ];
      default:
        return [
          const Color(0xFFFF8E72),
          const Color(0xFFFFBBA8),
          const Color(0xFFFFD7CC),
          const Color(0xFFFFF0EB),
        ];
    }
  }

  @override
  void initState() {
    super.initState();
    _initTts();
    _startNewRound();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.38);
    await _flutterTts.setPitch(1.30);
  }

  void _startNewRound() {
    _roundWordQueue.clear();

    List<WordSearchTarget> sourceList;
    if (widget.category.key == 'sport') {
      sourceList = _sportWords;
    } else if (widget.category.key == 'career') {
      sourceList = _jobWords;
    } else if (widget.category.key == 'home') {
      sourceList = _houseWords;
    } else if (widget.category.key == 'vehicle') {
      sourceList = _vehicleWords;
    } else if (widget.category.key == 'location') {
      sourceList = _placeWords;
    } else if (widget.category.key == 'clothing') {
      sourceList = _clothesWords;
    } else if (widget.category.key == 'fruit') {
      sourceList = _fruitWords;
    } else if (widget.category.key == 'food') {
      sourceList = _foodWords;
    } else {
      sourceList = _animalWords;
    }

    final matched = sourceList.where((w) => w.word.length <= gridSize).toList()..shuffle();
    _totalWordsGoal = matched.length;
    _roundWordQueue.addAll(matched);

    _foundWordsList.clear();
    _draggedIndices.clear();
    _hintedIndex = null;
    _hintsRemaining = 3;
    _score = 0;

    _prepareBoardForCurrentQueue();
  }

  void _prepareBoardForCurrentQueue() {
    final unfoundWords = _roundWordQueue
        .where((t) => !_foundWordsList.any((f) => f.word == t.word))
        .toList();

    _activeBoardTargets.clear();

    List<WordSearchTarget> candidateList = [];
    int longWordCount = 0;

    for (var target in unfoundWords) {
      if (candidateList.length >= visibleTargetSlots) break;
      if (target.word.length >= 9) {
        if (longWordCount == 0) {
          candidateList.add(target);
          longWordCount++;
        }
      } else {
        candidateList.add(target);
      }
    }

    if (candidateList.length < visibleTargetSlots) {
      for (var target in unfoundWords) {
        if (!candidateList.contains(target)) {
          candidateList.add(target);
        }
        if (candidateList.length >= visibleTargetSlots) break;
      }
    }

    _activeBoardTargets.addAll(candidateList);
    _generateGrid();
    if (mounted) setState(() {});
  }

  void _generateGrid() {
    final random = math.Random();
    bool allPlaced = false;
    int boardAttempts = 0;

    while (!allPlaced && boardAttempts < 40) {
      boardAttempts++;
      _grid = List.generate(gridSize, (_) => List.generate(gridSize, (_) => ''));
      _placedLocations.clear();
      allPlaced = true;

      for (var target in _activeBoardTargets) {
        bool placed = false;
        int wordAttempts = 0;
        final word = target.word;

        while (!placed && wordAttempts < 80) {
          wordAttempts++;
          final dir = WordDirection.values[random.nextInt(WordDirection.values.length)];
          int row = random.nextInt(gridSize);
          int col = random.nextInt(gridSize);

          int dRow = 0;
          int dCol = 0;

          switch (dir) {
            case WordDirection.horizontalForward:
              dRow = 0;
              dCol = 1;
              break;
            case WordDirection.horizontalBackward:
              dRow = 0;
              dCol = -1;
              break;
            case WordDirection.verticalDown:
              dRow = 1;
              dCol = 0;
              break;
            case WordDirection.verticalUp:
              dRow = -1;
              dCol = 0;
              break;
            case WordDirection.diagonalDownRight:
              dRow = 1;
              dCol = 1;
              break;
            case WordDirection.diagonalDownLeft:
              dRow = 1;
              dCol = -1;
              break;
          }

          int endRow = row + dRow * (word.length - 1);
          int endCol = col + dCol * (word.length - 1);

          if (endRow >= 0 && endRow < gridSize && endCol >= 0 && endCol < gridSize) {
            bool canPlace = true;
            for (int i = 0; i < word.length; i++) {
              int r = row + dRow * i;
              int c = col + dCol * i;
              if (_grid[r][c] != '' && _grid[r][c] != word[i]) {
                canPlace = false;
                break;
              }
            }

            if (canPlace) {
              List<int> wordIndices = [];
              for (int i = 0; i < word.length; i++) {
                int r = row + dRow * i;
                int c = col + dCol * i;
                _grid[r][c] = word[i];
                wordIndices.add(r * gridSize + c);
              }
              _placedLocations.add(PlacedWordLocation(word: word, indices: wordIndices));
              placed = true;
            }
          }
        }

        if (!placed) {
          allPlaced = false;
          break;
        }
      }
    }

    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (_grid[r][c] == '') {
          _grid[r][c] = letters[random.nextInt(letters.length)];
        }
      }
    }
  }

  void _useHint() {
    if (_hintsRemaining <= 0) return;

    final unfoundOnBoard = _activeBoardTargets.where(
      (t) => !_foundWordsList.any((f) => f.word == t.word),
    ).toList();

    if (unfoundOnBoard.isEmpty) return;

    final targetToHint = unfoundOnBoard.first;
    final location = _placedLocations.firstWhere((p) => p.word == targetToHint.word);
    final firstCharIndex = location.indices.first;

    setState(() {
      _hintsRemaining--;
      _hintedIndex = firstCharIndex;
    });

    _speakWord(targetToHint.word);
  }

  void _speakUnfoundWords() {
    final unfoundOnBoard = _activeBoardTargets.where(
      (t) => !_foundWordsList.any((f) => f.word == t.word),
    ).toList();

    if (unfoundOnBoard.isNotEmpty) {
      final wordToSpeak = unfoundOnBoard.first.word;
      _speakWord(wordToSpeak);
    }
  }

  int? _getIndexFromOffset(Offset globalPosition) {
    final RenderBox? renderBox = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    final localPosition = renderBox.globalToLocal(globalPosition);
    final size = renderBox.size;

    if (localPosition.dx < 0 || localPosition.dx >= size.width ||
        localPosition.dy < 0 || localPosition.dy >= size.height) {
      return null;
    }

    final cellWidth = size.width / gridSize;
    final cellHeight = size.height / gridSize;

    final col = (localPosition.dx / cellWidth).floor();
    final row = (localPosition.dy / cellHeight).floor();

    if (row >= 0 && row < gridSize && col >= 0 && col < gridSize) {
      return row * gridSize + col;
    }
    return null;
  }

  void _onPanStart(DragStartDetails details) {
    final index = _getIndexFromOffset(details.globalPosition);
    if (index != null) {
      setState(() {
        _draggedIndices.clear();
        _draggedIndices.add(index);
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final index = _getIndexFromOffset(details.globalPosition);
    if (index != null && _draggedIndices.isNotEmpty) {
      final startIdx = _draggedIndices.first;
      final startRow = startIdx ~/ gridSize;
      final startCol = startIdx % gridSize;

      final curRow = index ~/ gridSize;
      final curCol = index % gridSize;

      final dRow = curRow - startRow;
      final dCol = curCol - startCol;

      bool isStraight = (dRow == 0 && dCol != 0) ||
          (dCol == 0 && dRow != 0) ||
          (dRow.abs() == dCol.abs() && dRow != 0);

      if (isStraight) {
        int steps = math.max(dRow.abs(), dCol.abs());
        int stepRow = dRow == 0 ? 0 : (dRow ~/ steps);
        int stepCol = dCol == 0 ? 0 : (dCol ~/ steps);

        List<int> newPath = [];
        for (int i = 0; i <= steps; i++) {
          int r = startRow + stepRow * i;
          int c = startCol + stepCol * i;
          newPath.add(r * gridSize + c);
        }

        setState(() {
          _draggedIndices.clear();
          _draggedIndices.addAll(newPath);
        });
      }
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_draggedIndices.isEmpty) return;

    String currentWord = _draggedIndices.map((idx) {
      int r = idx ~/ gridSize;
      int c = idx % gridSize;
      return _grid[r][c];
    }).join('');

    String reverseWord = currentWord.split('').reversed.join('');
    bool isMatch = false;

    for (var target in _activeBoardTargets) {
      bool alreadyFound = _foundWordsList.any((e) => e.word == target.word);
      if (!alreadyFound) {
        if (currentWord == target.word || reverseWord == target.word) {
          isMatch = true;
          final color = _pastelColors[_foundWordsList.length % _pastelColors.length];

          setState(() {
            _foundWordsList.add(FoundWordItem(
              word: target.word,
              cellIndices: List<int>.from(_draggedIndices),
              highlightColor: color,
            ));
            _score += 10;
            _draggedIndices.clear();
            _hintedIndex = null;
          });

          _speakWord(target.word);

          if (_foundWordsList.length >= _totalWordsGoal) {
            Future.delayed(const Duration(milliseconds: 600), _showVictoryDialog);
          } else {
            final remainingInCurrentBatch = _activeBoardTargets
                .where((t) => !_foundWordsList.any((f) => f.word == t.word))
                .toList();

            if (remainingInCurrentBatch.isEmpty) {
              Future.delayed(const Duration(milliseconds: 300), () {
                _prepareBoardForCurrentQueue();
              });
            }
          }
          break;
        }
      }
    }

    if (!isMatch) {
      setState(() {
        _draggedIndices.clear();
      });
    }
  }

  Future<void> _speakWord(String word) async {
    await _flutterTts.stop();
    await _flutterTts.speak(word);
  }

  // ================= POPUP จบเกม: หน้าจอเฉลิมฉลองเต็มรูปแบบตามรูปภาพตัวอย่าง =================
  void _showVictoryDialog() {
    final catColor = widget.category.cardColor;
    final catShadow = widget.category.shadowColor;
    final int earnedCoins = _score;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                catColor,
                catShadow,
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
                    borderRadius: const BorderRadius.vertical(top: Radius.elliptical(260, 90)),
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
                      Text(
                        'เก่งมาก ยอดเยี่ยม',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: catShadow,
                              offset: const Offset(0, 4),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ป้าย "คุณเล่นเกมหมวด ... เสร็จแล้ว!"
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
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
                                    '+$earnedCoins',
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
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    final maxAllowedHeight = screenHeight - 330;
    final boardSize = math.min(screenWidth - 32, maxAllowedHeight);

    final Color topBarColor = _getCategoryThemeColor();
    final List<Color> bgGradients = _getCategoryBackgroundGradient();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: bgGradients,
            stops: const [0.0, 0.35, 0.70, 1.0],
          ),
        ),
        child: SafeArea(
          top: false,
          bottom: true,
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
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => Navigator.maybePop(context),
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
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                ),
              ),

              // 2. แถบสเตตัส (WORDS FOUND X / Goal พร้อมคะแนนปัจจุบัน)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: topBarColor.withOpacity(0.25),
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: topBarColor.withOpacity(0.10),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: topBarColor,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: topBarColor.withOpacity(0.35),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.category.titleEn,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'WORDS FOUND ',
                              style: TextStyle(
                                color: Colors.blueGrey.shade800,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${_foundWordsList.length} / $_totalWordsGoal',
                                style: const TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.stars_rounded,
                              color: Color(0xFFF59E0B),
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$_score',
                              style: const TextStyle(
                                color: Color(0xFFB45309),
                                fontSize: 13.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. การ์ดคำศัพท์ 2 คอลัมน์ด้านบน
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.8),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _activeBoardTargets.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 2.8,
                    ),
                    itemBuilder: (context, index) {
                      final target = _activeBoardTargets[index];
                      final foundIndex = _foundWordsList.indexWhere((e) => e.word == target.word);
                      final isFound = foundIndex != -1;
                      final pillColor = isFound
                          ? _foundWordsList[foundIndex].highlightColor
                          : const Color(0xFFE2E8F0);

                      return GestureDetector(
                        onTap: () => _speakWord(target.word),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isFound ? pillColor.withOpacity(0.35) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isFound ? pillColor : const Color(0xFFCBD5E1),
                              width: 1.6,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 38,
                                height: 38,
                                child: Image.asset(
                                  target.imagePath,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.restaurant_rounded,
                                    size: 24,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      target.word,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w900,
                                        color: isFound ? const Color(0xFF0F172A) : const Color(0xFF334155),
                                        decoration: isFound ? TextDecoration.lineThrough : null,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      target.thai,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: isFound ? Colors.black54 : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                isFound ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                color: isFound ? pillColor : const Color(0xFFCBD5E1),
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // 4. กระดานค้นหาคำ 9x9 (ฐานสีตามหมวดหมู่)
              Center(
                child: SizedBox(
                  width: boardSize,
                  height: boardSize + 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: topBarColor,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: topBarColor.withOpacity(0.4),
                          width: 2.5,
                        ),
                      ),
                      child: Container(
                        key: _gridKey,
                        child: GestureDetector(
                          onPanStart: _onPanStart,
                          onPanUpdate: _onPanUpdate,
                          onPanEnd: _onPanEnd,
                          child: Column(
                            children: List.generate(gridSize, (r) {
                              return Expanded(
                                child: Row(
                                  children: List.generate(gridSize, (c) {
                                    final index = r * gridSize + c;
                                    final letter = _grid[r][c];

                                    bool isDragging = _draggedIndices.contains(index);
                                    bool isHinted = _hintedIndex == index;

                                    FoundWordItem? matchedFoundItem;
                                    for (var item in _foundWordsList.reversed) {
                                      if (item.cellIndices.contains(index)) {
                                        matchedFoundItem = item;
                                        break;
                                      }
                                    }

                                    Color cellBg = const Color(0xFFFFF7ED);
                                    Color cellBorder = const Color(0xFFFED7AA);
                                    Color textCol = const Color(0xFF0F172A);

                                    if (isDragging) {
                                      cellBg = const Color(0xFFFF80AB).withOpacity(0.85);
                                      cellBorder = const Color(0xFFF50057);
                                      textCol = Colors.white;
                                    } else if (matchedFoundItem != null) {
                                      cellBg = matchedFoundItem.highlightColor.withOpacity(0.70);
                                      cellBorder = matchedFoundItem.highlightColor;
                                      textCol = const Color(0xFF0F172A);
                                    } else if (isHinted) {
                                      cellBg = const Color(0xFFEA580C);
                                      cellBorder = const Color(0xFFC2410C);
                                      textCol = Colors.white;
                                    }

                                    return Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.all(1.5),
                                        decoration: BoxDecoration(
                                          color: cellBg,
                                          borderRadius: BorderRadius.circular(7),
                                          border: Border.all(
                                            color: cellBorder,
                                            width: isHinted ? 2.2 : 1.2,
                                          ),
                                        ),
                                        child: Center(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              letter,
                                              style: TextStyle(
                                                fontSize: isHinted ? 19.0 : 17.5,
                                                fontWeight: FontWeight.w900,
                                                color: textCol,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 5. ปุ่มตัวช่วย 2 ปุ่ม
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // ปุ่มใบ้คำ
                    Expanded(
                      child: GestureDetector(
                        onTap: _useHint,
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFB45309),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.only(bottom: 3.5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 22),
                                const SizedBox(width: 8),
                                Text(
                                  'ใบ้คำ ($_hintsRemaining)',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // ปุ่มฟังเสียงคำ
                    Expanded(
                      child: GestureDetector(
                        onTap: _speakUnfoundWords,
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0369A1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.only(bottom: 3.5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF0284C7),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(Icons.volume_up_rounded, color: Colors.white, size: 22),
                                SizedBox(width: 8),
                                Text(
                                  'ฟังเสียงคำ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                    letterSpacing: 0.3,
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
              ),

              const SizedBox(height: 10),
            ],
          ),
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