import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Widget child;

  const GradientContainer({
    Key? key,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xff852CFF), Color.fromARGB(255, 115, 43, 179)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Container(
          width: width - 3,
          height: height - 3,
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(borderRadius)),
          child: child,
        ),
      ),
    );
  }
}

class BuildTextField extends StatelessWidget {
  const BuildTextField({
    Key? key,
    required this.t,
    required this.w,
    required this.context,
    required this.label,
    required this.hint,
    required this.controller,
    required this.node,
    this.nextNode,
    this.prefixIcon,
    required this.type,
    this.textData = '',
  }) : super(key: key);

  final ThemeData t;
  final double w;
  final BuildContext context;
  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode node;
  final FocusNode? nextNode;
  final IconData? prefixIcon;
  final TextInputType type;
  final String textData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: w,
          height: 50,
          child: TextFormField(
            textAlignVertical: TextAlignVertical.bottom,
            controller: controller,
            focusNode: node,
            keyboardType: type,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
            onFieldSubmitted: (String text) {
              FocusScope.of(context).requestFocus(nextNode);
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                focusColor: Colors.transparent,
                filled: true,
                fillColor: t.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(width: 0, style: BorderStyle.none),
                ),
                prefixIcon: prefixIcon == null
                    ? null
                    : Icon(
                        prefixIcon,
                        color: t.primaryColor,
                      ),
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff767676),
                )),
          ),
        ),
      ],
    );
  }
}
