import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:quiz/config/app_colors.dart';

class TimerWidget extends StatelessWidget {
  final CountDownController countDownController;
  final double size;
 final  void Function() on_complete;
  const TimerWidget({super.key, required this.countDownController,required  this.size, required this.on_complete});

  @override
  Widget build(BuildContext context) {
    return   CircularCountDownTimer(
      onStart: (){
        countDownController.pause();
      },
                        isReverseAnimation: true,
                        width: size,
                        height: size,
                        duration: 6,
                        fillColor: AppColor.green_color,
                        ringColor: Colors.grey.shade300,
                        strokeWidth: 10,
                        isReverse: true,
                        textFormat: CountdownTextFormat.MM_SS,
                        controller: countDownController,
                  
                        onComplete:on_complete
                      );
  }
}