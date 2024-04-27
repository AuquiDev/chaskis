import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:chaskis/utils/custom_text.dart';
import 'package:chaskis/widgets/state_signal_icons.dart';

class CardTitleFormPax extends StatelessWidget {
  const CardTitleFormPax({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
                  delay: const Duration(milliseconds: 400),
      child: SafeArea(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/img/andeanlodges.png',
                        height: 80,
                      ),
                    ],
                  ),
                   const OfflineSIgnalButon(),
                  const SizedBox(width: 80,)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15, right: 30, left: 30, bottom: 20),
                child: Column(
                  children: [
                    H2Text(
                      text: title,
                      fontSize: 13,
                      maxLines: 10,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
