import 'package:flutter/foundation.dart';
import 'package:nike/data/auth_info.dart';
import 'package:nike/data/source/auth_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/http_client.dart';

final authRepository = AuthRepository(AuthRemoteDataSource(httpClient));

abstract class IAuthRepository {
  Future<void> login(String username, String password);
  Future<void> signUp(String username, String password);
  Future<void> refreshToken();
  Future<void> signOut();
}

class AuthRepository implements IAuthRepository {
  final IAuthDataSource dataSource;
  static final ValueNotifier<AuthInfo?> authChangeNotifir = ValueNotifier(null);

  AuthRepository(this.dataSource);
  @override
  Future<void> login(String username, String password) async {
    final AuthInfo authInfo = await dataSource.login(username, password);
    _saveAuthTokens(authInfo);
  }

  @override
  Future<void> signUp(String username, String password) async {
    final authInfo = await dataSource.signUp(username, password);
    _saveAuthTokens(authInfo);
  }

  @override
  Future<void> refreshToken() async {
    if (authChangeNotifir.value != null) {
      final AuthInfo authInfo = await dataSource.refreshToken(authChangeNotifir.value!.refreshToken);
      _saveAuthTokens(authInfo);
      
    }
  }

  Future<void> _saveAuthTokens(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString("access_token", authInfo.accessToken);
    sharedPreferences.setString("refresh_token", authInfo.accessToken);
    sharedPreferences.setString("email", authInfo.email);
    loadAuthInfo();
  }

  Future<void> loadAuthInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String accessToken =
        sharedPreferences.getString('access_token') ?? '';
    final String refreshToken =
        sharedPreferences.getString('refresh_token') ?? '';
    final String email =
        sharedPreferences.getString('email') ?? '';

    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      authChangeNotifir.value = AuthInfo(accessToken, refreshToken, email);
    }
  }

  @override
  Future<void> signOut() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.clear();
    authChangeNotifir.value = null;
  }
}
