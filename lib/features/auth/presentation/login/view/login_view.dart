import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/localization/locale_cubit.dart';
import 'package:kamkor/core/router/app_router.dart';
import 'package:kamkor/core/theme/app_motion.dart';
import 'package:kamkor/core/theme/app_spacing.dart';
import 'package:kamkor/core/widgets/state_views/loading_view.dart';
import 'package:kamkor/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kamkor/features/auth/presentation/login/bloc/login_bloc.dart';
import 'package:kamkor/features/auth/presentation/login/widgets/link_input_field.dart';
import 'package:kamkor/features/auth/presentation/login/widgets/pin_input_field.dart';
import 'package:kamkor/features/auth/presentation/login/widgets/qr_scanner_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // While the global session check runs, this screen doubles as the splash.
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthInitial || authState is AuthLoading) {
          return Scaffold(
            body: SafeArea(
              child: LoadingView(
                message: AppLocalizations.of(context).checking_session,
              ),
            ),
          );
        }
        return const _LoginContent();
      },
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen: (prev, curr) =>
          curr.status == LoginStatus.success ||
          (prev.phase == LoginPhase.enterLink &&
              curr.phase == LoginPhase.enterPin),
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          // Hand the session to the global bloc; the router navigates.
          context.read<AuthBloc>().add(AuthLoggedIn(state.session!));
          return;
        }
        // The link/QR just validated: acknowledge before the phase animates.
        unawaited(HapticFeedback.mediumImpact());
        // Icon tint follows the shared snackBarTheme (inverse surface).
        final onSnack = Theme.of(context).colorScheme.onInverseSurface;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 1),
              content: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: onSnack),
                  const SizedBox(width: AppSpacing.sm),
                  Text(l.login_link_valid),
                ],
              ),
            ),
          );
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                AnimatedSwitcher(
                  duration: AppMotion.resolve(context, AppMotion.long),
                  child: state.phase == LoginPhase.enterLink
                      ? _LinkPhase(state: state)
                      : _PinPhase(state: state),
                ),
                const Positioned(
                  top: 0,
                  right: 0,
                  child: _LanguageToggle(),
                ),
                if (state.isLoading) const _LoadingOverlay(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LinkPhase extends StatelessWidget {
  const _LinkPhase({required this.state});

  final LoginState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // Link-related errors render under the input; others as a generic message.
    final linkError = switch (state.error) {
      LoginError.linkRequired => l.login_link_required,
      LoginError.linkInvalid => l.login_link_invalid,
      _ => null,
    };
    return SingleChildScrollView(
      key: const ValueKey('link'),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Icon(
            Icons.shield_outlined,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l.login_title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.login_subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.login_link_origin,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          QrScannerView(
            enabled: !state.isLoading,
            onDetected: (raw) =>
                context.read<LoginBloc>().add(AccessTokenSubmitted(raw)),
          ),
          const SizedBox(height: AppSpacing.xl),
          _OrDivider(label: l.login_or_paste),
          const SizedBox(height: AppSpacing.lg),
          LinkInputField(
            enabled: !state.isLoading,
            errorText: linkError,
            onSubmit: (input) =>
                context.read<LoginBloc>().add(AccessTokenSubmitted(input)),
          ),
          if (state.error != LoginError.none && linkError == null) ...[
            const SizedBox(height: AppSpacing.md),
            _InlineError(message: _errorText(l, state.error)),
          ],
          const SizedBox(height: AppSpacing.xl),
          // Public reference is available without signing in.
          TextButton.icon(
            onPressed: () => unawaited(context.router.push(const InfoRoute())),
            icon: const Icon(Icons.info_outline),
            label: Text(l.info_title),
          ),
        ],
      ),
    );
  }
}

class _PinPhase extends StatefulWidget {
  const _PinPhase({required this.state});

  final LoginState state;

  @override
  State<_PinPhase> createState() => _PinPhaseState();
}

class _PinPhaseState extends State<_PinPhase> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocus = FocusNode();

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocus.dispose();
    super.dispose();
  }

  void _submit() {
    final pin = _pinController.text;
    if (pin.isEmpty) return;
    context.read<LoginBloc>().add(PinSubmitted(pin));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = widget.state;
    final pinError =
        state.error == LoginError.none ? null : _errorText(l, state.error);
    return BlocListener<LoginBloc, LoginState>(
      // On a rejected PIN, clear the field and keep focus so the user can
      // retype immediately.
      listenWhen: (prev, curr) =>
          prev.error != curr.error && curr.error != LoginError.none,
      listener: (context, _) {
        _pinController.clear();
        _pinFocus.requestFocus();
      },
      child: SingleChildScrollView(
        key: const ValueKey('pin'),
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () =>
                        context.read<LoginBloc>().add(const LoginRestarted()),
                icon: const Icon(Icons.arrow_back),
                label: Text(l.login_back),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Icon(
              Icons.lock_outline,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l.enter_pin,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            PinInputField(
              controller: _pinController,
              focusNode: _pinFocus,
              enabled: !state.isLoading,
              onCompleted: _submit,
            ),
            if (pinError != null) ...[
              const SizedBox(height: AppSpacing.md),
              _InlineError(message: pinError),
            ],
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: state.isLoading ? null : _submit,
              child: Text(l.login_submit),
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact language switcher, reusing the app-wide [LocaleCubit].
class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cubit = context.read<LocaleCubit>();
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return PopupMenuButton<String>(
          icon: const Icon(Icons.language),
          tooltip: l.profile_language,
          initialValue: locale.languageCode == 'ru' ? 'ru' : 'ky',
          onSelected: (value) =>
              value == 'ru' ? cubit.setRussian() : cubit.setKyrgyz(),
          itemBuilder: (context) => [
            PopupMenuItem(value: 'ky', child: Text(l.language_kyrgyz)),
            PopupMenuItem(value: 'ru', child: Text(l.language_russian)),
          ],
        );
      },
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outlineVariant;
    return Row(
      children: [
        Expanded(child: Divider(color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Expanded(child: Divider(color: color)),
      ],
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Muted (non-SOS) error role + an icon, so the meaning is not colour-only.
    final color = theme.colorScheme.error;
    return Row(
      children: [
        Icon(Icons.error_outline, color: color, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    // Scrim from the theme instead of a raw Colors.black26 literal.
    final scrim = Theme.of(context).colorScheme.scrim.withValues(alpha: 0.32);
    return Positioned.fill(
      child: ColoredBox(
        color: scrim,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

String _errorText(AppLocalizations l, LoginError error) => switch (error) {
      LoginError.none => '',
      LoginError.linkRequired => l.login_link_required,
      LoginError.linkInvalid => l.login_link_invalid,
      LoginError.network => l.error_network,
      LoginError.timeout => l.error_timeout,
      LoginError.server => l.error_server,
      LoginError.wrongPin => l.pin_invalid,
      LoginError.unknown => l.error_unknown,
    };
