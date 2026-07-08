/// Form/input validation helpers, framework-agnostic (no l10n concerns).
///
/// Validators return primitive results (`bool`); callers map them to localized
/// messages so the UI layer owns all user-facing text.
abstract final class Validators {
  // Optional leading `+` and 9–15 digits — matches KG mobile and landline
  // numbers once separators are stripped.
  static final RegExp _phone = RegExp(r'^\+?\d{9,15}$');
  static final RegExp _phoneSeparators = RegExp(r'[\s\-()]');

  /// Strips spaces, dashes and brackets from a raw phone input.
  static String normalizePhone(String value) =>
      value.replaceAll(_phoneSeparators, '');

  /// Whether [value] is a plausible phone number after normalization.
  static bool isValidPhone(String value) =>
      _phone.hasMatch(normalizePhone(value));

  /// Whether [value] holds at least one non-whitespace character.
  static bool isNotBlank(String value) => value.trim().isNotEmpty;
}
