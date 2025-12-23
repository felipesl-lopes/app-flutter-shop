import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final String _title;
  final void Function() _onPressed;

  SendButton(this._title, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _onPressed,
      child: Text(_title, style: TextStyle(color: Colors.white, fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
