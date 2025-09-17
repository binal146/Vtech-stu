import 'package:flutter/material.dart';
import '../utils/colour.dart';
import '/app/core/widget/app_bar_title.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String appBarTitleText;
  final String subTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool isBackButtonEnabled;
  final bool isCenterTitle;
  final bool ismaintitle;
  final double? leadingWidth;

  const CustomAppBar({
    Key? key,
    required this.appBarTitleText,
    this.actions,
    this.leading,
    this.leadingWidth,
    this.ismaintitle=false,
    this.isBackButtonEnabled = true,
    this.isCenterTitle = true,
    this.subTitle = "",
  }) : super(key: key);

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Clr.white,
      centerTitle: isCenterTitle,
      elevation: 2,
      automaticallyImplyLeading: isBackButtonEnabled,
      actions: actions,
      leading: leading,
      leadingWidth: leadingWidth,
      iconTheme: const IconThemeData(color:  Clr.black),
      title: AppBarTitle(text: appBarTitleText,ismaintitle:ismaintitle,subtitle: subTitle, ),
    );
  }
}
