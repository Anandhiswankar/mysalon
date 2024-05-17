import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';

class CustomInputBox extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final String placeholder;
  final IconData icons;

  bool isNumber;
  bool enable = true;

  CustomInputBox({
    super.key,
    required this.placeholder,
    required this.icons,
    required this.controller,
    required this.text,
    this.enable = true,
    this.isNumber = false,
  });

  @override
  State<CustomInputBox> createState() => _CustomInputBoxState();
}

class _CustomInputBoxState extends State<CustomInputBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(61, 0, 0, 0),
                blurRadius: 2.2,
                offset: Offset(0, 3),
                spreadRadius: 0.2)
          ]),
      child: TextField(
        controller: widget.controller,
        enabled: widget.enable,
        maxLength: widget.isNumber ? 10 : 1000,
        keyboardType:
            widget.isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
            counterText: '',
            prefixIcon: Icon(
              widget.icons,
              size: 30,
              color: primeColor,
            ),
            hintText: widget.placeholder),
      ),
    );
  }
}
