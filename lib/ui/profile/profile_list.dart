import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/ui/auth/auth.dart';
import 'package:nike/ui/favorite/favorite_screen.dart';
import 'package:nike/ui/profile/profile_item.dart';
import 'package:nike/ui/record/record_screen.dart';

class ProfileList extends StatelessWidget {
  final List<String> titles = ['لیست علاقه مندی ها', 'سوابق سفارش'];
  final List<Icon> icons = [
    const Icon(CupertinoIcons.heart),
    const Icon(CupertinoIcons.bag)
  ];
  ProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: titles.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Divider(
            color: Theme.of(context).dividerColor,
            height: 1,
          );
        } else if (index == 3) {
          return ValueListenableBuilder(
            valueListenable: AuthRepository.authChangeNotifir,
            builder: (BuildContext context, value, Widget? child) {
              final login = value != null;
              return ProfileItem(
                icon: Icon(login
                    ? CupertinoIcons.arrow_right_square
                    : CupertinoIcons.arrow_left_square),
                title: login ? 'خروج از حساب کاربری' : 'ورود به حساب کاربری',
                onTap: () {
                  if (login) {
                    showDialog(
                      context: context,
                      builder: (context) => Directionality(
                        textDirection: TextDirection.rtl,
                        child: AlertDialog(
                          title: const Text('خروج از حساب کاربری'),
                          content:
                              const Text('آیا میخواهید از حساب خود خارج شوید؟'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('خیر')),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  authRepository.signOut();
                                  CartRepository.countChangeNotifier.value = 0;
                                },
                                child: const Text('بله')),
                          ],
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                      builder: (context) => const AuthScreen(),
                    ));
                  }
                },
              );
            },
          );
        } else if (index == 1) {
          return ProfileItem(
            icon: icons[index - 1],
            title: titles[index - 1],
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const FavoriteScreen(),
              ));
            },
          );
        } else if (index == 2) {
          return ProfileItem(
            icon: icons[index - 1],
            title: titles[index - 1],
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const RecordScreen(),
              ));
            },
          );
        } else {
          return ProfileItem(
            icon: icons[index - 1],
            title: titles[index - 1],
            onTap: () {},
          );
        }
      },
    );
  }
}
