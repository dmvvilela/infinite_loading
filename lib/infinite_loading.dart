library infinite_loading;

import 'package:flutter/material.dart';

/// A loading widget that displays an oscillating progress bar that moves
/// back and forth infinitely until completion.
///
/// The widget can be configured with various properties including:
/// - Width and height
/// - Colors for track, progress bar, and border
/// - Border width and radius
/// - Animation speed
/// - Completion state (success/error) with smooth icon animations
class InfiniteLoading extends StatefulWidget {
  /// The width of the loading widget container
  final double width;

  /// The height of the loading widget container
  final double height;

  /// Background color of the track (container)
  final Color trackColor;

  /// Color of the moving progress bar
  final Color progressColor;

  /// Color of the border during loading
  final Color borderColor;

  /// Width of the border
  final double borderWidth;

  /// Border radius for rounded corners
  final double borderRadius;

  /// Duration for one complete oscillation (left to right and back)
  final Duration oscillationDuration;

  /// Width of the oscillating progress bar
  final double progressBarWidth;

  /// Completion state:
  /// - null: infinite loading
  /// - true: complete with success (green checkmark)
  /// - false: complete with error (red X)
  final bool? completeWithSuccess;

  /// Color of the success icon and border
  final Color successColor;

  /// Color of the error icon and border
  final Color errorColor;

  /// Duration for the completion animation
  final Duration completionAnimationDuration;

  const InfiniteLoading({
    super.key,
    this.width = 200.0,
    this.height = 8.0,
    this.trackColor = Colors.white,
    this.progressColor = const Color(0xFFFFD421),
    this.borderColor = Colors.grey,
    this.borderWidth = 2.0,
    this.borderRadius = 14.0,
    this.oscillationDuration = const Duration(milliseconds: 1200),
    this.progressBarWidth = 40.0,
    this.completeWithSuccess,
    this.successColor = const Color(0xFF4CAF50),
    this.errorColor = const Color(0xFFF44336),
    this.completionAnimationDuration = const Duration(milliseconds: 400),
  });

  @override
  State<InfiniteLoading> createState() => _InfiniteLoadingState();
}

class _InfiniteLoadingState extends State<InfiniteLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _oscillationController;
  late Animation<double> _oscillationAnimation;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _oscillationController = AnimationController(
      duration: widget.oscillationDuration,
      vsync: this,
    );

    // Calculate the travel distance for the progress bar
    final double travelDistance =
        widget.width - widget.progressBarWidth - (widget.borderWidth * 2);

    _oscillationAnimation = Tween<double>(
      begin: 0.0,
      end: travelDistance,
    ).animate(CurvedAnimation(
      parent: _oscillationController,
      curve: Curves.easeInOut,
    ));

    // Set up the repeating animation with reverse
    _oscillationController.addStatusListener((status) {
      if (!_isCompleted) {
        if (status == AnimationStatus.completed) {
          _oscillationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _oscillationController.forward();
        }
      }
    });

    // Start the animation if not completed
    if (widget.completeWithSuccess == null) {
      _oscillationController.forward();
    }
  }

  @override
  void didUpdateWidget(InfiniteLoading oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle completion state change
    if (widget.completeWithSuccess != null &&
        oldWidget.completeWithSuccess == null) {
      setState(() {
        _isCompleted = true;
      });
      _oscillationController.stop();
    }

    // Update animation if duration changed
    if (widget.oscillationDuration != oldWidget.oscillationDuration) {
      _oscillationController.duration = widget.oscillationDuration;
    }
  }

  @override
  void dispose() {
    _oscillationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.completionAnimationDuration,
      curve: Curves.easeInOut,
      width: _isCompleted ? widget.height * 3.5 : widget.width,
      height: _isCompleted ? widget.height * 3.5 : widget.height,
      decoration: BoxDecoration(
        color: _isCompleted
            ? (widget.completeWithSuccess == true
                ? widget.successColor
                : widget.errorColor)
            : widget.trackColor,
        border: Border.all(
          color: _isCompleted
              ? (widget.completeWithSuccess == true
                  ? widget.successColor
                  : widget.errorColor)
              : widget.borderColor,
          width: widget.borderWidth,
        ),
        borderRadius: BorderRadius.circular(
          _isCompleted ? (widget.height * 3.5 / 2) : widget.borderRadius,
        ),
      ),
      child: _isCompleted
          ? _buildCompletionIcon()
          : _buildOscillatingProgress(),
    );
  }

  Widget _buildOscillatingProgress() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: AnimatedBuilder(
        animation: _oscillationAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned(
                left: _oscillationAnimation.value + widget.borderWidth,
                top: 0,
                bottom: 0,
                child: Container(
                  width: widget.progressBarWidth,
                  decoration: BoxDecoration(
                    color: widget.progressColor,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCompletionIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: widget.completionAnimationDuration,
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Icon(
            widget.completeWithSuccess == true
                ? Icons.check_rounded
                : Icons.close_rounded,
            color: Colors.white,
            size: widget.height * 2.5,
          ),
        );
      },
    );
  }
}
