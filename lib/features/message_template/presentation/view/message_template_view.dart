import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/theme/app_radius.dart';
import 'package:kamkor/core/theme/app_spacing.dart';
import 'package:kamkor/core/widgets/app_banner.dart';
import 'package:kamkor/core/widgets/app_button.dart';
import 'package:kamkor/core/widgets/app_text_field.dart';
import 'package:kamkor/core/widgets/state_views/error_view.dart';
import 'package:kamkor/core/widgets/state_views/loading_view.dart';
import 'package:kamkor/features/message_template/domain/entities/message_template.dart';
import 'package:kamkor/features/message_template/presentation/bloc/message_template_bloc.dart';

class MessageTemplateView extends StatelessWidget {
  const MessageTemplateView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.message_template_title)),
      body: BlocConsumer<MessageTemplateBloc, MessageTemplateState>(
        listenWhen: (prev, curr) => prev.saveStatus != curr.saveStatus,
        listener: (context, state) {
          if (state.saveStatus == MtSaveStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.message_template_saved)),
            );
          } else if (state.saveStatus == MtSaveStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_errorText(l, state.saveError))),
            );
          }
        },
        builder: (context, state) {
          return switch (state.status) {
            MtStatus.initial || MtStatus.loading => const LoadingView(),
            MtStatus.failure => ErrorView(
                message: _errorText(l, state.loadError),
                retryLabel: l.retry,
                onRetry: () => context
                    .read<MessageTemplateBloc>()
                    .add(const MessageTemplateRequested()),
              ),
            MtStatus.ready => _TemplateForm(
                key: ValueKey(state.template),
                template: state.template!,
                saving: state.isSaving,
              ),
          };
        },
      ),
    );
  }
}

class _TemplateForm extends StatefulWidget {
  const _TemplateForm({
    required this.template,
    required this.saving,
    super.key,
  });

  final MessageTemplate template;
  final bool saving;

  @override
  State<_TemplateForm> createState() => _TemplateFormState();
}

class _TemplateFormState extends State<_TemplateForm> {
  /// Illustrative coordinates used only to render the live preview.
  static const _sampleGeo = '42.8746, 74.5698';

  late final TextEditingController _message =
      TextEditingController(text: widget.template.messageText);

  /// Whether live coordinates ride along with the message. Derived from the
  /// saved template: a signature carrying the `{geo}` marker means "on".
  late bool _includeLocation =
      widget.template.geoSignature.contains(MessageTemplate.geoPlaceholder);

  /// The saved geo signature (e.g. "Я здесь: {geo}"), kept so switching the
  /// location off and on again never loses custom wording around the marker.
  late final String _savedSignature = widget.template.geoSignature;

  String? _messageError;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  /// What gets persisted as the geo signature: the saved wording when it holds
  /// the marker, otherwise the bare `{geo}` marker — and nothing when location
  /// is switched off.
  String get _effectiveSignature {
    if (!_includeLocation) return '';
    return _savedSignature.contains(MessageTemplate.geoPlaceholder)
        ? _savedSignature
        : MessageTemplate.geoPlaceholder;
  }

  /// The coordinates line as the recipient will see it (marker filled with
  /// sample coordinates), or null when location is off.
  String? _previewLocation() {
    if (!_includeLocation) return null;
    final line = _effectiveSignature
        .replaceAll(MessageTemplate.geoPlaceholder, _sampleGeo)
        .trim();
    return line.isEmpty ? _sampleGeo : line;
  }

  void _save() {
    final message = _message.text.trim();
    // An empty template would send a blank alarm message — block it.
    if (message.isEmpty) {
      final l = AppLocalizations.of(context);
      setState(() => _messageError = l.message_template_required);
      return;
    }
    context.read<MessageTemplateBloc>().add(
          MessageTemplateSaved(
            messageText: message,
            geoSignature: _effectiveSignature,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Plain-language explainer up top: what this screen is, who receives
          // the message and that coordinates ride along automatically.
          AppBanner.info(
            text: l.message_template_intro,
            icon: Icons.forum_outlined,
          ),
          const SizedBox(height: AppSpacing.xl),

          // 1 — the message itself, with an example so a first-time user knows
          // what to write. Typing refreshes the live preview below.
          AppTextField(
            controller: _message,
            label: l.message_template_message_label,
            hint: l.message_template_message_hint,
            errorText: _messageError,
            enabled: !widget.saving,
            maxLines: 5,
            maxLength: MessageTemplate.maxMessageLength,
            textInputAction: TextInputAction.newline,
            onChanged: (_) => setState(() => _messageError = null),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 2 — coordinates as a plain switch instead of the technical {geo}
          // token: the user decides "share my location" in words, and the
          // preview shows exactly what that adds.
          Card(
            child: SwitchListTile(
              value: _includeLocation,
              onChanged: widget.saving
                  ? null
                  : (value) => setState(() => _includeLocation = value),
              secondary: Icon(
                Icons.location_on_outlined,
                color: scheme.primary,
              ),
              title: Text(l.message_template_location_title),
              subtitle: Text(l.message_template_location_desc),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // 3 — exactly what a recipient will see, rendered live as a chat
          // bubble so the abstract "template" becomes a concrete message.
          _PreviewBubble(
            caption: l.message_template_preview_label,
            emptyHint: l.message_template_preview_empty,
            message: _message.text.trim(),
            location: _previewLocation(),
          ),
          const SizedBox(height: AppSpacing.sm),
          _PreviewNote(text: l.message_template_preview_hint),
          const SizedBox(height: AppSpacing.xl),

          AppButton(
            label: l.message_template_save,
            loading: widget.saving,
            onPressed: widget.saving ? null : _save,
          ),
        ],
      ),
    );
  }
}

/// Live preview of the alarm message shown as an incoming chat bubble: the
/// message text and, when location is on, a coordinates line with a pin. Makes
/// the abstract template concrete — the user sees precisely what a contact will
/// receive. Shows a placeholder hint while the message is still empty.
class _PreviewBubble extends StatelessWidget {
  const _PreviewBubble({
    required this.caption,
    required this.emptyHint,
    required this.message,
    this.location,
  });

  final String caption;
  final String emptyHint;
  final String message;
  final String? location;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isEmpty = message.isEmpty && location == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Caption framing the bubble as "what the recipient receives".
        Row(
          children: [
            Icon(Icons.sms_outlined, size: 18, color: scheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.sm),
            Text(
              caption,
              style: theme.textTheme.labelLarge?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        // Incoming-message bubble: a rounded tonal container aligned to the
        // start, with the top-start corner squared off like a chat tail.
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: scheme.secondaryContainer,
              // Squared top-start corner (a chat "tail"); the rest rounded.
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(AppRadius.lg),
                bottomLeft: Radius.circular(AppRadius.lg),
                bottomRight: Radius.circular(AppRadius.lg),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isEmpty)
                  Text(
                    emptyHint,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                else ...[
                  if (message.isNotEmpty)
                    Text(
                      message,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: scheme.onSecondaryContainer,
                      ),
                    ),
                  if (location != null) ...[
                    if (message.isNotEmpty)
                      const SizedBox(height: AppSpacing.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 20,
                          color: scheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Flexible(
                          child: Text(
                            location!,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: scheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// A small muted note under the preview (e.g. "coordinates are illustrative").
class _PreviewNote extends StatelessWidget {
  const _PreviewNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

String _errorText(AppLocalizations l, MtError error) => switch (error) {
      MtError.none => '',
      MtError.network => l.error_network,
      MtError.timeout => l.error_timeout,
      MtError.validation => l.message_template_invalid,
      MtError.server => l.error_server,
      MtError.unknown => l.error_unknown,
    };
