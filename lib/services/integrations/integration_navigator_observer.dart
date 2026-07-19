import 'package:flutter/widgets.dart';
import 'package:pomodoro_sczuw/enums/page_navigation_action.dart';
import 'package:pomodoro_sczuw/services/integrations/events/integration_event.dart';
import 'package:pomodoro_sczuw/services/integrations/integration_bus.dart';

class IntegrationNavigatorObserver extends NavigatorObserver {
  final IntegrationBus _bus;

  IntegrationNavigatorObserver(this._bus);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _bus.publish(
      PageNavigated(
        fromRouteName: _routeName(previousRoute),
        toRouteName: _routeName(route),
        action: PageNavigationAction.push,
      ),
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _bus.publish(
      PageNavigated(
        fromRouteName: _routeName(route),
        toRouteName: _routeName(previousRoute),
        action: PageNavigationAction.pop,
      ),
    );
  }

  String? _routeName(Route<dynamic>? route) {
    if (route == null) return null;
    return route.settings.name ?? route.runtimeType.toString();
  }
}
