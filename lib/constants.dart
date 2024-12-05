import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(
      color: Colors.black,
    ));

Widget customTextField({
  String? Function(String?)? onChanged,
  required TextEditingController controller,
  required String? hintText,
  required String? Function(String?)? validator,
  int? maxLines,
  required bool isNumber,
  required String labelText,
}) {
  return TextFormField(
    onChanged: onChanged,
    maxLines: maxLines,
    keyboardType: isNumber ? const TextInputType.numberWithOptions() : null,
    inputFormatters: isNumber
        ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
        : [], //
    validator: validator,
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      border: border,
      enabledBorder: border,
    ),
  );
}
