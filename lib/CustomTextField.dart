import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {Key? key,
      required this.hintText,
      required this.prefixIcon,
      required this.controller,
      this.obsureText = false})
      : super(key: key);

  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final bool obsureText;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = new FocusNode();
    _focusNode.addListener(_onOnFocusNodeEvent);
  }

  _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  Color _getPrefixIconColor() {
    return _focusNode.hasFocus ? Colors.cyan : Colors.grey;
  }

  Color _getTextColor() {
    return _focusNode.hasFocus ? Colors.cyan : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obsureText,
      style: TextStyle(color: _getTextColor(), fontSize: 18.0),
      focusNode: _focusNode,
      decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(
            widget.prefixIcon,
            color: _getPrefixIconColor(),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 3),
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyan, width: 3),
              borderRadius: BorderRadius.all(Radius.circular(30.0)))),
    );
  }
}
