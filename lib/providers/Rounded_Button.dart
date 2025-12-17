import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool filled;


  const RoundedButton({super.key, required this.text, required this.onPressed, this.filled = true});


  @override
  Widget build(BuildContext context) {
    final btn = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
      ),
      child: Text(text),
    );


    if (filled) return SizedBox(width: double.infinity, child: btn);


// outlined style
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
        ),
        child: Text(text),
      ),
    );
  }
}
