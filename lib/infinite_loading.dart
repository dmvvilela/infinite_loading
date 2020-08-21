library infinite_loading;

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';

class InfiniteLoading extends StatefulWidget {
  final double width;
  final Color trackColor;
  final Color progressBorderColor;
  final Color completeBorderColor;
  // If null, it will infinitely load..
  // true will finish with success, and
  // false will finish with error.
  final bool completeWithSuccess;

  InfiniteLoading({
    @required this.width,
    this.trackColor = Colors.white,
    this.progressBorderColor = Colors.grey,
    this.completeBorderColor = Colors.grey,
    this.completeWithSuccess,
  });

  @override
  _InfiniteLoadingState createState() => _InfiniteLoadingState();
}

class _InfiniteLoadingState extends State<InfiniteLoading>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  double _width;
  double _height = 8;
  Color _color;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _width = widget.width;
    _color = widget.trackColor;

    _animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            switch (status) {
              case AnimationStatus.completed:
                _animationController.reverse();
                break;
              case AnimationStatus.dismissed:
                _animationController.forward();
                break;
              default:
                break;
            }
          })
          ..forward();

    _animation = Tween<double>(begin: 0.0, end: _width - 44.0)
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(InfiniteLoading oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.completeWithSuccess != null) {
      if (!widget.completeWithSuccess) {
        _color = Color(0xFFDD4B39);
      } else {
        _color = Color(0xFFFFD421);
      }
      _isLoading = false;
      _width = 27;
      _height = 27;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          child: AnimatedContainer(
            width: _width,
            height: _height,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
            decoration: BoxDecoration(
              color: _color,
              border: Border.all(
                  color: _isLoading
                      ? widget.progressBorderColor
                      : widget.completeBorderColor,
                  width: 2,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: _isLoading
                ? AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_animation.value, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 40,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Color(0xFFFFD421),
                              border:
                                  Border.all(width: 0, style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                        ),
                      );
                    })
                : Container(),
          ),
        ),
        if (widget.completeWithSuccess != null)
          ControlledAnimation(
            playback: Playback.PLAY_FORWARD,
            duration: Duration(milliseconds: 160),
            delay: Duration(milliseconds: 220),
            tween: Tween(begin: 0.0, end: 27.0),
            curve: Curves.easeIn,
            builder: (context, tween) => ClipRect(
              child: Center(
                child: Container(
                  height: 27,
                  width: tween,
                  child: widget.completeWithSuccess
                      ? Image.asset(
                          'assets/images/check.png',
                          fit: BoxFit.none,
                        )
                      : Image.asset('assets/images/error.png'),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
