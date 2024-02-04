import 'package:flutter/material.dart';
import 'package:quiz/config/app_text_styles.dart';
import 'package:quiz/config/helper_functions.dart';
import 'package:quiz/features/quiz/screens/quiz_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {


    Future.delayed(Duration(seconds: 3)).then((value) {

      replace_screen(context, QuizScreen());
      
    });
    return Scaffold(
      body: 
      Center(child: Text("Welcome",style: AppTextStyle.blackHeader3,),),
    );
  }
}