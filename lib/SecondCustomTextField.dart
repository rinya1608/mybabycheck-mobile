import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondCustomTextField extends StatefulWidget {
  const SecondCustomTextField(
      {Key? key, required this.hintText, required this.controller})
      : super(key: key);

  final String hintText;
  final TextEditingController controller;

  @override
  _SecondCustomTextFieldState createState() => _SecondCustomTextFieldState();
}

class _SecondCustomTextFieldState extends State<SecondCustomTextField> {
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

  Color _getTextColor() {
    return _focusNode.hasFocus ? Colors.cyan : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      style: TextStyle(color: _getTextColor(), fontSize: 18.0),
      focusNode: _focusNode,
      decoration: InputDecoration(
          hintText: widget.hintText,
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 3),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyan, width: 3),
              borderRadius: BorderRadius.all(Radius.circular(10.0)))),
    );
  }
}
