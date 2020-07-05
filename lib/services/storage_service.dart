import 'package:admin/models/database_wrapper.dart';

abstract class IStorageService {
  Future<int> retrieveDatabaseVersion();

  Future<int> publishDatabase(DatabaseWrapper models);
}