import 'package:admin/models/database_metadata.dart';
import 'package:admin/models/database_wrapper.dart';

abstract class IStorageService {
  Future<DatabaseMetadata> retrieveDatabaseMetadata();

  Future<DatabaseMetadata> publishDatabase(DatabaseWrapper models);
}