import 'package:flutter_application_1/theme/theme.dart';

class InputDecortions {
  static InputDecoration authInputDecoration({
    required String hinText,
    required String labelText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      enabledBorder: _borderStyle(MyTheme.primary.withOpacity(0.6), 1.5),
      focusedBorder: _borderStyle(MyTheme.primary, 2),
      hintText: hinText,
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: MyTheme.primary)
          : null,
      filled: true,
      fillColor: Colors.grey.shade100,
      focusedErrorBorder: _borderStyle(Colors.red, 2),
      errorBorder: _borderStyle(Colors.red.withOpacity(0.6), 1.5),
    );
  }

  static OutlineInputBorder _borderStyle(Color color, double width) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
      borderRadius: BorderRadius.circular(8),
    );
  }
}