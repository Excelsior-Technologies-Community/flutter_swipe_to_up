import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Main widget for swipeable story view with InShort-style animations
class SwipeableStoryView extends StatefulWidget {
  final List<Widget> stories;
  final Function(int)? onStoryChanged;
  final int initialStoryIndex;
  final Duration animationDuration;

  const SwipeableStoryView({
    Key? key,
    required this.stories,
    this.onStoryChanged,
    this.initialStoryIndex = 0,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<SwipeableStoryView> createState() => _SwipeableStoryViewState();
}

class _SwipeableStoryViewState extends State<SwipeableStoryView> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialStoryIndex;
  }

  void _onStoryChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onStoryChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return InShortStyleStoriesWithCallback(
      stories: widget.stories,
      initialIndex: _currentIndex,
      onStoryChanged: _onStoryChanged,
      animationDuration: widget.animationDuration,
    );
  }
}

/// Updated InShort-style stories with callback support and bidirectional swiping
class InShortStyleStoriesWithCallback extends StatefulWidget {
  final List<Widget> stories;
  final int initialIndex;
  final Function(int)? onStoryChanged;
  final Duration animationDuration;

  const InShortStyleStoriesWithCallback({
    Key? key,
    required this.stories,
    this.initialIndex = 0,
    this.onStoryChanged,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<InShortStyleStoriesWithCallback> createState() =>
      _InShortStyleStoriesWithCallbackState();
}

class _InShortStyleStoriesWithCallbackState
    extends State<InShortStyleStoriesWithCallback>
    with SingleTickerProviderStateMixin {
  late int currentIndex;
  double dragOffset = 0.0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
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
      behavior: HitTestBehavior.translucent,
      onVerticalDragUpdate: (details) {
        if (!_isAnimating) {
          setState(() {
            dragOffset += details.delta.dy;

            // Swipe up (negative) - can go to next if available
            if (dragOffset < 0 && currentIndex < widget.stories.length - 1) {
              dragOffset = dragOffset.clamp(-screenHeight, 0.0);
            }
            // Swipe down (positive) - can go to previous if available
            else if (dragOffset > 0 && currentIndex > 0) {
              dragOffset = dragOffset.clamp(0.0, screenHeight);
            }
            // Reset if no stories in that direction
            else {
              dragOffset = 0.0;
            }
          });
        }
      },
      onVerticalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        final threshold = screenHeight * 0.2;

        // Swipe UP - go to next story
        if ((dragOffset < -threshold || velocity < -500) &&
            currentIndex < widget.stories.length - 1) {
          _animateToNext(screenHeight);
        }
        // Swipe DOWN - go to previous story
        else if ((dragOffset > threshold || velocity > 500) && currentIndex > 0) {
          _animateToPrevious(screenHeight);
        }
        // Snap back if threshold not met
        else {
          _animateBack();
        }
      },
      child: Container(
        color: Colors.black,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            double effectiveOffset = dragOffset;

            if (_isAnimating) {
              effectiveOffset = dragOffset * (1 - _animation.value);
            }

            return Stack(
              fit: StackFit.expand,
              children: [
                // Previous story (behind when swiping down)
                if (currentIndex > 0 && dragOffset > 0)
                  Positioned.fill(
                    child: _buildStoryCard(
                      child: widget.stories[currentIndex - 1],
                      scale: 0.90 +
                          (0.10 *
                              _getPreviousProgress(
                                  effectiveOffset, screenHeight)),
                      opacity: 1.0,
                      translateY: 0,
                    ),
                  ),

                // Next story (behind when swiping up)
                if (currentIndex < widget.stories.length - 1 && dragOffset <= 0)
                  Positioned.fill(
                    child: _buildStoryCard(
                      child: widget.stories[currentIndex + 1],
                      scale: 0.90 +
                          (0.10 *
                              _getNextProgress(
                                  effectiveOffset, screenHeight)),
                      opacity: 1.0,
                      translateY: 0,
                    ),
                  ),

                // Current story (on top) - slides up or down
                Positioned.fill(
                  child: _buildStoryCard(
                    child: widget.stories[currentIndex],
                    scale: 1.0,
                    opacity: 1.0 -
                        (0.3 * _getCurrentProgress(effectiveOffset, screenHeight)),
                    translateY: effectiveOffset,
                  ),
                ),
              ],
            );
          },
        ),
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
      widget.onStoryChanged?.call(currentIndex);
    });
  }

  void _animateToPrevious(double screenHeight) {
    setState(() {
      _isAnimating = true;
    });

    _animationController.forward(from: 0.0).then((_) {
      setState(() {
        currentIndex--;
        dragOffset = 0.0;
        _isAnimating = false;
      });
      _animationController.reset();
      widget.onStoryChanged?.call(currentIndex);
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
    return Transform.translate(
      offset: Offset(0, translateY),
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: child,
          ),
        ),
      ),
    );
  }

  double _getCurrentProgress(double offset, double screenHeight) {
    return (offset.abs() / screenHeight).clamp(0.0, 1.0);
  }

  double _getNextProgress(double offset, double screenHeight) {
    return _easeOutCubic((-offset / screenHeight).clamp(0.0, 1.0));
  }

  double _getPreviousProgress(double offset, double screenHeight) {
    return _easeOutCubic((offset / screenHeight).clamp(0.0, 1.0));
  }

  double _easeOutCubic(double t) {
    return 1 - math.pow(1 - t, 3).toDouble();
  }
}