import 'package:flutter/material.dart';
import 'Adapt.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.fn,
      required this.style});
  final IconData icon;
  final String text;
  final Function fn;
  final ButtonStyle style;
  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return SizedBox(
      height: Adapt.pt(36),
      child: OutlinedButton.icon(
        icon: Icon(
          icon,
          size: Adapt.pt(16),
        ),
        label: Text(text),
        onPressed: () => fn(context),
        style: style,
      ),
    );
  }
}
