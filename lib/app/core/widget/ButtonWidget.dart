import 'package:flutter/material.dart';

import '../utils/colour.dart';
import '../values/text_styles.dart';

class ButtonWidget extends StatelessWidget {

  final String text;
  final Function()? onClicked;

  const ButtonWidget({
     Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onClicked,
    child: Container(
      alignment: Alignment.center,
      padding:  const EdgeInsets.symmetric(vertical: 0,horizontal: 16),
      margin: const EdgeInsets.only(top: 0,bottom: 16,left: 16,right: 16),
      height: MediaQuery.of(context).size.height/15,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color:Clr.buttoBgColor,
      ),
      child: Text(
        text,
        textScaleFactor: 1,
      ),
    ),
  );
}