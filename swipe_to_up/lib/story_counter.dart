import 'package:flutter/material.dart';

/// Displays current story number out of total
class StoryCounter extends StatelessWidget {
  final int currentStory;
  final int totalStories;

  const StoryCounter({
    Key? key,
    required this.currentStory,
    required this.totalStories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${currentStory + 1}/$totalStories',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
