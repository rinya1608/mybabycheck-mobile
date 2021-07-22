import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextFieldDatePicker extends StatefulWidget {
  const CustomTextFieldDatePicker(
      {Key? key, required this.hintText, required this.controller})
      : super(key: key);

  final String hintText;
  final TextEditingController controller;

  @override
  _CustomTextFieldDatePickerState createState() =>
      _CustomTextFieldDatePickerState();
}

class _CustomTextFieldDatePickerState extends State<CustomTextFieldDatePicker> {
  late FocusNode _focusNode;
  late String dateString = widget.controller.text.isNotEmpty
      ? widget.controller.text
      : "Выберите дату";

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
        controller: widget.controller..text = dateString,
        style: TextStyle(color: _getTextColor(), fontSize: 18.0),
        focusNode: _focusNode,
        decoration: InputDecoration(
            hintText: dateString,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 3),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.cyan, width: 3),
                borderRadius: BorderRadius.all(Radius.circular(10.0)))),
        readOnly: true,
        onTap: () async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1960),
              initialDate: DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            dateString = date.year.toString() +
                "-" +
                date.month.toString() +
                "-" +
                date.day.toString();
          }
        });
  }
}
