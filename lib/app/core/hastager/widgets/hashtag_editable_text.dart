
import 'package:flutter/cupertino.dart';

import '../composer/composer.dart';
import '../detector/detector.dart';


/// Show decorated tagged text while user is inputting text.
///
/// [decoratedStyle] is textStyle of tagged text.
/// [basicStyle] is textStyle of others.
/// EditableText which decorates the contents start with "#"
class HashTagEditableText extends EditableText {
  HashTagEditableText({
    super.key,
    FocusNode? focusNode,
    required super.controller,
    required TextStyle basicStyle,
    required this.decoratedStyle,
    required super.cursorColor,
    required this.decorateAtSign,
    this.onDetectionTyped,
    this.onDetectionFinished,
    super.onChanged,
    super.onSubmitted,
    super.maxLines = null,
    super.minLines,
    TextInputType? keyboardType,
    bool? autofocus,
    super.obscureText,
    super.readOnly,
    super.forceLine,
    ToolbarOptions super.toolbarOptions = const ToolbarOptions(
      copy: true,
      cut: true,
      paste: true,
      selectAll: true,
    ),
    super.autocorrect,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.textCapitalization,
    super.locale,
    super.textScaleFactor,
    super.expands,
    super.selectionColor,
    super.selectionControls,
    super.textInputAction,
    super.onEditingComplete,
    super.onSelectionChanged,
    super.onSelectionHandleTapped,
    super.inputFormatters,
    super.cursorWidth,
    super.cursorRadius,
    super.cursorOpacityAnimates,
    super.cursorOffset,
    super.paintCursorAboveText,
    super.selectionHeightStyle,
    super.selectionWidthStyle,
    super.keyboardAppearance,
    super.scrollPadding,
    super.dragStartBehavior,
    super.scrollController,
    super.scrollPhysics,
    super.showCursor,
    super.showSelectionHandles,
    super.rendererIgnoresPointer = true,
    super.backgroundCursorColor = CupertinoColors.inactiveGray,
    bool super.enableInteractiveSelection = true,
    super.autocorrectionTextRectColor,
    super.obscuringCharacter,
    super.onAppPrivateCommand,
    super.mouseCursor,
    super.autofillHints = null,
    super.restorationId,
    super.cursorHeight,
  }) : super(
          focusNode: (focusNode) ?? FocusNode(),
          style: basicStyle,
          keyboardType: (keyboardType) ?? TextInputType.text,
          autofocus: (autofocus) ?? false,
        );

  final ValueChanged<String>? onDetectionTyped;

  final VoidCallback? onDetectionFinished;

  final TextStyle decoratedStyle;

  final bool decorateAtSign;

  @override
  HashTagEditableTextState createState() => HashTagEditableTextState();
}

/// State of [HashTagEditableText]
///
/// Return decorated tagged text by using functions in [Detector]
class HashTagEditableTextState extends EditableTextState {
  @override
  HashTagEditableText get widget => super.widget as HashTagEditableText;

  late Detector detector;

  Detection? prevTypingDetection;

  @override
  void initState() {
    super.initState();
    detector = Detector(
        textStyle: widget.style,
        decoratedStyle: widget.decoratedStyle,
        decorateAtSign: widget.decorateAtSign);
    widget.controller.addListener(() {
      _onValueUpdated.call();
    });
  }

  void _onValueUpdated() {
    final detections = detector.getDetections(textEditingValue.text);
    final composer = Composer(
      selection: textEditingValue.selection.start,
      onDetectionTyped: widget.onDetectionTyped,
      sourceText: textEditingValue.text,
      decoratedStyle: widget.decoratedStyle,
      detections: detections,
      composing: textEditingValue.composing,
    );

    final typingDetection = composer.typingDetection();
    if (prevTypingDetection != null && typingDetection == null) {
      widget.onDetectionFinished?.call();
    }
    prevTypingDetection = typingDetection;
    if (detections.isNotEmpty) {
      /// use [dComposer] to show composing underline
      detections.sort();
      if (widget.onDetectionTyped != null) {
        composer.callOnDetectionTyped();
      }
    }
  }

  @override
  TextSpan buildTextSpan() {
    final detections = detector.getDetections(textEditingValue.text);
    final composer = Composer(
      selection: textEditingValue.selection.start,
      onDetectionTyped: widget.onDetectionTyped,
      sourceText: textEditingValue.text,
      decoratedStyle: widget.decoratedStyle,
      detections: detections,
      composing: textEditingValue.composing,
    );
    if (detections.isEmpty) {
      /// use same method as default textField to show composing underline
      return widget.controller.buildTextSpan(
        context: context,
        style: widget.style,
        withComposing: !widget.readOnly,
      );
    }
    return composer.getComposedTextSpan();
  }
}
