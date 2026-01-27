/// Font family constants for the application - "Organic Luxury" Typography
///
/// This file centralizes all font family definitions to ensure consistency
/// across the app and make it easy to update fonts in the future.
///
/// Font choices for premium botanical aesthetic:
/// - **DM Serif Display**: Elegant serif for headings - adds botanical character
/// - **DM Sans**: Modern geometric sans for body text - clean and readable
/// - **Space Mono**: Monospace for data/metrics - scientific credibility
///
/// These fonts were selected for their:
/// - Premium, sophisticated aesthetic
/// - Botanical elegance combined with modern precision
/// - Excellent mobile readability
/// - Scientific credibility for plant health data
/// - Wide language support
abstract class AppFonts {
  /// Primary font for headings, titles, and hero text
  ///
  /// DM Serif Display is an elegant transitional serif with botanical
  /// character. Use for:
  /// - H1, H2, H3 headings
  /// - Hero section text
  /// - App branding
  /// - Feature titles
  /// - Plant names in cards
  static const String displayFont = 'DM Serif Display';

  /// Secondary font for body text, UI elements, and navigation
  ///
  /// DM Sans is a modern geometric sans-serif with excellent readability.
  /// Use for:
  /// - Body text (large, medium, small)
  /// - Buttons and CTAs
  /// - Navigation labels
  /// - Input fields
  /// - Descriptions and captions
  static const String bodyFont = 'DM Sans';

  /// Tertiary font for data, metrics, and technical information
  ///
  /// Space Mono adds scientific credibility and precision.
  /// Use for:
  /// - Confidence percentages
  /// - Timestamps and dates
  /// - Technical data
  /// - Code snippets
  /// - Model predictions
  static const String monoFont = 'Space Mono';

  // Legacy aliases (for backwards compatibility during migration)
  static const String headingFont = displayFont;

  /// Default font weight for regular text
  static const int fontWeightRegular = 400;

  /// Default font weight for medium emphasis
  static const int fontWeightMedium = 500;

  /// Default font weight for semi-bold emphasis
  static const int fontWeightSemiBold = 600;

  /// Default font weight for bold text
  static const int fontWeightBold = 700;

  /// Letter spacing for display text (tighter for elegance)
  static const double letterSpacingDisplay = -0.5;

  /// Letter spacing for body text
  static const double letterSpacingBody = 0.0;

  /// Letter spacing for mono text (wider for readability)
  static const double letterSpacingMono = 0.5;

  /// Letter spacing for buttons (subtle spacing)
  static const double letterSpacingButton = 0.5;

  /// Letter spacing for overlines and labels
  static const double letterSpacingLabel = 1.0;
}
