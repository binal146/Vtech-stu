import 'package:flutter/material.dart';

import '/app/core/values/text_styles.dart';

class AppBarTitle extends StatelessWidget {
  final String text;
  final String subtitle;
  final bool ismaintitle;

  const AppBarTitle({Key? key, required this.text, this.ismaintitle=false,this.subtitle=""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: ismaintitle?appBarTitle:appBarTitle,
          textAlign: TextAlign.center,
        ),
        (subtitle.isNotEmpty) ? Text(
          subtitle,
          style: subTitle,
          textAlign: TextAlign.center,
        ) : SizedBox(),
      ],
    );
  }
}
