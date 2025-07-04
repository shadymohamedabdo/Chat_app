import 'package:flutter/material.dart';

class customTextForm extends StatelessWidget {
  final String hintText;
  final TextEditingController myController;
  final String validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onFieldSubmitted;
  const customTextForm({super.key, required this.hintText, required this.myController, required this.validator, this.prefixIcon, this.suffixIcon, this.onFieldSubmitted,  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,

      onFieldSubmitted : onFieldSubmitted,
      keyboardType: TextInputType.emailAddress,
      maxLength: 25,
      validator: (value){
        if(value!.isEmpty){
          return validator ;
        }
      },
      controller: myController,
      autocorrect: true,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        // when u press
        focusedBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Colors.blue,
            width: 3,
          ),
        ),
        hintText: hintText,
        // helperStyle: TextStyle(color: Colors.grey,fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        border:
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        enabled: true,
        enabledBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
    );
  }
}