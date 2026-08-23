import 'package:flutter/material.dart';
import 'story_detail_screen.dart';

class TaleItem {
  final String title;
  final String imageUrl;

  TaleItem({required this.title, required this.imageUrl});
}

class TaleScreen extends StatelessWidget {
  TaleScreen({Key? key}) : super(key: key);

  final List<TaleItem> tales = [
    TaleItem(
      title: 'Little Red Riding Hood',
      imageUrl: 'assets/images/tale/Little Red Riding Hood.jpg',
    ),
    TaleItem(
      title: 'The Ant and the Grasshopper',
      imageUrl: 'assets/images/tale/The Ant and the Grasshopper.png',
    ),
    TaleItem(
      title: 'The Boy Who Cried Wolf',
      imageUrl: 'assets/images/tale/The Boy Who Cried Wolf.png',
    ),
    TaleItem(
      title: 'The Fox and the Stork',
      imageUrl: 'assets/images/tale/The Fox and the Stork.png',
    ),
    TaleItem(
      title: 'The Goose That Laid the Golden Eggs',
      imageUrl: 'assets/images/tale/The Goose That Laid the Golden Eggs.png',
    ),
    TaleItem(
      title: 'The Lion and the Fox',
      imageUrl: 'assets/images/tale/The Lion and the Fox.png',
    ),
    TaleItem(
      title: 'The Lion and the Mouse',
      imageUrl: 'assets/images/tale/The Lion and the Mouse.png',
    ),
    TaleItem(
      title: 'The Three Little Pigs',
      imageUrl: 'assets/images/tale/The Three Little Pigs.png',
    ),
    TaleItem(
      title: 'The Tortoise and the Hare',
      imageUrl: 'assets/images/tale/The Tortoise and the Hare.jpg',
    ),
    TaleItem(
      title: 'The Ugly Duckling',
      imageUrl: 'assets/images/tale/The Ugly Duckling.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0088FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Tale',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a story for you.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tales.length,
              itemBuilder: (context, index) {
                final tale = tales[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          tale.imageUrl,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              tale.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StoryDetailScreen(title: tale.title),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2997FF),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                            ),
                            child: const Text(
                              'Start',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}