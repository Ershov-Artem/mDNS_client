import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget{
  final String text;
  final Function() onTap;
  final double height;
  final double width;
  final BoxDecoration decoration;

  CustomButton({required this.onTap, required this.text, required this.height, required this.width, required this.decoration});
  @override
  Widget build(BuildContext context)=>GestureDetector(
    onTap: onTap,
    child: Container(
    width: width,
    height: height,
    decoration: decoration,
    child: Align(
    alignment: Alignment.center,
    child: Text(text, style: Theme.of(context).textTheme.button,
    textAlign: TextAlign.center,),
    )
    )
  );
}