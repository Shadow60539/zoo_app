import 'package:flutter/widgets.dart';

class Transition extends AnimatedWidget {
  /// Creates sequence of transitions.
  ///
  /// [driveAnimation] must not be null
  const Transition._(
      {this.positionAnimation,
      this.driveAnimation,
      this.child,
      this.isModel = false})
      : super(listenable: driveAnimation);

  /// The driving animation for FooTransitions
  final Animation<double> driveAnimation;
  final Tween<Offset> positionAnimation;
  final Widget child;

  /// To controll the opacity of the model animation.
  ///
  /// For all animations other than model `Transition.model`, isModel is false
  final bool isModel;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: positionAnimation.animate(driveAnimation),
      child: Opacity(
        opacity:
            isModel ? 1.0 : driveAnimation.value.clamp(0.0, 1.0).toDouble(),
        child: child,
      ),
    );
  }

  /// Creates transition animation for content container in `AnimalDetailsPage`
  factory Transition.container(
          {Widget child, Animation<double> driveAnimation}) =>
      Transition._(
        driveAnimation: driveAnimation,
        positionAnimation:
            Tween(begin: const Offset(0.0, 1.0), end: Offset.zero),
        child: child,
      );

  /// Creates transition animation for model in `AnimalDetailsPage`
  factory Transition.model({Widget child, Animation<double> driveAnimation}) =>
      Transition._(
        isModel: true,
        driveAnimation: CurvedAnimation(
          parent: driveAnimation,
          curve: const Interval(0.6, 1.0, curve: Curves.easeInOutBack),
        ),
        positionAnimation:
            Tween(begin: Offset.zero, end: const Offset(0, -0.25)),
        child: ScaleTransition(
            scale: CurvedAnimation(
              parent: driveAnimation,
              curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
            ),
            child: child),
      );

  /// Creates transition animation for back button in `AnimalDetailsPage`
  factory Transition.backButton(
          {Widget child, Animation<double> driveAnimation}) =>
      Transition._(
        driveAnimation: driveAnimation,
        positionAnimation:
            Tween(begin: const Offset(-1.4, 0.0), end: Offset.zero),
        child: child,
      );

  /// Creates transition animation for like button in `AnimalDetailsPage`
  factory Transition.likeButton(
          {Widget child, Animation<double> driveAnimation}) =>
      Transition._(
        driveAnimation: driveAnimation,
        positionAnimation:
            Tween(begin: const Offset(1.4, 0.0), end: Offset.zero),
        child: child,
      );
}

class IndicatorAnimation extends AnimatedWidget {
  /// `AnimatedWidget` for scroll indicator
  ///
  /// Nested `ScaleTransition` and `FadeTransition`
  const IndicatorAnimation({this.animation, this.child})
      : super(listenable: animation);

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

const kDuration = Duration(milliseconds: 800);
const kCurve = Curves.easeOutSine;

class FadeFromUpAnimation extends StatefulWidget {
  final Widget child;

  const FadeFromUpAnimation({this.child});
  @override
  _FadeFromUpAnimationState createState() => _FadeFromUpAnimationState();
}

class _FadeFromUpAnimationState extends State<FadeFromUpAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> _animation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: kDuration)
      ..forward();
    _animation = Tween<Offset>(
            begin: const Offset(0, 0.2), end: const Offset(0, 0))
        .animate(CurvedAnimation(parent: _animationController, curve: kCurve));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: FadeTransition(
        opacity: _animationController,
        child: widget.child,
      ),
    );
  }
}
