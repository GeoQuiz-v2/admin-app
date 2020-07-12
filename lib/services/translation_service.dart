import 'package:admin/models/database_wrapper.dart';
import 'package:admin/utils/intl_resource.dart';

abstract class ITranslationService {
  Future translate(IntlResource resource, List<String> languages);
}