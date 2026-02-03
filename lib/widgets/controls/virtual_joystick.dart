import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class VirtualJoystick extends StatefulWidget {
  final Function(Vector2) onDirectionChanged;

  const VirtualJoystick({Key? key, required this.onDirectionChanged}) : super(key: key);

  @override
  _VirtualJoystickState createState() => _VirtualJoystickState();
}

class _VirtualJoystickState extends State<VirtualJoystick> {
  Offset _dragPosition = Offset.zero;
  bool _isDragging = false;

  void _handleDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragPosition = Offset(
        _dragPosition.dx + details.delta.dx,
        _dragPosition.dy + details.delta.dy,
      );

      double distance = _dragPosition.distance;
      if (distance > 50) {
        _dragPosition = Offset.fromDirection(
          _dragPosition.direction,
          50,
        );
      }

      Vector2 direction = Vector2(
        _dragPosition.dx / 50,
        _dragPosition.dy / 50,
      );
      widget.onDirectionChanged(direction);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
      _dragPosition = Offset.zero;
      widget.onDirectionChanged(Vector2.zero());
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handleDragStart,
      onPanUpdate: _handleDragUpdate,
      onPanEnd: _handleDragEnd,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black26,
          border: Border.all(color: Colors.white54, width: 3),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: _dragPosition,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isDragging ? Colors.red : Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
