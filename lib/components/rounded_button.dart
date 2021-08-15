import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final String childText;
  final Function onTap;
  RoundedButton( {@required this.childText,this.color,this.onTap } );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onTap,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            childText,
            style:TextStyle( color: Colors.white ) 
          ),
        ),
      ),
    );
  }
}