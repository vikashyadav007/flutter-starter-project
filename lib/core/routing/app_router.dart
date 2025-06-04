import 'package:starter_project/features/auth/presentation/pages/auth_page.dart';
import 'package:starter_project/features/auth/presentation/providers/global_auth_provider.dart';
import 'package:starter_project/features/home/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

enum AppPath { login, home, upcomingPayments, editUpcomingPayment, cardEmi }

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
    ],
    redirect: (context, state) {
      return ref.read(routerRedirectProvider);
    },
  );
}
