import 'dart:async';
import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/config/app_colors.dart';
import 'package:quiz/config/app_text_styles.dart';
import 'package:quiz/config/constants.dart';
import 'package:quiz/config/spacer.dart';
import 'package:quiz/cubit/quizz_cubit.dart';
import 'package:quiz/features/quiz/widgets.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with WidgetsBindingObserver {
  ValueNotifier<int> current_second = ValueNotifier(-1);
  ValueNotifier<int> random_number = ValueNotifier(-1);
  ValueNotifier<int> countdown = ValueNotifier(-1);
  Timer get_current_second_timer =
      Timer.periodic(Duration(seconds: 1), (timer) {});
  late Animation<Color> value_color;
  int success = 0;

  int total = 0;

  bool is_app_minimize = false;

  final CountDownController countDownController = CountDownController();

  get_random_number() {
    final random = Random();

    random_number.value = random.nextInt((4)) + current_second.value - 2;
  }

  get_current_second() {
    get_current_second_timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!is_app_minimize) {
        current_second.value = DateTime.now().second;
        get_random_number();
      }
    });
  }

  on_click() {
    get_current_second_timer.cancel();
    BlocProvider.of<QuizzCubit>(context).on_click(
        current_second: current_second.value,
        random_number: random_number.value);
    if (countDownController.isStarted) {
      countDownController.pause();
    }
  }

  when_app_minimzed() {
    is_app_minimize = true;
    if (countDownController.isStarted) {
      countDownController.pause();
    }
  }

  when_app_resumed() {
    is_app_minimize = false;
    if (countDownController.isPaused) {
      countDownController.resume();
    }
  }

  on_start() {
    get_current_second();
    BlocProvider.of<QuizzCubit>(context).on_start();
    countDownController.restart();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    get_current_second();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
    get_current_second_timer.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      when_app_minimzed();
    } else if (state == AppLifecycleState.resumed) {
      // App is in the foreground
      when_app_resumed();
    }
  }

  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Quizz"),
      ),
      body: Padding(
          padding: screen_padding,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CountingContainers(
                      title: "Current seconds",
                      valueNotifier: current_second,
                    ),
                  ),
                  width20,
                  Expanded(
                    child: CountingContainers(
                      title: "Random number",
                      valueNotifier: random_number,
                    ),
                  )
                ],
              ),
              height20,
              BlocConsumer<QuizzCubit, QuizzState>(listener: (context, state) {
                if (state is SuccesState) {
                  success = success + 1;
                  total = total + 1;
                } else if (state is FailureState) {
                  total = total + 1;
                } else if (state is TimerState) {
                  // on_start();
                }

                // TODO: implement listener
              }, builder: (context, state) {
                return Container(
                  padding: screen_padding,
                  decoration: BoxDecoration(
                      color: state is TimerState
                          ? AppColor.purple_color
                          : state is FailureState
                              ? AppColor.primary_color
                              : AppColor.green_color,
                      borderRadius: radius),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state is TimerState
                            ? "All the best and Best of Luck"
                            : state is SuccesState
                                ? "Yayy ! Success, You are great"
                                : "Sorry ! you missed this time Try again",
                        style: AppTextStyle.blackHeader1
                            .copyWith(color: Colors.white),
                      ),
                      Divider(
                        thickness: .5,
                        color: Colors.black,
                      ),
                      Text(
                        "Attempts: " + total.toString(),
                        style: AppTextStyle.subHeader4
                            .copyWith(color: Colors.white),
                      ),
                      Divider(
                        thickness: .5,
                        color: Colors.black,
                      ),
                      Text(
                        "Score: " +
                            success.toString() +
                            " / " +
                            total.toString(),
                        style: AppTextStyle.blackHeader4
                            .copyWith(color: Colors.white),
                      ),
                      height10,
                    ],
                  ),
                );
              }),
              Spacer(),
              BlocBuilder<QuizzCubit, QuizzState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      CircularCountDownTimer(
                        isReverseAnimation: true,
                        width: screen_width / 3,
                        height: screen_width / 3,
                        duration: 6,
                        fillColor: AppColor.green_color,
                        ringColor: Colors.grey.shade300,
                        strokeWidth: 10,
                        isReverse: true,
                        textFormat: CountdownTextFormat.MM_SS,
                        controller: countDownController,
                        // onStart: (){
                        //   on_start();
                        // },
                        onComplete: () {
                          on_click();
                        },
                      ),
                      height20,
                      height20,
                      height20,
                      MaterialButton(
                        minWidth: double.infinity,
                        padding: screen_padding,
                        color: AppColor.button_color,
                        onPressed: () {
                          if (state is TimerState) {
                            on_click();
                          } else {
                            on_start();
                          }
                        },
                        child: Text(state is TimerState ? "Click" : "Start"),
                      ),
                    ],
                  );
                },
              ),
              height20,
            ],
          )),
    );
  }
}
