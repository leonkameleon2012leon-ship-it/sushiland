import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onInteract;
  final VoidCallback onMenu;

  const ActionButtons({
    Key? key,
    required this.onInteract,
    required this.onMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ActionButton(
          label: 'A',
          color: Colors.green,
          onPressed: onInteract,
        ),
        SizedBox(height: 10),
        ActionButton(
          label: 'Menu',
          color: Colors.blue,
          onPressed: onMenu,
          width: 80,
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final double width;

  const ActionButton({
    Key? key,
    required this.label,
    required this.color,
    required this.onPressed,
    this.width = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
