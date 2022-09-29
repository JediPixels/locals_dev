enum FeedOrder {
  recent,
  oldest,
}

extension CapitalizationExtension on String {
  String get firstLetterCapitalize => this[0].toUpperCase() + substring(1);
}