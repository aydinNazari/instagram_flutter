import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color background;
  final Color borderColor;
  final Color textColor;
  final String text;

  const FollowButton(
      {Key? key,
      this.function,
      required this.background,
      required this.borderColor,
      required this.text,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: function,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width / 55,
        ),
        child: Container(
          width: size.width / 1.8,
          height: size.width / 12,
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            color: background,
            borderRadius: BorderRadius.all(
              Radius.circular(
                size.width / 80,
              ),
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: size.width / 25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
