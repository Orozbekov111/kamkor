import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/router/app_router.dart';
import 'package:kamkor/core/theme/app_semantic_colors.dart';

/// A light haptic tick when a bottom-nav destination changes, so switching
/// tabs has the same tactile feedback as the rest of the app.
void _selectTab(TabsRouter tabsRouter, int index) {
  if (tabsRouter.activeIndex != index) {
    unawaited(HapticFeedback.selectionClick());
  }
  tabsRouter.setActiveIndex(index);
}

/// Authenticated shell: a bottom navigation bar with a raised, dominant SOS
/// button in the center. SOS stays the obvious primary action — not just one of
/// the tabs. The four side destinations own their own Scaffolds/AppBars; this
/// shell contributes only the bar and the center button.
///
/// Tab order matches the child-route order in [AppRouter]:
/// 0 Contacts · 1 Info · 2 SOS (center, default) · 3 History · 4 Profile.
@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _sosIndex = 2;

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        ContactsRoute(),
        InfoRoute(),
        SosRoute(),
        SosHistoryRoute(),
        ProfileRoute(),
      ],
      // Keep the bar put when a tab opens the keyboard (inner scaffolds handle
      // their own inset); the bar never rides up over the keyboard.
      resizeToAvoidBottomInset: false,
      // Lets tabs observe tab re-selection (e.g. the SOS tab refreshes its
      // contacts readiness hint on return). Fresh instance per builder call.
      navigatorObservers: () => [AutoRouteObserver()],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonBuilder: (context, tabsRouter) => _SosFab(
        onPressed: () => _selectTab(tabsRouter, _sosIndex),
      ),
      bottomNavigationBuilder: (context, tabsRouter) =>
          _BottomBar(tabsRouter: tabsRouter),
    );
  }
}

/// Raised, red, dominant SOS entry. Tapping it opens the SOS screen (idle),
/// where the deliberate hold-to-activate control lives — this button never
/// triggers the alarm itself.
class _SosFab extends StatelessWidget {
  const _SosFab({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final semantic = context.semantic;
    return Semantics(
      button: true,
      label: l.nav_sos_open,
      child: SizedBox(
        width: 68,
        height: 68,
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: semantic.sos,
          foregroundColor: semantic.onSos,
          // The one deliberate lift in the app: the SOS entry protrudes above
          // the bar so it reads as primary. Everything else stays flat.
          elevation: 3,
          highlightElevation: 3,
          shape: const CircleBorder(),
          tooltip: l.nav_sos_open,
          child: Text(
            l.sos_button,
            style: theme.textTheme.labelLarge?.copyWith(
              color: semantic.onSos,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.tabsRouter});

  final TabsRouter tabsRouter;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return DecoratedBox(
      // Hairline divider (not a shadow) marking the bar off from the content
      // above it — mirrors the AppBar's bottom border, keeps the flat look.
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: BottomAppBar(
        color: theme.colorScheme.surface,
        elevation: 0,
        height: 72,
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          children: [
            _NavItem(
              tabsRouter: tabsRouter,
              index: 0,
              icon: Icons.contacts_outlined,
              selectedIcon: Icons.contacts,
              label: l.nav_contacts,
            ),
            _NavItem(
              tabsRouter: tabsRouter,
              index: 1,
              icon: Icons.info_outline,
              selectedIcon: Icons.info,
              label: l.info_title,
            ),
            // Gap under the docked SOS button.
            const SizedBox(width: 72),
            _NavItem(
              tabsRouter: tabsRouter,
              index: 3,
              icon: Icons.history_outlined,
              selectedIcon: Icons.history,
              label: l.nav_history,
            ),
            _NavItem(
              tabsRouter: tabsRouter,
              index: 4,
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: l.profile_title,
            ),
          ],
        ),
      ),
    );
  }
}

/// A single bottom-bar destination: icon only (labels are dropped so long
/// Kyrgyz words can't truncate or collide with the docked SOS button).
/// Selection is conveyed by shape — filled icon when active, outlined when not
/// — plus the primary green tone, never colour alone (WCAG 1.4.1). Because
/// there is no visible text, the [label] drives a Semantics label and a
/// long-press tooltip so screen readers and sighted users can still name the
/// section (WCAG 1.1.1 / 4.1.2). Tap target is 72dp tall × ≥48dp wide.
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tabsRouter,
    required this.index,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final TabsRouter tabsRouter;
  final int index;
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = tabsRouter.activeIndex == index;
    final color = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: Tooltip(
          message: label,
          child: InkWell(
            onTap: () => _selectTab(tabsRouter, index),
            child: SizedBox(
              height: 72,
              child: Center(
                child: Icon(
                  selected ? selectedIcon : icon,
                  color: color,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
