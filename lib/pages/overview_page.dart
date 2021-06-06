import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:scratcher/scratcher.dart';
import 'package:zoo_app/core/palette.dart';
import 'package:zoo_app/core/scratch_notifier.dart';
import 'package:zoo_app/widgets/custom_transitions.dart';
import 'package:zoo_app/widgets/size_widget.dart';
import 'package:zoo_app/widgets/utils.dart';
import 'package:zoo_app/widgets/zoo_dictionary.dart';

import 'animal_details_page.dart';

const double _topMargin = 100;
const double _bottomMargin = 40;

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key key}) : super(key: key);

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage>
    with SingleTickerProviderStateMixin, Utils {
  Size get _size => MediaQuery.of(context).size;
  ScrollController _scrollController;

  AnimationController _animationController;

  Animation<double> _scrollIndicatorAnimation;

  int _currentIndex = 1;

  double _scrollPercentage = 0.0;

  double scrollTotalHeight = 0.0;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final List<int> _dummyList = [];

  final ScratchNotifier _scratchNotifier = ScratchNotifier();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Future f = Future(() {});
      animalNames.forEach((element) {
        f = f.then(
            (value) => Future.delayed(const Duration(milliseconds: 250), () {
                  _dummyList.add(0);
                  _listKey.currentState.insertItem(_dummyList.length - 1);
                }));
      });
    });

    _scrollController = ScrollController()..addListener(_listener);

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();

    _scrollIndicatorAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    super.initState();
  }

  void _listener() {
    final double _maxScrollExtent = _scrollController.position.maxScrollExtent;
    final double _position = _scrollController.position.pixels.isNegative
        ? 0.0
        : _scrollController.position.pixels;

    _scrollPercentage = _position / _maxScrollExtent;

    final double scolledHeight = _scrollPercentage * scrollTotalHeight;

    final double heightOfBox = scrollTotalHeight / animalNames.length;

    final int _stoppedIndex = (scolledHeight / heightOfBox)
        .ceil()
        .clamp(1, animalNames.length)
        .toInt();
    _currentIndex = _stoppedIndex;

    // Scroll activity lookup
    _scrollController.position.isScrollingNotifier.addListener(() {
      final bool _isScrolling =
          _scrollController.position.isScrollingNotifier.value;

      if (!_isScrolling) {
        _animationController.forward();
      }
    });

    if (_scrollController.position.activity is BallisticScrollActivity) {
      _animationController.reverse();
    }
  }

  AppBar get _appBar => AppBar(
        toolbarHeight: kToolbarHeight * 2,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Transform.scale(
            scale: 0.25,
            child: SvgPicture.asset(
              'assets/controls.svg',
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        actions: [
          SvgPicture.asset(
            'assets/setting.svg',
            color: Colors.black.withOpacity(0.5),
          ),
          const SizedBox(width: 20)
        ],
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/note.svg',
                  height: 10,
                  color: Palette.orange.withOpacity(0.5),
                ),
                const SizedBox(width: 10),
                Text(
                  "Gotta Catch ’Em All",
                  key: ValueKey(_currentIndex),
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontFamily: GoogleFonts.nunitoSans().fontFamily),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _cardList(double kContainerConstraints) => SizedBox(
        height: _size.height,
        width: _size.width * 0.8,
        child: AnimatedList(
          shrinkWrap: true,
          initialItemCount: _dummyList.length,
          itemBuilder: (context, index, animation) {
            final String e = animalNames[index];
            return ValueListenableBuilder(
              valueListenable: _scratchNotifier,
              builder: (BuildContext context, _, Widget child) {
                return RepaintBoundary(
                  child: FadeFromUpAnimation(
                    child: AnimatedContainer(
                      height: kContainerConstraints,
                      alignment: Alignment.center,
                      width: kContainerConstraints,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: !_scratchNotifier.isContains(e)
                            ? Colors.black.withOpacity(0.03)
                            : Palette.orange.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Scratcher(
                              onScratchEnd: () async {
                                await _onScratchEnd(e);
                              },
                              accuracy: ScratchAccuracy.low,
                              color: Colors.transparent,
                              image: Image.asset(
                                _scratchNotifier.isContains(e)
                                    ? 'assets/${e.toLowerCase()}.png'
                                    : 'assets/${e.toLowerCase()}_initial.png',
                              ),
                              child:
                                  Image.asset('assets/${e.toLowerCase()}.png')),
                          AnimatedCrossFade(
                            alignment: Alignment.center,
                            firstChild: Lottie.asset('assets/clapping.json',
                                frameRate: FrameRate.max,
                                width: kContainerConstraints,
                                fit: BoxFit.cover,
                                repeat: false,
                                alignment: Alignment.bottomCenter),
                            secondChild: const SizedBox.shrink(),
                            crossFadeState: _scratchNotifier.isContains(e)
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 400),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          physics: const BouncingScrollPhysics(),
          key: _listKey,
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 40),
        ),
      );

  Future _onScratchEnd(String e) async {
    _scratchNotifier.addToScrated(e);
    await Future.delayed(const Duration(milliseconds: 1800));
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AnimalDetailsPage(
                  model: e.toLowerCase(),
                )));
  }

  @override
  Widget build(BuildContext context) {
    final double kContainerConstraints = _size.height * 0.3;

    return SafeArea(
      child: Scaffold(
          appBar: _appBar,
          backgroundColor: Colors.white,
          body: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(flex: 2),
              _indicator(),
              const SizedBox(width: 10),
              _cardList(kContainerConstraints),
              const Spacer(),
            ],
          )),
    );
  }

  AnimatedBuilder _indicator() {
    return AnimatedBuilder(
      animation: _scrollController,
      builder: (BuildContext context, Widget child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            MeasureSize(
              onChange: (size) {
                scrollTotalHeight = size.height - _topMargin - _bottomMargin;
                setState(() {});
              },
              child: Container(
                width: 4,
                margin: const EdgeInsets.only(
                    top: _topMargin, bottom: _bottomMargin),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            AnimatedContainer(
              curve: Curves.slowMiddle,
              width: 4,
              height: _scrollPercentage * scrollTotalHeight,
              margin: const EdgeInsets.only(top: _topMargin, bottom: 40),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Palette.orange.withOpacity(0.1),
                      Palette.orange,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2)),
              duration: const Duration(milliseconds: 1200),
            ),
            AnimatedPositioned(
                top: _scrollPercentage * scrollTotalHeight + _topMargin - 10,
                right: -12,
                duration: const Duration(milliseconds: 1200),
                child: IndicatorAnimation(
                  animation: _scrollIndicatorAnimation,
                  child: Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 2,
                              blurRadius: 5)
                        ]),
                    child: AnimatedSwitcher(
                      transitionBuilder: (child, animation) {
                        return Transition.container(
                            driveAnimation: animation, child: child);
                      },
                      duration: const Duration(milliseconds: 400),
                      child: Text(
                        animalsEmojiMapper[_currentIndex],
                        key: ValueKey(_currentIndex),
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 10),
                      ),
                    ),
                  ),
                )),
          ],
        );
      },
    );
  }
}
