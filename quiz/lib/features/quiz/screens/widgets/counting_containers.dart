import 'package:flutter/material.dart';
import 'package:quiz/config/app_colors.dart';
import 'package:quiz/config/app_text_styles.dart';
import 'package:quiz/config/constants.dart';

class CountingContainers extends StatelessWidget {
  final String title;
  final ValueNotifier<int> valueNotifier;
  const CountingContainers(
      {super.key, required this.title,  required this.valueNotifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screen_padding_value, vertical: screen_padding_value),
      decoration: BoxDecoration(
          color: AppColor.blue_color,
          borderRadius: radius,
          border: Border.all(color: AppColor.button_color)),
      child: Column(
        children: [
          Text(
            title,
            style: AppTextStyle.blackHeader4,
          ),
          Divider(
            thickness: 2,
          ),
          ValueListenableBuilder<int>(
            valueListenable: valueNotifier,
            builder: (context, state,_) {
              return Text(
                state.toString(),
                style: AppTextStyle.blackHeader2,
              );
            },
          ),
        ],
      ),
    );
  }
}
