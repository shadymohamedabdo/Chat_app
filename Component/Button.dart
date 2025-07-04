import 'package:flutter/material.dart';

class customButton extends StatelessWidget {
  final void Function()? onPressed;
  final Color color;
  final String text;
  const customButton({super.key, required this.color, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50)
      ),
      alignment: Alignment.center,
      child: MaterialButton(
        height: 40,
        minWidth: double.infinity,
        onPressed: onPressed,
        child: Text(text,style: TextStyle(color: Colors.white,fontSize: 20),),),
    );
    ();
  }
}