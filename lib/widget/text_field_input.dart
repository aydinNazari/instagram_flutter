import 'package:flutter/material.dart';

class TextFieldInput extends StatefulWidget {
  const TextFieldInput({
    Key? key,
    required this.size,
    required this.hintText,
    required this.isPass,
    required this.textInputType,
    required this.value,
    required this.ctrlVisibility,
    this.iconOnPress,
  }) : super(key: key);

  final String hintText;
  final bool isPass;
  final bool ctrlVisibility;
  final TextInputType textInputType;
  final Size size;
  final Function(String) value;
  final void Function()? iconOnPress;

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  bool control = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width,
      height: widget.size.height / 12,
      decoration: BoxDecoration(
        color: const Color(0xff181818),
        borderRadius: BorderRadius.all(
          Radius.circular(widget.size.width / 40),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: widget.size.width / 25,
          ),
          Expanded(
            child: TextField(
              onChanged: widget.value,
              obscureText: widget.ctrlVisibility,
              keyboardType: widget.textInputType,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.size.width / 25),
            child: InkWell(
              onTap: widget.iconOnPress,
              child: Icon(
                widget.isPass && widget.ctrlVisibility == false
                    ? Icons.visibility_off
                    : widget.isPass == false
                        ? null
                        : widget.ctrlVisibility == false
                            ? Icons.visibility_off
                            : Icons.visibility,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
