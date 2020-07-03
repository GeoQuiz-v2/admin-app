import 'package:admin/models/database_wrapper.dart';
import 'package:admin/services/storage_service.dart';

class CloudStorageService implements IStorageService {
  @override
  Future<int> retrieveDatabaseVersion() {
    throw UnimplementedError();
  }

  @override
  Future updateDatabase(DatabaseWrapper models) {
    throw UnimplementedError();
  }
}