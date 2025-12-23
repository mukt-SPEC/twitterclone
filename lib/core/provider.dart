import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitterclone/constants/constants.dart';

final _clientProvider = Provider<Client>(
  (ref) => Client()
    ..setProject(AppwriteEnvironment.appwriteProjectId)
    ..setSelfSigned(status: true)
    ..setEndpoint(AppwriteEnvironment.appwritePublicEndpoint),
);
final _accountProvider = Provider<Account>((ref) {
  final client = ref.watch(_clientProvider);
  return Account(client);
});
final _databaseProvider = Provider<Databases>(
  (ref) => Databases(ref.read(_clientProvider)),
);
final _realtimeProvider = Provider<Realtime>(
  (ref) => Realtime(ref.read(_clientProvider)),
);
final _tableDatabse = Provider<TablesDB>(
  (ref) => TablesDB(ref.read(_clientProvider)),
);

abstract class Dependency {
  static Provider<Client> get client => _clientProvider;
  static Provider<Databases> get database => _databaseProvider;
  static Provider<Account> get account => _accountProvider;
  static Provider<Realtime> get realtime => _realtimeProvider;
  static Provider<TablesDB> get tablesDb => _tableDatabse;
}
