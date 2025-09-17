import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CommanText extends StatelessWidget {

  final String text;
  final TextStyle textStyle;

   const CommanText({super.key, 
     required this.text,
     required this.textStyle,
   });

  @override
  Widget build(BuildContext context) {
    return (text.isNotEmpty) ? Text(text,style: textStyle,) : Container();
  }



}
