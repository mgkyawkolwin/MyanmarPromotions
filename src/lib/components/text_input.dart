import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget textInput(
    {String labelText = "Text Input Field",
      String helperText = "Completed",
      String validateText = "Required !",
      bool obscureText = false,
      bool hasIcon = false,
      IconData icon = Icons.keyboard,
      Color iconColor = Colors.grey,
      bool hasPrefixIcon = false,
      IconData prefixIcon = Icons.keyboard,
      Color prefixIconColor = Colors.grey,
      bool hasIconButton = false,
      IconData iconButton = Icons.check,
      VoidCallback onPressedIconButton = defaultCallBackForTextInput,
      Function(String) onChanged = defaultOnChangedForTextInput,
      bool readOnly = false,
      maxLines = 1,
      TextInputType inputType = TextInputType.text,
      required TextEditingController textEditingController}) {
  return TextFormField(
    controller: textEditingController,
    keyboardType: inputType,
    obscureText: obscureText,
    autovalidateMode: AutovalidateMode.always,
    validator: (String? val) {
      if (val == null || val.isEmpty) {
        return validateText;
      } else {
        return null;
      }
    },
    onChanged: onChanged,
    readOnly: readOnly,
    maxLines: maxLines,
    decoration: InputDecoration(
      // labelText: labelText,
      prefixIcon: hasPrefixIcon ? Icon(prefixIcon, color: prefixIconColor) : null,
      helperText: helperText,
      icon: hasIcon
          ? Icon(
        icon,
        size: 36.0,
        color: iconColor,
      )
          : null,
      suffixIcon: hasIconButton
          ? IconButton(
        onPressed: onPressedIconButton,
        icon: Icon(iconButton),
      )
          : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black45, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black45, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
  );
}

dynamic defaultOnChangedForTextInput(String a) {
  //ignore: avoid_print
  print("Default On Tap");
}

dynamic defaultCallBackForTextInput() {
  //ignore: avoid_print
  print("default callback");
}