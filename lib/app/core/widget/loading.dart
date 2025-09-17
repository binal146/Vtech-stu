import 'package:flutter/material.dart';

import '../utils/colour.dart';
import '/app/core/values/app_values.dart';
import '/app/core/widget/elevated_container.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.transparent,
      child: Center(
        child: ElevatedContainer(
          padding: EdgeInsets.all(AppValues.margin),
          child: CircularProgressIndicator(
            color: Clr.appColor,
          ),
        ),
      ),
    );
  }
}
