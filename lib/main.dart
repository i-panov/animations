import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Animation')),
      body: Container(
          //width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedButton(label: 'Посмотреть в AR', onTap: () {
              print('AR button tapped!');
            }),
          )
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
      duration: new Duration(seconds: 3),
    );

    final tween = Tween<double>(begin: 10.0, end: 180.0);
    _animation = tween.animate(_controller);
    _animation.addListener(_toggleLabel);
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned(
        top: 25,
        left: 25,
        child: Container(
          width: 100 + _animation.value,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(80),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 5),
              BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(5, 5)),
            ],
          ),
          child: GestureDetector(
            child: Center(
              child: Text(widget.label),
            ),
            onTap: widget.onTap,
          ),
        ),
      ),
      GestureDetector(
        child: Container(
          child: Image.asset('assets/AR_icon-24.png', width: 100, height: 100),
        ),
        onTap: () => !_animation.isCompleted ? _controller.forward() : _controller.reset(),
      ),
    ],
  );
}
