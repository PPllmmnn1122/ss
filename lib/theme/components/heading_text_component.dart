import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class WalkthroughWidget extends StatelessWidget {
  final WalkThroughModelClass data;

  const WalkthroughWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: [
          64.height,
          Image.asset(data.image.validate(),
              fit: BoxFit.cover, height: context.height() * 0.55),
          108.height,
          Text(data.title.validate(),
              textAlign: TextAlign.center, style: boldTextStyle(size: 24)),
          16.height,
          Text(
            data.subTitle.validate(),
            style: secondaryTextStyle(size: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
