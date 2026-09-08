import 'package:flutter/widgets.dart';

/// Semantic corner-radius scale used for cards, buttons and sheets.
abstract final class AppRadius {
  static const double sm = 8;
  static const double card = 12;
  static const double lg = 16;

  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(card),
  );
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));
}
