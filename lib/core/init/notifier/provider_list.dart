import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:uuid/uuid.dart';

import '../data_service/data_service.dart';
import '../navigation/navigation_service.dart';
import '../theme/theme_service.dart';

class ApplicationProvider {
  static ApplicationProvider? _instance;
  static ApplicationProvider get instance {
    _instance ??= ApplicationProvider._init();
    return _instance!;
  }

  ApplicationProvider._init();

  List<SingleChildWidget> singleItems = [];
  List<SingleChildWidget> dependItems = [
    // StreamProvider<List<TaskModel>>(
    //     create: (context) => TaskDataNotifier().getTasks(),
    //     initialData: []),
    ChangeNotifierProvider(
      create: (context) => DataService(),
    ),
    ChangeNotifierProvider(
      create: (context) => ThemeService(),
    ),
    Provider.value(value: NavigationService.instance)
  ];
  List<SingleChildWidget> uiChangesItems = [];
}
