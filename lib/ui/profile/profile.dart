import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/ui/profile/profile_list.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('پروفایل'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
                width: 65,
                height: 65,
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(width: 1, color: themeData.dividerColor)),
                child: Image.asset('assets/img/nike_logo.png')),
            ValueListenableBuilder(
              valueListenable: AuthRepository.authChangeNotifir,
              builder: (context, value, child) {
                return Text(
                  value != null ? value.email : 'کاربر مهمان',
                  style: themeData.textTheme.bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                );
              },
            ),
            const SizedBox(
              height: 32,
            ),
            Expanded(child: ProfileList())
          ],
        ),
      ),
    );
  }
}
