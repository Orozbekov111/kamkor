import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kamkor/core/theme/app_semantic_colors.dart';
import 'package:kamkor/core/theme/app_spacing.dart';

/// The primary SOS control: a single circular button that runs the whole
/// activation gesture inside itself.
///
/// 1. **Hold** — press and hold for 3s; a ring fills and short haptic ticks
///    pulse so the hold is felt. Releasing early cancels, so a stray touch
///    never triggers anything.
/// 2. **Countdown** — once the hold completes, a 5s countdown runs in the same
///    circle: a big number counts down over a draining ring, with a Cancel
///    button in the middle. If it isn't cancelled, [onActivate] fires at zero.
///
/// Two deliberate barriers (a 3s hold, then a 5s cancelable countdown) make an
/// accidental alarm almost impossible while a real one stays one gesture away.
class SosButton extends StatefulWidget {
  const SosButton({
    required this.onActivate,
    required this.label,
    required this.holdHint,
    required this.countdownHint,
    required this.cancelLabel,
    super.key,
  });

  final VoidCallback onActivate;
  final String label;

  /// Shown under the button while idle/holding.
  final String holdHint;

  /// Shown under the button during the countdown.
  final String countdownHint;

  /// Label of the in-circle cancel button during the countdown.
  final String cancelLabel;

  @override
  State<SosButton> createState() => _SosButtonState();
}

enum _SosPhase { idle, holding, countdown }

class _SosButtonState extends State<SosButton> with TickerProviderStateMixin {
  static const _size = 240.0;
  static const _holdDuration = Duration(seconds: 2);
  static const _countdownDuration = Duration(seconds: 5);
  // Short, frequent ticks while holding — the button "buzzes" under the finger.
  static const _holdTickInterval = Duration(milliseconds: 120);

  late final AnimationController _holdController = AnimationController(
    vsync: this,
    duration: _holdDuration,
  )..addStatusListener(_onHoldStatus);

  late final AnimationController _countdownController = AnimationController(
    vsync: this,
    duration: _countdownDuration,
  )
    ..addListener(_onCountdownTick)
    ..addStatusListener(_onCountdownStatus);

  Timer? _holdTicks;
  _SosPhase _phase = _SosPhase.idle;
  int _secondsLeft = _countdownDuration.inSeconds;

  // ---- Hold phase ---------------------------------------------------------

  void _startHold() {
    if (_phase != _SosPhase.idle) return;
    setState(() => _phase = _SosPhase.holding);
    unawaited(HapticFeedback.lightImpact());
    unawaited(_holdController.forward(from: 0));
    // Light impacts (stronger than a selection tick) at a steady beat.
    _holdTicks = Timer.periodic(
      _holdTickInterval,
      (_) => unawaited(HapticFeedback.lightImpact()),
    );
  }

  void _cancelHold() {
    if (_phase != _SosPhase.holding) return;
    _stopHoldTicks();
    unawaited(_holdController.reverse());
    setState(() => _phase = _SosPhase.idle);
  }

  void _onHoldStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && _phase == _SosPhase.holding) {
      _stopHoldTicks();
      // A firmer beat marks the switch from "holding" to "counting down".
      unawaited(HapticFeedback.mediumImpact());
      _startCountdown();
    }
  }

  void _stopHoldTicks() {
    _holdTicks?.cancel();
    _holdTicks = null;
  }

  // ---- Countdown phase ----------------------------------------------------

  void _startCountdown() {
    _holdController.value = 0; // clear the fill behind the countdown ring
    setState(() {
      _phase = _SosPhase.countdown;
      _secondsLeft = _countdownDuration.inSeconds;
    });
    unawaited(_countdownController.forward(from: 0));
  }

  void _onCountdownTick() {
    final remaining =
        (_countdownDuration.inMilliseconds * (1 - _countdownController.value) /
                1000)
            .ceil();
    final clamped = remaining.clamp(0, _countdownDuration.inSeconds);
    if (clamped != _secondsLeft) {
      setState(() => _secondsLeft = clamped);
      // One light tick per second as the number changes.
      if (clamped > 0) unawaited(HapticFeedback.lightImpact());
    }
  }

  void _cancelCountdown() {
    if (_phase != _SosPhase.countdown) return;
    _countdownController
      ..stop()
      ..value = 0;
    unawaited(HapticFeedback.selectionClick());
    setState(() => _phase = _SosPhase.idle);
  }

  void _onCountdownStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed ||
        _phase != _SosPhase.countdown) {
      return;
    }
    // One firm confirmation, then start the real alarm.
    unawaited(HapticFeedback.heavyImpact());
    _countdownController.value = 0;
    setState(() => _phase = _SosPhase.idle);
    widget.onActivate();
  }

  @override
  void dispose() {
    _stopHoldTicks();
    _holdController.dispose();
    _countdownController.dispose();
    super.dispose();
  }

  // ---- UI -----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCountdown = _phase == _SosPhase.countdown;
    final hint = isCountdown ? widget.countdownHint : widget.holdHint;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          label: widget.label,
          hint: widget.holdHint,
          child: GestureDetector(
            // Press-and-hold starts the hold; releasing before it completes
            // cancels. During the countdown the outer gesture is inert — the
            // in-circle Cancel button owns the tap.
            onTapDown: (_) {
              if (_phase == _SosPhase.idle) _startHold();
            },
            onTapUp: (_) {
              if (_phase == _SosPhase.holding) _cancelHold();
            },
            onTapCancel: () {
              if (_phase == _SosPhase.holding) _cancelHold();
            },
            child: SizedBox(
              width: _size,
              height: _size,
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _holdController,
                  _countdownController,
                ]),
                builder: (context, _) => _buildCircle(context, theme),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          hint,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildCircle(BuildContext context, ThemeData theme) {
    final semantic = context.semantic;
    final isCountdown = _phase == _SosPhase.countdown;
    // Ring: fills while holding, drains while counting down, hidden when idle.
    final ringValue = isCountdown
        ? 1 - _countdownController.value
        : _holdController.value;
    return Stack(
      alignment: Alignment.center,
      children: [
        // Progress ring sits in the gap around the disc, on the page surface —
        // so it is drawn in the SOS red (not the on-red tone) to stay clearly
        // visible against the background in both light and dark themes.
        SizedBox(
          width: _size,
          height: _size,
          child: CircularProgressIndicator(
            value: ringValue,
            strokeWidth: 12,
            backgroundColor: semantic.sos.withValues(alpha: 0.18),
            valueColor: AlwaysStoppedAnimation(semantic.sos),
          ),
        ),
        // The red disc.
        Container(
          width: _size - 48,
          height: _size - 48,
          decoration: BoxDecoration(
            color: semantic.sos,
            shape: BoxShape.circle,
            // The one deliberate shadow in the app: a soft red glow lifting the
            // single focus element.
            boxShadow: const [
              BoxShadow(
                color: Color(0x40D32029),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: isCountdown
                ? _CountdownFace(
                    seconds: _secondsLeft,
                    cancelLabel: widget.cancelLabel,
                    onCancel: _cancelCountdown,
                  )
                : _LabelFace(label: widget.label),
          ),
        ),
      ],
    );
  }
}

/// The idle/holding face: the big SOS word.
class _LabelFace extends StatelessWidget {
  const _LabelFace({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semantic;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Text(
          label,
          style: theme.textTheme.displaySmall?.copyWith(
            color: semantic.onSos,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

/// The countdown face: the remaining seconds above an in-circle Cancel button.
class _CountdownFace extends StatelessWidget {
  const _CountdownFace({
    required this.seconds,
    required this.cancelLabel,
    required this.onCancel,
  });

  final int seconds;
  final String cancelLabel;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = context.semantic;
    final onSos = semantic.onSos;
    // Inset from the disc edge and scale down as one unit, so the number and
    // the cancel pill always fit the circle — even with a long localized label
    // or a large system font.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$seconds',
              style: theme.textTheme.displayMedium?.copyWith(
                color: onSos,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            // Cancel lives inside the circle. A translucent pill keeps it
            // legible on the red disc and gives a comfortable tap target.
            Semantics(
              button: true,
              label: cancelLabel,
              child: Material(
                color: onSos.withValues(alpha: 0.18),
                shape: const StadiumBorder(),
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: onCancel,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close, size: 18, color: onSos),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          cancelLabel,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: onSos,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
