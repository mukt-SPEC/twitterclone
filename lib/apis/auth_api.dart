import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/core/core.dart';
import 'package:twitterclone/core/provider.dart';
import 'package:twitterclone/core/result.dart';

abstract class IAuthAPI {
  FutureResult<User> signUp({required String email, required String password});
  FutureResult<Session> signIn({
    required String email,
    required String password,
  });

  Future<User?> currentUser();
}

final authAPIProvider = Provider<AuthApi>((ref) {
  final account = ref.watch(Dependency.account);
  return AuthApi(account: account);
});

class AuthApi implements IAuthAPI {
  final Account _account;
  AuthApi({required Account account}) : _account = account;

  @override
  FutureResult<User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );

      return Success(user);
    } on AppwriteException catch (e, stackTrace) {
      return Error(Failure(e.message, stackTrace));
    } catch (e, stackTrace) {
      return Error(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureResult<Session> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      _account.get();
      return Success(account);
    } on AppwriteException catch (e, stackTrace) {
      return Error(Failure(e.toString(), stackTrace));
    } catch (e, stackTrace) {
      return Error(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<User?> currentUser() async {
    try {
      return await _account.get();
    } on AppwriteException catch (e) {
      e.message;
      return null;
    } catch (e) {
      return null;
    }
  }
}
