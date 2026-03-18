import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpField extends StatelessWidget {
  const OtpField(
      {super.key,
      required this.otpValue,
      required this.maxLength,
      this.enableField = true,
      required this.lable});
  final int maxLength;
  final TextEditingController otpValue;
  final bool? enableField;
  final String lable;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 185,
        child: TextFormField(
          enabled: enableField,
          controller: otpValue,
          keyboardType: TextInputType.number,
          maxLength: maxLength,
          textAlign: TextAlign.center,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: '',
            labelText: lable,
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.grey, width: 3),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
          validator: (value) {
            // Ensure the input is exactly 5 digits
            if (value == null || value.isEmpty) {
              return 'Please enter the ${lable}';
            } else if (value.length != maxLength) {
              return '${lable} must be $maxLength digits';
            }
            return null;
          },
          style: const TextStyle(
              letterSpacing: 15), // Adds space between the characters
        ),
      ),
    );
  }
}
