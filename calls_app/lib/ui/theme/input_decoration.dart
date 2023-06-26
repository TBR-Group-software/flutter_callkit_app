import 'package:flutter/material.dart';

import '../../gen/colors.gen.dart';

InputDecoration phoneInputDecoration({
  required String hintText,
  required TextStyle? hintStyle,
}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    filled: true,
    fillColor: AppColors.white2,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: BorderSide.none,
    ),
    hintText: hintText,
    hintStyle: hintStyle,
  );
}
