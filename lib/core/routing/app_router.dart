import 'package:fuel_pro_360/features/auth/presentation/pages/auth_page.dart';
import 'package:fuel_pro_360/features/auth/presentation/providers/global_auth_provider.dart';
import 'package:fuel_pro_360/features/customers/presentation/pages/customer_screen.dart';
import 'package:fuel_pro_360/features/draft_indents/presentation/pages/complete_draft_indent_screen.dart';
import 'package:fuel_pro_360/features/draft_indents/presentation/pages/draft_indents_screen.dart';
import 'package:fuel_pro_360/features/home/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/pages/record_indent.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/pages/end_shift_screen.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/pages/shift_management_screen.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/pages/start_new_shift.dart';

part 'app_router.g.dart';

GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

enum AppPath {
  login,
  home,
  recordIndent,
  customers,
  shiftManagement,
  draftIndents,
  startNewShift,
  endShift,
  completeIndent,
}

@riverpod
String? routerRedirect(Ref ref) {
  final globalAuth = ref.watch(globalAuthProvider);

  if (!globalAuth.isAuthenticated) {
    return '/${AppPath.login.name}';
  }

  return null;
}

@Riverpod(keepAlive: true)
class NavigationObserver extends _$NavigationObserver
    implements NavigatorObserver {
  @override
  void build() {
    //TODO add this authRepositoryProvider as per base project
    // final repository = ref.watch(authRepositoryProvider);
    // _getUserProfile = GetUser
  }

  @override
  void didChangeTop(Route topRoute, Route? previousTopRoute) {
    // TODO: implement didChangeTop
  }

  //TODO implement this when you want to perform something on navigation
  @override
  void didPop(Route route, Route? previousRoute) {
    // TODO: implement didPop
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    // TODO: implement didPush
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    // TODO: implement didRemove
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    // TODO: implement didReplace
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    // TODO: implement didStartUserGesture
  }

  @override
  void didStopUserGesture() {
    // TODO: implement didStopUserGesture
  }

  @override
  NavigatorState? get navigator => null;
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  ref.watch(routerRedirectProvider);

  final navigationObserver = ref.watch(navigationObserverProvider.notifier);

  return GoRouter(
    navigatorKey: navigatorKey,
    observers: [navigationObserver],
    initialLocation: '/${AppPath.login.name}',
    routes: [
      GoRoute(
        path: '/${AppPath.login.name}',
        name: AppPath.login.name,
        builder: (context, state) => AuthPage(),
      ),
      GoRoute(
        path: '/${AppPath.home.name}',
        name: AppPath.home.name,
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/${AppPath.recordIndent.name}',
        name: AppPath.recordIndent.name,
        builder: (context, state) => RecordIndent(),
      ),
      GoRoute(
        path: '/${AppPath.customers.name}',
        name: AppPath.customers.name,
        builder: (context, state) => CustomerScreen(),
      ),
      GoRoute(
        path: '/${AppPath.shiftManagement.name}',
        name: AppPath.shiftManagement.name,
        builder: (context, state) => ShiftManagementScreen(),
      ),
      GoRoute(
        path: '/${AppPath.draftIndents.name}',
        name: AppPath.draftIndents.name,
        builder: (context, state) => DraftIndentsScreen(),
      ),
      GoRoute(
        path: '/${AppPath.startNewShift.name}',
        name: AppPath.startNewShift.name,
        builder: (context, state) => StartNewShift(),
      ),
      GoRoute(
        path: '/${AppPath.endShift.name}',
        name: AppPath.endShift.name,
        builder: (context, state) => EndShiftScreen(),
      ),
      GoRoute(
        path: '/${AppPath.completeIndent.name}',
        name: AppPath.completeIndent.name,
        builder: (context, state) => CompleteDraftIndentScreen(),
      ),
    ],
    redirect: (context, state) {
      return ref.read(routerRedirectProvider);
    },
  );
}
