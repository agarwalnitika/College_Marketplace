import 'package:flutter/material.dart';

class TypingTextAnimation extends StatefulWidget {
  @override
  State createState() => new TypingTextAnimationState();
}

class TypingTextAnimationState extends State<TypingTextAnimation>
    with TickerProviderStateMixin {
  Animation<int> _characterCount;

  int _stringIndex;
  static const List<String> _kStrings = const <String>[
    'Want to Donate?  ',
    'Well Here is your chance',
  ];
  String get _currentString => _kStrings[_stringIndex % _kStrings.length];
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    setState(() {
      _stringIndex = _stringIndex == null ? 0 : _stringIndex + 1;
      _characterCount = new StepTween(begin: 0, end: _currentString.length)
          .animate(
          new CurvedAnimation(parent: controller, curve: Curves.easeIn));
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle textStyle = theme.textTheme.title.copyWith(
      color: Colors.red,
      fontSize: 35.0,
    );
    return  new Container(
      height: 35,
      width: 350,
      margin: new EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
      child: _characterCount == null
          ? null
          : new AnimatedBuilder(
        animation: _characterCount,
        builder: (BuildContext context, Widget child) {
          String text =
          _currentString.substring(0, _characterCount.value);
          return new Text(text, style: textStyle
          );
        },
      ),

    );
  }
}