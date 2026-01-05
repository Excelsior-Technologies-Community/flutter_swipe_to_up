import 'package:flutter/material.dart';
import 'package:flutter_swipe_to_up/sample_stories.dart';
import 'package:flutter_swipe_to_up/story_card.dart';
import 'package:flutter_swipe_to_up/story_counter.dart';
import 'package:flutter_swipe_to_up/story_progress_indigator.dart';
import 'package:flutter_swipe_to_up/swipeable_story_view.dart';


/// Main screen displaying swipeable stories
class StoryScreen extends StatefulWidget {
  const StoryScreen({Key? key}) : super(key: key);

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  int currentStory = 0;
  final stories = SampleStories.getStories();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main swipeable story view
          SwipeableStoryView(
            stories: stories
                .map((story) => StoryCard(
              title: story['title'],
              content: story['content'],
              imageUrl: story['imageUrl'],
              category: story['category'],
              backgroundColor: Colors.white,
              onShare: () => _handleShare(story['title']),
            ))
                .toList(),
            onStoryChanged: (index) {
              setState(() {
                currentStory = index;
              });
            },
            initialStoryIndex: 0,
          ),

          // Progress indicator
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: StoryProgressIndicator(
              totalStories: stories.length,
              currentStory: currentStory,
            ),
          ),

          // Story counter
          Positioned(
            top: 65,
            right: 20,
            child: StoryCounter(
              currentStory: currentStory,
              totalStories: stories.length,
            ),
          ),
        ],
      ),
    );
  }

  void _handleShare(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing: $title'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}