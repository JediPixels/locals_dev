class TimeAgoService {
  static String getSingleOrPluralS(int duration) {
    if (duration > 1) {
      return 's';
    }
    return '';
  }

  static String getTimeAgoSinceDateTime(int timestamp) {
    // Convert timestamp to Milliseconds
    timestamp = timestamp * 1000;
    final DateTime currentDateTime = DateTime.now();
    final DateTime dateTimeFromMilliseconds = DateTime.fromMillisecondsSinceEpoch((timestamp));
    final Duration dateTimeDuration = currentDateTime.difference(dateTimeFromMilliseconds);

    if (dateTimeDuration.inSeconds < 60) {
      return '${dateTimeDuration.inSeconds} second${getSingleOrPluralS(dateTimeDuration.inSeconds)} ago';
    } else if (dateTimeDuration.inMinutes < 60) {
      return '${dateTimeDuration.inMinutes} minute${getSingleOrPluralS(dateTimeDuration.inMinutes)} ago';
    } else if (dateTimeDuration.inHours <= 24) {
      return '${dateTimeDuration.inHours} hour${getSingleOrPluralS(dateTimeDuration.inHours)} ago';
    } else if (dateTimeDuration.inDays >= 1 && dateTimeDuration.inDays <= 30) {
      return '${dateTimeDuration.inDays} day${getSingleOrPluralS(dateTimeDuration.inDays)} ago';
    } else if (dateTimeDuration.inDays > 30) {
      return '$dateTimeFromMilliseconds';
    } else {
      return 'just now';
    }
  }
}