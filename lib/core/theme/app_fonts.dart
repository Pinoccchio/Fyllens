/// Font family constants for the application
///
/// This file centralizes all font family definitions to ensure consistency
/// across the app and make it easy to update fonts in the future.
///
/// Font choices:
/// - **Inter**: Modern, precise sans-serif perfect for headings and titles
/// - **Poppins**: Friendly, rounded sans-serif ideal for body text and approachable content
///
/// These fonts were selected for their:
/// - Excellent mobile readability
/// - Professional yet approachable aesthetic
/// - Perfect balance for a nature/agriculture app
/// - Wide language support
abstract class AppFonts {
  /// Primary font for headings, titles, and navigation
  ///
  /// Inter is a modern geometric sans-serif designed for UI with excellent
  /// legibility at all sizes. Use for:
  /// - H1, H2, H3 headings
  /// - App bar titles
  /// - Navigation labels
  /// - Buttons (when precision is needed)
  static const String headingFont = 'Inter';

  /// Secondary font for body text, descriptions, and content
  ///
  /// Poppins is a friendly rounded sans-serif that adds warmth and
  /// approachability. Use for:
  /// - Body text (large, medium, small)
  /// - Descriptions
  /// - Input fields
  /// - Captions
  /// - Buttons (when friendliness is preferred)
  static const String bodyFont = 'Poppins';

  /// Default font weight for regular text
  static const int fontWeightRegular = 400;

  /// Default font weight for medium emphasis
  static const int fontWeightMedium = 500;

  /// Default font weight for semi-bold emphasis
  static const int fontWeightSemiBold = 600;

  /// Default font weight for bold text
  static const int fontWeightBold = 700;
}
