import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ShadowMatchItem {
  final String id;
  final String name;
  final String thaiName;
  final String imagePath;
  final String shadowPath;

  const ShadowMatchItem({
    required this.id,
    required this.name,
    required this.thaiName,
    required this.imagePath,
    required this.shadowPath,
  });
}

class CategoryData {
  final Color primaryColor;
  final Color darkBorderColor;
  final Color shadowCardBg;
  final List<Color> backgroundGradient;
  final List<ShadowMatchItem> items;

  const CategoryData({
    required this.primaryColor,
    required this.darkBorderColor,
    required this.shadowCardBg,
    required this.backgroundGradient,
    required this.items,
  });
}

class ShadowMatchScreen extends StatefulWidget {
  final String categoryTitle;

  const ShadowMatchScreen({
    super.key,
    required this.categoryTitle,
  });

  @override
  State<ShadowMatchScreen> createState() => _ShadowMatchScreenState();
}

class _ShadowMatchScreenState extends State<ShadowMatchScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  // 1. คลังหมวดสัตว์ (24 ชนิด / ธีมสีม่วง)
  static const List<ShadowMatchItem> _animalItems = [
    ShadowMatchItem(id: 'bear', name: 'Bear', thaiName: 'หมี', imagePath: 'assets/images/guess/animal/Bear.png', shadowPath: 'assets/images/guess/animal/bear_shadow.png'),
    ShadowMatchItem(id: 'bird', name: 'Bird', thaiName: 'นก', imagePath: 'assets/images/guess/animal/Bird.png', shadowPath: 'assets/images/guess/animal/bird_shadow.png'),
    ShadowMatchItem(id: 'butterfly', name: 'Butterfly', thaiName: 'ผีเสื้อ', imagePath: 'assets/images/guess/animal/Butterfly.png', shadowPath: 'assets/images/guess/animal/butterfly_shadow.png'),
    ShadowMatchItem(id: 'cat', name: 'Cat', thaiName: 'แมว', imagePath: 'assets/images/guess/animal/Cat.png', shadowPath: 'assets/images/guess/animal/cat_shadow.png'),
    ShadowMatchItem(id: 'chicken', name: 'Chicken', thaiName: 'ไก่', imagePath: 'assets/images/guess/animal/Chicken.png', shadowPath: 'assets/images/guess/animal/chicken2_shadow.png'),
    ShadowMatchItem(id: 'cow', name: 'Cow', thaiName: 'วัว', imagePath: 'assets/images/guess/animal/Cow.png', shadowPath: 'assets/images/guess/animal/cow_shadow.png'),
    ShadowMatchItem(id: 'crocodile', name: 'Crocodile', thaiName: 'จระเข้', imagePath: 'assets/images/guess/animal/Crocodile.png', shadowPath: 'assets/images/guess/animal/crocodile_shadow.png'),
    ShadowMatchItem(id: 'dog', name: 'Dog', thaiName: 'สุนัข', imagePath: 'assets/images/guess/animal/Dog.png', shadowPath: 'assets/images/guess/animal/dog_shadow.png'),
    ShadowMatchItem(id: 'dolphin', name: 'Dolphin', thaiName: 'โลมา', imagePath: 'assets/images/guess/animal/Dolphin.png', shadowPath: 'assets/images/guess/animal/dolphin_shadow.png'),
    ShadowMatchItem(id: 'duck', name: 'Duck', thaiName: 'เป็ด', imagePath: 'assets/images/guess/animal/Duck.png', shadowPath: 'assets/images/guess/animal/duck_shadow.png'),
    ShadowMatchItem(id: 'elephant', name: 'Elephant', thaiName: 'ช้าง', imagePath: 'assets/images/guess/animal/Elephant.png', shadowPath: 'assets/images/guess/animal/elephant_shadow.png'),
    ShadowMatchItem(id: 'fish', name: 'Fish', thaiName: 'ปลา', imagePath: 'assets/images/guess/animal/Fish.png', shadowPath: 'assets/images/guess/animal/fish_shadow.png'),
    ShadowMatchItem(id: 'frog', name: 'Frog', thaiName: 'กบ', imagePath: 'assets/images/guess/animal/Frog.png', shadowPath: 'assets/images/guess/animal/frog_shadow.png'),
    ShadowMatchItem(id: 'giraffe', name: 'Giraffe', thaiName: 'ยีราฟ', imagePath: 'assets/images/guess/animal/Giraffe.png', shadowPath: 'assets/images/guess/animal/giraffe_shadow.png'),
    ShadowMatchItem(id: 'horse', name: 'Horse', thaiName: 'ม้า', imagePath: 'assets/images/guess/animal/Horse.png', shadowPath: 'assets/images/guess/animal/horse_shadow.png'),
    ShadowMatchItem(id: 'koala', name: 'Koala', thaiName: 'โคอาลา', imagePath: 'assets/images/guess/animal/Koala.png', shadowPath: 'assets/images/guess/animal/koala_shadow.png'),
    ShadowMatchItem(id: 'lion', name: 'Lion', thaiName: 'สิงโต', imagePath: 'assets/images/guess/animal/Lion.png', shadowPath: 'assets/images/guess/animal/lion_shadow.png'),
    ShadowMatchItem(id: 'mosquito', name: 'Mosquito', thaiName: 'ยุง', imagePath: 'assets/images/guess/animal/Mosquito.png', shadowPath: 'assets/images/guess/animal/mosquito_shadow.png'),
    ShadowMatchItem(id: 'owl', name: 'Owl', thaiName: 'นกฮูก', imagePath: 'assets/images/guess/animal/Owl.png', shadowPath: 'assets/images/guess/animal/owl_shadow.png'),
    ShadowMatchItem(id: 'peacock', name: 'Peacock', thaiName: 'นกยูง', imagePath: 'assets/images/guess/animal/Peacock.png', shadowPath: 'assets/images/guess/animal/peacock_shadow.png'),
    ShadowMatchItem(id: 'penguin', name: 'Penguin', thaiName: 'เพนกวิน', imagePath: 'assets/images/guess/animal/Penguin.png', shadowPath: 'assets/images/guess/animal/penguin_shadow.png'),
    ShadowMatchItem(id: 'pig', name: 'Pig', thaiName: 'หมู', imagePath: 'assets/images/guess/animal/Pig.png', shadowPath: 'assets/images/guess/animal/pig_shadow.png'),
    ShadowMatchItem(id: 'rabbit', name: 'Rabbit', thaiName: 'กระต่าย', imagePath: 'assets/images/guess/animal/Rabbit.png', shadowPath: 'assets/images/guess/animal/rabbit_shadow.png'),
    ShadowMatchItem(id: 'sheep', name: 'Sheep', thaiName: 'แกะ', imagePath: 'assets/images/guess/animal/Sheep.webp', shadowPath: 'assets/images/guess/animal/sheep_shadow.png'),
    ShadowMatchItem(id: 'shrimp', name: 'Shrimp', thaiName: 'กุ้ง', imagePath: 'assets/images/guess/animal/Shrimp.png', shadowPath: 'assets/images/guess/animal/shrimp_shadow.png'),
    ShadowMatchItem(id: 'snake', name: 'Snake', thaiName: 'งู', imagePath: 'assets/images/guess/animal/Snake.png', shadowPath: 'assets/images/guess/animal/snake_shadow.png'),
    ShadowMatchItem(id: 'spider', name: 'Spider', thaiName: 'แมงมุม', imagePath: 'assets/images/guess/animal/Spider.png', shadowPath: 'assets/images/guess/animal/spider_shadow.png'),
    ShadowMatchItem(id: 'tiger', name: 'Tiger', thaiName: 'เสือ', imagePath: 'assets/images/guess/animal/Tiger.png', shadowPath: 'assets/images/guess/animal/tiger_shadow.png'),
    ShadowMatchItem(id: 'turtle', name: 'Turtle', thaiName: 'เต่า', imagePath: 'assets/images/guess/animal/Turtle.webp', shadowPath: 'assets/images/guess/animal/turtle_shadow.png'),
    ShadowMatchItem(id: 'zebra', name: 'Zebra', thaiName: 'ม้าลาย', imagePath: 'assets/images/guess/animal/Zebra.png', shadowPath: 'assets/images/guess/animal/zebra_shadow.png'),
  ];

  // 2. คลังหมวดร่างกาย (26 ชนิด / ธีมสีส้มทอง)
  static const List<ShadowMatchItem> _bodyItems = [
    ShadowMatchItem(id: 'arm', name: 'Arm', thaiName: 'แขน', imagePath: 'assets/images/guess/Body/Arm.png', shadowPath: 'assets/images/guess/Body/Arm_shadow.png'),
    ShadowMatchItem(id: 'belly', name: 'Belly', thaiName: 'ท้อง', imagePath: 'assets/images/guess/Body/Belly.png', shadowPath: 'assets/images/guess/Body/Belly_shadow.png'),
    ShadowMatchItem(id: 'bone', name: 'Bone', thaiName: 'กระดูก', imagePath: 'assets/images/guess/Body/Bone.png', shadowPath: 'assets/images/guess/Body/Bone_shadow.png'),
    ShadowMatchItem(id: 'brain', name: 'Brain', thaiName: 'สมอง', imagePath: 'assets/images/guess/Body/Brain.png', shadowPath: 'assets/images/guess/Body/Brain_shadow.png'),
    ShadowMatchItem(id: 'cheek', name: 'Cheek', thaiName: 'แก้ม', imagePath: 'assets/images/guess/Body/Cheek.png', shadowPath: 'assets/images/guess/Body/Cheek_shadow.png'),
    ShadowMatchItem(id: 'chest', name: 'Chest', thaiName: 'หน้าอก', imagePath: 'assets/images/guess/Body/Chest.png', shadowPath: 'assets/images/guess/Body/Chest_shadow.png'),
    ShadowMatchItem(id: 'chin', name: 'Chin', thaiName: 'คาง', imagePath: 'assets/images/guess/Body/Chin.png', shadowPath: 'assets/images/guess/Body/Chin_shadow.png'),
    ShadowMatchItem(id: 'ear', name: 'Ear', thaiName: 'หู', imagePath: 'assets/images/guess/Body/Ear.png', shadowPath: 'assets/images/guess/Body/Ear_shadow.png'),
    ShadowMatchItem(id: 'eye', name: 'Eye', thaiName: 'ตา', imagePath: 'assets/images/guess/Body/Eye.png', shadowPath: 'assets/images/guess/Body/Eye_shadow.png'),
    ShadowMatchItem(id: 'eyebrow', name: 'Eyebrow', thaiName: 'คิ้ว', imagePath: 'assets/images/guess/Body/Eyebrow.png', shadowPath: 'assets/images/guess/Body/Eyebrow_shadow.png'),
    ShadowMatchItem(id: 'eyelash', name: 'Eyelash', thaiName: 'ขนตา', imagePath: 'assets/images/guess/Body/Eyelash.png', shadowPath: 'assets/images/guess/Body/Eyelash_shadow.png'),
    ShadowMatchItem(id: 'face', name: 'Face', thaiName: 'ใบหน้า', imagePath: 'assets/images/guess/Body/Face.png', shadowPath: 'assets/images/guess/Body/Face_shadow.png'),
    ShadowMatchItem(id: 'finger', name: 'Finger', thaiName: 'นิ้วมือ', imagePath: 'assets/images/guess/Body/Finger.png', shadowPath: 'assets/images/guess/Body/Finger_shadow.png'),
    ShadowMatchItem(id: 'foot', name: 'Foot', thaiName: 'เท้า', imagePath: 'assets/images/guess/Body/Foot.png', shadowPath: 'assets/images/guess/Body/Foot_shadow.png'),
    ShadowMatchItem(id: 'forehead', name: 'Forehead', thaiName: 'หน้าผาก', imagePath: 'assets/images/guess/Body/Forehead.png', shadowPath: 'assets/images/guess/Body/Forehead_shadow.png'),
    ShadowMatchItem(id: 'hair', name: 'Hair', thaiName: 'ผม', imagePath: 'assets/images/guess/Body/Hair.png', shadowPath: 'assets/images/guess/Body/Hair_shadow.png'),
    ShadowMatchItem(id: 'hand', name: 'Hand', thaiName: 'มือ', imagePath: 'assets/images/guess/Body/Hand.png', shadowPath: 'assets/images/guess/Body/Hand_shadow.png'),
    ShadowMatchItem(id: 'head', name: 'Head', thaiName: 'ศีรษะ', imagePath: 'assets/images/guess/Body/Head.png', shadowPath: 'assets/images/guess/Body/Head_shadow.png'),
    ShadowMatchItem(id: 'heart', name: 'Heart', thaiName: 'หัวใจ', imagePath: 'assets/images/guess/Body/Heart.png', shadowPath: 'assets/images/guess/Body/Heart_shadow.png'),
    ShadowMatchItem(id: 'leg', name: 'Leg', thaiName: 'ขา', imagePath: 'assets/images/guess/Body/Leg.png', shadowPath: 'assets/images/guess/Body/Leg_shadow.png'),
    ShadowMatchItem(id: 'lip', name: 'Lip', thaiName: 'ริมฝีปาก', imagePath: 'assets/images/guess/Body/Lip.png', shadowPath: 'assets/images/guess/Body/Lip_shadow.png'),
    ShadowMatchItem(id: 'lungs', name: 'Lungs', thaiName: 'ปอด', imagePath: 'assets/images/guess/Body/Lungs.png', shadowPath: 'assets/images/guess/Body/Lungs_shadow.png'),
    ShadowMatchItem(id: 'mouth', name: 'Mouth', thaiName: 'ปาก', imagePath: 'assets/images/guess/Body/Mouth.png', shadowPath: 'assets/images/guess/Body/Mouth_shadow.png'),
    ShadowMatchItem(id: 'nail', name: 'Nail', thaiName: 'เล็บ', imagePath: 'assets/images/guess/Body/Nail.png', shadowPath: 'assets/images/guess/Body/Nail_shadow.png'),
    ShadowMatchItem(id: 'neck', name: 'Neck', thaiName: 'คอ', imagePath: 'assets/images/guess/Body/Neck.png', shadowPath: 'assets/images/guess/Body/Neck_shadow.png'),
    ShadowMatchItem(id: 'nose', name: 'Nose', thaiName: 'จมูก', imagePath: 'assets/images/guess/Body/Nose.png', shadowPath: 'assets/images/guess/Body/Nose_shadow.png'),
    ShadowMatchItem(id: 'shoulder', name: 'Shoulder', thaiName: 'ไหล่', imagePath: 'assets/images/guess/Body/Shoulder.png', shadowPath: 'assets/images/guess/Body/Shoulder_shadow.png'),
    ShadowMatchItem(id: 'thigh', name: 'Thigh', thaiName: 'ต้นขา', imagePath: 'assets/images/guess/Body/Thigh.png', shadowPath: 'assets/images/guess/Body/Thigh_shadow.png'),
    ShadowMatchItem(id: 'tongue', name: 'Tongue', thaiName: 'ลิ้น', imagePath: 'assets/images/guess/Body/Tongue.png', shadowPath: 'assets/images/guess/Body/Tongue_shadow.png'),
    ShadowMatchItem(id: 'tooth', name: 'Tooth', thaiName: 'ฟัน', imagePath: 'assets/images/guess/Body/Tooth.png', shadowPath: 'assets/images/guess/Body/Tooth_shadow.png'),
  ];

  // 3. คลังหมวดเสื้อผ้า (26 ชนิด / ธีมสีชมพู)
  static const List<ShadowMatchItem> _clothesItems = [
    ShadowMatchItem(id: 'backpack', name: 'Backpack', thaiName: 'กระเป๋าเป้', imagePath: 'assets/images/guess/Clothes/Backpack.png', shadowPath: 'assets/images/guess/Clothes/Backpack_shadow.png'),
    ShadowMatchItem(id: 'bag', name: 'Bag', thaiName: 'กระเป๋าถือ', imagePath: 'assets/images/guess/Clothes/Bag.png', shadowPath: 'assets/images/guess/Clothes/Bag_shadow.png'),
    ShadowMatchItem(id: 'belt', name: 'Belt', thaiName: 'เข็มขัด', imagePath: 'assets/images/guess/Clothes/Belt.png', shadowPath: 'assets/images/guess/Clothes/Belt_shadow.png'),
    ShadowMatchItem(id: 'boots', name: 'Boots', thaiName: 'รองเท้าบูต', imagePath: 'assets/images/guess/Clothes/Boots.png', shadowPath: 'assets/images/guess/Clothes/Boots_shadow.png'),
    ShadowMatchItem(id: 'cap', name: 'Cap', thaiName: 'หมวกแก๊ป', imagePath: 'assets/images/guess/Clothes/Cap.png', shadowPath: 'assets/images/guess/Clothes/Cap_shadow.png'),
    ShadowMatchItem(id: 'dress', name: 'Dress', thaiName: 'ชุดกระโปรง', imagePath: 'assets/images/guess/Clothes/Dress.png', shadowPath: 'assets/images/guess/Clothes/Dress_shadow.png'),
    ShadowMatchItem(id: 'earrings', name: 'Earrings', thaiName: 'ต่างหู', imagePath: 'assets/images/guess/Clothes/Earrings.png', shadowPath: 'assets/images/guess/Clothes/Earrings_shadow.png'),
    ShadowMatchItem(id: 'glasses', name: 'Glasses', thaiName: 'แว่นตา', imagePath: 'assets/images/guess/Clothes/Glasses.png', shadowPath: 'assets/images/guess/Clothes/Glasses_shadow.png'),
    ShadowMatchItem(id: 'hat', name: 'Hat', thaiName: 'หมวกปีก', imagePath: 'assets/images/guess/Clothes/Hat.png', shadowPath: 'assets/images/guess/Clothes/Hat_shadow.png'),
    ShadowMatchItem(id: 'hoodie', name: 'Hoodie', thaiName: 'เสื้อมีฮู้ด', imagePath: 'assets/images/guess/Clothes/Hoodie.png', shadowPath: 'assets/images/guess/Clothes/Hoodie_shadow.png'),
    ShadowMatchItem(id: 'jacket', name: 'Jacket', thaiName: 'เสื้อแจ็กเกต', imagePath: 'assets/images/guess/Clothes/Jacket.png', shadowPath: 'assets/images/guess/Clothes/Jacket_shadow.png'),
    ShadowMatchItem(id: 'jeans', name: 'Jeans', thaiName: 'กางเกงยีนส์', imagePath: 'assets/images/guess/Clothes/Jeans.png', shadowPath: 'assets/images/guess/Clothes/Jeans_shadow.png'),
    ShadowMatchItem(id: 'necklace', name: 'Necklace', thaiName: 'สร้อยคอ', imagePath: 'assets/images/guess/Clothes/Necklace.png', shadowPath: 'assets/images/guess/Clothes/Necklace_shadow.png'),
    ShadowMatchItem(id: 'pajamas', name: 'Pajamas', thaiName: 'ชุดนอน', imagePath: 'assets/images/guess/Clothes/Pajamas.png', shadowPath: 'assets/images/guess/Clothes/Pajamas_shadow.png'),
    ShadowMatchItem(id: 'pants', name: 'Pants', thaiName: 'กางเกงขายาว', imagePath: 'assets/images/guess/Clothes/Pants.png', shadowPath: 'assets/images/guess/Clothes/Pants_shadow.png'),
    ShadowMatchItem(id: 'raincoat', name: 'Raincoat', thaiName: 'เสื้อกันฝน', imagePath: 'assets/images/guess/Clothes/Raincoat.png', shadowPath: 'assets/images/guess/Clothes/Raincoat_shadow.png'),
    ShadowMatchItem(id: 'ring', name: 'Ring', thaiName: 'แหวน', imagePath: 'assets/images/guess/Clothes/Ring.png', shadowPath: 'assets/images/guess/Clothes/Ring_shadow.png'),
    ShadowMatchItem(id: 'scarf', name: 'Scarf', thaiName: 'ผ้าพันคอ', imagePath: 'assets/images/guess/Clothes/Scarf.png', shadowPath: 'assets/images/guess/Clothes/Scarf_shadow.png'),
    ShadowMatchItem(id: 'shirt', name: 'Shirt', thaiName: 'เสื้อเชิ้ต', imagePath: 'assets/images/guess/Clothes/Shirt.png', shadowPath: 'assets/images/guess/Clothes/Shirt_shadow.png'),
    ShadowMatchItem(id: 'shoes', name: 'Shoes', thaiName: 'รองเท้า', imagePath: 'assets/images/guess/Clothes/Shoes.png', shadowPath: 'assets/images/guess/Clothes/Shoes_shadow.png'),
    ShadowMatchItem(id: 'shorts', name: 'Shorts', thaiName: 'กางเกงขาสั้น', imagePath: 'assets/images/guess/Clothes/Shorts.png', shadowPath: 'assets/images/guess/Clothes/shorts_shadow.png'),
    ShadowMatchItem(id: 'skirt', name: 'Skirt', thaiName: 'กระโปรง', imagePath: 'assets/images/guess/Clothes/Skirt.png', shadowPath: 'assets/images/guess/Clothes/Skirt_shadow.png'),
    ShadowMatchItem(id: 'socks', name: 'Socks', thaiName: 'ถุงเท้า', imagePath: 'assets/images/guess/Clothes/Socks.png', shadowPath: 'assets/images/guess/Clothes/Socks_shadow.png'),
    ShadowMatchItem(id: 'sunglasses', name: 'Sunglasses', thaiName: 'แว่นตากันแดด', imagePath: 'assets/images/guess/Clothes/Sunglasses.png', shadowPath: 'assets/images/guess/Clothes/Sunglasses_shadow.png'),
    ShadowMatchItem(id: 'sweater', name: 'Sweater', thaiName: 'เสื้อกันหนาว', imagePath: 'assets/images/guess/Clothes/Sweater.png', shadowPath: 'assets/images/guess/Clothes/Sweater_shadow.png'),
    ShadowMatchItem(id: 'swimsuit', name: 'Swimsuit', thaiName: 'ชุดว่ายน้ำ', imagePath: 'assets/images/guess/Clothes/Swimsuit.png', shadowPath: 'assets/images/guess/Clothes/Swimsuit_shadow.png'),
    ShadowMatchItem(id: 'tie', name: 'Tie', thaiName: 'เนคไท', imagePath: 'assets/images/guess/Clothes/Tie.png', shadowPath: 'assets/images/guess/Clothes/Tie_shadow.png'),
    ShadowMatchItem(id: 't-shirt', name: 'T-shirt', thaiName: 'เสื้อยืด', imagePath: 'assets/images/guess/Clothes/T-shirt.png', shadowPath: 'assets/images/guess/Clothes/T-shirt_shadow.png'),
    ShadowMatchItem(id: 'uniform', name: 'Uniform', thaiName: 'ชุดยูนิฟอร์ม', imagePath: 'assets/images/guess/Clothes/Uniform.png', shadowPath: 'assets/images/guess/Clothes/Uniform_shadow.png'),
    ShadowMatchItem(id: 'watch', name: 'Watch', thaiName: 'นาฬิกาข้อมือ', imagePath: 'assets/images/guess/Clothes/Watch.png', shadowPath: 'assets/images/guess/Clothes/Watch_shadow.png'),
  ];

  // 4. คลังหมวดกิจวัตรประจำวัน (27 ชนิด / ธีมสีม่วงคราม)
  static const List<ShadowMatchItem> _dailyRoutineItems = [
    ShadowMatchItem(id: 'brushmyteeth', name: 'Brush my teeth', thaiName: 'แปรงฟัน', imagePath: 'assets/images/guess/dailyroutine/Brushmyteeth.png', shadowPath: 'assets/images/guess/dailyroutine/Brushmyteeth_shadow.png'),
    ShadowMatchItem(id: 'cleanmyroom', name: 'Clean my room', thaiName: 'ทำความสะอาดห้อง', imagePath: 'assets/images/guess/dailyroutine/Cleanmyroom.png', shadowPath: 'assets/images/guess/dailyroutine/Cleanmyroom_shadow.png'),
    ShadowMatchItem(id: 'combmyhair', name: 'Comb my hair', thaiName: 'หวีผม', imagePath: 'assets/images/guess/dailyroutine/Combmyhair.png', shadowPath: 'assets/images/guess/dailyroutine/Combmyhair_shadow.png'),
    ShadowMatchItem(id: 'dohomework', name: 'Do homework', thaiName: 'ทำการบ้าน', imagePath: 'assets/images/guess/dailyroutine/Dohomework.png', shadowPath: 'assets/images/guess/dailyroutine/Dohomework_shadow.png'),
    ShadowMatchItem(id: 'dream', name: 'Dream', thaiName: 'ฝัน', imagePath: 'assets/images/guess/dailyroutine/Dream.png', shadowPath: 'assets/images/guess/dailyroutine/Dream_shadow.png'),
    ShadowMatchItem(id: 'drinkwater', name: 'Drink water', thaiName: 'ดื่มน้ำ', imagePath: 'assets/images/guess/dailyroutine/Drinkwater.png', shadowPath: 'assets/images/guess/dailyroutine/Drinkwater_shadow.png'),
    ShadowMatchItem(id: 'exercise', name: 'Exercise', thaiName: 'ออกกำลังกาย', imagePath: 'assets/images/guess/dailyroutine/Exercise.png', shadowPath: 'assets/images/guess/dailyroutine/Exercise_shadow.png'),
    ShadowMatchItem(id: 'getdressed', name: 'Get dressed', thaiName: 'แต่งตัว', imagePath: 'assets/images/guess/dailyroutine/Getdressed.png', shadowPath: 'assets/images/guess/dailyroutine/Getdressed_shadow.png'),
    ShadowMatchItem(id: 'getup', name: 'Get up', thaiName: 'ลุกจากที่นอน', imagePath: 'assets/images/guess/dailyroutine/Getup.png', shadowPath: 'assets/images/guess/dailyroutine/Getup_shadow.png'),
    ShadowMatchItem(id: 'gohome', name: 'Go home', thaiName: 'กลับบ้าน', imagePath: 'assets/images/guess/dailyroutine/Gohome.png', shadowPath: 'assets/images/guess/dailyroutine/Gohome_shadow.png'),
    ShadowMatchItem(id: 'goshopping', name: 'Go shopping', thaiName: 'ไปซื้อของ', imagePath: 'assets/images/guess/dailyroutine/Goshopping.png', shadowPath: 'assets/images/guess/dailyroutine/Goshopping_shadow.png'),
    ShadowMatchItem(id: 'gotoschool', name: 'Go to school', thaiName: 'ไปโรงเรียน', imagePath: 'assets/images/guess/dailyroutine/Gotoschool.png', shadowPath: 'assets/images/guess/dailyroutine/Gotoschool_shadow.png'),
    ShadowMatchItem(id: 'havebreakfast', name: 'Have breakfast', thaiName: 'ทานอาหารเช้า', imagePath: 'assets/images/guess/dailyroutine/Havebreakfast.png', shadowPath: 'assets/images/guess/dailyroutine/Havebreakfast_shadow.png'),
    ShadowMatchItem(id: 'listen', name: 'Listen', thaiName: 'ฟังเพลง/ฟังเสียง', imagePath: 'assets/images/guess/dailyroutine/Listen.png', shadowPath: 'assets/images/guess/dailyroutine/Listen_shadow.png'),
    ShadowMatchItem(id: 'makemybed', name: 'Make my bed', thaiName: 'เก็บที่นอน', imagePath: 'assets/images/guess/dailyroutine/Makemybed.png', shadowPath: 'assets/images/guess/dailyroutine/Makemybed_shadow.png'),
    ShadowMatchItem(id: 'meetmyfriends', name: 'Meet my friends', thaiName: 'พบเพื่อนๆ', imagePath: 'assets/images/guess/dailyroutine/Meetmyfriends.png', shadowPath: 'assets/images/guess/dailyroutine/Meetmyfriends_shadow.png'),
    ShadowMatchItem(id: 'packmybag', name: 'Pack my bag', thaiName: 'จัดกระเป๋า', imagePath: 'assets/images/guess/dailyroutine/Packmybag.png', shadowPath: 'assets/images/guess/dailyroutine/Packmybag_shadow.png'),
    ShadowMatchItem(id: 'playgames', name: 'Play games', thaiName: 'เล่นเกม', imagePath: 'assets/images/guess/dailyroutine/Playgames.png', shadowPath: 'assets/images/guess/dailyroutine/Playgames_shadow.png'),
    ShadowMatchItem(id: 'read', name: 'Read', thaiName: 'อ่าน', imagePath: 'assets/images/guess/dailyroutine/Read.png', shadowPath: 'assets/images/guess/dailyroutine/read_shadow.png'),
    ShadowMatchItem(id: 'rideabike', name: 'Ride a bike', thaiName: 'ปั่นจักรยาน', imagePath: 'assets/images/guess/dailyroutine/Rideabike.png', shadowPath: 'assets/images/guess/dailyroutine/rideabike_shadow.png'),
    ShadowMatchItem(id: 'sleep', name: 'Sleep', thaiName: 'นอนหลับ', imagePath: 'assets/images/guess/dailyroutine/Sleep.png', shadowPath: 'assets/images/guess/dailyroutine/Sleep_shadow.png'),
    ShadowMatchItem(id: 'study', name: 'Study', thaiName: 'เรียนหนังสือ', imagePath: 'assets/images/guess/dailyroutine/Study.png', shadowPath: 'assets/images/guess/dailyroutine/Study_shadow.png'),
    ShadowMatchItem(id: 'takeabath', name: 'Take a bath', thaiName: 'อาบน้ำในอ่าง', imagePath: 'assets/images/guess/dailyroutine/Takeabath.png', shadowPath: 'assets/images/guess/dailyroutine/Takeabath_shadow.png'),
    ShadowMatchItem(id: 'takeashower', name: 'Take a shower', thaiName: 'อาบน้ำฝักบัว', imagePath: 'assets/images/guess/dailyroutine/Takeashower.png', shadowPath: 'assets/images/guess/dailyroutine/Takeashower_shadow.png'),
    ShadowMatchItem(id: 'wakeup', name: 'Wake up', thaiName: 'ตื่นนอน', imagePath: 'assets/images/guess/dailyroutine/Wakeup.png', shadowPath: 'assets/images/guess/dailyroutine/Wakeup_shadow.png'),
    ShadowMatchItem(id: 'washmyface', name: 'Wash my face', thaiName: 'ล้างหน้า', imagePath: 'assets/images/guess/dailyroutine/Washmyface.png', shadowPath: 'assets/images/guess/dailyroutine/Washmyface_shadow.png'),
    ShadowMatchItem(id: 'washthedishes', name: 'Wash the dishes', thaiName: 'ล้างจาน', imagePath: 'assets/images/guess/dailyroutine/Washthedishes.png', shadowPath: 'assets/images/guess/dailyroutine/Washthedishes_shadow.png'),
    ShadowMatchItem(id: 'watchtv', name: 'Watch TV', thaiName: 'ดูทีวี', imagePath: 'assets/images/guess/dailyroutine/WatchTV.png', shadowPath: 'assets/images/guess/dailyroutine/WatchTV_shadow.png'),
    ShadowMatchItem(id: 'write', name: 'Write', thaiName: 'เขียน', imagePath: 'assets/images/guess/dailyroutine/Write.png', shadowPath: 'assets/images/guess/dailyroutine/write_shadow.png'),
  ];

  // 5. คลังหมวดอาหาร (30 ชนิด / ธีมสีเขียว)
  static const List<ShadowMatchItem> _foodItems = [
    ShadowMatchItem(id: 'bread', name: 'Bread', thaiName: 'ขนมปัง', imagePath: 'assets/images/guess/food/Bread.png', shadowPath: 'assets/images/guess/food/bread_shadow.png'),
    ShadowMatchItem(id: 'burger', name: 'Burger', thaiName: 'เบอร์เกอร์', imagePath: 'assets/images/guess/food/Burger.png', shadowPath: 'assets/images/guess/food/burger_shadow.png'),
    ShadowMatchItem(id: 'cake', name: 'Cake', thaiName: 'เค้ก', imagePath: 'assets/images/guess/food/Cake.png', shadowPath: 'assets/images/guess/food/cake_shadow.png'),
    ShadowMatchItem(id: 'candy', name: 'Candy', thaiName: 'ลูกอม', imagePath: 'assets/images/guess/food/Candy.png', shadowPath: 'assets/images/guess/food/candy_shadow.png'),
    ShadowMatchItem(id: 'cheese', name: 'Cheese', thaiName: 'ชีส', imagePath: 'assets/images/guess/food/Cheese.png', shadowPath: 'assets/images/guess/food/cheese_shadow.png'),
    ShadowMatchItem(id: 'chicken', name: 'Chicken', thaiName: 'ไก่ย่าง/ไก่ทอด', imagePath: 'assets/images/guess/food/Chicken.png', shadowPath: 'assets/images/guess/food/Chicken_shadow.png'),
    ShadowMatchItem(id: 'chocolate', name: 'Chocolate', thaiName: 'ช็อกโกแลต', imagePath: 'assets/images/guess/food/Chocolate.png', shadowPath: 'assets/images/guess/food/chocolate_shadow.png'),
    ShadowMatchItem(id: 'cookie', name: 'Cookie', thaiName: 'คุกกี้', imagePath: 'assets/images/guess/food/Cookie.png', shadowPath: 'assets/images/guess/food/cookie_shadow.png'),
    ShadowMatchItem(id: 'corn', name: 'Corn', thaiName: 'ข้าวโพด', imagePath: 'assets/images/guess/food/Corn.png', shadowPath: 'assets/images/guess/food/corn_shadow.png'),
    ShadowMatchItem(id: 'donut', name: 'Donut', thaiName: 'โดนัท', imagePath: 'assets/images/guess/food/Donut.png', shadowPath: 'assets/images/guess/food/donut_shadow.png'),
    ShadowMatchItem(id: 'egg', name: 'Egg', thaiName: 'ไข่', imagePath: 'assets/images/guess/food/Egg.png', shadowPath: 'assets/images/guess/food/egg_shadow.png'),
    ShadowMatchItem(id: 'fish', name: 'Fish', thaiName: 'ปลา', imagePath: 'assets/images/guess/food/Fish.png', shadowPath: 'assets/images/guess/food/fish3_shadow.png'),
    ShadowMatchItem(id: 'frenchfries', name: 'French fries', thaiName: 'เฟรนช์ฟรายส์', imagePath: 'assets/images/guess/food/Frenchfries.png', shadowPath: 'assets/images/guess/food/frenchfries_shadow.png'),
    ShadowMatchItem(id: 'icecream', name: 'Ice cream', thaiName: 'ไอศกรีม', imagePath: 'assets/images/guess/food/Icecream.png', shadowPath: 'assets/images/guess/food/icecream_shadow.png'),
    ShadowMatchItem(id: 'juice', name: 'Juice', thaiName: 'น้ำผลไม้', imagePath: 'assets/images/guess/food/Juice.png', shadowPath: 'assets/images/guess/food/juice_shadow.png'),
    ShadowMatchItem(id: 'meat', name: 'Meat', thaiName: 'เนื้อสัตว์', imagePath: 'assets/images/guess/food/Meat.png', shadowPath: 'assets/images/guess/food/meat_shadow.png'),
    ShadowMatchItem(id: 'milk', name: 'Milk', thaiName: 'นม', imagePath: 'assets/images/guess/food/Milk.png', shadowPath: 'assets/images/guess/food/milk_shadow.png'),
    ShadowMatchItem(id: 'noodle', name: 'Noodle', thaiName: 'ก๋วยเตี๋ยว/บะหมี่', imagePath: 'assets/images/guess/food/Noodle.png', shadowPath: 'assets/images/guess/food/Noodle_shadow.png'),
    ShadowMatchItem(id: 'pizza', name: 'Pizza', thaiName: 'พิซซ่า', imagePath: 'assets/images/guess/food/Pizza.png', shadowPath: 'assets/images/guess/food/Pizza_shadow.png'),
    ShadowMatchItem(id: 'potato', name: 'Potato', thaiName: 'มันฝรั่ง', imagePath: 'assets/images/guess/food/Potato.png', shadowPath: 'assets/images/guess/food/Potato_shadow.png'),
    ShadowMatchItem(id: 'rice', name: 'Rice', thaiName: 'ข้าว', imagePath: 'assets/images/guess/food/Rice.png', shadowPath: 'assets/images/guess/food/Rice_shadow.png'),
    ShadowMatchItem(id: 'salad', name: 'Salad', thaiName: 'สลัดผัก', imagePath: 'assets/images/guess/food/Salad.png', shadowPath: 'assets/images/guess/food/Salad_shadow.png'),
    ShadowMatchItem(id: 'salt', name: 'Salt', thaiName: 'เกลือ', imagePath: 'assets/images/guess/food/Salt.png', shadowPath: 'assets/images/guess/food/Salt_shadow.png'),
    ShadowMatchItem(id: 'sandwich', name: 'Sandwich', thaiName: 'แซนด์วิช', imagePath: 'assets/images/guess/food/Sandwich.png', shadowPath: 'assets/images/guess/food/Sandwich_shadow.png'),
    ShadowMatchItem(id: 'sausage', name: 'Sausage', thaiName: 'ไส้กรอก', imagePath: 'assets/images/guess/food/Sausage.png', shadowPath: 'assets/images/guess/food/Sausage_shadow.png'),
    ShadowMatchItem(id: 'soup', name: 'Soup', thaiName: 'ซุป', imagePath: 'assets/images/guess/food/Soup.png', shadowPath: 'assets/images/guess/food/Soup_shadow.png'),
    ShadowMatchItem(id: 'sugar', name: 'Sugar', thaiName: 'น้ำตาล', imagePath: 'assets/images/guess/food/Sugar.png', shadowPath: 'assets/images/guess/food/Sugar_shadow.png'),
    ShadowMatchItem(id: 'tomato', name: 'Tomato', thaiName: 'มะเขือเทศ', imagePath: 'assets/images/guess/food/Tomato.png', shadowPath: 'assets/images/guess/food/Tomato_shadow.png'),
    ShadowMatchItem(id: 'vegetable', name: 'Vegetable', thaiName: 'ผัก', imagePath: 'assets/images/guess/food/Vegetable.png', shadowPath: 'assets/images/guess/food/Vegetable_shadow.png'),
    ShadowMatchItem(id: 'water', name: 'Water', thaiName: 'น้ำดื่ม', imagePath: 'assets/images/guess/food/Water.png', shadowPath: 'assets/images/guess/food/Water_shadow.png'),
  ];

  // 6. คลังหมวดผลไม้ (30 ชนิด / ธีมสีแดงส้ม)
  static const List<ShadowMatchItem> _fruitItems = [
    ShadowMatchItem(id: 'apple', name: 'Apple', thaiName: 'แอปเปิ้ล', imagePath: 'assets/images/guess/fruit/Apple.png', shadowPath: 'assets/images/guess/fruit/Apple_shadow.png'),
    ShadowMatchItem(id: 'apricot', name: 'Apricot', thaiName: 'แอปริคอต', imagePath: 'assets/images/guess/fruit/Apricot.png', shadowPath: 'assets/images/guess/fruit/Apricot_shadow.png'),
    ShadowMatchItem(id: 'avocado', name: 'Avocado', thaiName: 'อะโวคาโด', imagePath: 'assets/images/guess/fruit/Avocado.png', shadowPath: 'assets/images/guess/fruit/Avocado_shadow.png'),
    ShadowMatchItem(id: 'banana', name: 'Banana', thaiName: 'กล้วย', imagePath: 'assets/images/guess/fruit/Banana.png', shadowPath: 'assets/images/guess/fruit/Banana_shadow.png'),
    ShadowMatchItem(id: 'blackberry', name: 'Blackberry', thaiName: 'แบล็กเบอร์รี', imagePath: 'assets/images/guess/fruit/Blackberry.png', shadowPath: 'assets/images/guess/fruit/Blackberry_shadow.png'),
    ShadowMatchItem(id: 'blueberry', name: 'Blueberry', thaiName: 'บลูเบอร์รี', imagePath: 'assets/images/guess/fruit/Blueberry.png', shadowPath: 'assets/images/guess/fruit/Blueberry_shadow.png'),
    ShadowMatchItem(id: 'cantaloupe', name: 'Cantaloupe', thaiName: 'แคนตาลูป', imagePath: 'assets/images/guess/fruit/Cantaloupe.png', shadowPath: 'assets/images/guess/fruit/Cantaloupe_shadow.png'),
    ShadowMatchItem(id: 'cherry', name: 'Cherry', thaiName: 'เชอร์รี', imagePath: 'assets/images/guess/fruit/Cherry.png', shadowPath: 'assets/images/guess/fruit/Cherry_shadow.png'),
    ShadowMatchItem(id: 'coconut', name: 'Coconut', thaiName: 'มะพร้าว', imagePath: 'assets/images/guess/fruit/Coconut.png', shadowPath: 'assets/images/guess/fruit/Coconut_shadow.png'),
    ShadowMatchItem(id: 'durian', name: 'Durian', thaiName: 'ทุเรียน', imagePath: 'assets/images/guess/fruit/Durian.png', shadowPath: 'assets/images/guess/fruit/Durian_shadow.png'),
    ShadowMatchItem(id: 'grape', name: 'Grape', thaiName: 'องุ่น', imagePath: 'assets/images/guess/fruit/Grape.png', shadowPath: 'assets/images/guess/fruit/Grape_shadow.png'),
    ShadowMatchItem(id: 'guava', name: 'Guava', thaiName: 'ฝรั่ง', imagePath: 'assets/images/guess/fruit/Guava.png', shadowPath: 'assets/images/guess/fruit/Guava_shadow.png'),
    ShadowMatchItem(id: 'kiwi', name: 'Kiwi', thaiName: 'กีวี', imagePath: 'assets/images/guess/fruit/Kiwi.png', shadowPath: 'assets/images/guess/fruit/Kiwi_shadow.png'),
    ShadowMatchItem(id: 'lemon', name: 'Lemon', thaiName: 'เลมอน', imagePath: 'assets/images/guess/fruit/Lemon.png', shadowPath: 'assets/images/guess/fruit/Lemon_shadow.png'),
    ShadowMatchItem(id: 'lime', name: 'Lime', thaiName: 'มะนาว', imagePath: 'assets/images/guess/fruit/Lime.png', shadowPath: 'assets/images/guess/fruit/Lime_shadow.png'),
    ShadowMatchItem(id: 'longan', name: 'Longan', thaiName: 'ลำไย', imagePath: 'assets/images/guess/fruit/Longan.png', shadowPath: 'assets/images/guess/fruit/Longan_shadow.png'),
    ShadowMatchItem(id: 'lychee', name: 'Lychee', thaiName: 'ลิ้นจี่', imagePath: 'assets/images/guess/fruit/Lychee.png', shadowPath: 'assets/images/guess/fruit/Lychee_shadow.png'),
    ShadowMatchItem(id: 'mango', name: 'Mango', thaiName: 'มะม่วง', imagePath: 'assets/images/guess/fruit/Mango.png', shadowPath: 'assets/images/guess/fruit/Mango_shadow.png'),
    ShadowMatchItem(id: 'mangosteen', name: 'Mangosteen', thaiName: 'มังคุด', imagePath: 'assets/images/guess/fruit/Mangosteen.png', shadowPath: 'assets/images/guess/fruit/Mangosteen_shadow.png'),
    ShadowMatchItem(id: 'orange', name: 'Orange', thaiName: 'ส้ม', imagePath: 'assets/images/guess/fruit/Orange.png', shadowPath: 'assets/images/guess/fruit/Orange_shadow.png'),
    ShadowMatchItem(id: 'papaya', name: 'Papaya', thaiName: 'มะละกอ', imagePath: 'assets/images/guess/fruit/Papaya.png', shadowPath: 'assets/images/guess/fruit/Papaya_shadow.png'),
    ShadowMatchItem(id: 'passionfruit', name: 'Passion fruit', thaiName: 'เสาวรส', imagePath: 'assets/images/guess/fruit/Passionfruit.png', shadowPath: 'assets/images/guess/fruit/Passionfruit_shadow.png'),
    ShadowMatchItem(id: 'pineapple', name: 'Pineapple', thaiName: 'สับปะรด', imagePath: 'assets/images/guess/fruit/Pineapple.png', shadowPath: 'assets/images/guess/fruit/Pineapple_shadow.png'),
    ShadowMatchItem(id: 'pomegranate', name: 'Pomegranate', thaiName: 'ทับทิม', imagePath: 'assets/images/guess/fruit/Pomegranate.png', shadowPath: 'assets/images/guess/fruit/Pomegranate_shadow.png'),
    ShadowMatchItem(id: 'rambutan', name: 'Rambutan', thaiName: 'เงาะ', imagePath: 'assets/images/guess/fruit/Rambutan.png', shadowPath: 'assets/images/guess/fruit/Rambutan_shadow.png'),
    ShadowMatchItem(id: 'raspberry', name: 'Raspberry', thaiName: 'ราสเบอร์รี', imagePath: 'assets/images/guess/fruit/Raspberry.png', shadowPath: 'assets/images/guess/fruit/Raspberry_shadow.png'),
    ShadowMatchItem(id: 'roseapple', name: 'Rose apple', thaiName: 'ชมพู่', imagePath: 'assets/images/guess/fruit/Roseapple.png', shadowPath: 'assets/images/guess/fruit/Roseapple_shadow.png'),
    ShadowMatchItem(id: 'starfruit', name: 'Star fruit', thaiName: 'มะเฟือง', imagePath: 'assets/images/guess/fruit/Starfruit.png', shadowPath: 'assets/images/guess/fruit/Starfruit_shadow.png'),
    ShadowMatchItem(id: 'strawberry', name: 'Strawberry', thaiName: 'สตรอว์เบอร์รี', imagePath: 'assets/images/guess/fruit/Strawberry.png', shadowPath: 'assets/images/guess/fruit/Strawberry_shadow.png'),
    ShadowMatchItem(id: 'watermelon', name: 'Watermelon', thaiName: 'แตงโม', imagePath: 'assets/images/guess/fruit/Watermelon.png', shadowPath: 'assets/images/guess/fruit/Watermelon_shadow.png'),
  ];

  // 7. คลังหมวดบ้าน (33 ชนิด / ธีมสีฟ้าไซแอน)
  static const List<ShadowMatchItem> _houseItems = [
    ShadowMatchItem(id: 'bathroom', name: 'Bathroom', thaiName: 'ห้องน้ำ', imagePath: 'assets/images/guess/house/Bathroom.png', shadowPath: 'assets/images/guess/house/bathroom_shadow.png'),
    ShadowMatchItem(id: 'bed', name: 'Bed', thaiName: 'เตียงนอน', imagePath: 'assets/images/guess/house/Bed.png', shadowPath: 'assets/images/guess/house/bed_shadow.png'),
    ShadowMatchItem(id: 'bedroom', name: 'Bedroom', thaiName: 'ห้องนอน', imagePath: 'assets/images/guess/house/Bedroom.png', shadowPath: 'assets/images/guess/house/bedroom_shadow.png'),
    ShadowMatchItem(id: 'blanket', name: 'Blanket', thaiName: 'ผ้าห่ม', imagePath: 'assets/images/guess/house/Blanket.png', shadowPath: 'assets/images/guess/house/blanket_shadow.png'),
    ShadowMatchItem(id: 'chair', name: 'Chair', thaiName: 'เก้าอี้', imagePath: 'assets/images/guess/house/Chair.png', shadowPath: 'assets/images/guess/house/chair_shadow.png'),
    ShadowMatchItem(id: 'clock', name: 'Clock', thaiName: 'นาฬิกาแขวน', imagePath: 'assets/images/guess/house/Clock.png', shadowPath: 'assets/images/guess/house/clock_shadow.png'),
    ShadowMatchItem(id: 'closet', name: 'Closet', thaiName: 'ตู้เสื้อผ้า', imagePath: 'assets/images/guess/house/Closet.png', shadowPath: 'assets/images/guess/house/closet_shadow.png'),
    ShadowMatchItem(id: 'diningroom', name: 'Dining room', thaiName: 'ห้องรับประทานอาหาร', imagePath: 'assets/images/guess/house/Diningroom.png', shadowPath: 'assets/images/guess/house/diningroom_shadow.png'),
    ShadowMatchItem(id: 'door', name: 'Door', thaiName: 'ประตู', imagePath: 'assets/images/guess/house/Door.png', shadowPath: 'assets/images/guess/house/door_shadow.png'),
    ShadowMatchItem(id: 'fan', name: 'Fan', thaiName: 'พัดลม', imagePath: 'assets/images/guess/house/Fan.png', shadowPath: 'assets/images/guess/house/fan_shadow.png'),
    ShadowMatchItem(id: 'floor', name: 'Floor', thaiName: 'พื้นบ้าน', imagePath: 'assets/images/guess/house/Floor.png', shadowPath: 'assets/images/guess/house/Floor_shadow.png'),
    ShadowMatchItem(id: 'fork', name: 'Fork', thaiName: 'ส้อม', imagePath: 'assets/images/guess/house/Fork.png', shadowPath: 'assets/images/guess/house/fork_shadow.png'),
    ShadowMatchItem(id: 'garden', name: 'Garden', thaiName: 'สวนหน้าบ้าน', imagePath: 'assets/images/guess/house/Garden.png', shadowPath: 'assets/images/guess/house/garden_shadow.png'),
    ShadowMatchItem(id: 'house', name: 'House', thaiName: 'บ้าน', imagePath: 'assets/images/guess/house/House.png', shadowPath: 'assets/images/guess/house/house_shadow.png'),
    ShadowMatchItem(id: 'kitchen', name: 'Kitchen', thaiName: 'ห้องครัว', imagePath: 'assets/images/guess/house/Kitchen.png', shadowPath: 'assets/images/guess/house/kitchen_shadow.png'),
    ShadowMatchItem(id: 'lamp', name: 'Lamp', thaiName: 'โคมไฟ', imagePath: 'assets/images/guess/house/Lamp.png', shadowPath: 'assets/images/guess/house/Lamp_shadow_black.png'),
    ShadowMatchItem(id: 'livingroom', name: 'Living room', thaiName: 'ห้องนั่งเล่น', imagePath: 'assets/images/guess/house/Livingroom.png', shadowPath: 'assets/images/guess/house/Livingroom_shadow.png'),
    ShadowMatchItem(id: 'mirror', name: 'Mirror', thaiName: 'กระจกเงา', imagePath: 'assets/images/guess/house/Mirror.png', shadowPath: 'assets/images/guess/house/Mirror_shadow.png'),
    ShadowMatchItem(id: 'pillow', name: 'Pillow', thaiName: 'หมอน', imagePath: 'assets/images/guess/house/Pillow.png', shadowPath: 'assets/images/guess/house/Pillow_shadow.png'),
    ShadowMatchItem(id: 'plate', name: 'Plate', thaiName: 'จาน', imagePath: 'assets/images/guess/house/Plate.png', shadowPath: 'assets/images/guess/house/Plate_shadow.png'),
    ShadowMatchItem(id: 'refrigerator', name: 'Refrigerator', thaiName: 'ตู้เย็น', imagePath: 'assets/images/guess/house/Refrigerator.png', shadowPath: 'assets/images/guess/house/Refrigerator_shadow.png'),
    ShadowMatchItem(id: 'roof', name: 'Roof', thaiName: 'หลังคา', imagePath: 'assets/images/guess/house/Roof.png', shadowPath: 'assets/images/guess/house/Roof_shadow.png'),
    ShadowMatchItem(id: 'room', name: 'Room', thaiName: 'ห้อง', imagePath: 'assets/images/guess/house/Room.png', shadowPath: 'assets/images/guess/house/Room_shadow.png'),
    ShadowMatchItem(id: 'shower', name: 'Shower', thaiName: 'ฝักบัวอาบน้ำ', imagePath: 'assets/images/guess/house/Shower.png', shadowPath: 'assets/images/guess/house/Shower_shadow.png'),
    ShadowMatchItem(id: 'soap', name: 'Soap', thaiName: 'สบู่', imagePath: 'assets/images/guess/house/Soap.png', shadowPath: 'assets/images/guess/house/Soap_shadow.png'),
    ShadowMatchItem(id: 'sofa', name: 'Sofa', thaiName: 'โซฟา', imagePath: 'assets/images/guess/house/Sofa.png', shadowPath: 'assets/images/guess/house/Sofa_shadow.png'),
    ShadowMatchItem(id: 'spoon', name: 'Spoon', thaiName: 'ช้อน', imagePath: 'assets/images/guess/house/Spoon.png', shadowPath: 'assets/images/guess/house/Spoon_shadow.png'),
    ShadowMatchItem(id: 'stairs', name: 'Stairs', thaiName: 'บันได', imagePath: 'assets/images/guess/house/Stairs.png', shadowPath: 'assets/images/guess/house/Stairs_shadow.png'),
    ShadowMatchItem(id: 'table', name: 'Table', thaiName: 'โต๊ะ', imagePath: 'assets/images/guess/house/Table.png', shadowPath: 'assets/images/guess/house/Table_shadow.png'),
    ShadowMatchItem(id: 'television', name: 'Television', thaiName: 'โทรทัศน์', imagePath: 'assets/images/guess/house/Television.png', shadowPath: 'assets/images/guess/house/Television_shadow.png'),
    ShadowMatchItem(id: 'toilet', name: 'Toilet', thaiName: 'โถส้วม', imagePath: 'assets/images/guess/house/Toilet.png', shadowPath: 'assets/images/guess/house/Toilet_shadow.png'),
    ShadowMatchItem(id: 'towel', name: 'Towel', thaiName: 'ผ้าเช็ดตัว', imagePath: 'assets/images/guess/house/Towel.png', shadowPath: 'assets/images/guess/house/Towel_shadow.png'),
    ShadowMatchItem(id: 'wall', name: 'Wall', thaiName: 'กำแพง/ฝาผนัง', imagePath: 'assets/images/guess/house/Wall.png', shadowPath: 'assets/images/guess/house/Wall_shadow.png'),
    ShadowMatchItem(id: 'washingmachine', name: 'Washing machine', thaiName: 'เครื่องซักผ้า', imagePath: 'assets/images/guess/house/Washingmachine.png', shadowPath: 'assets/images/guess/house/Washingmachine_shadow.png'),
    ShadowMatchItem(id: 'window', name: 'Window', thaiName: 'หน้าต่าง', imagePath: 'assets/images/guess/house/Window.png', shadowPath: 'assets/images/guess/house/Window_shadow.png'),
  ];

  // 8. คลังหมวดยานพาหนะ (18 ชนิด / ธีมสีส้มอิฐ)[cite: 27]
  static const List<ShadowMatchItem> _vehicleItems = [
    ShadowMatchItem(id: 'airplane', name: 'Airplane', thaiName: 'เครื่องบิน', imagePath: 'assets/images/guess/Vehicles/Airplane.png', shadowPath: 'assets/images/guess/Vehicles/Airplane_shadow.png'), //[cite: 27]
    ShadowMatchItem(id: 'ambulance', name: 'Ambulance', thaiName: 'รถพยาบาล', imagePath: 'assets/images/guess/Vehicles/Ambulance.png', shadowPath: 'assets/images/guess/Vehicles/Ambulance_shadow.png'), //[cite: 27]
    ShadowMatchItem(id: 'bicycle', name: 'Bicycle', thaiName: 'จักรยาน', imagePath: 'assets/images/guess/Vehicles/Bicycle.png', shadowPath: 'assets/images/guess/Vehicles/Bicycle_shadow.png'), //[cite: 27]
    ShadowMatchItem(id: 'boat', name: 'Boat', thaiName: 'เรือ', imagePath: 'assets/images/guess/Vehicles/Boat.png', shadowPath: 'assets/images/guess/Vehicles/Boat_shadow.png'), //[cite: 27]
    ShadowMatchItem(id: 'bus', name: 'Bus', thaiName: 'รถบัสประจำทาง', imagePath: 'assets/images/guess/Vehicles/Bus.png', shadowPath: 'assets/images/guess/Vehicles/Bus_shadow.png'), //[cite: 27]
    ShadowMatchItem(id: 'car', name: 'Car', thaiName: 'รถยนต์', imagePath: 'assets/images/guess/Vehicles/Car.png', shadowPath: 'assets/images/guess/Vehicles/Car_shadow.png'), //[cite: 27]
    ShadowMatchItem(id: 'firetruck', name: 'Firetruck', thaiName: 'รถดับเพลิง', imagePath: 'assets/images/guess/Vehicles/Firetruck.png', shadowPath: 'assets/images/guess/Vehicles/Firetruck_shadow.png'), //[cite: 27]
    ShadowMatchItem(id: 'helicopter', name: 'Helicopter', thaiName: 'เฮลิคอปเตอร์', imagePath: 'assets/images/guess/Vehicles/Helicopter.png', shadowPath: 'assets/images/guess/Vehicles/Helicopter_shadow.png'), //[cite: 27]
    ShadowMatchItem(id: 'motorcycle', name: 'Motorcycle', thaiName: 'รถจักรยานยนต์', imagePath: 'assets/images/guess/Vehicles/Motorcycle.png', shadowPath: 'assets/images/guess/Vehicles/Motorcycle_shadow.png'), //[cite: 27]
    ShadowMatchItem(id: 'rocket', name: 'Rocket', thaiName: 'จรวด', imagePath: 'assets/images/guess/Vehicles/Rocket.png', shadowPath: 'assets/images/guess/Vehicles/rocket_shadow.png'), //[cite: 27]
    ShadowMatchItem(id: 'schoolbus', name: 'Schoolbus', thaiName: 'รถโรงเรียน', imagePath: 'assets/images/guess/Vehicles/Schoolbus.png', shadowPath: 'assets/images/guess/Vehicles/schoolbus_shadow.png'), //[cite: 27]
    ShadowMatchItem(id: 'ship', name: 'Ship', thaiName: 'เรือเดินสมุทร', imagePath: 'assets/images/guess/Vehicles/Ship.png', shadowPath: 'assets/images/guess/Vehicles/Ship_shadow.png'), //[cite: 27]
    ShadowMatchItem(id: 'skytrain', name: 'Skytrain', thaiName: 'รถไฟฟ้า', imagePath: 'assets/images/guess/Vehicles/Skytrain.png', shadowPath: 'assets/images/guess/Vehicles/Skytrain_shadow.png'), //[cite: 27]
    ShadowMatchItem(id: 'submarine', name: 'Submarine', thaiName: 'เรือดำน้ำ', imagePath: 'assets/images/guess/Vehicles/Submarine.png', shadowPath: 'assets/images/guess/Vehicles/Submarine_shadow.png'), //[cite: 27]
    ShadowMatchItem(id: 'taxi', name: 'Taxi', thaiName: 'รถแท็กซี่', imagePath: 'assets/images/guess/Vehicles/Taxi.png', shadowPath: 'assets/images/guess/Vehicles/Taxi_shadow.png'), //[cite: 27]
    ShadowMatchItem(id: 'train', name: 'Train', thaiName: 'รถไฟ', imagePath: 'assets/images/guess/Vehicles/Train.png', shadowPath: 'assets/images/guess/Vehicles/Train_shadow.png'), //[cite: 27]
    ShadowMatchItem(id: 'truck', name: 'Truck', thaiName: 'รถบรรทุก', imagePath: 'assets/images/guess/Vehicles/Truck.png', shadowPath: 'assets/images/guess/Vehicles/Truck_shadow.png'), //[cite: 27]
    ShadowMatchItem(id: 'van', name: 'Van', thaiName: 'รถตู้', imagePath: 'assets/images/guess/Vehicles/Van.png', shadowPath: 'assets/images/guess/Vehicles/van_shadow.png'), //[cite: 27]
  ];

  // 9. คลังหมวดกีฬา (19 ชนิด / ธีมสีฟ้า)
  static const List<ShadowMatchItem> _sportsItems = [
    ShadowMatchItem(id: 'archery', name: 'Archery', thaiName: 'ยิงธนู', imagePath: 'assets/images/guess/Sports/Archery.png', shadowPath: 'assets/images/guess/Sports/Archery_shadow.png'),
    ShadowMatchItem(id: 'badminton', name: 'Badminton', thaiName: 'แบดมินตัน', imagePath: 'assets/images/guess/Sports/Badminton.png', shadowPath: 'assets/images/guess/Sports/Badminton_shadow.png'),
    ShadowMatchItem(id: 'baseball', name: 'Baseball', thaiName: 'เบสบอล', imagePath: 'assets/images/guess/Sports/Baseball.png', shadowPath: 'assets/images/guess/Sports/Baseball_shadow.png'),
    ShadowMatchItem(id: 'basketball', name: 'Basketball', thaiName: 'บาสเกตบอล', imagePath: 'assets/images/guess/Sports/Basketball.png', shadowPath: 'assets/images/guess/Sports/Basketball_shadow.png'),
    ShadowMatchItem(id: 'bowling', name: 'Bowling', thaiName: 'โบว์ลิ่ง', imagePath: 'assets/images/guess/Sports/Bowling.png', shadowPath: 'assets/images/guess/Sports/Bowling_shadow.png'),
    ShadowMatchItem(id: 'boxing', name: 'Boxing', thaiName: 'มวย', imagePath: 'assets/images/guess/Sports/Boxing.png', shadowPath: 'assets/images/guess/Sports/Boxing_shadow.png'),
    ShadowMatchItem(id: 'cycling', name: 'Cycling', thaiName: 'ปั่นจักรยาน', imagePath: 'assets/images/guess/Sports/Cycling.png', shadowPath: 'assets/images/guess/Sports/Cycling_shadow.png'),
    ShadowMatchItem(id: 'golf', name: 'Golf', thaiName: 'กอล์ฟ', imagePath: 'assets/images/guess/Sports/Golf.png', shadowPath: 'assets/images/guess/Sports/Golf_shadow.png'),
    ShadowMatchItem(id: 'gymnastics', name: 'Gymnastics', thaiName: 'ยิมนาสติก', imagePath: 'assets/images/guess/Sports/Gymnastics.png', shadowPath: 'assets/images/guess/Sports/Gymnastics_shadow.png'),
    ShadowMatchItem(id: 'hockey', name: 'Hockey', thaiName: 'ฮอกกี้', imagePath: 'assets/images/guess/Sports/Hockey.png', shadowPath: 'assets/images/guess/Sports/Hockey_shadow.png'),
    ShadowMatchItem(id: 'rugby', name: 'Rugby', thaiName: 'รักบี้', imagePath: 'assets/images/guess/Sports/Rugby.png', shadowPath: 'assets/images/guess/Sports/Rugby_shadow.png'),
    ShadowMatchItem(id: 'running', name: 'Running', thaiName: 'วิ่ง', imagePath: 'assets/images/guess/Sports/Running.png', shadowPath: 'assets/images/guess/Sports/Running_shadow.png'),
    ShadowMatchItem(id: 'skateboarding', name: 'Skateboarding', thaiName: 'สเกตบอร์ด', imagePath: 'assets/images/guess/Sports/Skateboarding.png', shadowPath: 'assets/images/guess/Sports/Skateboarding_shadow.png'),
    ShadowMatchItem(id: 'surfing', name: 'Surfing', thaiName: 'เซิร์ฟบอร์ด', imagePath: 'assets/images/guess/Sports/Surfing.png', shadowPath: 'assets/images/guess/Sports/Surfing_shadow.png'),
    ShadowMatchItem(id: 'swimming', name: 'Swimming', thaiName: 'ว่ายน้ำ', imagePath: 'assets/images/guess/Sports/Swimming.png', shadowPath: 'assets/images/guess/Sports/Swimming_shadow.png'),
    ShadowMatchItem(id: 'tabletennis', name: 'Table Tennis', thaiName: 'ปิงปอง', imagePath: 'assets/images/guess/Sports/Tabletennis.png', shadowPath: 'assets/images/guess/Sports/Tabletennis_shadow.png'),
    ShadowMatchItem(id: 'taekwondo', name: 'Taekwondo', thaiName: 'เทควันโด', imagePath: 'assets/images/guess/Sports/Taekwondo.png', shadowPath: 'assets/images/guess/Sports/taekwondo_shadow.png'),
    ShadowMatchItem(id: 'tennis', name: 'Tennis', thaiName: 'เทนนิส', imagePath: 'assets/images/guess/Sports/Tennis.png', shadowPath: 'assets/images/guess/Sports/Tennis_shadow.png'),
    ShadowMatchItem(id: 'volleyball', name: 'Volleyball', thaiName: 'วอลเลย์บอล', imagePath: 'assets/images/guess/Sports/Volleyball.png', shadowPath: 'assets/images/guess/Sports/volleyball_shadow.png'),
  ];

  late CategoryData _currentCategory;
  late List<ShadowMatchItem> _shuffledPool;
  late List<ShadowMatchItem> _currentItems;
  late List<ShadowMatchItem> _shuffledShadows;
  final Map<String, bool> _matchedStatus = {};

  String? _selectedRealId;
  String? _selectedShadowId;

  int _score = 0;
  int _round = 1;
  late int _totalRounds;
  final int _itemsPerRound = 4;

  final Map<String, GlobalKey> _realDotKeys = {};
  final Map<String, GlobalKey> _shadowDotKeys = {};
  final GlobalKey _arenaKey = GlobalKey();

  final List<Color> _lineColors = const [
    Color(0xFF2563EB),
    Color(0xFFEC4899),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _resolveCategory();
    _startNewRound();
  }

  void _resolveCategory() {
    final title = widget.categoryTitle.trim();

    if (title.contains('สัตว์') || title.toLowerCase() == 'animal') {
      _currentCategory = const CategoryData(
        primaryColor: Color(0xFFA855F7),
        darkBorderColor: Color(0xFF581C87),
        shadowCardBg: Color(0xFFF5F3FF),
        backgroundGradient: [Color(0xFFE9D5FF), Color(0xFFF3E8FF), Color(0xFFFAF5FF)],
        items: _animalItems,
      );
    } else if (title.contains('ร่างกาย') || title.toLowerCase() == 'body') {
      _currentCategory = const CategoryData(
        primaryColor: Color(0xFFF59E0B),
        darkBorderColor: Color(0xFFB45309),
        shadowCardBg: Color(0xFFFEF3C7),
        backgroundGradient: [Color(0xFFFDE68A), Color(0xFFFEF3C7), Color(0xFFFFFBEB)],
        items: _bodyItems,
      );
    } else if (title.contains('เสื้อผ้า') || title.toLowerCase() == 'clothing' || title.toLowerCase() == 'clothes') {
      _currentCategory = const CategoryData(
        primaryColor: Color(0xFFEC4899),
        darkBorderColor: Color(0xFF9D174D),
        shadowCardBg: Color(0xFFFDF2F8),
        backgroundGradient: [Color(0xFFFBCFE8), Color(0xFFFDF2F8), Color(0xFFFFFFFF)],
        items: _clothesItems,
      );
    } else if (title.contains('กิจวัตร') || title.toLowerCase() == 'daily_routine' || title.toLowerCase() == 'dailyroutine') {
      _currentCategory = const CategoryData(
        primaryColor: Color(0xFF8B5CF6),
        darkBorderColor: Color(0xFF5B21B6),
        shadowCardBg: Color(0xFFF5F3FF),
        backgroundGradient: [Color(0xFFDDD6FE), Color(0xFFEDE9FE), Color(0xFFFFFFFF)],
        items: _dailyRoutineItems,
      );
    } else if (title.contains('อาหาร') || title.toLowerCase() == 'food') {
      _currentCategory = const CategoryData(
        primaryColor: Color(0xFF10B981),
        darkBorderColor: Color(0xFF065F46),
        shadowCardBg: Color(0xFFECFDF5),
        backgroundGradient: [Color(0xFFA7F3D0), Color(0xFFD1FAE5), Color(0xFFFFFFFF)],
        items: _foodItems,
      );
    } else if (title.contains('ผลไม้') || title.toLowerCase() == 'fruit') {
      _currentCategory = const CategoryData(
        primaryColor: Color(0xFFEF4444),
        darkBorderColor: Color(0xFF991B1B),
        shadowCardBg: Color(0xFFFEF2F2),
        backgroundGradient: [Color(0xFFFECACA), Color(0xFFFEE2E2), Color(0xFFFFFFFF)],
        items: _fruitItems,
      );
    } else if (title.contains('บ้าน') || title.toLowerCase() == 'home' || title.toLowerCase() == 'house') {
      _currentCategory = const CategoryData(
        primaryColor: Color(0xFF06B6D4),
        darkBorderColor: Color(0xFF0E7490),
        shadowCardBg: Color(0xFFECFEFF),
        backgroundGradient: [Color(0xFFA5F3FC), Color(0xFFCFFAFE), Color(0xFFFFFFFF)],
        items: _houseItems,
      );
    } else if (title.contains('ยานพาหนะ') || title.toLowerCase() == 'vehicle' || title.toLowerCase() == 'vehicles') {
      _currentCategory = const CategoryData(
        primaryColor: Color(0xFFF97316), // สีส้มอิฐตามการ์ดเมนู[cite: 10]
        darkBorderColor: Color(0xFFC2410C), // สีส้มเข้มคมชัด
        shadowCardBg: Color(0xFFFFF7ED), // ส้มพาสเทลอ่อนสว่างสบายตา
        backgroundGradient: [Color(0xFFFED7AA), Color(0xFFFFEDD5), Color(0xFFFFFFFF)],
        items: _vehicleItems, // รายการยานพาหนะครบ 18 ชนิด[cite: 27]
      );
    } else if (title.contains('กีฬา') || title.toLowerCase() == 'sport' || title.toLowerCase() == 'sports') {
      _currentCategory = const CategoryData(
        primaryColor: Color(0xFF3B82F6),
        darkBorderColor: Color(0xFF1E3A8A),
        shadowCardBg: Color(0xFFEFF6FF),
        backgroundGradient: [Color(0xFFBAE6FD), Color(0xFFE0F2FE), Color(0xFFF0F9FF)],
        items: _sportsItems,
      );
    } else {
      _currentCategory = const CategoryData(
        primaryColor: Color(0xFF3B82F6),
        darkBorderColor: Color(0xFF1E3A8A),
        shadowCardBg: Color(0xFFEFF6FF),
        backgroundGradient: [Color(0xFFBAE6FD), Color(0xFFE0F2FE), Color(0xFFF0F9FF)],
        items: _sportsItems,
      );
    }

    _totalRounds = (_currentCategory.items.length / _itemsPerRound).ceil();

    final random = math.Random();
    _shuffledPool = List<ShadowMatchItem>.from(_currentCategory.items)..shuffle(random);
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.38);
    await _flutterTts.setPitch(1.30);
  }

  void _startNewRound() {
    final random = math.Random();
    int startIndex = (_round - 1) * _itemsPerRound;
    int endIndex = startIndex + _itemsPerRound;

    if (endIndex > _shuffledPool.length) {
      endIndex = _shuffledPool.length;
    }

    _currentItems = _shuffledPool.sublist(startIndex, endIndex);
    _shuffledShadows = List<ShadowMatchItem>.from(_currentItems)..shuffle(random);

    _matchedStatus.clear();
    _realDotKeys.clear();
    _shadowDotKeys.clear();

    for (var item in _currentItems) {
      _matchedStatus[item.id] = false;
      _realDotKeys[item.id] = GlobalKey();
      _shadowDotKeys[item.id] = GlobalKey();
    }

    _selectedRealId = null;
    _selectedShadowId = null;

    setState(() {});
  }

  Future<void> _playItemSound(String name) async {
    await _flutterTts.stop();
    await _flutterTts.speak(name);
  }

  void _onSelectReal(String id) {
    if (_matchedStatus[id] == true) return;
    setState(() => _selectedRealId = id);
    _checkMatch();
  }

  void _onSelectShadow(String id) {
    if (_matchedStatus[id] == true) return;
    setState(() => _selectedShadowId = id);
    _checkMatch();
  }

  void _checkMatch() async {
    if (_selectedRealId != null && _selectedShadowId != null) {
      if (_selectedRealId == _selectedShadowId) {
        final matchedId = _selectedRealId!;
        final matchedItem = _currentCategory.items.firstWhere((a) => a.id == matchedId);

        setState(() {
          _matchedStatus[matchedId] = true;
          _score += 10;
          _selectedRealId = null;
          _selectedShadowId = null;
        });

        _playItemSound(matchedItem.name);
        await _showWordRevealModal(matchedItem);

        if (_matchedStatus.values.every((matched) => matched)) {
          await Future.delayed(const Duration(milliseconds: 400));
          if (!mounted) return;

          if (_round < _totalRounds) {
            setState(() => _round++);
            _startNewRound();
          } else {
            _showVictoryDialog();
          }
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 280));
        if (!mounted) return;
        setState(() {
          _selectedRealId = null;
          _selectedShadowId = null;
        });
      }
    }
  }

  Future<void> _showWordRevealModal(ShadowMatchItem item) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        Future.delayed(const Duration(milliseconds: 1400), () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 55),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: _currentCategory.primaryColor, width: 3.5),
              boxShadow: [
                BoxShadow(
                  color: _currentCategory.darkBorderColor,
                  offset: const Offset(0, 7),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 170,
                  decoration: BoxDecoration(
                    color: _currentCategory.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Center(
                    child: Image.asset(
                      item.imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        item.name.toLowerCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E293B),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        item.thaiName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _currentCategory.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showVictoryDialog() {
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
                _currentCategory.primaryColor,
                _currentCategory.darkBorderColor,
              ],
            ),
          ),
          child: Stack(
            children: [
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
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _CelebrationParticlesPainter(),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildBigStar(56),
                          const SizedBox(width: 8),
                          _buildBigStar(76),
                          const SizedBox(width: 8),
                          _buildBigStar(56),
                        ],
                      ),
                      const SizedBox(height: 14),
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
                              color: _currentCategory.darkBorderColor,
                              offset: const Offset(0, 4),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                        ),
                        child: Text(
                          'คุณเล่นเกมหมวด "${widget.categoryTitle}" เสร็จแล้ว!',
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
                      Row(
                        children: [
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

  Widget _buildBigStar(double size) {
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _currentCategory.backgroundGradient,
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
        child: Column(
          children: [
            // Header Bar
            Container(
              color: _currentCategory.primaryColor,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.categoryTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 34),
                    ],
                  ),
                ),
              ),
            ),

            // แถบคำอธิบายและหลอดด่าน
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: _currentCategory.darkBorderColor,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF0F172A),
                      offset: Offset(0, 3.5),
                      blurRadius: 0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(bottom: 3.5),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _currentCategory.primaryColor, width: 2.2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'แตะรูปภาพ แล้วแตะเงา เพื่อโยงเส้นคู่กัน',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                          color: _currentCategory.darkBorderColor,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFFB45309),
                                  offset: Offset(0, 1.8),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            child: Text(
                              'ด่าน $_round/$_totalRounds',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Row(
                              children: List.generate(_totalRounds, (index) {
                                final bool isPassed = index < _round;
                                return Expanded(
                                  child: Container(
                                    height: 10,
                                    margin: EdgeInsets.only(right: index == _totalRounds - 1 ? 0 : 4),
                                    decoration: BoxDecoration(
                                      color: isPassed ? const Color(0xFFF59E0B) : const Color(0xFFE2E8F0),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isPassed ? const Color(0xFFB45309) : const Color(0xFFCBD5E1),
                                        width: 1.4,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Play Arena
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Stack(
                  key: _arenaKey,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _NewWorksheetLinePainter(
                          arenaKey: _arenaKey,
                          currentItems: _currentItems,
                          realDotKeys: _realDotKeys,
                          shadowDotKeys: _shadowDotKeys,
                          matchedStatus: _matchedStatus,
                          lineColors: _lineColors,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // รูปจริง
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(_currentItems.length, (index) {
                            final item = _currentItems[index];
                            final isSelected = _selectedRealId == item.id;
                            final isMatched = _matchedStatus[item.id] ?? false;
                            final dotColor = _lineColors[index % _lineColors.length];

                            return _buildCardItem(
                              item: item,
                              isShadow: false,
                              isSelected: isSelected,
                              isMatched: isMatched,
                              dotColor: dotColor,
                              dotKey: _realDotKeys[item.id],
                              onTap: () => _onSelectReal(item.id),
                            );
                          }),
                        ),

                        const Spacer(),

                        // รูปเงา
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(_shuffledShadows.length, (index) {
                            final item = _shuffledShadows[index];
                            final isSelected = _selectedShadowId == item.id;
                            final isMatched = _matchedStatus[item.id] ?? false;
                            final realIndex = _currentItems.indexWhere((r) => r.id == item.id);
                            final dotColor = _lineColors[realIndex % _lineColors.length];

                            return _buildCardItem(
                              item: item,
                              isShadow: true,
                              isSelected: isSelected,
                              isMatched: isMatched,
                              dotColor: dotColor,
                              dotKey: _shadowDotKeys[item.id],
                              onTap: () => _onSelectShadow(item.id),
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardItem({
    required ShadowMatchItem item,
    required bool isShadow,
    required bool isSelected,
    required bool isMatched,
    required Color dotColor,
    required GlobalKey? dotKey,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isShadow) ...[
            _buildRadioDot(dotKey, isSelected, isMatched, dotColor),
            const SizedBox(width: 8),
          ],

          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isSelected ? _currentCategory.primaryColor : _currentCategory.darkBorderColor,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: isSelected ? _currentCategory.primaryColor : _currentCategory.darkBorderColor,
                  offset: const Offset(0, 4.5),
                  blurRadius: 0,
                ),
              ],
            ),
            padding: const EdgeInsets.only(bottom: 3.5),
            child: Container(
              decoration: BoxDecoration(
                color: isShadow ? _currentCategory.shadowCardBg : const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                  color: isSelected ? _currentCategory.primaryColor : _currentCategory.darkBorderColor,
                  width: 2.6,
                ),
              ),
              padding: const EdgeInsets.all(6),
              child: Center(
                child: Image.asset(
                  isShadow ? item.shadowPath : item.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    isShadow ? Icons.dark_mode_rounded : Icons.directions_car_rounded,
                    size: 44,
                    color: isShadow ? Colors.black87 : _currentCategory.primaryColor,
                  ),
                ),
              ),
            ),
          ),

          if (!isShadow) ...[
            const SizedBox(width: 8),
            _buildRadioDot(dotKey, isSelected, isMatched, dotColor),
          ],
        ],
      ),
    );
  }

  Widget _buildRadioDot(GlobalKey? key, bool isSelected, bool isMatched, Color dotColor) {
    return Container(
      key: key,
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? _currentCategory.primaryColor : _currentCategory.darkBorderColor,
          width: 2.8,
        ),
      ),
      child: Center(
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: isMatched ? dotColor : (isSelected ? _currentCategory.primaryColor : Colors.transparent),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _CelebrationParticlesPainter extends CustomPainter {
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
    ];

    for (int i = 0; i < 55; i++) {
      paint.color = colors[random.nextInt(colors.length)];
      final double x = random.nextDouble() * size.width;
      final double y = random.nextDouble() * size.height * 0.75;
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

class _NewWorksheetLinePainter extends CustomPainter {
  final GlobalKey arenaKey;
  final List<ShadowMatchItem> currentItems;
  final Map<String, GlobalKey> realDotKeys;
  final Map<String, GlobalKey> shadowDotKeys;
  final Map<String, bool> matchedStatus;
  final List<Color> lineColors;

  _NewWorksheetLinePainter({
    required this.arenaKey,
    required this.currentItems,
    required this.realDotKeys,
    required this.shadowDotKeys,
    required this.matchedStatus,
    required this.lineColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final RenderBox? arenaBox = arenaKey.currentContext?.findRenderObject() as RenderBox?;
    if (arenaBox == null) return;

    for (int i = 0; i < currentItems.length; i++) {
      final item = currentItems[i];
      if (matchedStatus[item.id] != true) continue;

      final realContext = realDotKeys[item.id]?.currentContext;
      final shadowContext = shadowDotKeys[item.id]?.currentContext;

      if (realContext == null || shadowContext == null) continue;

      final RenderBox? realBox = realContext.findRenderObject() as RenderBox?;
      final RenderBox? shadowBox = shadowContext.findRenderObject() as RenderBox?;

      if (realBox == null || shadowBox == null) continue;

      final startOffset = arenaBox.globalToLocal(
        realBox.localToGlobal(Offset(realBox.size.width / 2, realBox.size.height / 2)),
      );
      final endOffset = arenaBox.globalToLocal(
        shadowBox.localToGlobal(Offset(shadowBox.size.width / 2, shadowBox.size.height / 2)),
      );

      final lineColor = lineColors[i % lineColors.length];

      final paint = Paint()
        ..color = lineColor
        ..strokeWidth = 4.2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final path = Path();
      path.moveTo(startOffset.dx, startOffset.dy);
      final midX = (startOffset.dx + endOffset.dx) / 2;
      path.cubicTo(
        midX, startOffset.dy,
        midX, endOffset.dy,
        endOffset.dx, endOffset.dy,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NewWorksheetLinePainter oldDelegate) => true;
}