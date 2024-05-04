import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double height;
  final Color backgroundColor, splashColor;
  final Function onPressed;
  final Widget child;
  final Color disabledColor;
  final double width;

  const CustomButton({
    Key key,
    @required this.height,
    this.width,
    this.backgroundColor,
    this.disabledColor,
    // this.backgroundColor = Colors.indigo,
    @required this.onPressed,
    this.splashColor = Colors.white30,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? 200,
      child: MaterialButton(
        disabledColor: disabledColor,
        splashColor: splashColor,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: backgroundColor ?? Colors.blue[600],
        elevation: 5.0,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
