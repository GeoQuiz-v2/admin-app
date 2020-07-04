import 'package:admin/models/model.dart';

abstract class IDao<T extends Model> {
  Future<Map<String, T>> list();
  Future<String> create(T model);
  Future update(T model);
  Future delete(T model);
}