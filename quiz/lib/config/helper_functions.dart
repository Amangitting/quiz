import 'package:flutter/material.dart';

replace_screen(BuildContext context, screen){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>screen));
}