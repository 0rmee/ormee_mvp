import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_mvp/designs/OrmeeColor.dart';
import 'package:ormee_mvp/designs/OrmeeTypo.dart';

class OrmeeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final IconData? leftIcon;
  final VoidCallback? leftAction;
  final Widget? rightIcon;
  final VoidCallback? rightAction;

  const OrmeeAppBar({
    Key? key,
    this.title,
    this.leftIcon,
    this.leftAction,
    this.rightIcon,
    this.rightAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: OrmeeColor.white,
      backgroundColor: OrmeeColor.white,
      elevation: 0,
      leading: IconButton(
        onPressed: leftAction ?? () => Get.back(),
        icon: leftIcon != null
            ? Icon(leftIcon, color: OrmeeColor.gray[800])
            : SvgPicture.asset(
                'assets/icons/left.svg',
                color: OrmeeColor.gray[800],
              ),
      ),
      // title 부분을 Obx로 감싸서 반응형으로 만듦
      title: Obx(() => T3_18px(
            text: title ?? "Ormee",
          )),
      centerTitle: true,
      actions: rightIcon != null
          ? [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: IconButton(
                  onPressed: rightAction ?? () {},
                  icon: rightIcon!,
                ),
              ),
            ]
          : [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}