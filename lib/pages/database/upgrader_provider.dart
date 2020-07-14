import 'package:admin/services/database_service.dart';
import 'package:flutter/widgets.dart';


class UpgraderProvider extends ChangeNotifier {
  final IDatabaseService databaseService;

  UpgraderProvider({
    @required this.databaseService
  });

  Future upgrade(int currentVersion, int newVersion) async {
    await databaseService.upgrade(currentVersion, newVersion);
    notifyListeners();
  }
}