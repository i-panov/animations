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
  bool _labelVisible = false;
  void _toggleLabel() => setState(() => _labelVisible = !_labelVisible);

  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 1),
    );

    final tween = Tween<double>(begin: 10.0, end: 250.0);
    _animation = tween.animate(_controller);
    _animation.addListener(_toggleLabel);
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      !_animation.isDismissed
      ? Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(left: 15),
          width: _animation.value,
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
              child: _animation.isCompleted
              //TODO: Анимация появления текста
                ? Text(widget.label, style:  TextStyle(fontSize: 15))
                : SizedBox(width: 1),
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
              onTap: () => !_animation.isCompleted ? _controller.forward() : _controller.reset(),
            ),
            _controller.isAnimating
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
}
