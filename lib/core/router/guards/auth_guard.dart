import 'package:auto_route/auto_route.dart';
import 'package:kamkor/core/router/app_router.dart';
import 'package:kamkor/features/auth/presentation/bloc/auth_bloc.dart';

/// Allows navigation only when [AuthBloc] reports an authenticated session;
/// otherwise redirects to [LoginRoute]. Deep-link defense — the main gate is
/// the auth listener in `App`.
class AuthGuard extends AutoRouteGuard {
  AuthGuard(this._authBloc);

  final AuthBloc _authBloc;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_authBloc.state is Authenticated) {
      resolver.next();
    } else {
      resolver.redirectUntil(const LoginRoute());
    }
  }
}
