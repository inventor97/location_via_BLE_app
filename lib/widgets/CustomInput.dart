import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInput extends StatelessWidget {
  final ValueChanged<String>? onChange;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? hint;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final String? labelText;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final Color borderColor;
  final bool obscureText;
  final int? errorTextLine;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final bool isTextCenter;

  const CustomInput({
    this.onChange,
    this.controller,
    this.suffixIcon,
    this.prefixIcon,
    this.hint,
    this.keyboardType,
    this.focusNode,
    this.inputFormatters,
    this.labelText,
    this.validator,
    this.borderColor = Colors.lightBlueAccent,
    this.obscureText = false,
    this.errorTextLine,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.isTextCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        validator: validator,
        focusNode: this.focusNode,
        onChanged: this.onChange,
        inputFormatters: inputFormatters,
        autofocus: false,
        controller: this.controller,
        keyboardType: this.keyboardType,
        cursorColor: Colors.black,
        obscureText: this.obscureText,
        enabled: this.enabled,
        textAlign: isTextCenter ? TextAlign.center : TextAlign.start,
        textCapitalization: this.textCapitalization,
        decoration: InputDecoration(
          errorMaxLines: errorTextLine,
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          hintText: this.hint,
          suffixIcon: this.suffixIcon,
          prefixIcon: this.prefixIcon,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: this.borderColor),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: this.borderColor),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
    );
  }
}
