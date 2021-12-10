import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Animation')),
      body: Center(
        child: Container(
          height: 100,
          width: 300,
          color: Colors.white,
          child: AnimatedButton(label: 'Посмотреть в AR', onTap: () {
            print('AR button tapped!');
          })
        ),
      ),
    ),
  );
}

class AnimatedButton extends StatefulWidget {
  final String label;
  final GestureTapCallback? onTap;

  AnimatedButton({
    required this.label,
    this.onTap,
  });

  @override
  State<StatefulWidget> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late final AnimationController _rightShiftController;
  late final Animation<double> _rightShift;

  @override
  void initState() {
    super.initState();

    _rightShiftController = new AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _rightShift = Tween<double>(begin: 10.0, end: 250.0)
      .animate(_rightShiftController)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _rightShiftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      !_rightShift.isDismissed
      ? Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(left: 15),
          width: _rightShift.value,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(80),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 5),
              BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(5, 5)),
            ],
          ),
          child: GestureDetector(
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 45),
              child: _buildText(),
            ),
            onTap: widget.onTap,
          ),
        ),
      )
      : SizedBox(width: 1),
      Align(
        alignment: Alignment.centerLeft,
        child: Stack(
          children: [
            GestureDetector(
              child: Image.asset('assets/AR_icon-24.png', width: 80, height: 80),
              onTap: () => !_rightShift.isCompleted ? _rightShiftController.forward() : _rightShiftController.reset(),
            ),
            _rightShiftController.isAnimating
              ? Positioned(
                top: 7,
                left: 8,
                child: SizedBox(
                  height: 62,
                  width: 62,
                  child: CircularProgressIndicator(
                    color: Color(0xff263351),
                    strokeWidth: 2,
                  ),
                ),
            )
            : SizedBox(width: 1),
          ],
        ),
      ),
    ],
  );

  Widget _buildText() {
    if (!_rightShift.isCompleted) {
      return SizedBox(width: 1);
    }

    return FadeInText(Text(widget.label, style: TextStyle(fontSize: 15)));
  }
}

class FadeInText extends StatefulWidget {
  final Text text;

  FadeInText(this.text);

  @override
  State<StatefulWidget> createState() => _FadeInTextState();
}

class _FadeInTextState extends State<FadeInText> with SingleTickerProviderStateMixin {
  late final AnimationController _fadeInController;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    _fadeInController = new AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeInController,
        curve: Interval(0.0, 0.5, curve: Curves.linear),
      ),
    )..addListener(() => setState(() {}));

    _fadeInController.forward();
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _fadeIn.value,
      child: widget.text,
    );
  }
}
