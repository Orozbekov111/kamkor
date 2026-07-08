import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kamkor/core/localization/l10n/gen/app_localizations.dart';
import 'package:kamkor/core/utils/launcher.dart';

/// Selectable body text that turns phone-number-looking runs into tappable
/// `tel:` links. The pattern is deliberately conservative (7–15 digits) to
/// avoid mistaking years or article numbers for phone numbers.
class PhoneLinkText extends StatefulWidget {
  const PhoneLinkText(this.text, {this.style, super.key});

  final String text;
  final TextStyle? style;

  @override
  State<PhoneLinkText> createState() => _PhoneLinkTextState();
}

class _PhoneLinkTextState extends State<PhoneLinkText> {
  static final RegExp _phone = RegExp(r'\+?\d[\d\s\-()]{5,}\d');
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    super.dispose();
  }

  Future<void> _call(String number) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await Launcher.dial(number);
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(l.error_call_failed)));
    }
  }

  List<InlineSpan> _buildSpans(Color linkColor) {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();

    final spans = <InlineSpan>[];
    final text = widget.text;
    var last = 0;
    for (final match in _phone.allMatches(text)) {
      final token = match.group(0)!;
      final digits = token.replaceAll(RegExp(r'\D'), '');
      // Keep non-phone-length matches as plain text.
      if (digits.length < 7 || digits.length > 15) continue;
      if (match.start > last) {
        spans.add(TextSpan(text: text.substring(last, match.start)));
      }
      final recognizer = TapGestureRecognizer()
        ..onTap = () => unawaited(_call(digits));
      _recognizers.add(recognizer);
      spans.add(
        TextSpan(
          text: token,
          style: TextStyle(
            color: linkColor,
            decoration: TextDecoration.underline,
          ),
          recognizer: recognizer,
        ),
      );
      last = match.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last)));
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SelectableText.rich(
      TextSpan(
        style: widget.style,
        children: _buildSpans(theme.colorScheme.primary),
      ),
    );
  }
}
