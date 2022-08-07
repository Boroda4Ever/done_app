import 'package:flutter/material.dart';

import '../../../common/architecture_widgets/not_found_navigation_widget.dart';
import '../../../features/task_view_and_create/presentation/pages/task_create_page.dart';
import '../../../features/task_view_and_create/presentation/task_view/task_view_page.dart';
import '../../constants/navigation/navigation_constants.dart';

class NavigationRoute {
  static final NavigationRoute _instance = NavigationRoute._init();
  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavigationConstants.defaultRoute:
        return normalNavigate(const TaskViewPage(),
            NavigationConstants.defaultRoute, settings.arguments);

      case NavigationConstants.taskView:
        return normalNavigate(const TaskViewPage(),
            NavigationConstants.taskView, settings.arguments);

      case NavigationConstants.taskCreateView:
        return normalNavigate(TaskCreatePage(),
            NavigationConstants.taskCreateView, settings.arguments);

      // case NavigationConstants.ON_BOARD:
      //   return normalNavigate(OnBoardView(), NavigationConstants.ON_BOARD);

      // case NavigationConstants.SETTINGS_WEB_VIEW:
      //   if (args.arguments is SettingsDynamicModel) {
      //     return normalNavigate(
      //       SettingsDynamicView(model: args.arguments as SettingsDynamicModel),
      //       NavigationConstants.SETTINGS_WEB_VIEW,
      //     );
      //   }
      //   throw NavigateException<SettingsDynamicModel>(args.arguments);

      default:
        return MaterialPageRoute(
          builder: (context) => const NotFoundNavigationWidget(),
        );
    }
  }

  MaterialPageRoute normalNavigate(
      Widget widget, String pageName, Object? args) {
    return MaterialPageRoute(
        builder: (context) => widget,
        //analytciste görülecek olan sayfa ismi için pageName veriyoruz
        settings: RouteSettings(name: pageName, arguments: args));
  }
}
