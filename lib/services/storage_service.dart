import 'package:admin/models/database_wrapper.dart';

abstract class IStorageService {
  Future<int> retrieveDatabaseVersion();

  Future updateDatabase(DatabaseWrapper models);
}