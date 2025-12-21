import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/core/core.dart';
import 'package:twitterclone/core/provider.dart';
import 'package:twitterclone/core/result.dart';

abstract class IAuthAPI {
  FutureResult<User> signUp({required String email, required String password});
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
}
