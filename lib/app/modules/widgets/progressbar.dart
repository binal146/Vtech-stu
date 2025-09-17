import 'package:flutter/material.dart';
import '../../core/utils/colour.dart';

class ProgressBar extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final Color color;

  const ProgressBar({
    key,
    required this.child,
    required this.inAsyncCall,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = List<Widget>.empty(growable: true);
    widgetList.add(child);
    if (inAsyncCall) {
      final modal = Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 5,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.42,
                      child: const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: Clr.venderFont,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}