import 'package:flutter/material.dart';

Widget dropDown(
    {required List<String> itemList,
      required String labelText,
      String validateText = "Required !",
      String helperText = "Completed",
      bool hasIcon = false,
      IconData icon = Icons.check,
      Color iconColor = Colors.black45,
      bool hasPrefixIcon = false,
      IconData prefixIcon = Icons.keyboard,
      Color prefixIconColor = Colors.grey,
      required void Function(String?) onChanged}) {
  return DropdownButtonFormField(
    autovalidateMode: AutovalidateMode.always,
    validator: (String? val) {
      if (itemList.contains(val)) {
        return null;
      } else {
        return validateText;
      }
    },
    decoration: InputDecoration(
      // labelText: labelText,
      helperText: helperText,
      icon: hasIcon
          ? Icon(
        icon,
        size: 36.0,
        color: iconColor,
      )
          : null,

      prefixIcon: hasPrefixIcon ? Icon(prefixIcon, color: prefixIconColor) : null,

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
    items: itemList.map<DropdownMenuItem<String>>((String newValue) {
      return DropdownMenuItem(
        value: newValue,
        child: Text(newValue),
      );
    }).toList(),
    onChanged: onChanged,
  );
}