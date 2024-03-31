import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class custom_text_form_field extends StatelessWidget {
  const custom_text_form_field(
      {super.key,
      this.hintText,
      this.prefixIcon,
      required this.controller,
      this.isEnable = true,
      this.onChange,
      required this.textInputType});
  final String? hintText;
  final Widget? prefixIcon;
  final TextEditingController controller;
  final bool isEnable;
  final Function(String)? onChange;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChange,
      enabled: isEnable,
      controller: controller,
      textAlign: TextAlign.left,
      textAlignVertical: TextAlignVertical.center,
      //  obscureText: true,
      keyboardType: textInputType,
      cursorColor: AppColors.color707070,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(22)),
        ),
        prefixIcon: prefixIcon,
        // suffixIconColor: AppColors.color707070,
        hintText: hintText,
        // label: Text(
        //   "Password",
        //   style: TextStyle(color: AppColors.color707070),
        // ),
        // border: OutlineInputBorder(),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(22),
          ),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(22),
          ),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(22),
          ),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
    );
  }
}
