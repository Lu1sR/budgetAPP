import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final Function(String) function;
  final VoidCallback onPressed;
  final TextEditingController controller;

  const CustomTextForm(
      {Key key,
      this.hintText,
      this.prefixIcon,
      this.keyboardType,
      this.function,
      this.onPressed,
      this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTap: onPressed,
      onSaved: (input) => function(input),
      style: TextStyle(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
          color: Colors.indigo[400]),
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        hintStyle: TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
            color: Colors.indigo[200]),
        hintText: hintText,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.all(16),
      ),
      autofocus: false,
      keyboardType: keyboardType,
    );
  }
}
