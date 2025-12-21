import 'package:twitterclone/core/result.dart';

typedef FutureResult<T> = Future<Result<T>>;
typedef FutureEitherVoid = FutureResult<void>;
typedef FutureVoid = Future<void>;
