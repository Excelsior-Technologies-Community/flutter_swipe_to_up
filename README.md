## Flutter Swipe To Up

A beautiful InShort-style swipeable story view widget with smooth animations for Flutter apps. Perfect for creating engaging vertical story feeds like InShort, Instagram Stories, or news apps.

## Features

✨ **Smooth InShort-style animations** - Beautiful stack-based transitions  
🔄 **Bidirectional swiping** - Swipe up for next, swipe down for previous  
📱 **Responsive** - Works perfectly on all screen sizes  
⚡ **High performance** - Optimized animations with no lag  
🎨 **Customizable** - Control animation duration and behavior  
🚀 **Easy to use** - Simple API with minimal setup 

## Preview

https://github.com/user-attachments/assets/704ef587-c5f9-4672-bae5-27a44429e018


## Installation

Add this to your package's `pubspec.yaml` file:
```yaml
dependencies:
  flutter_swipe_to_up: ^1.0.0
```

Then run:
```bash
flutter pub get
```

### Basic Example
```dart
import 'package:flutter/material.dart';
import 'package:flutter_swipe_to_up/swipeable_story_view.dart';

class StoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SwipeableStoryView(
        stories: [
          Container(
            color: Colors.red,
            child: Center(
              child: Text(
                'Story 1',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
          ),
          Container(
            color: Colors.blue,
            child: Center(
              child: Text(
                'Story 2',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
          ),
          Container(
            color: Colors.green,
            child: Center(
              child: Text(
                'Story 3',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

## Advanced Example with Callbacks
```dart
SwipeableStoryView(
  stories: yourStoryWidgets,
  initialStoryIndex: 0,
  animationDuration: Duration(milliseconds: 300),
  onStoryChanged: (index) {
    print('Story changed to index: $index');
    // Track analytics, update UI, etc.
  },
)
```

## Custom Story Widget
```dart
class StoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const StoryCard({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage
SwipeableStoryView(
  stories: [
    StoryCard(
      title: 'Breaking News',
      description: 'Latest updates from around the world',
      imageUrl: 'https://example.com/image1.jpg',
    ),
    StoryCard(
      title: 'Technology',
      description: 'New innovations in tech',
      imageUrl: 'https://example.com/image2.jpg',
    ),
  ],
)
```

## Requirements

- Flutter SDK: `>=3.0.0`
- Dart SDK: `>=2.17.0 <4.0.0`

## License

MIT License

Copyright (c) 2025 Excelsior Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all  
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED **"AS IS"**, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
