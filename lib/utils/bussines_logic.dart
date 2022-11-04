String timeAgo(DateTime d) {
  Duration diff = DateTime.now().difference(d);
  // DateTime.now().difference(d);
  if (diff.inDays > 365) {
    return "قبل ${(diff.inDays / 365).floor() > 2 ? (diff.inDays / 365).floor() : ""} ${(diff.inDays / 365).floor() == 1 ? "سنة" : (diff.inDays / 365).floor() == 2 ? "سنتين" : (diff.inDays / 365).floor() >= 3 && (diff.inDays / 365).floor() <= 10 ? "سنين" : "سنة"}";
  }
  if (diff.inDays > 30) {
    return "قبل ${(diff.inDays / 30).floor() > 2 ? (diff.inDays / 30).floor() : ""} ${(diff.inDays / 30).floor() == 1 ? "شهر" : (diff.inDays / 30).floor() == 2 ? "شهرين" : (diff.inDays / 30).floor() >= 3 && (diff.inDays / 30).floor() <= 10 ? "أشهر" : "شهر"}";
  }
  if (diff.inDays > 7) {
    // return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    return "قبل ${(diff.inDays / 7).floor() > 2 ? (diff.inDays / 7).floor() : ""} ${(diff.inDays / 7).floor() == 1 ? "أسبوع" : (diff.inDays / 7).floor() == 2 ? "أسبوعين" : (diff.inDays / 7).floor() >= 3 && (diff.inDays / 7).floor() <= 10 ? "أسابيع" : "أسبوع"}";
  }
  if (diff.inDays > 0) {
    return "قبل ${diff.inDays > 2 ? diff.inDays : ""} ${diff.inDays == 1 ? "يوم" : diff.inDays == 2 ? "يومين" : diff.inDays >= 3 && diff.inDays <= 10 ? "أيام" : "يوم"}";
  }
  if (diff.inHours > 0) {
    return "قبل ${diff.inHours > 2 ? diff.inHours : ""} ${diff.inHours == 1 ? "ساعة" : diff.inHours == 2 ? "ساعتين" : diff.inHours >= 3 && diff.inHours <= 10 ? "ساعات" : "ساعة"}";
  }
  if (diff.inMinutes > 0) {
    return "قبل ${diff.inMinutes > 2 ? diff.inMinutes : ""} ${diff.inMinutes == 1 ? "دقيقة" : diff.inMinutes == 2 ? "دقيقتين" : diff.inMinutes >= 3 && diff.inMinutes <= 10 ? "دقائق" : "دقيقة"}";
  }
  return "الآن";
}
