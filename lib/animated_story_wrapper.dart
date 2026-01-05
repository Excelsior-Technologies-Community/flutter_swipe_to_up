import 'package:flutter/material.dart';
import 'dart:math' as math;

/// InShort-style stories with stack-based animation
class InShortStyleStories extends StatefulWidget {
  final List<Widget> stories;

  const InShortStyleStories({Key? key, required this.stories}) : super(key: key);

  @override
  State<InShortStyleStories> createState() => _InShortStyleStoriesState();
}

class _InShortStyleStoriesState extends State<InShortStyleStories> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  double dragOffset = 0.0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (!_isAnimating) {
          setState(() {
            dragOffset += details.delta.dy;
            dragOffset = dragOffset.clamp(-screenHeight, 0.0);
          });
        }
      },
      onVerticalDragEnd: (details) {
        final threshold = -screenHeight * 0.25;

        if (dragOffset < threshold && currentIndex < widget.stories.length - 1) {
          _animateToNext(screenHeight);
        } else {
          _animateBack();
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          double effectiveOffset = dragOffset;

          if (_isAnimating) {
            effectiveOffset = dragOffset + (_animation.value * -dragOffset);
          }

          return Stack(
            children: [
              // Next story (behind)
              if (currentIndex < widget.stories.length - 1)
                _buildStoryCard(
                  child: widget.stories[currentIndex + 1],  // Add 'child:' here
                  scale: 0.9 + (0.1 * _getNextProgress(effectiveOffset, screenHeight)),
                  opacity: 0.6 + (0.4 * _getNextProgress(effectiveOffset, screenHeight)),
                  translateY: 0,
                ),

              // Current story (on top)
              _buildStoryCard(
                child: widget.stories[currentIndex],  // Add 'child:' here
                scale: 1.0,
                opacity: 1.0 - (0.4 * _getCurrentProgress(effectiveOffset, screenHeight)),
                translateY: effectiveOffset,
              ),
            ],
          );
        },
      ),
    );
  }

  void _animateToNext(double screenHeight) {
    setState(() {
      _isAnimating = true;
    });

    _animationController.forward(from: 0.0).then((_) {
      setState(() {
        currentIndex++;
        dragOffset = 0.0;
        _isAnimating = false;
      });
      _animationController.reset();
    });
  }

  void _animateBack() {
    setState(() {
      _isAnimating = true;
    });

    _animationController.forward(from: 0.0).then((_) {
      setState(() {
        dragOffset = 0.0;
        _isAnimating = false;
      });
      _animationController.reset();
    });
  }

  Widget _buildStoryCard({
    required Widget child,
    required double scale,
    required double opacity,
    required double translateY,
  }) {
    return Container(
      color: Colors.black,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(0.0, translateY)
          ..scale(scale),
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: child,
        ),
      ),
    );
  }

  double _getCurrentProgress(double offset, double screenHeight) {
    return (-offset / screenHeight).clamp(0.0, 1.0);
  }

  double _getNextProgress(double offset, double screenHeight) {
    return _easeOutCubic(_getCurrentProgress(offset, screenHeight));
  }

  double _easeOutCubic(double t) {
    return 1 - math.pow(1 - t, 3).toDouble();
  }
}