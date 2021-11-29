import 'package:flutter/material.dart';
import 'package:food_rating_app/common/styles.dart';
import 'package:lottie/lottie.dart';

class AnimationPlaceholder extends StatelessWidget {
  final String animation;
  final String text;
  final bool hasButton;
  final String? buttonText;
  final Function()? onButtonTap;
  const AnimationPlaceholder({
    Key? key,
    required this.animation,
    required this.text,
    this.hasButton = false,
    this.buttonText,
    this.onButtonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            animation,
            width: 180.0,
            height: 180.0,
          ),
          const SizedBox(height: 24.0),
          SizedBox(
            width: 280.0,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyles.kRegularBody.copyWith(
                fontSize: 18.0,
              ),
            ),
          ),
          const SizedBox(height: 18.0),
          hasButton
              ? ElevatedButton(
                  child: Text(
                    buttonText ?? '',
                    style: TextStyles.kRegularTitle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 14.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: onButtonTap,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
