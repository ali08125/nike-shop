// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/data/repo/cart_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository authRepository;
  final ICartRepository cartRepository;
  bool isLogin;
  AuthBloc(this.authRepository, this.cartRepository, {this.isLogin = true})
      : super(AuthInitial(isLogin)) {
    on<AuthEvent>((event, emit) async {
      try {
        if (event is AuthButtonClicked) {
          emit(AuthLoading(isLogin));
          if (isLogin) {
            await authRepository.login(event.username, event.password);
            await cartRepository.count();
            emit(AuthSuccess(isLogin));
          } else {
            await authRepository.signUp(event.username, event.password);
            emit(AuthSuccess(isLogin));
          }
        } else if (event is AuthModeChangeClicked) {
          isLogin = !isLogin;
          emit(AuthInitial(isLogin));
        }
      } catch (e) {
        emit(AuthError(AppExceptions(), isLogin));
      }
    });
  }
}
