import 'package:flutter/material.dart';

/// Progress indicator showing which story is currently active
class StoryProgressIndicator extends StatelessWidget {
  final int totalStories;
  final int currentStory;

  const StoryProgressIndicator({
    Key? key,
    required this.totalStories,
    required this.currentStory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(
          totalStories,
              (index) => Expanded(
            child: Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index <= currentStory
                    ? Colors.white
                    : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}