import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/Adapt.dart';

class ShowModalBottomSheet {
  static void showBottomModal(BuildContext context,
      {required List modalList,
      required Function fn,
      Function? switchChange,
      String? name}) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Adapt.pt(18)),
              topRight: Radius.circular(Adapt.pt(12)))),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(12),
                child: Text(
                  name ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(
                      0xffaeaeae,
                    ),
                    fontSize: Adapt.pt(12),
                  ),
                ),
              ),
             Divider(
                height: Adapt.pt(1.5),
                color: Color(
                  0xffaeaeae,
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Adapt.pt(6), horizontal: Adapt.pt(12)),
                  child: Column(
                    children: [
                      for (int i = 0; i < modalList.length; i++)
                        buildSheetItem(context, modalList, i, fn, setState)
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

// (BuildContext context) {
//           return SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   child: Text(
//                     "将联系人'测试屏蔽人名称名称名称'屏蔽，同事删除该联系人的聊天记录",
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       color: const Color(
//                         0xffaeaeae,
//                       ),
//                       fontSize: Adapt.pt(12),
//                     ),
//                   ),
//                 ),
//                 const Divider(
//                   height: 1.5,
//                   color: Color(
//                     0xffaeaeae,
//                   ),
//                 ),
//                 Container(
//                     padding: EdgeInsets.symmetric(
//                         vertical: Adapt.pt(6), horizontal: Adapt.pt(12)),
//                     child: Column(
//                       children: [
//                         for (int i = 0; i < modalList.length; i++)
//                           buildSheetItem(modalList, i, fn,)
//                       ],
//                     ))
//               ],
//             ),
//           );
//         })

bool isSwitch = false;

Widget buildSheetItem(
    BuildContext context, List list, int i, Function fn, setState) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: Adapt.pt(6)),
    child: InkWell(
      onTap: () {
        fn(i, list[i]);
        if (list[i]['isSwitch'] == null) {
          Navigator.pop(context);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  list[i]['icon'],
                  size: Adapt.pt(30),
                ),
                SizedBox(width: Adapt.pt(6)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list[i]['name'],
                      style: TextStyle(
                          fontSize: Adapt.pt(16), fontWeight: FontWeight.w400),
                    ),
                    list[i]['description'] != null
                        ? Text(
                            list[i]['description'],
                            style: TextStyle(
                              fontSize: Adapt.pt(12),
                              color: const Color(
                                0xffaeaeae,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
          list[i]['isSwitch'] != null
              ? CupertinoSwitch(
                  value: list[i]['isSwitch'],
                  onChanged: (bool val) {
                    setState(() {
                      list[i]['isSwitch'] = !list[i]['isSwitch'];
                    });
                    list[i]['switchChange'](list[i]['isSwitch']);
                  },
                )
              : Container(),
        ],
      ),
    ),
  );
}
