import 'package:flutter/material.dart';

class BouncingButton extends StatefulWidget {
  final String text;
  final Function onPressed;
  final Color color;
  final Color? buttonColor;

  const BouncingButton({super.key, required this.text, required this.onPressed, this.color = Colors.blue, required this.buttonColor});

  @override
  BouncingButtonState createState() => BouncingButtonState();
}

class BouncingButtonState extends State<BouncingButton> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  Color _buttonColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(_animationController);
    _buttonColor = widget.buttonColor!;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _buttonColor = widget.color;
        });
        _animationController.forward();
      },
      onTapUp: (_) {
        setState(() {
          _buttonColor = widget.buttonColor!;
        });
        _animationController.reverse();
      },
      onTapCancel: () {
        setState(() {
          _buttonColor = widget.buttonColor!;
        });
        _animationController.reverse();
      },
      onTap: () => widget.onPressed(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _buttonColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(widget.text, style: const TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ),
    );
  }
}
