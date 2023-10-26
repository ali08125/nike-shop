part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState(this.isLogin);

  final bool isLogin;
  @override
  List<Object> get props => [isLogin];
}

class AuthInitial extends AuthState {
  const AuthInitial(super.isLogin);
}

class AuthLoading extends AuthState {
  const AuthLoading(super.isLogin);
}

class AuthError extends AuthState {
  final AppExceptions exception;

  const AuthError(this.exception, super.isLogin);
}

class AuthSuccess extends AuthState {
  const AuthSuccess(super.isLogin);
}
