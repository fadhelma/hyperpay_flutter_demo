import 'package:flutter/material.dart';
import '../Helper/constants.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPress;
  final String title;

  const CustomButton({Key? key, required this.onPress, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Set width to full width
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      // Optional margin
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: DefaultValues.mainColor, // Text color
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
