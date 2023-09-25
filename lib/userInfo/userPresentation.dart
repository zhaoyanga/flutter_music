import 'package:flutter/material.dart';
import '../common/Adapt.dart';

class UserPresentation extends StatefulWidget {
  const UserPresentation({super.key, required this.accountInfo});
  final Map accountInfo;
  @override
  State<UserPresentation> createState() => _UserPresentationState();
}

class _UserPresentationState extends State<UserPresentation> {
  @override
  void initState() {
    super.initState();
  }

  void getUserDetail() {}
  @override
  Widget build(BuildContext context) {
    Adapt.initialize(context);
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: Adapt.pt(34)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Adapt.pt(18)),
            boxShadow: [
              BoxShadow(
                blurRadius: Adapt.pt(10), //阴影范围
                spreadRadius: 0.1, //阴影浓度
                color: Colors.grey.withOpacity(0.2), //阴影颜色
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: Adapt.pt(12), top: Adapt.pt(32)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.accountInfo['nickname'],
                      style: TextStyle(
                        fontSize: Adapt.pt(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: Adapt.pt(6)),
                    Container(
                      height: Adapt.pt(18),
                      margin: EdgeInsets.only(top: Adapt.pt(2)),
                      child: Image.network(
                          "https://p5.music.126.net/obj/wo3DlcOGw6DClTvDisK1/4417174727/92fe/d574/3f90/5a848e3068b16fafac6b6c5138457f80.png"),
                    )
                  ],
                ),
                SizedBox(height: Adapt.pt(6)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: Adapt.pt(12),
                          color: const Color(
                            0xffaeaeae,
                          ),
                        ),
                        children: [
                          TextSpan(
                              text: "${widget.accountInfo['follows'] ?? 0}"),
                          const TextSpan(text: " 关注")
                        ],
                      ),
                    ),
                    SizedBox(width: Adapt.pt(12)),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: Adapt.pt(12),
                          color: const Color(
                            0xffaeaeae,
                          ),
                        ),
                        children: const [
                          TextSpan(text: "0"),
                          TextSpan(text: " 粉丝")
                        ],
                      ),
                    ),
                    SizedBox(width: Adapt.pt(12)),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: Adapt.pt(12),
                          color: const Color(
                            0xffaeaeae,
                          ),
                        ),
                        children: [
                          const TextSpan(text: "Lv."),
                          TextSpan(text: "${widget.accountInfo['leval'] ?? 0}")
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          child: Center(
            child: Container(
              width: Adapt.pt(60),
              height: Adapt.pt(60),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(widget.accountInfo['avatarUrl']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
