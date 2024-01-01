import 'package:flutter/material.dart';

class Button extends ImplicitlyAnimatedWidget {
  final bool active;

  final Function()? onPressed;
  final IconData icon;
  final Color? color, activeColor, iconColor, activeIconColor;

  const Button({
    Key? key,
    this.active = false,
    this.onPressed,
    this.color = Colors.white,
    this.activeColor = Colors.black,
    this.iconColor = Colors.black,
    this.activeIconColor = Colors.white,
    this.icon = Icons.block,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.ease,
  }) : super(key: key, duration: duration, curve: curve);


  @override
  AnimatedWidgetBaseState<Button> createState() => _ButtonState();
}

class _ButtonState extends AnimatedWidgetBaseState<Button> {
  ColorTween? _colorTween;

  ColorTween? _iconColorTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _colorTween = visitor(
      _colorTween,
      widget.active ? widget.activeColor : widget.color,
      (value) => ColorTween(begin: value)
    ) as ColorTween?;

    _iconColorTween = visitor(
      _iconColorTween,
      widget.active ? widget.activeIconColor : widget.iconColor,
      (value) => ColorTween(begin: value)
    ) as ColorTween?;
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: FittedBox(
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: _colorTween?.evaluate(animation),
          onPressed: widget.onPressed,
          child: Icon(
            widget.icon,
            color: _iconColorTween?.evaluate(animation),
            size: 28,
          ),
        ),
      ),
    );
  }
}