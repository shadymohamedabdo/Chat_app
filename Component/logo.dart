import 'package:flutter/material.dart';

class customLogo extends StatelessWidget {
  const customLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return   Center(
        child: CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: 40,
            child:
            Image(image: AssetImage('image/shady.jpg'),height: 50,width: 50,)
        )
    );

  }
}