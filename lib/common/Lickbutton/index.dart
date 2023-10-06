import 'package:flutter/material.dart';
import '../Assets_Images.dart';
import '../Adapt.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({
    super.key,
    required this.likedCount,
    required this.fn,
    required this.index,
    required this.liked,
  });
  final int likedCount;
  final Function fn;
  final int index;
  final bool liked;
  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _iconAnimation;
  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    // _iconAnimation = Tween(begin: 1.0, end: 1.3).animate(_animationController);

    _iconAnimation = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.3)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(_animationController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return InkWell(
      onTap: () {
        _clickIcon(widget.index);
      },
      child: ScaleTransition(
        scale: _iconAnimation,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(top: Adapt.pt(2)),
              child: Text("${widget.likedCount}",style:TextStyle(
                color:widget.liked ? Colors.red : Colors.black,
              )),
            ),
            SizedBox(width: Adapt.pt(6)),
            widget.liked ? Image.asset(
                            AssetsImages.lickPng,
                            width: Adapt.pt(15),
                            color: Colors.red,
                          ) : Image.asset(
                            AssetsImages.lickPng,
                            width: Adapt.pt(15),
                            color: Colors.black,
                          )
          ],
        ),
      ),
    );
  }

  _clickIcon(int index) {
    if (_iconAnimation.status == AnimationStatus.forward ||
        _iconAnimation.status == AnimationStatus.reverse) {
      return;
    }
    widget.fn(index);
    if (_iconAnimation.status == AnimationStatus.dismissed) {
      _animationController.forward();
    } else if (_iconAnimation.status == AnimationStatus.completed) {
      _animationController.reverse();
    }
  }
}
