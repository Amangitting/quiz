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
import 'package:quiz/features/quiz/screens/widgets/counting_containers.dart';
import 'package:quiz/features/quiz/screens/widgets/timer_widget.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with WidgetsBindingObserver {
  ValueNotifier<int> current_second = ValueNotifier(0);
  ValueNotifier<int> random_number = ValueNotifier(0);
  Timer get_current_second_timer =
      Timer.periodic(const Duration(seconds: 1), (timer) {});
  int success = 0;

  int total = 0;

  bool is_app_minimize = false;

  final CountDownController countDownController = CountDownController();

  get_random_number() {
    final random = Random();

    random_number.value = random.nextInt((4)) + current_second.value - 2;
  }

  get_current_second() {
    get_current_second_timer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
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
    countDownController.start();
    get_current_second();
    BlocProvider.of<QuizzCubit>(context).on_start();
    countDownController.restart();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // countDownController.pause();
    // get_current_second();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    get_current_second_timer.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      when_app_minimzed();
    } else if (state == AppLifecycleState.resumed) {
      when_app_resumed();
    }
  }

  Color get_color(QuizzState state) {
    if (state is InitState) {
      return AppColor.button_color;
    } else if (state is TimerState) {
      return AppColor.purple_color;
    } else if (state is SuccesState) {
      return AppColor.green_color;
    } else {
      return AppColor.primary_color;
    }
  }

  String get_title(QuizzState state) {
    if (state is InitState) {
      return "Let's start";
    } else if (state is TimerState) {
      return "All the best and Best of Luck";
    } else if (state is SuccesState) {
      return "Yayy ! Success, You are great";
    } else {
      return "Sorry ! you missed this time Try again";
    }
  }

  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blue_color,
        title: const Text("Quizz"),
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
                }

                // TODO: implement listener
              }, builder: (context, state) {
                return Container(
                  padding: screen_padding,
                  decoration: BoxDecoration(
                      color: get_color(state), borderRadius: radius),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        get_title(state),
                        style: AppTextStyle.blackHeader1
                            .copyWith(color: Colors.white),
                      ),
                      const Divider(
                        thickness: .5,
                        color: Colors.black,
                      ),
                      Text(
                        "Attempts: " + total.toString(),
                        style: AppTextStyle.subHeader2
                            .copyWith(color: Colors.white),
                      ),
                      const Divider(
                        thickness: .5,
                        color: Colors.black,
                      ),
                      Text(
                        "Score: " +
                            success.toString() +
                            " / " +
                            total.toString(),
                        style: AppTextStyle.blackHeader2
                            .copyWith(color: Colors.white),
                      ),
                      height10,
                    ],
                  ),
                );
              }),
    height20,
                      height20,
                      height20,              BlocBuilder<QuizzCubit, QuizzState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      TimerWidget(
                          countDownController: countDownController,
                          size: screen_width / 3,
                          on_complete: () {
                            on_click();
                          }),
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
                          } else if (state is InitState||state is FailureState||state is SuccesState) {
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
