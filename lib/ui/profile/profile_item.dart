import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ProfileItem extends StatelessWidget {
  final Icon icon;
  final String title;
  final Function() onTap;
  const ProfileItem({super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 56,
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                icon,
                const SizedBox(
                  width: 16,
                ),
                Text(
                  title,
                  style: themeData.textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        Divider(
          color: themeData.dividerColor,
          height: 1,
        ),
      ],
    );
  }
}
