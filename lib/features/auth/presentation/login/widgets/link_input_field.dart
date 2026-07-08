import 'package:flutter/material.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/theme/app_spacing.dart';
import 'package:kamkor/core/widgets/app_button.dart';
import 'package:kamkor/core/widgets/app_text_field.dart';

/// Personal-link paste field with a submit action.
class LinkInputField extends StatefulWidget {
  const LinkInputField({
    required this.onSubmit,
    this.enabled = true,
    this.errorText,
    super.key,
  });

  final ValueChanged<String> onSubmit;
  final bool enabled;
  final String? errorText;

  @override
  State<LinkInputField> createState() => _LinkInputFieldState();
}

class _LinkInputFieldState extends State<LinkInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => widget.onSubmit(_controller.text);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _controller,
          label: l.login_link_label,
          hint: l.login_link_hint,
          errorText: widget.errorText,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.go,
          enabled: widget.enabled,
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: l.login_continue,
          icon: Icons.arrow_forward,
          onPressed: widget.enabled ? _submit : null,
        ),
      ],
    );
  }
}
