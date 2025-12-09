import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Centralized icon definitions for the application
///
/// This file maps all icons used throughout the app to Phosphor icons,
/// making it easy to maintain consistency and update icons in one place.
///
/// Phosphor Icons provide 5 weight variants:
/// - Thin: PhosphorIcons.thin
/// - Light: PhosphorIcons.light
/// - Regular: PhosphorIcons.regular
/// - Bold: PhosphorIcons.bold
/// - Fill: PhosphorIcons.fill
///
/// We primarily use Light weight for consistency with modern minimalist design.
abstract class AppIcons {
  // ==================== NAVIGATION ICONS ====================

  /// Home icon for navigation
  static PhosphorIconData get home => PhosphorIcons.house;

  /// Home icon (filled variant)
  static PhosphorIconData get homeFilled => PhosphorIcons.houseFill;

  /// Library/Books icon for navigation
  static PhosphorIconData get library => PhosphorIcons.books;

  /// Library/Books icon (filled variant)
  static PhosphorIconData get libraryFilled => PhosphorIcons.booksFill;

  /// Scan/Camera icon for navigation
  static PhosphorIconData get scan => PhosphorIcons.camera;

  /// Scan/Camera icon (filled variant)
  static PhosphorIconData get scanFilled => PhosphorIcons.cameraFill;

  /// History/Clock icon for navigation
  static PhosphorIconData get history => PhosphorIcons.clockCounterClockwise;

  /// History/Clock icon (filled variant)
  static PhosphorIconData get historyFilled => PhosphorIcons.clockCounterClockwiseFill;

  /// Profile/User icon for navigation
  static PhosphorIconData get profile => PhosphorIcons.user;

  /// Profile/User icon (filled variant)
  static PhosphorIconData get profileFilled => PhosphorIcons.userFill;

  // ==================== PLANT & NATURE ICONS ====================

  /// Leaf icon - general plant/eco indicator
  static PhosphorIconData get leaf => PhosphorIcons.leaf;

  /// Leaf icon (filled variant)
  static PhosphorIconData get leafFilled => PhosphorIcons.leafFill;

  /// Seedling icon - young plant/growth
  static PhosphorIconData get seedling => PhosphorIcons.treeStructure;

  /// Flower icon - plant species
  static PhosphorIconData get flower => PhosphorIcons.flower;

  /// Flower icon (filled variant)
  static PhosphorIconData get flowerFilled => PhosphorIcons.flowerFill;

  /// Plant icon - general plant indicator
  static PhosphorIconData get plant => PhosphorIcons.treeStructure;

  /// Tree icon - larger plants
  static PhosphorIconData get tree => PhosphorIcons.tree;

  // ==================== ENVIRONMENT ICONS ====================

  /// Sun icon - sunlight/light conditions
  static PhosphorIconData get sun => PhosphorIcons.sun;

  /// Sun icon (filled variant)
  static PhosphorIconData get sunFilled => PhosphorIcons.sunFill;

  /// Water droplet icon - water conditions
  static PhosphorIconData get waterDrop => PhosphorIcons.drop;

  /// Water droplet icon (filled variant)
  static PhosphorIconData get waterDropFilled => PhosphorIcons.dropFill;

  /// Lightbulb icon - tips/ideas/recommendations
  static PhosphorIconData get lightbulb => PhosphorIcons.lightbulb;

  /// Lightbulb icon (filled variant)
  static PhosphorIconData get lightbulbFilled => PhosphorIcons.lightbulbFill;

  // ==================== UI CONTROL ICONS ====================

  /// Search icon
  static PhosphorIconData get search => PhosphorIcons.magnifyingGlass;

  /// Notification bell icon
  static PhosphorIconData get notifications => PhosphorIcons.bell;

  /// Notification bell icon (filled variant)
  static PhosphorIconData get notificationsFilled => PhosphorIcons.bellFill;

  /// Right chevron/caret icon
  static PhosphorIconData get chevronRight => PhosphorIcons.caretRight;

  /// Left chevron/caret icon
  static PhosphorIconData get chevronLeft => PhosphorIcons.caretLeft;

  /// Down chevron/caret icon
  static PhosphorIconData get chevronDown => PhosphorIcons.caretDown;

  /// Up chevron/caret icon
  static PhosphorIconData get chevronUp => PhosphorIcons.caretUp;

  /// Back arrow icon
  static PhosphorIconData get arrowBack => PhosphorIcons.arrowLeft;

  /// Forward arrow icon
  static PhosphorIconData get arrowForward => PhosphorIcons.arrowRight;

  /// Close/X icon
  static PhosphorIconData get close => PhosphorIcons.x;

  /// Menu icon (hamburger)
  static PhosphorIconData get menu => PhosphorIcons.list;

  /// More options icon (three dots vertical)
  static PhosphorIconData get moreVert => PhosphorIcons.dotsThreeVertical;

  /// More options icon (three dots horizontal)
  static PhosphorIconData get moreHoriz => PhosphorIcons.dotsThree;

  // ==================== FORM & INPUT ICONS ====================

  /// Eye icon - show password/visibility
  static PhosphorIconData get visibility => PhosphorIcons.eye;

  /// Eye slash icon - hide password/visibility off
  static PhosphorIconData get visibilityOff => PhosphorIcons.eyeSlash;

  /// Check/checkmark icon
  static PhosphorIconData get check => PhosphorIcons.check;

  /// Check circle icon
  static PhosphorIconData get checkCircle => PhosphorIcons.checkCircle;

  /// Check circle icon (filled variant)
  static PhosphorIconData get checkCircleFilled => PhosphorIcons.checkCircleFill;

  // ==================== STATUS & FEEDBACK ICONS ====================

  /// Warning icon
  static PhosphorIconData get warning => PhosphorIcons.warning;

  /// Warning icon (filled variant)
  static PhosphorIconData get warningFilled => PhosphorIcons.warningFill;

  /// Error/X circle icon
  static PhosphorIconData get error => PhosphorIcons.xCircle;

  /// Error/X circle icon (filled variant)
  static PhosphorIconData get errorFilled => PhosphorIcons.xCircleFill;

  /// Info icon
  static PhosphorIconData get info => PhosphorIcons.info;

  /// Info icon (filled variant)
  static PhosphorIconData get infoFilled => PhosphorIcons.infoFill;

  // ==================== IMAGE & MEDIA ICONS ====================

  /// Image icon
  static PhosphorIconData get image => PhosphorIcons.image;

  /// Image square icon
  static PhosphorIconData get imageSquare => PhosphorIcons.imageSquare;

  /// Camera icon
  static PhosphorIconData get camera => PhosphorIcons.camera;

  /// Gallery/images icon
  static PhosphorIconData get gallery => PhosphorIcons.image;

  // ==================== TIME & DATE ICONS ====================

  /// Clock icon
  static PhosphorIconData get clock => PhosphorIcons.clock;

  /// Calendar icon
  static PhosphorIconData get calendar => PhosphorIcons.calendar;

  // ==================== SETTINGS & TOOLS ICONS ====================

  /// Settings/gear icon
  static PhosphorIconData get settings => PhosphorIcons.gear;

  /// Filter icon
  static PhosphorIconData get filter => PhosphorIcons.funnel;

  /// Sort icon
  static PhosphorIconData get sort => PhosphorIcons.arrowsDownUp;

  /// Edit/pencil icon
  static PhosphorIconData get edit => PhosphorIcons.pencil;

  /// Delete/trash icon
  static PhosphorIconData get delete => PhosphorIcons.trash;

  // ==================== COMMUNICATION ICONS ====================

  /// Chat/message icon
  static PhosphorIconData get chat => PhosphorIcons.chatCircle;

  /// Share icon
  static PhosphorIconData get share => PhosphorIcons.shareNetwork;

  /// Download icon
  static PhosphorIconData get download => PhosphorIcons.downloadSimple;

  /// Upload icon
  static PhosphorIconData get upload => PhosphorIcons.uploadSimple;

  // ==================== AUTHENTICATION ICONS ====================

  /// Lock icon - password/security
  static PhosphorIconData get lock => PhosphorIcons.lock;

  /// Unlock icon
  static PhosphorIconData get unlock => PhosphorIcons.lockOpen;

  /// Email icon
  static PhosphorIconData get email => PhosphorIcons.envelope;

  /// Sign out icon
  static PhosphorIconData get signOut => PhosphorIcons.signOut;
}
