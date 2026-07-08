import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/theme/app_radius.dart';
import 'package:kamkor/core/theme/app_spacing.dart';
import 'package:kamkor/core/widgets/app_button.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

/// Camera QR scanner. The camera is mounted only after the user taps the
/// primer, so the OS permission prompt is preceded by a plain explanation.
/// Emits the first decoded value once; it re-arms after a failed validation so
/// the user can rescan without restarting the screen.
class QrScannerView extends StatefulWidget {
  const QrScannerView({
    required this.onDetected,
    this.enabled = true,
    super.key,
  });

  final ValueChanged<String> onDetected;
  final bool enabled;

  @override
  State<QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView> {
  MobileScannerController? _controller;
  bool _handled = false;

  @override
  void didUpdateWidget(QrScannerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-arm once a validation attempt finishes (loading → enabled) so an
    // invalid or expired code doesn't leave the camera permanently frozen.
    if (!oldWidget.enabled && widget.enabled) _handled = false;
  }

  @override
  void dispose() {
    unawaited(_controller?.dispose());
    super.dispose();
  }

  void _startCamera() {
    setState(() {
      _handled = false;
      _controller = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
      );
    });
  }

  void _retry() {
    unawaited(_controller?.dispose());
    _startCamera();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled || !widget.enabled || capture.barcodes.isEmpty) return;
    final raw = capture.barcodes.first.rawValue;
    if (raw == null || raw.isEmpty) return;
    _handled = true;
    widget.onDetected(raw);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.brLg,
      child: AspectRatio(
        aspectRatio: 1,
        child: _controller == null
            ? _CameraPrimer(onStart: _startCamera)
            : _CameraSurface(
                controller: _controller!,
                onDetect: _onDetect,
                onRetry: _retry,
              ),
      ),
    );
  }
}

class _CameraSurface extends StatelessWidget {
  const _CameraSurface({
    required this.controller,
    required this.onDetect,
    required this.onRetry,
  });

  final MobileScannerController controller;
  final void Function(BarcodeCapture) onDetect;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: controller,
          onDetect: onDetect,
          errorBuilder: (context, error) => _CameraError(
            error: error,
            onRetry: onRetry,
          ),
        ),
        // Framing guide to help the user aim at the QR code.
        IgnorePointer(
          child: Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: scheme.onPrimary, width: 3),
                borderRadius: AppRadius.brMd,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            color: Colors.black54,
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Text(
              l.login_scan_hint,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

/// Pre-permission explanation shown before the camera (and its OS prompt).
class _CameraPrimer extends StatelessWidget {
  const _CameraPrimer({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l.login_camera_primer, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: l.login_camera_primer_action,
              icon: Icons.photo_camera_outlined,
              onPressed: onStart,
            ),
          ],
        ),
      ),
    );
  }
}

/// Distinguishes a permanent permission denial (→ settings) from a transient
/// camera failure (→ retry).
class _CameraError extends StatelessWidget {
  const _CameraError({required this.error, required this.onRetry});

  final MobileScannerException error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final denied =
        error.errorCode == MobileScannerErrorCode.permissionDenied;
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              denied
                  ? Icons.no_photography_outlined
                  : Icons.error_outline,
              size: 40,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              denied ? l.login_camera_denied_hint : l.login_camera_error,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            if (denied)
              AppButton(
                label: l.open_settings,
                icon: Icons.settings_outlined,
                onPressed: () => unawaited(openAppSettings()),
              )
            else
              AppButton(
                label: l.retry,
                icon: Icons.refresh,
                onPressed: onRetry,
              ),
          ],
        ),
      ),
    );
  }
}
