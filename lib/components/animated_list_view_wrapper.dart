import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimatedListViewWrapper extends StatelessWidget {
  final int itemCount;
  final Function(int) child;
  const AnimatedListViewWrapper(
      {super.key, required this.itemCount, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  horizontalOffset: -50.0,
                  // return index to child
                  child: FadeInAnimation(child: child(index)),
                ),
              );
            }));
  }
}
