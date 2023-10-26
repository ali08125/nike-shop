import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/auth/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _usernameController =
      TextEditingController(text: 'test@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '123456');

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    const onBackground = Colors.white;
    return Theme(
      data: themeData.copyWith(
          snackBarTheme: SnackBarThemeData(
              backgroundColor: themeData.colorScheme.primary,
              contentTextStyle: const TextStyle(fontFamily: 'IranYekan')),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
             
                minimumSize: MaterialStateProperty.all(
                  const Size.fromHeight(56),
                ),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                )),
                backgroundColor: MaterialStateProperty.all(onBackground),
                foregroundColor:
                    MaterialStateProperty.all(themeData.colorScheme.secondary)),
          ),
          colorScheme: themeData.colorScheme.copyWith(onSurface: onBackground),
          inputDecorationTheme: InputDecorationTheme(
              labelStyle: const TextStyle(color: onBackground, fontSize: 12),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.white, width: 1)))),
      child: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
              backgroundColor: themeData.colorScheme.secondary,
              body: BlocProvider<AuthBloc>(
                create: (context) {
                  final bloc = AuthBloc(authRepository, cartRepository);
                  //run on state changing
                  bloc.stream.forEach((state) {
                    if (state is AuthSuccess) {
                      Navigator.of(context).pop();
                    } else if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.exception.message),
                      ));
                    }
                  });
                  bloc.add(AuthStarted());
                  return bloc;
                },
                child: BlocBuilder<AuthBloc, AuthState>(
                  //when widget should rebuild
                  buildWhen: (previous, current) {
                    return current is AuthLoading ||
                        current is AuthError ||
                        current is AuthInitial;
                  },
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(48, 0, 48, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/img/nike_logo.png',
                            height: 28,
                            color: onBackground,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            state.isLogin ? 'خوش آمدید' : 'ثبت نام',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            state.isLogin
                                ? 'لطفا وارد حساب کاربری خود شوید'
                                : 'ایمیل و رمز عبور خود را تعیین کنید',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextField(
                            controller: _usernameController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                label: Text('آدرس ایمیل')),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          PasswordTextField(
                            onBackground: onBackground,
                            controller: _passwordController,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<AuthBloc>(context).add(
                                    AuthButtonClicked(_usernameController.text,
                                        _passwordController.text));
                              },
                              child: state is AuthLoading
                                  ? const CircularProgressIndicator(
                                      color: LightThemeColors.secondaryColor,
                                    )
                                  : Text(state.isLogin ? 'ورود' : 'ثبت نام')),
                          const SizedBox(
                            height: 32,
                          ),
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(AuthModeChangeClicked());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.isLogin
                                      ? 'حساب کاربری ندارید؟'
                                      : 'حساب کاربری دارید؟',
                                  style: themeData.textTheme.bodySmall!
                                      .copyWith(fontSize: 12),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  state.isLogin ? 'ثبت نام' : 'ورود',
                                  style: themeData.textTheme.bodySmall!
                                      .copyWith(
                                          fontSize: 12,
                                          color: themeData.colorScheme.primary),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PasswordTextField extends StatefulWidget {
  PasswordTextField({super.key, 
    required this.onBackground,
    required this.controller,
  });

  final Color onBackground;
  bool showPassword = false;
  final TextEditingController controller;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.showPassword ? false : true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          label: const Text('رمز عبور'),
          suffixIcon: GestureDetector(
            onTap: () {},
            child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.showPassword = !widget.showPassword;
                });
              },
              child: Icon(
                widget.showPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: widget.onBackground.withOpacity(0.5),
              ),
            ),
          )),
    );
  }
}
