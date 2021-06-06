import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:model_viewer/model_viewer.dart';
import 'package:zoo_app/core/palette.dart';
import 'package:zoo_app/widgets/custom_transitions.dart';
import 'package:zoo_app/widgets/utils.dart';
import 'package:zoo_app/widgets/zoo_dictionary.dart';

class AnimalDetailsPage extends StatefulWidget {
  const AnimalDetailsPage({Key key, this.model}) : super(key: key);
  final String model;

  @override
  _AnimalDetailsPageState createState() => _AnimalDetailsPageState();
}

class _AnimalDetailsPageState extends State<AnimalDetailsPage>
    with SingleTickerProviderStateMixin, Utils {
  AnimationController _animationController;

  Animation<double> _modelDrivingAnimation;
  Animation<double> _containerDrivingAnimation;
  Animation<double> _buttonDrivingAnimation;

  ZooDictionary _dictionary;

  bool _isLoading = true;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 3000),
        reverseDuration: const Duration(milliseconds: 2000));

    // Model
    _modelDrivingAnimation = CurvedAnimation(
        parent: _animationController, curve: const Interval(0.0, 0.6));

    // Container
    _containerDrivingAnimation = CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.6, curve: Curves.easeInOutBack));

    // Button
    _buttonDrivingAnimation = CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 0.8, curve: Curves.easeInOutBack));

    _dictionary = zooDictionaryMap[widget.model.toLowerCase()];

    _startAnimationController();

    super.initState();
  }

  Future<void> _startAnimationController() async {
    // Wait for model to load.
    // Apparently, ModelViewer doesn't have onLoaded callback.
    await Future.delayed(const Duration(seconds: 3)).whenComplete(() {
      _isLoading = false;
      setState(() {});
      _animationController.forward();
    });
  }

  void _navigateBack() {
    _animationController.reverse().whenComplete(() => Navigator.pop(context));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateBack();
        return Future.value(false);
      },
      child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment:
                      _isLoading ? Alignment.center : Alignment.bottomCenter,
                  children: [
                    Visibility(
                      visible: _isLoading,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Opacity(
                            opacity: 0.8,
                            child: Lottie.asset('assets/meme-cat.json',
                                height: 100, frameRate: FrameRate.max),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Loading...',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 12),
                          )
                        ],
                      ),
                    ),
                    _ModelWidget(
                        modelDrivingAnimation: _modelDrivingAnimation,
                        src: widget.model.toLowerCase()),
                    Transition.container(
                        driveAnimation: _containerDrivingAnimation,
                        child: _AnimalDetialsWidget(dictionary: _dictionary)),
                    _BackButton(
                      buttonDrivingAnimation: _buttonDrivingAnimation,
                      navigateBack: _navigateBack,
                    ),
                    _LikeButton(
                        buttonDrivingAnimation: _buttonDrivingAnimation,
                        isLikedNotifier: isLikedNotifier),
                  ],
                ),
              ))),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback navigateBack;

  const _BackButton(
      {Key key,
      @required Animation<double> buttonDrivingAnimation,
      this.navigateBack})
      : _buttonDrivingAnimation = buttonDrivingAnimation,
        super(key: key);

  final Animation<double> _buttonDrivingAnimation;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 20,
      child: InkWell(
        onTap: navigateBack,
        child: Transition.backButton(
          driveAnimation: _buttonDrivingAnimation,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Palette.orange.withOpacity(0.1)),
            child: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black.withOpacity(0.75),
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _LikeButton extends StatelessWidget {
  const _LikeButton({
    Key key,
    @required Animation<double> buttonDrivingAnimation,
    @required this.isLikedNotifier,
  })  : _buttonDrivingAnimation = buttonDrivingAnimation,
        super(key: key);

  final Animation<double> _buttonDrivingAnimation;
  final ValueNotifier<bool> isLikedNotifier;

  void _likePressed() {
    isLikedNotifier.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        right: 20,
        child: Transition.likeButton(
          driveAnimation: _buttonDrivingAnimation,
          child: ValueListenableBuilder(
            valueListenable: isLikedNotifier,
            builder: (BuildContext context, bool _isLiked, Widget child) {
              return InkWell(
                onTap: _likePressed,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Palette.orange.withOpacity(0.1)),
                  child: AnimatedCrossFade(
                    firstChild: SvgPicture.asset(
                      'assets/liked.svg',
                      height: 12,
                    ),
                    secondChild: SvgPicture.asset(
                      'assets/like.svg',
                      height: 12,
                    ),
                    layoutBuilder:
                        (topChild, topChildKey, bottomChild, bottomChildKey) =>
                            topChild,
                    crossFadeState: _isLiked
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 400),
                  ),
                ),
              );
            },
          ),
        ));
  }
}

class _ModelWidget extends StatelessWidget {
  const _ModelWidget({
    Key key,
    @required Animation<double> modelDrivingAnimation,
    @required this.src,
  })  : _modelDrivingAnimation = modelDrivingAnimation,
        super(key: key);

  final Animation<double> _modelDrivingAnimation;
  final String src;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _modelDrivingAnimation,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
      child: Transition.model(
        driveAnimation: _modelDrivingAnimation,
        child: ModelViewer(
          src: 'assets/$src.glb',
          autoPlay: true,
          autoRotate: true,
          autoRotateDelay: 1,
          cameraControls: true,
        ),
      ),
    );
  }
}

class _AnimalDetialsWidget extends StatelessWidget {
  const _AnimalDetialsWidget({
    Key key,
    @required ZooDictionary dictionary,
  })  : _dictionary = dictionary,
        super(key: key);

  final ZooDictionary _dictionary;

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Shrink the parent container's height.
      shrinkWrap: true,
      children: [
        Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 10,
                    blurRadius: 50)
              ]),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(2.5)),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                decoration:
                    BoxDecoration(color: Palette.orange.withOpacity(0.4)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: Text(
                  _dictionary.name,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                _dictionary.description,
                style: const TextStyle(color: Colors.black54, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Palette.orange.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4)),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _PandaTableEntry(
                        title: 'Height',
                        value: _dictionary.height,
                      ),
                      const VerticalDivider(
                        color: Colors.white,
                        thickness: 1,
                        width: 1,
                      ),
                      _PandaTableEntry(
                        title: 'Weight',
                        value: _dictionary.weight,
                      ),
                      const VerticalDivider(
                        color: Colors.white,
                        thickness: 1,
                        width: 1,
                      ),
                      _PandaTableEntry(
                        title: 'Lifespan',
                        value: _dictionary.lifeSpan,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50)
            ],
          ),
        ),
      ],
    );
  }
}

class _PandaTableEntry extends StatelessWidget {
  final String title;
  final String value;
  const _PandaTableEntry({Key key, this.title, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.black54, fontSize: 10),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.black54, fontSize: 8),
        ),
      ],
    );
  }
}
