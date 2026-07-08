import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kamkor/app/home/home_page.dart';
import 'package:kamkor/core/router/guards/auth_guard.dart';
import 'package:kamkor/features/auth/presentation/login/page/login_page.dart';
import 'package:kamkor/features/contacts/presentation/page/contacts_page.dart';
import 'package:kamkor/features/info/domain/entities/info_section.dart';
import 'package:kamkor/features/info/presentation/page/info_detail_page.dart';
import 'package:kamkor/features/info/presentation/page/info_page.dart';
import 'package:kamkor/features/info/presentation/page/info_section_page.dart';
import 'package:kamkor/features/message_template/presentation/page/message_template_page.dart';
import 'package:kamkor/features/profile/presentation/page/profile_page.dart';
import 'package:kamkor/features/sos/presentation/page/sos_page.dart';
import 'package:kamkor/features/sos_history/presentation/page/sos_history_detail_page.dart';
import 'package:kamkor/features/sos_history/presentation/page/sos_history_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter(this._authGuard);

  final AuthGuard _authGuard;

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page, initial: true),
        // Authenticated shell: bottom-nav tabs with the raised SOS button in
        // the center. The guard on the parent protects every tab.
        AutoRoute(
          page: HomeRoute.page,
          guards: [_authGuard],
          children: [
            AutoRoute(page: ContactsRoute.page),
            // Reference info is a shell tab; the SOS message template moved to
            // the SOS screen's app bar (pushed over the shell, see below).
            AutoRoute(page: InfoRoute.page),
            AutoRoute(page: SosRoute.page, initial: true),
            AutoRoute(page: SosHistoryRoute.page),
            AutoRoute(page: ProfileRoute.page),
          ],
        ),
        // Detail pushed over the whole shell (bubbles to the root stack).
        AutoRoute(page: SosHistoryDetailRoute.page, guards: [_authGuard]),
        // SOS message template — reached from the SOS app bar; pushed over the
        // shell as authenticated content.
        AutoRoute(page: MessageTemplateRoute.page, guards: [_authGuard]),
        // Public reference — also a shell tab (above); kept top-level so it is
        // reachable from login without authentication.
        AutoRoute(page: InfoRoute.page),
        AutoRoute(page: InfoSectionRoute.page),
        AutoRoute(page: InfoDetailRoute.page),
      ];
}
