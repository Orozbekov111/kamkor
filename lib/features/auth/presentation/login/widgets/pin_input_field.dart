import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Large, masked PIN entry. Excluded from semantics so the value is not
/// read aloud by screen readers.
///
/// Auto-submits via [onCompleted] once [maxLength] digits are entered — there
/// is no return key on the iOS numeric keyboard to rely on.
class PinInputField extends StatelessWidget {
  const PinInputField({
    required this.controller,
    required this.onCompleted,
    this.focusNode,
    this.enabled = true,
    this.maxLength = 14,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback onCompleted;
  final FocusNode? focusNode;
  final bool enabled;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        autofocus: true,
        obscureText: true,
        obscuringCharacter: '●',
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: maxLength,
        // Sized so a full 14-digit PIN fits one line on narrow phones; the
        // previous 32/16 tracking overflowed past ~7 characters.
        style: const TextStyle(
          fontSize: 22,
          letterSpacing: 6,
          fontWeight: FontWeight.w600,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          if (value.length == maxLength) onCompleted();
        },
        // Border/radius come from the shared `inputDecorationTheme`; only the
        // counter is suppressed here. Behavior (masking, auto-submit) is
        // unchanged.
        decoration: const InputDecoration(counterText: ''),
      ),
    );
  }
}
