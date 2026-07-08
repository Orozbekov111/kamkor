import 'package:flutter/rendering.dart';

/// Corner-radius scale (DESIGN_SYSTEM.md §4). Replaces scattered
/// `BorderRadius.circular(12)` literals with named, consistent tokens.
abstract final class AppRadius {
  /// Inputs, small chips.
  static const sm = 8.0;

  /// Cards, banners, status tiles, previews. The app-wide default.
  static const md = 12.0;

  /// Bottom-sheet top corners, large containers.
  static const lg = 16.0;

  /// Fully rounded (SOS button, avatars).
  static const full = 999.0;

  static const brSm = BorderRadius.all(Radius.circular(sm));
  static const brMd = BorderRadius.all(Radius.circular(md));
  static const brLg = BorderRadius.all(Radius.circular(lg));
}
